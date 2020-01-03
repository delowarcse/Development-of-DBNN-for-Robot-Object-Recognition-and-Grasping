function varargout = GUIObjectRecognitionNGrasping_HU2(varargin)

% Multiple object recognition and Grasping

% GUIOBJECTRECOGNITIONNGRASPING_HU2 MATLAB code for GUIObjectRecognitionNGrasping_HU2.fig
%      GUIOBJECTRECOGNITIONNGRASPING_HU2, by itself, creates a new GUIOBJECTRECOGNITIONNGRASPING_HU2 or raises the existing
%      singleton*.
%
%      H = GUIOBJECTRECOGNITIONNGRASPING_HU2 returns the handle to a new GUIOBJECTRECOGNITIONNGRASPING_HU2 or the handle to
%      the existing singleton*.
%
%      GUIOBJECTRECOGNITIONNGRASPING_HU2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIOBJECTRECOGNITIONNGRASPING_HU2.M with the given input arguments.
%
%      GUIOBJECTRECOGNITIONNGRASPING_HU2('Property','Value',...) creates a new GUIOBJECTRECOGNITIONNGRASPING_HU2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIObjectRecognitionNGrasping_HU2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIObjectRecognitionNGrasping_HU2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIObjectRecognitionNGrasping_HU2

% Last Modified by GUIDE v2.5 25-May-2016 14:38:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIObjectRecognitionNGrasping_HU2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIObjectRecognitionNGrasping_HU2_OutputFcn, ...
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


% --- Executes just before GUIObjectRecognitionNGrasping_HU2 is made visible.
function GUIObjectRecognitionNGrasping_HU2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIObjectRecognitionNGrasping_HU2 (see VARARGIN)

% Showing Test image 1 in pushbutton 1
    [a,map]=imread('Test_001.jpg');
    [r,c,d]=size(a);
    x=ceil(r/150);
    y=ceil(c/150);
    g=a(1:x:end,1:y:end,:);
    g(g==255)=5.5*255;
    %set(handles.axes1,'CData',g);
    axes(handles.axes1);
    imshow(g);

    % Showing Test image 2 in pushbutton 2
    [a,map]=imread('Test_002.jpg');
    [r,c,d]=size(a);
    x=ceil(r/200);
    y=ceil(c/200);
    g=a(1:x:end,1:y:end,:);
    g(g==255)=5.5*255;
    %set(handles.axes2,'CData',g);
    axes(handles.axes2);
    imshow(g);

    % Showing Test image 3 in pushbutton 3
    [a,map]=imread('Test_003.jpg');
    [r,c,d]=size(a);
    x=ceil(r/200);
    y=ceil(c/200);
    g=a(1:x:end,1:y:end,:);
    g(g==255)=5.5*255;
    %set(handles.axes3,'CData',g);
    axes(handles.axes3);
    imshow(g);

    % Showing Test image 4 in pushbutton 4
    [a,map]=imread('Test_004.jpg');
    [r,c,d]=size(a);
    x=ceil(r/200);
    y=ceil(c/200);
    g=a(1:x:end,1:y:end,:);
    g(g==255)=5.5*255;
    %set(handles.axes4,'CData',g)
    axes(handles.axes4);
    imshow(g);

% Choose default command line output for GUIObjectRecognitionNGrasping_HU2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIObjectRecognitionNGrasping_HU2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIObjectRecognitionNGrasping_HU2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

    % while 1
    for k = 1:1
        frame=getdata(obj,1);
        %main = strcat('MainIMAGE_06_00',num2str(1),'.jpg');
        %imwrite(frame,main);

        for i = 80:380  %75:240 %30:200 %40:310
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
            rectangle('Position',[centroid(object,1)-17,centroid(object,2)-18,36,36]);
        end

    % Object Extraction
        %figure;
        for n=1:Ne
            %figure;
            [r,c] = find(bw==n);

            % object extraction with respect to centroid, 81x81 pixels
            % n2 = frame1(round(centroid(n,2))-40:round(centroid(n,2))+40,round(centroid(n,1))-40:round(centroid(n,1))+40);
            % object extraction with respect to centroid, 28x28 pixels
            n2 = frame1(round(centroid(n,2))-13:round(centroid(n,2))+14,round(centroid(n,1))-13:round(centroid(n,1))+14);
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
%load dbnAfterBPCamera4;
load dbnAfterBP-28x28_1; % Load train network from DB-21052016_Pixel-28x28
[classNumber,y]=dbn.getOutput(data.testData)
%errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber);

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
figure, imshow(frame);

max_val = max(y(1,:));

if max_val < 0.5000
    %disp('The requested object does not exist');
    h = msgbox('The requested object does not exist', 'Warn','warn');
    return;
