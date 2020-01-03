%********************************************************
% ValueType class is an enumeration that contains types of values is used
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
%ValueType class or enumeration
classdef ValueType
    
    % binary: Units are 0 or 1
    % probability: Units are in [0,1]
    % gaussian: Units are in [-Inf,+Inf] with zero mean and unit variance
    enumeration
        binary,probability,gaussian
    end
    
end

