%********************************************************
%CD (Contrastive Divergence) class is a sampling method. In this class we
%can generate samples from an RBM model with training samples
%initialization. This class  inherits from Gibbs class.
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
%Cd class
classdef Cd<SamplingClasses.Gibbs
    % PUBLIC METHODS ------------------------------------------------------    
    methods (Access=public)
        %Constructor
        function obj=Cd()
            obj.methodType='Cd';
        end %End of Constructor function
        
        %Running sampling method to generate new values in visible and
        %hidden units.
        %modelParams: Parameters of RBM model
        %posVis: Positive visible data. In Cd method, This matrix will
        %be used visible units initialization and for positive hidden units
        %posHid: Positive hidden units.
        %negVis: negative visible units.
        %negHid: negative hidden units.
        function [obj,posHid,negVis,negHid]=run(obj,modelParams,posVis)
            [hidSample,hidProb]=obj.up(modelParams,posVis);
            posHid=hidProb;
            %Runnin sampling method several iteration
            for i=1:modelParams.kSamplingIteration;
               [visSample,visProb]=obj.down(modelParams,hidSample);
               [hidSample,hidProb]=obj.up(modelParams,visSample);
            end
            negVis=visSample;
            negHid=hidProb;
        end %End of run function 
        
    end %End PUBLIC METHODS    
    
end %End Cd class

