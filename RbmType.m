%********************************************************
% RbmType class is an enumeration that contains types of rbms is used
% in DBN.

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
%RbmType class or enumeration
classdef RbmType
    % generative: An Rbm that uses data without their labels. Result is a
    % generative model.    
    % discriminative: An Rbm that uses data with their labels. This RBM is a
    % discriminative model and can classify data to their labels.
    enumeration
        generative,discriminative
    end
    
end %End Classdef

