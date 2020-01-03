%********************************************************
% RBM class defines all necessary functions and features in all types of
% RBMs. Indeed the RBM class is an abstract class and we can't create an
% object from it.

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
%RBM Class
classdef RBM<handle
    
    % PUBLIC PROPERTIES ---------------------------------------------------
    properties (Access=public)
        %Storing RBM parameters
        rbmParams
    end %End PUBLIC PROPERTIES
    
    % PROTECTED PROPERTIES ------------------------------------------------
    properties (Access=protected)
        %Storing an object of Sampling class
        sampler
        %This parameter is used during training phase for updating weights.
        deltaWeight;
        %This parameter is used during training phase for updating visible
        %bias.
        deltaVisBias;
        %This parameter is used during training phase for updating hidden
        %bias.
        deltaHidBias;
    end %End PROTECTED PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=RBM(rbmParams)
            obj.rbmParams=rbmParams;
            if(rbmParams.gpu)
                gpuDevice(rbmParams.gpu);
            end
        end %End of constructor
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
            obj.rbmParams=gather(obj.rbmParams);
            obj.sampler=gather(obj.sampler);
            obj.deltaWeight=gather(obj.deltaWeight);
            obj.deltaVisBias=gather(obj.deltaVisBias);
            obj.deltaHidBias=gather(obj.deltaHidBias);
        end %End of gather function
        
         %Create RBM on GPU
        function obj=gpuArray(obj)
            obj.rbmParams.weight=gpuArray(obj.rbmParams.weight);
            obj.rbmParams.gpu=1;
        end %End of gpuArray function
        
    end %End PUBLIC METHODS
    
    % PROTECTED METHODS ---------------------------------------------------
    methods (Access=protected)
        
        function [deltaWeightReg,deltaVisBiasReg,deltaHidBiasReg]=getRegularizationGradient(obj,batchData,posHid)
            %sparsity regularization term
            deltaWeightReg=0;
            deltaVisBiasReg=0;
            deltaHidBiasReg=0;
        end %End of getRegularizationGradient function        
        
    end %End PROTECTED METHODS
    
    % PUBLIC ABSTRACT METHODS ---------------------------------------------
    methods(Abstract)
        %Training function
        train(obj,trainData)
        %Get feature from dataMatrix by RBM model
        [extractedFeature]=getFeature(obj,dataMatrix)
    end %End PUBLIC ABSTRACT METHODS
end %End RBM class