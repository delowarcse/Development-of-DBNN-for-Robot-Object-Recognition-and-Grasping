%********************************************************
% Sparse RBM class defines all necessary functions and features in all
% types of sparse RBMs. Indeed the SparseRBM class is an abstract class and
% we can't create an object from it.
% [1] H. Lee, C. Ekanadham, and A. Ng, “Sparse deep belief net model for
% visual area V2,” Advances in neural information processing systems, vol.
% 20, pp. 873–880, 2008.
% [2] N.-N. Ji, J.-S. Zhang, and C.-X. Zhang, “A sparse-response deep
% belief network based on rate distortion theory,” Pattern Recognition,
% vol. 47, no. 9, pp. 3179–3191, Sep. 2014.


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
%SparseRBM Class
classdef (Abstract) SparseRBM<RBM
    %% PUBLIC METHODS -----------------------------------------------------
    methods (Access=public)
        %% Constructor
        function obj=SparseRBM(rbmParams)
            obj=obj@RBM(rbmParams);
            obj.rbmParams.sparsity=1;
        end %End of Constructor function
        
    end %End PUBLIC METHODS
    
    %% PROTECTED METHODS --------------------------------------------------
    methods (Access=protected)
        
        function [deltaWeightReg,deltaVisBiasReg,deltaHidBiasReg]=getRegularizationGradient(obj,batchData,posHid)
            switch obj.rbmParams.sparsityMethod
                % based on paper [1]
                case 'quadratic'
                    term1=obj.rbmParams.sparsityTarget-posHid;
                    term2=1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=mean((posHid).*(1-posHid));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost.*mean(term1).*term3;
                    deltaWeightReg=obj.rbmParams.sparsityCost*repmat(mean(term1),size(batchData,2),1).*term2;
                % based on paper [2]
                case 'rateDistortion'
                    term2=-1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=-mean((posHid).*(1-posHid));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost*term3;
                    deltaWeightReg=obj.rbmParams.sparsityCost*term2;
                 % based on our paper
                case 'normal'
                    term1=obj.rbmParams.sparsityTarget-posHid;
                    term2=1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=mean((posHid).*(1-posHid));
                    term4=normpdf(mean(posHid),obj.rbmParams.sparsityTarget,sqrt(obj.rbmParams.sparsityVariance));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost*mean(term1).*term3.*term4;
                    deltaWeightReg=obj.rbmParams.sparsityCost*repmat(mean(term1),size(batchData,2),1).*term2.*repmat(term4,size(batchData,2),1);
                otherwise
                    error('Your sparsity method is not defined');
            end            
            deltaVisBiasReg=0;
        end %End of getRegularizationGradient function
        
    end %End PROTECTED METHODS
    
end %End SparseRBM class