end

for i=1:1:n
    if y(1,i) == max_val
        pos = i; 
    end
end

% according to object class, finding centroid of the object
Center_x = centroid(pos,2);
Center_y = centroid(pos,1);
Rotation = orientation(pos);
rectangle('Position',[centroid(pos,1)-17,centroid(pos,2)-18,36,36]);
   
% assign variable value to workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = -40; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -8; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(170);
    Rx = num2str(-180);
    Ry = num2str(0);
        rz = 180;
    Rz = num2str(rz);
    fig = num2str(5);
   
    % Move to the above position (Z=160) of the object
    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    
    % Rotate the gripper according the object orientation
    if Rotation<0
        rz1 = rz + Rotation - 90;
    else
        rz1 = rz + Rotation - 90;
    end
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
           
    Rz1 = num2str(rz1);
    P311 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz1,',',fig,')');
    rob.Move(1,P311);
    
    %pause;
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
            % Move to the actual position (Z=135) of the object
            P2 = strcat('(',X,',',Y,',','135',',',Rx,',',Ry,',',Rz1,',',fig,')');
            rob.Move(1,P2);
            
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % Chuck the object, pick-up
        caoExt.Execute('Chuck',1);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        P4 = strcat('(',X,',',Y,',','170',',',Rx,',',Ry,',',Rz,',',fig,')');
        rob.Move(1,P4);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % robot move to placing position
        %P3='(150,150,230,-180,0,180,5)';
        P3='(400,300,300,-180,0,180,5)';
        rob.Move(1,P3);
        %pause
%         load Obj1_01
%         [a b] = size(preArr2);
%         
%         % Trajectory learning
%         for i = 7:a
%             p = [preArr2(i,1) preArr2(i,2) preArr2(i,3) preArr2(i,4) preArr2(i,5) preArr2(i,6) 5];
%     
%             p1 = strhen7(p);
%             rob.Move(1,p1,'NEXT');
%             rob.Execute('Arrive',15);
%             rob.Execute('MotionSkip',[-1,3]);
%         end
%         
%         
        % place the object
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        caoExt.Execute('UnChuck',2);
        
         % back to the initial position
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        P1='(155,0,300,-180,0,180,5)';
        rob.Move(1,P1);

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

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

% while 1
for k = 1:1
    frame=getdata(obj,1);
    %main = strcat('MainIMAGE_06_00',num2str(1),'.jpg');
    %imwrite(frame,main);

    for i = 80:380  %75:240 %30:200 %40:310
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
        rectangle('Position',[centroid(object,1)-17,centroid(object,2)-18,36,36]);
    end
    
    % Object Extraction
    %figure;
    for n=1:Ne
        %figure;
        [r,c] = find(bw==n); % bw is label matrix
        
        % object extraction with respect to centroid, 81x81 pixels
        % n2 = frame1(round(centroid(n,2))-40:round(centroid(n,2))+40,round(centroid(n,1))-40:round(centroid(n,1))+40);
        % object extraction with respect to centroid, 28x28 pixels
        n2 = frame1(round(centroid(n,2))-13:round(centroid(n,2))+14,round(centroid(n,1))-13:round(centroid(n,1))+14);
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
load dbnAfterBP-28x28_1; % Load train network from DB-21052016_Pixel-28x28
[classNumber,y]=dbn.getOutput(data.testData)
%errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber);

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
figure, imshow(frame);

max_val = max(y(2,:));

if max_val < 0.5000
    %disp('The requested object does not exist');
    h = msgbox('The requested object does not exist', 'Warn','warn');
    return;
end

for i=1:1:n
    if y(2,i) == max_val
        pos = i;
    end
end

Center_x = centroid(pos,2);
Center_y = centroid(pos,1);
Rotation = orientation(pos);
rectangle('Position',[centroid(pos,1)-17,centroid(pos,2)-18,36,36]);

    
%show value in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = -40; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -5; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(160);
    Rx = num2str(-180);
    Ry = num2str(0);
        rz = 180;
    Rz = num2str(rz);
    fig = num2str(5);

    % Move to the above position (Z=160) of the object
    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    
    % Rotate the gripper according the object orientation
    if Rotation<0
        rz1 = rz + Rotation - 90;
    else
        rz1 = rz + Rotation - 90;
    end
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end

    Rz1 = num2str(rz1);
    P311 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz1,',',fig,')');
    rob.Move(1,P311);
    
    %pause;
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
             %Move to the actual position (Z=135) of the object
           P2 = strcat('(',X,',',Y,',','135',',',Rx,',',Ry,',',Rz1,',',fig,')');
            rob.Move(1,P2);
            
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % Chuck the object, pick-up
        caoExt.Execute('Chuck',1);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        P4 = strcat('(',X,',',Y,',','160',',',Rx,',',Ry,',',Rz,',',fig,')');
        rob.Move(1,P4);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % robot move to placing position
        %P3='(150,150,230,-180,0,180,5)';
        P3='(400,300,300,-180,0,180,5)';
        rob.Move(1,P3);
