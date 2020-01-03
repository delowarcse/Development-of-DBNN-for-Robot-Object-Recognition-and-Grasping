%********************************************************
% Restricted Boltzmann machines (RBMs) have been used as generative models
% of many different types of data. Their most important use is as learning
% modules that are composed to form deep belief nets. With some changes, we
% can convert generative RBM to a discriminative RBM that can classify
% data.
% Ref: G. Hinton,"A practical guide to training restricted boltzmann
% machines,"Machine Learning Group, University of Toronto, Technical
% report, 2010.

% CONTRIBUTORS
%	Created by:
% 		All right is reserved by Delowar Hossain
%		PhD on Intelligence Robotics
% 		Graduate School of Science and Engineering for Education
% 		Faculty of Engineering
%		University of Toyama, Japan. (2015-2018)
% 		E-mail: delowar_cse_ru@yahoo.com
% 		Skype: delowarcse
% 		Web-page: https://www.linkedin.com/in/delowar-hossain-ph-d-2bb479b9/
%**************************************************************************
%% DiscriminativeRBM Class
classdef DiscriminativeRBM<RBM
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %% Constructor
        function obj=DiscriminativeRBM(rbmParams)
            obj=obj@RBM(rbmParams);
            obj.rbmParams.rbmType=RbmType.discriminative;
        end %End of Constructor function
        
        %% Training function
        %data: A DataStore class object for using its training data 
        function train(obj,data) 
            %Prepare softmax units in visible units for labels
            numberOfClasses=max(data.trainLabels)+1;
            obj.rbmParams.numberOfVisibleSoftmax=numberOfClasses;
            trainDataPatch=full(ind2vec(data.trainLabels'+1)');
            %Initialize model parameters
            if (isempty(obj.rbmParams.weight))
                obj.rbmParams.visibleValueType=data.valueType;
                obj.rbmParams.weight=0.1*randn(size(data.trainData,2)+numberOfClasses,obj.rbmParams.numHid);
                obj.rbmParams.visBias=zeros(1,size(data.trainData,2)+numberOfClasses);
            end
            if (isempty(obj.deltaWeight))
                obj.deltaWeight=zeros(size(obj.rbmParams.weight));
                obj.deltaVisBias=zeros(size(obj.rbmParams.visBias));
                obj.deltaHidBias=zeros(size(obj.rbmParams.hidBias));
            end
            obj.rbmParams.redefineValues();
            %Create a sampling class object 
            if (isempty(obj.sampler))
                obj.sampler=SamplingClasses.Sampling(obj.rbmParams.samplingMethodType);
            end
            batchArraySize=ceil(size(data.trainData,1)/obj.rbmParams.batchSize);      
            %Computing start epoch for averaging
            avgstart = obj.rbmParams.maxEpoch + obj.rbmParams.epochNumber - obj.rbmParams.avgLast;
            %Reduction factor in averaging
            t=0;
            %Begin training
            for epoch=1:obj.rbmParams.maxEpoch
                ticID=tic;
                obj.rbmParams.epochNumber=obj.rbmParams.epochNumber+1;
                for batchNumber=1:batchArraySize
                    %Prepare training data with softmax units
                    batchTrainDataPatch=trainDataPatch(...
                        (batchNumber-1)*obj.rbmParams.batchSize+1:min(batchNumber*obj.rbmParams.batchSize,end),:);
                    batchData=[batchTrainDataPatch,data.trainData(...
                        (batchNumber-1)*obj.rbmParams.batchSize+1:min(batchNumber*obj.rbmParams.batchSize,end),:)];
                    obj.sampler.run(obj.rbmParams,batchData);                    
                    %weight
                    obj.deltaWeight=obj.rbmParams.moment(min(obj.rbmParams.epochNumber,end))*obj.deltaWeight+obj.rbmParams.learningRate*...
                        ((batchData'*obj.sampler.posHid-obj.sampler.negVis'*obj.sampler.negHid)/size(batchData,1)- ...
                        obj.rbmParams.penalty*obj.rbmParams.weight);
                    weight=obj.rbmParams.weight+obj.deltaWeight;
                    %visBias
                    obj.deltaVisBias=obj.rbmParams.moment(min(obj.rbmParams.epochNumber,end))*obj.deltaVisBias+obj.rbmParams.learningRate*...
                        ((sum(batchData,1)-sum(obj.sampler.negVis,1))/size(batchData,1));
                    visBias=obj.rbmParams.visBias+obj.deltaVisBias;
                    %HidBias
                    obj.deltaHidBias=obj.rbmParams.moment(min(obj.rbmParams.epochNumber,end))*obj.deltaHidBias+obj.rbmParams.learningRate*...
                        ((sum(obj.sampler.posHid,1)-sum(obj.sampler.negHid,1))/size(batchData,1));
                    hidBias=obj.rbmParams.hidBias+obj.deltaHidBias;
                    %Using regularization term gradient
                    [deltaWeightReg,deltaVisBiasReg,deltaHidBiasReg]=obj.getRegularizationGradient(batchData,obj.sampler.posHid);
                    weight=weight+deltaWeightReg;
                    visBias=visBias+deltaVisBiasReg;
                    hidBias=hidBias+deltaHidBiasReg;
                    %Averaging in some last layers
                    if (avgstart > 0 && obj.rbmParams.epochNumber > avgstart)
                        t = t+1;
                        obj.rbmParams.weight=obj.rbmParams.weight-(1/t)*(obj.rbmParams.weight-weight);
                        obj.rbmParams.visBias=obj.rbmParams.visBias-(1/t)*(obj.rbmParams.visBias-visBias);
                        obj.rbmParams.hidBias=obj.rbmParams.hidBias-(1/t)*(obj.rbmParams.hidBias-hidBias);
                    else
                        obj.rbmParams.weight= weight;
                        obj.rbmParams.visBias= visBias;
                        obj.rbmParams.hidBias= hidBias;
                    end
                end %End batches
                elapsedTime = toc(ticID);
                estimatedTime=elapsedTime*(obj.rbmParams.maxEpoch-epoch);
                perf=obj.computePerformance(data);                
                obj.rbmParams.performanceHistory=[obj.rbmParams.performanceHistory;[perf,elapsedTime]];                
                fprintf(1,'epoch number:%g\t performance:%g\t remained RBM training time:%g\n',obj.rbmParams.epochNumber,perf,estimatedTime);
            end %End epoches
        end %End of train function
        

        
        
        %% function to get feature from data
        %dataMatrix:A row data matrix
        %k:number of running sampling
        %fixedDimensions:Define dimensions that will be fixed during
        %sampling
        %extractedFeature: Features that has been extracted.
        %dataMatrixLabels: Labels for dataMatrix
        function [extractedFeature]=getFeature(obj,dataMatrix,k,fixedDimensions,dataMatrixLabels)
            if nargin<3
                k=1;
            end
            if nargin<4
                fixedDimensions=[];
            else
                fixedDimensions=fixedDimensions+obj.rbmParams.numberOfVisibleSoftmax;
            end
            %Prepare softmax units value
            if nargin<5 || isempty(dataMatrixLabels)
                dataMatrixLabelsVector=zeros(size(dataMatrix,1),obj.rbmParams.numberOfVisibleSoftmax);
            else
                dataMatrixLabelsVector=full(ind2vec(dataMatrixLabels'+1,obj.rbmParams.numberOfVisibleSoftmax)');
            end
            %Prepare dataMatrix with softmax units
            dataMatrix=[dataMatrixLabelsVector,dataMatrix];
            batchArraySize=ceil(size(dataMatrix,1)/obj.rbmParams.batchSize);
            %Extracted feature matrix
            extractedFeature=zeros(size(dataMatrix,1),obj.rbmParams.numHid);
            for i=1:batchArraySize
                batchData=dataMatrix((i-1)*obj.rbmParams.batchSize+1:min(i*obj.rbmParams.batchSize,end),:);
                [hidSample,hidProb]=obj.sampler.up(obj.rbmParams,batchData);
                for j=2:k
                    [visSample,~]=obj.sampler.down(obj.rbmParams,hidSample);
                    visSample(:,fixedDimensions)=batchData(:,fixedDimensions);
                    [hidSample,hidProb]=obj.sampler.up(obj.rbmParams,visSample);
                end
                extractedFeature((i-1)*obj.rbmParams.batchSize+1:min(i*obj.rbmParams.batchSize,end),:)=...
                    gather(hidProb);
            end
        end %End of getFeature function
        
        %% Generating data from hidden features
        %extractedFeature: Hidden features
        %k: number of running sampling
        %generatedData: visible data that has been generated
        %generatedLabel: generated Label with softmax units
        function [generatedData,generatedLabel]=generateData(obj,extractedFeature,k)
            if nargin<3
                k=1;
            end
            [visSample,visProb]=obj.sampler.down(obj.rbmParams,extractedFeature);
            for i=2:k
                [hidSample,~]=obj.sampler.up(obj.rbmParams,visSample);
                [visSample,visProb]=obj.sampler.down(obj.rbmParams,hidSample);
            end
            %Determine labels
            [~,I]=max(visProb(:,1:obj.rbmParams.numberOfVisibleSoftmax),[],2);
            generatedLabel=I-1;            
            %Determine data
            generatedData=gather(visSample(:,obj.rbmParams.numberOfVisibleSoftmax+1:end));
        end %End of generateData function
        
        %% Reconstructing visible data
        %dataMatrix: A row data matrix
        %k: number of running sampling
        %fixedDimensions:Define dimensions that will be fixed during
        %sampling
        %dataMatrixLabels: Labels for dataMatrix
        %reconstructedData: Visible data that has been reconstructed
        %reconstructedLabel: generated Label with softmax units
        function [reconstructedData,reconstructedLabel]=reconstructData(obj,dataMatrix,k,fixedDimensions,dataMatrixLabels)
            if nargin<3
                k=1;
            end
            if nargin<4
                fixedDimensions=[];
            end
            if nargin<5
                dataMatrixLabels=[];
            end            
            [extractedFeature]=obj.getFeature(dataMatrix,k,fixedDimensions,dataMatrixLabels);
            [reconstructedData,reconstructedLabel]=obj.generateData(extractedFeature,1);
        end %End of reconstructData function
        
        %% Computing performance of trained model
        %data: A DataStore class object for using its validation data 
        %perf:Computed performance of trained model for validation data
        function perf=computePerformance(obj,data)
            perf=[];
            if (isempty(data.validationData))
                fprintf('Computing performance needs validataion data.');
            else
                switch obj.rbmParams.performanceMethod
                    %Computing free energy for validation data in model
                    case 'freeEnergy'
                        dataMatrixLabelsVector=zeros(size(data.validationData,1),obj.rbmParams.numberOfVisibleSoftmax);
                        dataMatrix=[dataMatrixLabelsVector,data.validationData];
                        FE=SamplingClasses.freeEnergy(obj.rbmParams,dataMatrix);
                        perf=mean(FE);
                    %Computing reconstructed error for validation data in model
                    case 'reconstruction'
                        [reconstructedData]=obj.reconstructData(data.validationData);
                        perf=sum(sum((data.validationData-reconstructedData).^2 ))/...
                            (size(data.validationData,1)*size(data.validationData,2));
                    %Computing classification error for validation data in model    
                    case 'classification'
                        classNumber=obj.predictClass(data.validationData,'bySampling');
                        perf=sum(classNumber~=data.validationLabels)/length(classNumber);
                    otherwise
                        fprintf(1,'Your performance method (%s) is not defined or is empty.\n', obj.rbmParams.performanceMethod);
                end%End of switch
            end
        end %End of computePerformance function
        
                
        %% Generating data for a class number
        %classNumber: Class number
        %k: number of reconstructing data to get generatedData data
        %generatedData: visible data that has been generated from class
        %number
        function [generatedData]=generateClass(obj,classNumber,k)
            if nargin<3
                k=1;
            end
            reconstructedData=zeros(length(classNumber),obj.rbmParams.numVis-obj.rbmParams.numberOfVisibleSoftmax);
            dataMatrixLabels=classNumber;
            for i=1:k
                [reconstructedData]=obj.reconstructData(reconstructedData,3,[],dataMatrixLabels);
            end
            generatedData=reconstructedData;
        end %End of generateClass function
        
        %% Class prediction from input data
        %dataMatrix: A row data matrix
        %method: Metod of classification, Ref: [1]Y. Bengio, N. Chapados,
        %O. Delalleau, H. Larochelle, X. Saint-Mleux, C. Hudon, and J.
        %Louradour, "Detonation Classification from Acoustic Signature with
        %the Restricted Boltzmann Machine," Computational Intelligence,
        %2012.
        %classNumber: Predicted class number vector
        function classNumber=predictClass(obj,dataMatrix,method)
            if nargin<3
                method='byFreeEnergy';
            end
            switch method
                %Class prediction with sampling method
                case 'bySampling'
                    [~,classNumber]=obj.reconstructData(dataMatrix,1);
                %Class prediction with free energy
                case 'byFreeEnergy'
                    numclasses= obj.rbmParams.numberOfVisibleSoftmax;
                    numcases= size(dataMatrix, 1);
                    F= zeros(numcases, numclasses); 
                    X= zeros(numcases, numclasses);
                    dataMatrix=[X,dataMatrix];
                    %set every class bit in turn and find free energy of the configuration
                    for i=1:numclasses
                        X(:, max(1,i-1))=0;
                        X(:, i)=1;
                        dataMatrix(1:size(X,1),1:size(X,2))=X;
                        F(:,i)=SamplingClasses.freeEnergy(obj.rbmParams,dataMatrix);
                    end
                    %take the min
                    [~,I]= min(F, [], 2);
                    classNumber=I-1;
            end %end switch method
        end %End of predictClass function
        
    end %End PUBLIC METHODS

end %End DiscriminativeRBM class

