%********************************************************
%Sampling class is an interface class for using implemented sampling
%classes. Other classes can uniformly use implemented sampling classes with
%this useful class.
%
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
%Sampling class
classdef Sampling<handle
    % PUBLIC PROPERTIES ---------------------------------------------------
    properties (Access=public)
        %posHid: Positive hidden units.        
        posHid;
        %negVis: negative visible units.
        negVis;
        %negHid: negative hidden units.
        negHid;
    end %End PUBLIC PROPERTIES
    
    % PRIVATE PROPERTIES --------------------------------------------------
    properties (Access=private)
        %Storing object of sampling class
        methodObj;
    end %End PRIVATE PROPERTIES

    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        %methodType: determines sampling method type
        function obj=Sampling(methodType)
            %Creating sampling class object according to methodType
            switch methodType
                case SamplingClasses.SamplingMethodType.Gibbs
                    obj.methodObj=SamplingClasses.Gibbs();
                case SamplingClasses.SamplingMethodType.CD
                    obj.methodObj=SamplingClasses.Cd();
                case SamplingClasses.SamplingMethodType.PCD
                    obj.methodObj=SamplingClasses.Pcd();
                case SamplingClasses.SamplingMethodType.FEPCD
                    obj.methodObj=SamplingClasses.FEPcd();
            end
        end %End of Constructor
        
        %Running sampling method to generate new values in visible and
        %hidden units.
        %modelParams: Parameters of RBM model
        %data:A row data matrix for sampling from them.
        function run(obj,modelParams,data)
            [obj.methodObj,obj.posHid,obj.negVis,obj.negHid]=obj.methodObj.run(modelParams,data);
        end %End of run function
        
        %Sampling hidden units from visible units
        %modelParams: Parameters of RBM model
        %visSample: visible samples that will be used in sampling hidden units.
        %hidSample: generated hidden samples
        %hidProb: probability of activation in hidden samples
        function [hidSample,hidProb]=up(obj,modelParams,visSample)
            [hidSample,hidProb]=obj.methodObj.up(modelParams,visSample);
        end %End of up function
        
        %Sampling visible units from hiiden units
        %modelParams: Parameters of RBM model
        %visSample: visible samples that will be used in sampling hidden units.
        %visProb: probability of activation in visible samples
        function [visSample,visProb]=down(obj,modelParams,hidSample)
            [visSample,visProb]=obj.methodObj.down(modelParams,hidSample);
        end %End of down function
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
            obj.posHid=gather(obj.posHid);
            obj.negVis=gather(obj.negVis);
            obj.negHid=gather(obj.negHid);
            obj.methodObj=gather(obj.methodObj);
        end %End of gather function
            
    end %End PUBLIC METHODS
    
end %End Sampling class