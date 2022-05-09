function varargout = filtreFrequenciel(varargin)
% FILTREFREQUENCIEL MATLAB code for filtreFrequenciel.fig
%      FILTREFREQUENCIEL, by itself, creates a new FILTREFREQUENCIEL or raises the existing
%      singleton*.
%
%      H = FILTREFREQUENCIEL returns the handle to a new FILTREFREQUENCIEL or the handle to
%      the existing singleton*.
%
%      FILTREFREQUENCIEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTREFREQUENCIEL.M with the given input arguments.
%
%      FILTREFREQUENCIEL('Property','Value',...) creates a new FILTREFREQUENCIEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filtreFrequenciel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filtreFrequenciel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filtreFrequenciel

% Last Modified by GUIDE v2.5 24-Jan-2022 16:31:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filtreFrequenciel_OpeningFcn, ...
                   'gui_OutputFcn',  @filtreFrequenciel_OutputFcn, ...
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


% --- Executes just before filtreFrequenciel is made visible.
function filtreFrequenciel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filtreFrequenciel (see VARARGIN)

% Choose default command line output for filtreFrequenciel

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filtreFrequenciel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filtreFrequenciel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Ouvrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
%Chargement de l'image et affichage
handles.ima = imread(sprintf('%s',path,file));
%Affichage de l'aperçu
axes(handles.imageOrogin)
handles.courant_data = handles.ima;
%imshow(handles.courant_data);
subimage(handles.courant_data);
axes(handles.imageFilltrez)
handles.ima_traite = 256;
subimage(handles.ima_traite);

%Grrrrrrrr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)

delete(handles.figure1)




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle tobutten pas bas ideal (see GCBO)
I = handles.courant_data;
 F=fftshift(fft2(I)); 
% %calcul de la taille de l'image; 
 M=size(F,1); 
 N=size(F,2); 
 P=size(F,3); 
 H0=zeros(M,N); 
 D0=10; 
 M2=round(M/2); 
 N2=round(N/2); 
 H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 
 for i=1:M 
  for j=1:N 
      G(i,j)=F(i,j)*H0(i,j); 
 end 
 end 
 g=ifft2(G); 
 imshow(abs(g),[0,255]);%title('image filtrée');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to  tobutten pas haut ideal (see GCBO)
I=handles.courant_data;
%charge; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H1(i,j); 
end 
end 
g=ifft2(G); 
imshow(255-abs(g),[0,255]); 


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to  tobutten pas bas butterorth(see GCBO)
I = handles.courant_data;
%I = imread('eight.tif');

F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3);

H0=zeros(M,N); 
D0=20; 
M2=round(M/2); 
N2=round(N/2); 
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 

n=3; 

for i=1:M 
for j=1:N 
%H(i,j)=1/(1+(H0(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H0(i,j); 
end 
end 

g=ifft2(G); 
imshow(abs(g),[0,255]);%title('image filtrée');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to tobutten pas haut butterorth (see GCBO)
I=handles.courant_data;
%charge; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H1(i,j); 
end 
end 
g=ifft2(G); 
imshow(255-abs(g),[0,255]);
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
