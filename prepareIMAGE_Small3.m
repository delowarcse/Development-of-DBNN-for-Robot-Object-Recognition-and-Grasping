%****************************In the Name of God****************************
%prepareMNIST function prepares MNIST dataset to be usable.
%

% The code is inspired from paper: Hinton, Geoffrey E., and Ruslan R.
% Salakhutdinov. "Reducing the dimensionality of data with neural
% networks." Science 313.5786 (2006): 504-507.

% All right is reserved by Delowar Hossain
% CONTRIBUTOR
%	Created by:
% 		DELOWAR HOSSAIN
%		PhD on Intelligence Robotics
% 		Graduate School of Science and Engineering for Education
% 		Faculty of Engineering
%		University of Toyama, Toyama, Japan. (2015-2018)
% 		E-mail: delowar_cse_ru@yahoo.com
% 		Skype: delowarcse
% 		Web-page: https://www.linkedin.com/in/delowar-hossain-ph-d-2bb479b9/
%**************************************************************************
% Prepare a part of MNIST dataset to be usable
% mnistFolder: String that determine MNIST path folder
function [data] = prepareIMAGE_Small3()
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [0 +1]
data.valueType=ValueType.gaussian;
% data.valueType=ValueType.probability;

dataFile=load(['camera_image_small3.mat']);
data.trainData=dataFile.data;
data.trainLabels=dataFile.labels-1;
%data.testData=dataFile.testdata;
%data.testLabels=dataFile.testlabels-1;
end %End of prepareMNIST_Small funcrion