%         %pause
%         load Obj2_01
%         [a b] = size(preArr2);
%         
%         % Trajectory learning
%         for i = 9:a
%             p = [preArr2(i,1) preArr2(i,2) preArr2(i,3) preArr2(i,4) preArr2(i,5) preArr2(i,6) 5];
%     
%             p1 = strhen7(p);
%             rob.Move(1,p1,'NEXT');
%             rob.Execute('Arrive',15);
%             rob.Execute('MotionSkip',[-1,3]);
%         end
%         
        % place the object
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        caoExt.Execute('UnChuck',2);
%         
%         % back to the initial position
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        rob.Move(1,P1);

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

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

% while 1
for k = 1:1
    frame=getdata(obj,1);
    %main = strcat('MainIMAGE_06_00',num2str(1),'.jpg');
    %imwrite(frame,main);

    for i = 80:380 %75:240 %30:200 %40:310
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
        rectangle('Position',[centroid(object,1)-17,centroid(object,2)-17,36,36]);
    end
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
        [r,c] = find(bw==n);% bw is label matrix
        
        % object extraction with respect to centroid, 81x81 pixels
        % n2 = frame1(round(centroid(n,2))-40:round(centroid(n,2))+40,round(centroid(n,1))-40:round(centroid(n,1))+40);
        % object extraction with respect to centroid, 28x28 pixels
        n2 = frame1(round(centroid(n,2))-13:round(centroid(n,2))+14,round(centroid(n,1))-13:round(centroid(n,1))+14);
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
load dbnAfterBP-28x28_1; % Load train network from DB-21052016_Pixel-28x28
[classNumber,y]=dbn.getOutput(data.testData)
%errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber);

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row
figure, imshow(frame);

max_val = max(y(3,:));

if max_val < 0.5000
    %disp('The requested object does not exist');
    h = msgbox('The requested object does not exist', 'Warn','warn');
    return;
end

for i=1:1:n
    if y(3,i) == max_val
        pos = i;
    end
end

Center_x = centroid(pos,2);
Center_y = centroid(pos,1);
Rotation = orientation(pos);
rectangle('Position',[centroid(pos,1)-17,centroid(pos,2)-18,36,36]);

   
% show variable in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

     armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = -40; % to correct the robot position
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
    Z = num2str(160);
    Rx = num2str(-180);
    Ry = num2str(0);
    Rz = num2str(180);
    fig = num2str(5);

    % Move to the above position (Z=160) of the object
    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    
            State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
            % Move to the above actual (Z=133) of the object
            P2 = strcat('(',X,',',Y,',','133',',',Rx,',',Ry,',',Rz,',',fig,')');
            rob.Move(1,P2);
            
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        % Chuck the object, pick-up
        caoExt.Execute('Chuck',1);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        P4 = strcat('(',X,',',Y,',','160',',',Rx,',',Ry,',',Rz,',',fig,')');
        rob.Move(1,P4);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % robot move to placing position
        %P3='(150,150,230,-180,0,180,5)';
        P3='(400,300,300,-180,0,180,5)';
        rob.Move(1,P3);
        
%         %pause
%         load Obj3_01
%         [a b] = size(preArr3);
%         
%         % Trajectory learning
%         for i = 8:a
%             p = [preArr3(i,1) preArr3(i,2) preArr3(i,3) preArr3(i,4) preArr3(i,5) preArr3(i,6) 5];
%     
%             p1 = strhen7(p);
%             rob.Move(1,p1,'NEXT')
%             rob.Execute('Arrive',15);
%             rob.Execute('MotionSkip',[-1,3]);
%         end
%         
%         p3 = [497.00 -20 275 180 0 -180 5];
%         rob.Move(1,p3);
        
        % place the object
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        caoExt.Execute('UnChuck',2);
        
        % back to the initial position
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        rob.Move(1,P1);

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob
%close all


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

obj=videoinput('winvideo',1,'YUY2_640x480');  % create video input device

set(obj,'TriggerRepeat',inf) % set graphics object properties
set(obj,'ReturnedColorSpace','rgb')
start(obj)

