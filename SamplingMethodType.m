%********************************************************
%SamplingMethodType class is an enumeration that contains types of sampling
%methods is used in RBM.
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
%SamplingMethodType class or enumeration
classdef SamplingMethodType
   % Gibbs: Gibbs sampling method
   % CD: Contrastive Divergence sampling method
   % PCD: Persistent Contrastive Divergence sampling method
   % FEPCD: Free Energy in Persistent Contrastive Divergence sampling method
   enumeration
      Gibbs,CD,PCD,FEPCD
   end
    
end %End Classdef

