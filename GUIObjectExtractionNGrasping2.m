function varargout = GUIObjectExtractionNGrasping2(varargin)
% GUIOBJECTEXTRACTIONNGRASPING2 MATLAB code for GUIObjectExtractionNGrasping2.fig
%      GUIOBJECTEXTRACTIONNGRASPING2, by itself, creates a new GUIOBJECTEXTRACTIONNGRASPING2 or raises the existing
%      singleton*.
%
%      H = GUIOBJECTEXTRACTIONNGRASPING2 returns the handle to a new GUIOBJECTEXTRACTIONNGRASPING2 or the handle to
%      the existing singleton*.
%
%      GUIOBJECTEXTRACTIONNGRASPING2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIOBJECTEXTRACTIONNGRASPING2.M with the given input arguments.
%
%      GUIOBJECTEXTRACTIONNGRASPING2('Property','Value',...) creates a new GUIOBJECTEXTRACTIONNGRASPING2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIObjectExtractionNGrasping2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIObjectExtractionNGrasping2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

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
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIObjectExtractionNGrasping2

% Last Modified by GUIDE v2.5 25-Nov-2015 11:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIObjectExtractionNGrasping2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIObjectExtractionNGrasping2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%--- Executes just before GUIObjectExtractionNGrasping2 is made visible.
function GUIObjectExtractionNGrasping2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIObjectExtractionNGrasping2 (see VARARGIN)

% Showing Test image 1 in pushbutton 1
[a,map]=imread('Test_001.jpg');
[r,c,d]=size(a);
x=ceil(r/150);
y=ceil(c/150);
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.pushbutton1,'CData',g);

% Showing Test image 2 in pushbutton 2
[a,map]=imread('Test_002.jpg');
[r,c,d]=size(a);
x=ceil(r/200);
y=ceil(c/200);
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.pushbutton2,'CData',g);

% Showing Test image 3 in pushbutton 31
[a,map]=imread('Test_003.jpg');
[r,c,d]=size(a);
x=ceil(r/200);
y=ceil(c/200);
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.pushbutton3,'CData',g);

% Showing Test image 4 in pushbutton 31
[a,map]=imread('Test_004.jpg');
[r,c,d]=size(a);
x=ceil(r/200);
y=ceil(c/200);
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.pushbutton4,'CData',g)

% Choose default command line output for GUIObjectExtractionNGrasping2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIObjectExtractionNGrasping2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIObjectExtractionNGrasping2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of template1
%a = get(hObject,'Value');

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

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
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
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

        %imshow(n2);
        pause(0.5);
    end
    %axes(handles.axes1);
    flushdata(obj);
end
stop(obj);

% Testing extracted image using Deep Belief Network

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

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row

if n == 4   % if no. of objects are 4
        if y(1,1) > y(1,2) && y(1,1) > y(1,3) && y(1,1) > y(1,4)
        center = 1;
    elseif y(1,2) > y(1,1) && y(1,2) > y(1,3) && y(1,2) > y(1,4)
        center = 2;
    elseif y(1,3) > y(1,1) && y(1,3) > y(1,2) && y(1,3) > y(1,4)
        center = 3;
    else
        center = 4;
        end

    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    elseif center == 3
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    else
        Center_x = centroid(4,2);
        Center_y = centroid(4,1);
    end
    
elseif n == 3   % if no. of objects are 3
    if y(1,1)>y(1,2) && y(1,1)>y(1,3)
        center = 1;
    elseif y(1,2)>y(1,1) && y(1,2)>y(1,3)
        center = 2;
    else
        center = 3;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    else
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    end
    
elseif n == 2   % if no. of objects are 2
    if y(1,1)>y(1,2)
        center = 1;
    else
        center = 2;
    end
        % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    else
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    end
elseif n == 1   % if no. of object is 1
    %center = 1;
        Center_x = centroid(1,2);        
        Center_y = centroid(1,1);
else
    disp('There in no object');
end
    
% assign variable value to workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = 25; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -10; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(180);
    Rx = num2str(-180);
    Ry = num2str(0);
    Rz = num2str(180);
    fig = num2str(5);

    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % Chuck the object, pick-up
        caoExt.Execute('Chuck',1);
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % robot move to placing position
        P3='(345,0,400,-180,0,180,5)';
        rob.Move(1,P3);
        
        % place the object
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        caoExt.Execute('UnChuck',2);

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of template1
%a = get(hObject,'Value');

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

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
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
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

        %imshow(n2);
        pause(0.5);
    end
    %axes(handles.axes1);
    flushdata(obj);
end
stop(obj);