% while 1
for k = 1:1
    frame=getdata(obj,1);
    %main = strcat('MainIMAGE_06_00',num2str(1),'.jpg');
    %imwrite(frame,main);

    for i = 80:380 %75:240 %30:200 %40:310
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
        rectangle('Position',[centroid(object,1)-17,centroid(object,2)-18,36,36]);
    end
    
% Object Extraction
    %figure;
    for n=1:Ne
        %figure;
        [r,c] = find(bw==n);% bw is label matrix
        
        % object extraction with respect to centroid, 81x81 pixels
        % n2 = frame1(round(centroid(n,2))-40:round(centroid(n,2))+40,round(centroid(n,1))-40:round(centroid(n,1))+40);
        % object extraction with respect to centroid, 28x28 pixels
        n2 = frame1(round(centroid(n,2))-13:round(centroid(n,2))+14,round(centroid(n,1))-13:round(centroid(n,1))+14);
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
%load dbnAfterBPCamera4;
load dbnAfterBP-28x28_1; % Load train network from DB-21052016_Pixel-28x28
[classNumber,y]=dbn.getOutput(data.testData)
%errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber);

% write variable in workspace
assignin('base','classNumber',classNumber)
assignin('base','y',y)
assignin('base','centroid',centroid)

% finding the object class in the row

figure, imshow(frame);

max_val = max(y(4,:));

if max_val < 0.5000
    %disp('The requested object does not exist');
    h = msgbox('The requested object does not exist', 'Warn','warn');
    return;
end

for i=1:1:n
    if y(4,i) == max_val
        pos = i; 
    end
end

Center_x = centroid(pos,2);
Center_y = centroid(pos,1);
Rotation = orientation(pos);
rectangle('Position',[centroid(pos,1)-17,centroid(pos,2)-18,36,36]);


% show variable in workspace
%assignin('base','center',center)
assignin('base','Center_x',Center_x)
assignin('base','Center_y',Center_y)

% Robot Grasping

    armset;
    
    % Finding object position of X w.r.t robot
    ax = 160.5665;
    bx = -40; % to correct the robot position
    ax1 = 1.4009;
    %centroid(i,2);
    x = ax1*Center_x+ax+bx;
    
    % Finding object position of X w.r.t robot
    ay = -525.3694;
    by = -5; % to correct the robot position
    ay1 = 1.6046;
    %centroid(i,1);
    y = ay1*Center_y+ay+by;
    
    % Arm set

    X = num2str(x);
    Y = num2str(y);
    Z = num2str(160);
    Rx = num2str(-180);
    Ry = num2str(0);
        rz = 180;
    Rz = num2str(rz);
    fig = num2str(5);

    % Move to the above position (Z=160) of the object
    P2 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz,',',fig,')');
    rob.Move(1,P2);
    
    % Rotate the gripper according the object orientation
    if Rotation<0
        rz1 = rz + Rotation - 90;
    else
        rz1 = rz + Rotation - 90;
    end
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end

    Rz1 = num2str(rz1);
    P311 = strcat('(',X,',',Y,',',Z,',',Rx,',',Ry,',',Rz1,',',fig,')');
    rob.Move(1,P311);
    
    %pause;
    
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
            % Move to the above position (Z=133) of the object
            P2 = strcat('(',X,',',Y,',','133',',',Rx,',',Ry,',',Rz1,',',fig,')');
            rob.Move(1,P2);
            
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % Chuck the object, pick-up
        caoExt.Execute('Chuck',1);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        
        % after pick-up object, it will little high
        P4 = strcat('(',X,',',Y,',','160',',',Rx,',',Ry,',',Rz,',',fig,')');
        rob.Move(1,P4);
        %pause
        
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        % robot move to placing position
        %P3='(150,150,230,-180,0,180,5)';
        P3='(400,300,300,-180,0,180,5)';
        rob.Move(1,P3);
%         %pause
%         load Obj4_01
%         [a b] = size(preArr4);
%         
%         % Trajectory learning
%         for i = 6:a
%             p = [preArr4(i,1) preArr4(i,2) preArr4(i,3) preArr4(i,4) preArr4(i,5) preArr4(i,6) 5];
%             p1 = strhen7(p);
%             rob.Move(1,p1,'NEXT');
%             rob.Execute('Arrive',15);
%             rob.Execute('MotionSkip',[-1,3]);
%         end 
%         
%         p3 = [493.00 -100 275 180 0 -180 5];
%         rob.Move(1,p3);
        
        % place the object
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        caoExt.Execute('UnChuck',2);
        
        % back to the initial position
        State = caoExt.Execute('get_BusyState');
        while State ~=0
            State = caoExt.Execute('get_BusyState');
        end
        rob.Move(1,P1);

%pause(1)
clear cao % Clear all declear object for next execution
clear ws
clear ctrl
clear rob
