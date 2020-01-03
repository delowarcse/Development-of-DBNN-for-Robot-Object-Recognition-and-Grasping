%********************************************************
%freeEnergy function computes free Energy for each row data according to G.
%Hinton, “A practical guide to training restricted boltzmann machines,”
%Machine Learning Group, University of Toronto, Technical report, 2010.

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
%freeEnergy function
%dataMatrix: A row data matrix
function FE=freeEnergy(modelParams,dataMatrix)
    FE = -dataMatrix*modelParams.visBias'- ...
        sum(log(exp(dataMatrix*modelParams.weight+ ...
        repmat(modelParams.hidBias,size(dataMatrix,1),1))+1),2);
end %End of freeEnergy function