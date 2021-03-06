%********************************************************
%Gibbs class is a sampling method. In this class we can generate samples
%from an RBM model with random initialization samples. Also this class is
%parent class for other sampling classes.
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
%Gibbs class
classdef Gibbs

    % PUBLIC PROPERTIES ---------------------------------------------------
    properties (Access=public)
        %This variable stores sampling method type
        methodType;
    end %End PUBLIC PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=Gibbs()
            obj.methodType='Gibbs';
        end %End of Constructor function
        
        %Running sampling method to generate new values in visible and
        %hidden units.
        %modelParams: Parameters of RBM model
        %posVis: Positive visible data. In Gibbs method, This matrix will
        %be used for positive hidden units.
        %posHid: Positive hidden units.
        %negVis: negative visible units.
        %negHid: negative hidden units.
        function [obj,posHid,negVis,negHid]=run(obj,modelParams,posVis)
            [posVis]=obj.initPosVis(modelParams,posVis);
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
        
        %Sampling hidden units from visible units
        %modelParams: Parameters of RBM model
        %visSample: visible samples that will be used in sampling hidden units.
        %hidSample: generated hidden samples
        %hidProb: probability of activation in hidden samples
        function [hidSample,hidProb]=up(obj,modelParams,visSample)
            [hidInput]=obj.propVisToHid(modelParams,visSample);
            [hidSample,hidProb]=obj.sampleHidFromVis(modelParams,hidInput);
        end %End of up function
        
        %Sampling visible units from hiiden units
        %modelParams: Parameters of RBM model
        %visSample: visible samples that will be used in sampling hidden units.
        %visProb: probability of activation in visible samples
        function [visSample,visProb]=down(obj,modelParams,hidSample)
            [visInput]=obj.propHidToVis(modelParams,hidSample);
            [visSample,visProb]=obj.sampleVisFromHid(modelParams,visInput);
        end %End of down function
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
        end %End of gather function
        
    end % End PUBLIC METHODS
    
    
    % PROTECTED METHODS ---------------------------------------------------
    methods (Access=protected)
        %Sigmoid function
        %x: input vector
        function [y]=sigmoid(~,x)
            y=1./(1+exp(-x));
        end %End of sigmoid function
        
        %Propagate hidden unit values to each visible units
        %modelParams: Parameters of RBM model
        %hid: hidden unit values
        %visInput: Accumulated input value for visible units.
        function [visInput]=propHidToVis(~,modelParams,hid)
            visInput=hid*modelParams.weight' + ...
                repmat(modelParams.visBias,size(hid,1),1);
        end %End of propHidToVis function
        
        %Propagate visible unit values to each hidden units
        %modelParams: Parameters of RBM model
        %vis: visible unit values
        %hidInput: Accumulated input value for hidden units.
        function [hidInput]=propVisToHid(~,modelParams,vis)
            hidInput=vis*modelParams.weight + ...
                repmat(modelParams.hidBias,size(vis,1),1);
        end%End of propVisToHid function
        
        %Sample visible units from accumulated input value to each visible unit
        %modelParams: Parameters of RBM model
        %visInput: Accumulated input value for visible units.
        %visSample: visible samples
        %visProb: probability of activation in visible samples
        function [visSample,visProb]=sampleVisFromHid(obj,modelParams,visInput)
            switch modelParams.visibleValueType
                case ValueType.probability
                    visProb=obj.sigmoid(visInput);
                    visSample=visProb;
                case ValueType.binary
                    visProb=obj.sigmoid(visInput);
                    if(modelParams.gpu)
                        visSample=double(visProb>rand(size(visProb),'gpuArray'));
                    else
                        visSample=double(visProb>rand(size(visProb)));
                    end
                case ValueType.gaussian
                    visProb=visInput;
                    visSample=visProb;%+randn(size(visProb));
            end
            if (modelParams.numberOfVisibleSoftmax>0)
                %probability of softmax
                psm=softmax(visInput(:,1:modelParams.numberOfVisibleSoftmax)')';
                visProb(:,1:modelParams.numberOfVisibleSoftmax)=psm;
                %state of softmax
                if(modelParams.gpu)
                    ssf=psm>rand(size(psm),'gpuArray');
                else
                    ssf=psm>rand(size(psm));
                end             
                visSample(:,1:modelParams.numberOfVisibleSoftmax)=ssf;
            end
        end%End of sampleVisFromHid function
        
        %Sample hidden units from accumulated input value to each hidden unit
        %modelParams: Parameters of RBM model
        %hidInput: Accumulated input value for hidden units.
        %hidSample: hidden samples
        %hidProb: probability of activation in hidden samples
        function [hidSample,hidProb]=sampleHidFromVis(obj,modelParams,hidInput)
            switch modelParams.hiddenValueType
                case ValueType.probability
                    hidProb=obj.sigmoid(hidInput);
                    hidSample=hidProb;
                case ValueType.binary
                    hidProb=obj.sigmoid(hidInput);
                    if(modelParams.gpu)
                        hidSample=double(hidProb>rand(size(hidProb),'gpuArray'));
                    else
                        hidSample=double(hidProb>rand(size(hidProb)));
                    end
                case ValueType.gaussian
                    hidProb=hidInput;
                    hidSample=hidProb;%+randn(size(hidProb));
            end
        end %End of sampleHidFromVis function
        
    end % End PROTECTED METHODS
    
    % PRIVATE METHODS -----------------------------------------------------
    methods (Access=private)
        
        %Initialize positive visible values
        %modelParams: Parameters of RBM model
        %posVis: Positive visible data. In Gibbs method, This matrix will
        %be used only for understanding batch size.
        function [posVis]=initPosVis(~,modelParams,posVis)
            switch modelParams.visibleValueType
                case ValueType.probability
                    posVis=rand(size(posVis,1),modelParams.numVis);
                case ValueType.binary
                    posVis=double(0.5>rand(size(posVis,1),modelParams.numVis));
                case ValueType.gaussian
                    posVis=randn(size(posVis,1),modelParams.numVis);
            end
        end %End of initPosVis function
        
    end %End PRIVATE METHODS
    
end %End Gibbs class 

