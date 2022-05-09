function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 25-Jan-2022 12:19:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filttrePB.
function filttrePB_Callback(hObject, eventdata, handles)
% hObject    handle to filttrePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filttrePH.
function filttrePH_Callback(hObject, eventdata, handles)
image = handles.courant_data;
s= strel('disk',5);
imageDilate=imdilate(image,s);
imageErode=imerode(image,s);
[l,c,d]=size(imageDilate);
imageErode=double(imageErode);
imageDilate=double(imageDilate);
v=imageDilate;
 for i=1:l
    for j=1:c
            v(i,j)=imageDilate(i,j)-imageErode(i,j);       
    end
 end
imageS=uint8(v);
imshow(imageS);


% --- Executes on button press in fermeture.
function fermeture_Callback(hObject, eventdata, handles)
image = handles.courant_data;
s= strel('disk',10);
c2=imdilate(image,s);
imageS=imerode(c2,s); % erosion(dilatation(image))
imshow(imerode(c2,s));


% --- Executes on button press in ouverture.
function ouverture_Callback(hObject, eventdata, handles)
% hObject    handle to ouverture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%s=strel('square',3);
image = handles.courant_data;
s= strel('disk',10);
c2=imerode(image,s);
imageS=uint8(imdilate(c2,s)); % dilatation(erosion(image))
imshow(imageS);


% --- Executes on button press in erosion.
function erosion_Callback(hObject, eventdata, handles)
% hObject    handle to erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
lementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
if(islogical(outputImg))
  for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img-lementS;
        else
          M=255;  
        end
        outputImg(i,j) = min(M(:));       
    end
  end
    imageS=uint8(outputImg);   
else
    s=strel('square',3);
    imageS=imerode(image,s);
end
imshow(imageS);


% --- Executes on button press in delatation.
function delatation_Callback(hObject, eventdata, handles)
% hObject    handle to delatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image = handles.courant_data;
lementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
if(islogical(outputImg))
for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img+lementS;
        else
          M=0;  
        end
        outputImg(i,j) = max(M(:)); 
    end
end
    imageS=uint8(outputImg);   
else
    s=strel('square',3);
    imageS=imdilate(image,s);
end
imshow(imageS);




% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.*');
%Chargement de l'image et affichage
handles.ima = imread(sprintf('%s',path,file));
%Affichage de l'aperçu
axes(handles.imageOrigine)
handles.courant_data = handles.ima;
%imshow(handles.courant_data);
subimage(handles.courant_data);
axes(handles.imageTritai)
handles.ima_traite = 256;
subimage(handles.ima_traite);
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
image = handles.ima_traite;
[file,path] = uiputfile('*.png','Enregistrer Votre Image ...');
imwrite(image, sprintf('%s',path,file),'png');


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
delete(handles.figure1)