% Testing extracted image using Deep Belief Network

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

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
if n == 4 % if number of objects are 4
    if y(2,1) > y(2,2) && y(2,1) > y(2,3) && y(2,1) > y(2,4)
        center = 1;
    elseif y(2,2) > y(2,1) && y(2,2) > y(2,3) && y(2,2) > y(2,4)
        center = 2;
    elseif y(2,3) > y(2,1) && y(2,3) > y(2,2) && y(2,3) > y(2,4)
        center = 3;
    else
        center = 4;
    end

% according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    elseif center == 3
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    else
        Center_x = centroid(4,2);
        Center_y = centroid(4,1);
    end
    
elseif n == 3   % if number of objects are 3
    if y(2,1)>y(2,2) && y(2,1)>y(2,3)
        center = 1;
    elseif y(2,2)>y(2,1) && y(2,2)>y(2,3)
        center = 2;
    else
        center = 3;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    else
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    end
    
elseif n == 2   % if number of objects are 2
    if y(2,1)>y(2,2)
        center = 1;
    else
        center = 2;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    else
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    end
    
elseif n == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
else
    disp('There is no object');
end
    
%show value in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = 30; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -10; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(180);
    Rx = num2str(-180);
    Ry = num2str(0);
    Rz = num2str(180);
    fig = num2str(5);

    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%a = get(hObject,'Value');

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

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
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
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

        %imshow(n2);
        pause(0.5);
    end
    %axes(handles.axes1);
    flushdata(obj);
end
stop(obj);

% Testing extracted image using Deep Belief Network

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

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
if n==4
    if y(3,1) > y(3,2) && y(3,1) > y(3,3) && y(3,1) > y(3,4)
        center = 1;
    elseif y(3,2) > y(3,1) && y(3,2) > y(3,3) && y(3,2) > y(3,4)
        center = 2;
    elseif y(3,3) > y(3,1) && y(3,3) > y(3,2) && y(3,3) > y(3,4)
        center = 3;
    else
        center = 4;
    end

    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    elseif center == 3
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    else
        Center_x = centroid(4,2);
        Center_y = centroid(4,1);
    end
    
elseif n == 3   % number of objects are 3
    if y(3,1)>y(3,2) && y(3,1)>y(3,3)
        center = 1;
    elseif y(3,2)>y(3,1) && y(3,2)>y(3,3)
        center = 2;
    else
        center = 3;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    else
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    end
    
elseif n == 2   % number of objects are 2
    if y(3,1)>y(3,2)
        center = 1;
    else
        center = 2;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    else
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    end
    
elseif n == 1   % number of objects are 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
else
    disp('There is no object');
end
    
% show variable in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

     armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = 30; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -10; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(180);
    Rx = num2str(-180);
    Ry = num2str(0);
    Rz = num2str(180);
    fig = num2str(5);

    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of template1
%a = get(hObject,'Value');

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

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
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
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

        %imshow(n2);
        pause(0.5);
    end
    %axes(handles.axes1);
    flushdata(obj);
end
stop(obj);

% Testing extracted image using Deep Belief Network

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

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
if n == 4
    if y(4,1) > y(4,2) && y(4,1) > y(4,3) && y(4,1) > y(4,4)
        center = 1;
    elseif y(4,2) > y(4,1) && y(4,2) > y(4,3) && y(4,2) > y(4,4)
        center = 2;
    elseif y(4,3) > y(4,1) && y(4,3) > y(4,2) && y(4,3) > y(4,4)
        center = 3;
    else
        center = 4;
    end
% end
assignin('base','center',center)

% according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    elseif center == 3
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);
    else
        Center_x = centroid(4,2);
        Center_y = centroid(4,1);
    end
    
elseif n == 3
    if y(4,1)>y(4,2) && y(4,1)>y(4,3)
        center = 1;
    elseif y(4,2)>y(4,1) && y(4,2)>y(4,3)
        center = 2;
    else
        center = 3;
    end
        
     % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    elseif center == 2
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    else
        Center_x = centroid(3,2);
        Center_y = centroid(3,1);    
    end
    
elseif n == 2
    if y(4,1)>y(4,2)
        center = 1;
    else
        center = 2;
    end
    
    % according to object class, finding centroid of the object
    if center == 1
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
    else
        Center_x = centroid(2,2);
        Center_y = centroid(2,1);
    end
    
elseif n == 1
    
        Center_x = centroid(1,2);
        Center_y = centroid(1,1);
else
    disp('There is no object');
end

% show variable in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = 30; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -10; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(180);
    Rx = num2str(-180);
    Ry = num2str(0);
    Rz = num2str(180);
    fig = num2str(5);

    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    assignin('base','P2',P2)

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob