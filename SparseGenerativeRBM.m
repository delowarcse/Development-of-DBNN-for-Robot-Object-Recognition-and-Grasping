%********************************************************
% Different methods are proposed to build sparse RBMs. In all proposed
% methods, learning algorithm in RBM has been changed to enforce RBM to
% learn sparse representation. The goal of sparsity in RBM is that the most
% of hidden units has zero values and this is equivalent to tend activation
% probability of hidden units to zero. Sparse generative RBM is an
% sparse RBM for generative purposes like feature extraction, etc.

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
%SparseGenerativeRBM Class
classdef SparseGenerativeRBM<GenerativeRBM & SparseRBM
    
    %% PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=SparseGenerativeRBM(rbmParams)
            obj=obj@GenerativeRBM(rbmParams);
            obj=obj@SparseRBM(rbmParams);
        end %End of Constructor function
        
    end %End PUBLIC METHODS
    
   
end %End SparseGenerativeRBM class

