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

clear;
close all;
obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

count = 0;

% while 1
for k = 1:1
    frame=getdata(obj,1);
    %main = strcat('MainIMAGE_06_00',num2str(1),'.jpg');
    %imwrite(frame,main);

    for i = 40:340
        for j = 130:520
            im(i,j,:) = frame(i,j,:);
        end
    end

    frame1 = rgb2gray(im);
    
    % Detecting a Cell Using Image Segmentation
    % Step 2: Detect Entire Cell
    [~, threshold] = edge(frame1, 'Canny');
    fudgeFactor = 7; %5 not bad, 7,
    BWs = edge(frame1,'Canny', threshold * fudgeFactor);
    %     BWs = edge(frame1,'Canny', threshold);
    %     imshow(BWs), title('binary gradient mask');
    
    % Step 3: Dilate the Image
    se90 = strel('line', 3, 90); %Create morphological structuring element (STREL)
    se0 = strel('line', 3, 0); % strel('line', Length, Degree)
    
    BWsdil = imdilate(BWs, [se90 se0]);
    %  imshow(BWsdil), title('dilated gradient mask')
    
    %  Step 4: Fill Interior Gaps
    BWdfill = imfill(BWsdil, 'holes');
    %     imshow(BWdfill); title('binary image with filled holes');
    
    %Step 5: Remove Connected Objects on Border
    BWnobord = imclearborder(BWdfill, 8);
    %     imshow(BWnobord), title('cleared border image');
    
    %     Step 6: Smoothen the Object
    seD = strel('diamond',1);
    BWfinal = imerode(BWnobord,seD);
    BWfinal = imerode(BWfinal,seD);
    %     imshow(BWfinal), title('segmented image');
    %     hold on
    
    %     An alternate method for displaying
    %     the segmented object would be to place an outline
    %     around the segmented cell.
    %     The outline is created by the bwperim function.
    BWoutline = bwperim(BWfinal);
    Segout = frame1;
    Segout(BWoutline) = 255;
    figure,imshow(Segout), title('outlined original image');
    hold on
    
    % Remove all object containing fewer than 30 pixels
    bwao = bwareaopen(BWfinal,30);
    
    % Label the binary image and computer the centroid and center of mass.
    % labeledImage = bwlabel(BWfinal);
    [bw,Ne] = bwlabel(bwao, 8); % bw is label matrix and Ne is connected object
    
    % traces the exterior boundaries of objects
    % noholes is search only for object (parent and child) boundaries
    [B,L] = bwboundaries(bw,'noholes');
    
    loop = length(B);
    
    %     measurements = regionprops(L,frame1, ...
    %         'BoundingBox', 'Centroid', 'WeightedCentroid', 'Perimeter','Orientation','PixelValues');
    measurements = regionprops(L,frame1,'all');
    
    %     count = count+1
    centroid = [];
    orientation = [];
    box = [];
    val = [];
    
    for object=1:loop   
        box(object,:) = measurements(object).BoundingBox;
        centroid(object,:) = measurements(object).Centroid;
        centerOfMass(object,:) = measurements(object).WeightedCentroid;
        perimeter(object,:) = measurements(object).Perimeter;
        orientation(object,:) = measurements(object).Orientation;
        plot(centroid(object,1),centroid(object,2),'o');       
    end
    
%% Object Extraction
    %figure;
    for n=1:Ne
        figure;
        [r,c] = find(bw==n);
        
        % extractly object extraction and resizing object
        n1=frame1(min(r):max(r),min(c):max(c));
        [r1(n) c1(n)] = size(n1);
        for i = 1:r1(n)
            for j = 1:c1(n)
                a(i,j) = n1(i,j);
            end
        end
        for k = r1(n):70
            for l = c1(n):70
                a(k,l) = -100;
            end
        end
        ResizeIMAGE(n,:) = reshape(a,1,70*70);
        
        % object extraction with respect to centroid, 81x81 pixels
        % object extraction with respect to centroid, 81x81 pixels
        n2 = frame1(round(centroid(n,2))-40:round(centroid(n,2))+40,round(centroid(n,1))-40:round(centroid(n,1))+40);
        [r2(n) c2(n)] = size(n2);
        ReCenIMAGE(n,:) = reshape(n2,1,r2(n)*c2(n)); % Reshape 
        testdata(n,:) = double(ReCenIMAGE(n,:));

        imshow(n2);
        pause(0.5);
    end
    
    flushdata(obj);
end
stop(obj);

 %% Testing extracted image using Deep Belief Network
 
addpath('DeeBNet');
%  
% % Creating an object to store train and test data and their labels
% data=DataClasses.DataStore();
%  
% % Data value type is gaussian because the value can be consider a real
% % value [0 +1]
% data.valueType=ValueType.gaussian;
% % data.valueType=ValueType.probability;

data = prepareIMAGE_Small3();%uncomment this line to use a small part of MNIST dataset.
data.testData = testdata;
data.normalize('meanvar');
data.shuffle();

% load train neural network
load dbnAfterBPCamera4;
[classNumber,y]=dbn.getOutput(data.testData)
%errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber);

%% Robot Grasping

armset;

for i = 1:n
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = 15; % to correct the robot position
    ax1 = 1.4009;
    centroid(i,2);
    x = ax1*centroid(i,2)+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -10; % to correct the robot position
    ay1 = 1.6046;
    centroid(i,1);
    y = ay1*centroid(i,1)+ay+by;
    
    %% Arm set

X = num2str(x);
Y = num2str(y);
Z = num2str(180);
Rx = num2str(-180);
Ry = num2str(0);
Rz = num2str(180);
fig = num2str(5);

P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
rob.Move(1,P2);

pause(1)
end