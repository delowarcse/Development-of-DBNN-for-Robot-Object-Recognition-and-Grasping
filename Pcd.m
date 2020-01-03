%********************************************************
%PCD (Persistent Contrastive Divergence) class is a sampling method. In
%this class we can generate samples from an RBM model. Unlike CD method
%that uses training data as initial value for visible units, PCD method
%uses last chain state in the last update step. In other words, PCD uses
%successive Gibbs sampling runs to estimate model samples. Also this class
%inherits from Gibbs class. In this class many persistent chains can be run
%in parallel and we will refer to the current state in each of these chains
%as new sample or a “fantasy” particle. This class  inherits from Gibbs class.

% CONTRIBUTOR
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
%Pcd class
classdef Pcd<SamplingClasses.Gibbs
    % PROTECTED PROPERTIES ------------------------------------------------
    properties (Access=protected)
        numberOfChains
        lastChainState
    end %End PROTECTED PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=Pcd()
            obj.methodType='Pcd';
            obj.numberOfChains=25;
            obj.lastChainState=[];
        end %End of Constructor function
        
        %Running sampling method to generate new values in visible and
        %hidden units.
        %modelParams: Parameters of RBM model
        %posVis: Positive visible data. In PCD method, This matrix will
        %be used for positive hidden units
        %posHid: Positive hidden units.
        %negVis: negative visible units.
        %negHid: negative hidden units.
        function [obj,posHid,negVis,negHid]=run(obj,modelParams,posVis)
            %PCD method uses last chain state in the last update step. In
            %other words, PCD uses successive Gibbs sampling runs to
            %estimate model samples.
            if(isempty(obj.lastChainState))
                %PCD chains creation
                obj.lastChainState=obj.initPosVis(modelParams,obj.numberOfChains);
            end
            negVis=[];
            negHid=[];
            [~,hidProb]=obj.up(modelParams,posVis);
            posHid=hidProb;
            [hidSample,hidProb]=obj.up(modelParams,obj.lastChainState);           
            for j=1:ceil(size(posVis,1)/obj.numberOfChains)
                for i=1:modelParams.kSamplingIteration;
                    [visSample,visProb]=obj.down(modelParams,hidSample);                    
                    [hidSample,hidProb]=obj.up(modelParams,visSample);                    
                end
                negVis=[negVis;visSample];
                negHid=[negHid;hidProb];
            end
            obj.lastChainState=visSample;
            negVis=negVis(1:size(posVis,1),:);
            negHid=negHid(1:size(posVis,1),:);
        end %End of run function
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
            obj.numberOfChains=gather(obj.numberOfChains);
            obj.lastChainState=gather(obj.lastChainState);
        end %End of gather function
        
    end %End PUBLIC METHODS
    
    % PRIVATE METHODS -----------------------------------------------------
    methods (Access=private)
        
        %Initialize PCD chains
        %modelParams: Parameters of RBM model 
        %numberOfChains: PCD method uses last chain state in the last
        %update step.
        function [posVis]=initPosVis(~,modelParams,numberOfChains)
            %init posVis data
            switch modelParams.visibleValueType
                case ValueType.probability
                    posVis=rand(numberOfChains,modelParams.numVis);
                case ValueType.binary
                    posVis=0.5>rand(numberOfChains,modelParams.numVis);
                case ValueType.gaussian
                    posVis=randn(numberOfChains,modelParams.numVis);
            end
        end %End of initPosVis function
        
    end %End PRIVATE METHODS
    
end %End Pcd class

