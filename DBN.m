%********************************************************
% DBNs are generative models that are composed of multiple layers of RBMs.

%G. E. Hinton, S. Osindero, and Y.-W. Teh, �A Fast Learning Algorithm for
%Deep Belief Nets,?Neural Computation, vol. 18, no. 7, pp. 1527?554,
%2006.



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
%% DBN Class
classdef DBN<handle
    
    %% PUBLIC PROPERTIES ----------------------------------------
    properties (Access=public)
        %Determine DBN Type
        dbnType;
        %Store stacks of RBMs
        rbms;
        %Store neural network object when backpropagation is needed
        net;
    end %End PUBLIC PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %% Constructor
        %dbnType: Type of DBN can be autoEncoder or classifier
        %rbms: stacks of RBMs that is available from other trained DBN
        function obj=DBN(dbnType,rbms)
            if nargin<1
                dbnType='autoEncoder';
            end
            if nargin<2
                rbms=[];
            end
            obj.dbnType=dbnType;
            %If a trained stacks of RBMs is available, we can use it.
            obj.rbms=rbms;
            obj.net=[];
        end %End of Constructor function
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
            for i=1:length(obj.rbms)
                obj.rbms{i}.gather();
            end
        end%End of gather function
        
        %Create DBN on GPU
        function obj=gpuArray(obj)
            for i=1:length(obj.rbms)
                obj.rbms{i}.gpuArray();
            end
        end%End of gpuArray function
        
        %% Adding new RBM on top of stacks of RBMs
        %rbmParams: Parameters of a new RBM
        function addRBM(obj,rbmParams)
            if (rbmParams.sparsity==0)
                switch rbmParams.rbmType
                    case RbmType.discriminative
                        rbm=DiscriminativeRBM(rbmParams);
                    case RbmType.generative
                        rbm=GenerativeRBM(rbmParams);
                end
            elseif(rbmParams.sparsity==1)
                switch rbmParams.rbmType
                    case RbmType.discriminative
                        rbm=SparseDiscriminativeRBM(rbmParams);
                    case RbmType.generative
                        rbm=SparseGenerativeRBM(rbmParams);
                end
            end
            obj.rbms=[obj.rbms,{rbm}];
        end %End of addRBM function
        
        %% Taining RBMs layer by layer
        %data: A DataStore class object for using its training data
        function train(obj,data)
            visibleData=data.clone();
            %Training each RBM
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                fprintf(1,'\n ****** RBM %d ******* %d-%d\n',i,size(visibleData.trainData,2),rbm.rbmParams.numHid);
                rbm.train(visibleData);
                if(i<length(obj.rbms))
                    visibleData.trainData=rbm.getFeature(visibleData.trainData);
                    visibleData.validationData=rbm.getFeature(visibleData.validationData);
                    if (rbm.rbmParams.hiddenValueType==ValueType.binary)
                        visibleData.valueType=ValueType.probability;
                    else
                        visibleData.valueType=rbm.rbmParams.hiddenValueType;
                    end
                end
            end
        end %End of train function
        
        %% function to get feature from data
        %dataMatrix:A row data matrix
        %k:number of running sampling
        %extractedFeature: Features that has been extracted.
        function [extractedFeature]=getFeature(obj,dataMatrix,k,layerNumber,beforeBP)
            if nargin<3
                k=1;
            end
            if nargin<4
                layerNumber=length(obj.rbms);
            end
            if nargin<5
                if (isempty(obj.net))
                    beforeBP=1;
                else
                    beforeBP=0;
                end
            end
            extractedFeature=dataMatrix;
            if (beforeBP==1)
                %Get features layer by layer
                for i=1:layerNumber-1
                    rbm=obj.rbms{i};
                    extractedFeature=rbm.getFeature(extractedFeature);
                end
                rbm=obj.rbms{layerNumber};
                extractedFeature=rbm.getFeature(extractedFeature,k)
            else %After BP
                ocOld=obj.net.outputConnect;
                obj.net.outputConnect=zeros(1,obj.net.numLayers);
                obj.net.outputConnect(1,layerNumber)=1;
                [extractedFeature]=obj.net(dataMatrix');
                extractedFeature=extractedFeature';
                obj.net.outputConnect=ocOld;
            end
        end %End of getFeature function
        
        %% Generating data from hidden features
        %extractedFeature: Hidden features
        %k: number of running sampling
        %generatedData: visible data that has been generated
        function [generatedData]=generateData(obj,extractedFeature,k)
            if nargin<3
                k=1;
            end
            generatedData=extractedFeature;
            rbm=obj.rbms{end};
            generatedData=rbm.generateData(generatedData,k);
            for i=length(obj.rbms)-1:-1:1
                rbm=obj.rbms{i};
                generatedData=rbm.generateData(generatedData);
            end
        end %End of generateData function
        
        %% Reconstructing visible data
        %dataMatrix: A row data matrix
        %k: number of running sampling
        %fixedDimensions:Define dimensions that will be fixed at the end of
        %reconstruction.
        %reconstructedData: Visible data that has been reconstructed
        function [reconstructedData]=reconstructData(obj,dataMatrix,k,fixedDimensions)
            if nargin<3
                k=1;
            end
            if nargin<4
                fixedDimensions=[];
            end
            [extractedFeature]=obj.getFeature(dataMatrix,k);
            [generatedData]=obj.generateData(extractedFeature);
            generatedData(:,fixedDimensions)=dataMatrix(:,fixedDimensions);
            reconstructedData=generatedData;
        end %End of reconstructData function
        
        %% Generating data for a class number
        %classNumber: A vector of Class numbers
        %k: number of reconstructing data to get generatedData data
        %generatedData: visible data that has been generated from class
        %number
        function [generatedData]=generateClass(obj,classNumber,k)
            rbm=obj.rbms{end};
            if (rbm.rbmParams.rbmType~=RbmType.discriminative)
                error('The last RBM must be discriminative');
            end
            [generatedData]=rbm.generateClass(classNumber,k);
            for i=length(obj.rbms)-1:-1:1
                rbm=obj.rbms{i};
                generatedData=rbm.generateData(generatedData);
            end
        end %End of generateClass function
        
        %% Using backpropagation of MATLAB neural network in DBN
        %data: A DataStore class object for using its training data
        function backpropagation(obj,data,useGPU)
            if nargin<3
                useGPU='no';
            end
            %Creat a MATLAB neural network object and set its parameters
            obj.net=DBNtoNN(obj,data);
            obj.net.trainParam.epochs=200;
            % reductionFactor=ceil(size(data.trainData,1)/5000);
            reductionFactor=ceil(size(data.trainData,1)/800);
            %train neural network
            switch (obj.dbnType)
                case 'autoEncoder'
                    obj.net=train(obj.net,data.trainData',data.trainData','reduction',reductionFactor,'useGPU',useGPU);
                    obj.net.outputConnect=zeros(1,obj.net.numLayers);
                    obj.net.outputConnect(1,ceil(obj.net.numLayers/2))=1;
                case 'classifier'
                    trainLabel=full(ind2vec(data.trainLabels'+1));
                    obj.net=train(obj.net,data.trainData',trainLabel,'reduction',reductionFactor,'useGPU',useGPU);
                case 'functionApproximator'
                    obj.net=train(obj.net,data.trainData',data.trainLabels','reduction',reductionFactor,'useGPU',useGPU);
            end
        end %End of backpropagation function
        
        %% Get output of DBN according to its type.
        %dataMatrix:A row data matrix
        %method: Type of getting output from model
        function [output,y]=getOutput(obj,dataMatrix,method)
            if nargin<3
                method='byFreeEnergy';
            end
            switch (obj.dbnType)
                %DBN:autoEncoder
                case 'autoEncoder'
                    [extractedFeature]=obj.getFeature(dataMatrix,1);
                    output=extractedFeature;
                    %DBN:classifier
                case 'classifier'
                    if (isempty(obj.net))
                        if (obj.rbms{end}.rbmParams.rbmType==RbmType.discriminative)
                            extractedFeature=dataMatrix;
                            for i=1:length(obj.rbms)-1
                                rbm=obj.rbms{i};
                                extractedFeature=rbm.getFeature(extractedFeature,1);
                            end
                            rbm=obj.rbms{length(obj.rbms)};
                            classNumber=rbm.predictClass(extractedFeature,method);
                        else %using MATLAB neural network for classification
                            error('In this type of DBN you must first run backpropagation function.');
                        end
                    else
                        y=obj.net(dataMatrix');
                        classNumber=vec2ind(y)'-1;
                        %classNumber=vec2ind(y)'
                    end
                    output=classNumber;
                    %DBN:functionApproximator
                case 'functionApproximator'
                    y = obj.net(dataMatrix');
                    output=y';
            end %End switch DBN type
        end %End of getOutput function
        
        %% Plotting bases (Receptive Fields) in a DBN
        %rbmNumber: Determines the RBM that we want to plot its bases.
        function bases=plotBases(obj,rbmNumber)
            bases=obj.rbms{1}.rbmParams.weight...
                (obj.rbms{1}.rbmParams.numberOfVisibleSoftmax+1:end,:);
            
            for i=2:rbmNumber
                rbm=obj.rbms{i};
                bases=bases*rbm.rbmParams.weight...
                    (obj.rbms{i}.rbmParams.numberOfVisibleSoftmax+1:end,:);
            end
            bases=bases';
            bases=(bases-repmat(min(bases,[],2),1,size(bases,2)))./(repmat(max(bases,[],2),1,size(bases,2))-repmat(min(bases,[],2),1,size(bases,2)));
            DataClasses.DataStore.plotData({gather(bases)},1);
        end
    end %End PUBLIC METHODS
    
    %% PRIVATE METHODS ------------------------------------------------------
    methods (Access=private)
        %% Converting a DBN to a NN MATLAB object according to DBN type
        %data: A DataStore class object for using its properties
        function net=DBNtoNN(obj,data)
            switch (obj.dbnType)
                case 'autoEncoder'
                    net=obj.DBNtoAutoEncoderNN();
                case 'classifier'
                    net=obj.DBNtoClassifierNN(data);
                case 'functionApproximator'
                    net=obj.DBNtoFunctionApproximatorNN(data);
            end
        end %End of DBNtoNN
        
        %% Converting a classifier DBN to a NN MATLAB object
        %data: A DataStore class object for using its properties
        function net=DBNtoClassifierNN(obj,data)
            net=patternnet(5*ones(1,length(obj.rbms)));
            net.trainFcn ='trainscg';
            net.inputs{1}.processFcns={};
            net.outputs{end}.processFcns={};
            net.performFcn='mse';
            net.divideFcn = '';
            %Set NN structure
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                if (i==1)
                    net.inputs{1}.size=rbm.rbmParams.numVis-rbm.rbmParams.numberOfVisibleSoftmax;
                end
                switch rbm.rbmParams.hiddenValueType
                    case ValueType.binary
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                    case ValueType.probability
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                    case ValueType.gaussian
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn ='purelin';
                end
            end %End for all RBMs
            net.layers{end}.dimensions=max(data.trainLabels)+1;
            net.layers{end}.transferFcn = 'logsig';
            %Set NN weights
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                if(i==1)
                    net.IW{1,1}=double(gather(rbm.rbmParams.weight(rbm.rbmParams.numberOfVisibleSoftmax+1:end,:)'));
                    net.b{i}=double(gather(rbm.rbmParams.hidBias'));
                else
                    net.LW{i,i-1}=double(gather(rbm.rbmParams.weight(rbm.rbmParams.numberOfVisibleSoftmax+1:end,:)'));
                    net.b{i}=double(gather(rbm.rbmParams.hidBias'));
                end
            end %End for all RBMs
            rbm=obj.rbms{end};
            if (rbm.rbmParams.rbmType==RbmType.discriminative)
                net.LW{end,end-1}=double(gather(rbm.rbmParams.weight(1:rbm.rbmParams.numberOfVisibleSoftmax,:)));
                net.b{end}=double(gather(rbm.rbmParams.visBias(1:rbm.rbmParams.numberOfVisibleSoftmax)'));
            else
                %Set last layer randomly because the DBN has not
                %discriminative RBM
                net.LW{end,end-1}=0.1*randn(size(net.LW{end,end-1}));
            end
            
        end %End of DBNtoClassifierNN function
        
        %% Converting an autoEncoder DBN to a NN MATLAB object
        function net=DBNtoAutoEncoderNN(obj)
            net=fitnet(5*ones(1,length(obj.rbms)*2-1));
            net.trainFcn =  'trainscg';
            net.inputs{1}.processFcns={};
            net.outputs{end}.processFcns={};
            net.performFcn='mse';
            net.divideFcn = '';
            %Set NN structure
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                switch rbm.rbmParams.hiddenValueType
                    case ValueType.binary
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                        net.layers{length(net.layers)-i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{length(net.layers)-i}.transferFcn = 'logsig';
                    case ValueType.probability
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                        net.layers{length(net.layers)-i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{length(net.layers)-i}.transferFcn = 'logsig';
                    case ValueType.gaussian
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn ='purelin';
                        net.layers{length(net.layers)-i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{length(net.layers)-i}.transferFcn ='purelin';
                end
            end %End for all RBMs
            %Set NN structure for firs layer and last autoEncoder layer
            rbm=obj.rbms{1};
            switch rbm.rbmParams.visibleValueType
                case ValueType.binary
                    net.inputs{1}.size=rbm.rbmParams.numVis;
                    net.layers{end}.dimensions=rbm.rbmParams.numVis;
                    net.layers{end}.transferFcn = 'logsig';
                case ValueType.probability
                    net.inputs{1}.size=rbm.rbmParams.numVis;
                    net.layers{end}.dimensions=rbm.rbmParams.numVis;
                    net.layers{end}.transferFcn = 'logsig';
                case ValueType.gaussian
                    net.inputs{1}.size=rbm.rbmParams.numVis;
                    net.layers{end}.dimensions=rbm.rbmParams.numVis;
                    net.layers{end}.transferFcn = 'purelin';
            end
            %Set NN weights
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                if(i==1)
                    net.IW{1,1}=double(gather(rbm.rbmParams.weight'));
                    net.b{i}=double(gather(rbm.rbmParams.hidBias'));
                else
                    net.LW{i,i-1}=double(gather(rbm.rbmParams.weight'));
                    net.b{i}=double(gather(rbm.rbmParams.hidBias'));
                end
                net.LW{end-i+1,end-i}=double(gather(rbm.rbmParams.weight));
                net.b{end-i+1}=double(gather(rbm.rbmParams.visBias'));
            end %End for all RBMs
        end %End of DBNtoAutoEncoderNN function
        
        %% Converting a functionApproximator DBN to a NN MATLAB object
        %data: A DataStore class object for using its properties
        function net=DBNtoFunctionApproximatorNN(obj,data)
            net=fitnet(5*ones(1,length(obj.rbms)));
            net.trainFcn ='trainscg';
            net.inputs{1}.processFcns={};
            net.outputs{end}.processFcns={};
            net.divideFcn = '';
            %Set NN structure
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                if (i==1)
                    net.inputs{1}.size=rbm.rbmParams.numVis;
                end
                switch rbm.rbmParams.hiddenValueType
                    case ValueType.binary
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                    case ValueType.probability
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn = 'logsig';
                    case ValueType.gaussian
                        net.layers{i}.dimensions=rbm.rbmParams.numHid;
                        net.layers{i}.transferFcn ='purelin';
                end
            end %End for all RBMs
            net.layers{end}.transferFcn ='purelin';
            net.layers{end}.dimensions=size(data.trainLabels,2);
            %Set NN weights
            for i=1:length(obj.rbms)
                rbm=obj.rbms{i};
                if(i==1)
                    net.IW{1,1}=double(gather(rbm.rbmParams.weight'));
                    net.b{1}=double(gather(rbm.rbmParams.hidBias'));
                else
                    net.LW{i,i-1}=double(gather(rbm.rbmParams.weight'));
                    net.b{i}=double(gather(rbm.rbmParams.hidBias'));
                end
            end %End for all RBMs
            %Set last layer randomly
            net.LW{end,end-1}=0.05*randn(size(net.LW{end,end-1}));
        end % End of DBNtoFunctionApproximatorNN function
        
        
    end %End PRIVATE METHODS
    
end %End DBN class

