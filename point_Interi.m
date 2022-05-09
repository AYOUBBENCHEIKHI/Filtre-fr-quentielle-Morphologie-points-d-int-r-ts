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

% Last Modified by GUIDE v2.5 27-Jan-2022 22:36:50

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


% --- Executes on button press in susan.
function susan_Callback(hObject, eventdata, handles)
im= handles.courant_data;
% =======================conversion de l'image=============================
d = length(size(im));
    if d==3
        image=double(rgb2gray(im));
    elseif d==2
        image=double(im);
    end
[n,m]=size(image);
% =============================données=====================================
rayon=1;
alpha=80;
r=5;
alpha=alpha/100;
% ========================génerateur de mask=============================
mask=zeros(2*rayon+1);
b=ones(rayon+1);
for i=1:rayon+1
    for j=1:rayon+1
        if (rayon==1)
            if(j>i)
            b(i,j)=0;
            end
        else
            if(j>i+1)
            b(i,j)=0;
            end
        end
    end
end
mask(1:rayon+1,rayon+1:2*rayon+1)=b;
mask(1:rayon+1,1:rayon+1)=rot90(b);
mask0=mask;
mask0=flipdim(mask0,1);
mask=mask0+mask;
mask(rayon+1,:)=mask(rayon+1,:)-1;
% ==========================réponse maximale============================
max_reponse=sum(sum(mask));
% =====================balayage de toute l'image===========================
f=zeros(n,m);
for i=(rayon+1):n-rayon
    for j=(rayon+1):m-rayon
        image_courant=image(i-rayon:i+rayon,j-rayon:j+rayon);
        image_courant_mask=image_courant.*mask;
        inteniste_cental= image_courant_mask(rayon+1,rayon+1);
        s=exp(-1*(((image_courant_mask-inteniste_cental)/max_reponse).^6));
        somme=sum(sum(s));
% si le centre du mask est un 0 il faut soustraire les zeros des filtres
       if (inteniste_cental==0)
        somme=somme-length((find(mask==0)));
       end
        f(i,j)=somme;
    end
end

% =============selection et seuillage des points d'interét=================
ff=f(rayon+1:n-(rayon+1),rayon+1:m-(rayon+1));
minf=min(min(ff));
maxf=max(max(f));
fff=f;
d=2*r+1;
temp1=round(n/d);
   if (temp1-n/d)<0.5 &(temp1-n/d)>0
    temp1=temp1-1;
   end
    temp2=round(m/d);
   if (temp2-m/d)<0.5 &(temp2-m/d)>0
    temp2=temp2-1;
   end
    fff(n:temp1*d+d,m:temp2*d+d)=0;

for i=(r+1):d:temp1*d+d
   for j=(r+1):d:temp2*d+d
        window=fff(i-r:i+r,j-r:j+r);
        window0=window;
        [xx,yy]=find(window0==0);
        for k=1:length(xx)
            window0(xx(k),yy(k))=max(max(window0));
        end
        minwindow=min(min(window0));
        [y,x]=find(minwindow~=window & window<=minf+alpha*(maxf-minf) & window>0);
        [u,v]=find(minwindow==window);
    if length(u)>1
        for l=2:length(u)
            fff(i-r-1+u(l),j-r-1+v(l))=0 ;
        end
    end
   if length(x)~=0
    for l=1:length(y)
        fff(i-r-1+y(l),j-r-1+x(l))=0 ;
    end
   end
   end
end
seuil=minf+alpha*(maxf-minf);
[u,v]=find(minf<=fff & fff<=seuil );

% ==============affichage des resultats====================================
imageS=im;
imshow(im);
hold on;
plot(v,u,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(v));
msgbox(message);



% --- Executes on button press in harris.
function harris_Callback(hObject, eventdata, handles)
% hObject    handle to harris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.courant_data;
[m,n,d]=size(img);
if(d==3)
    img=rgb2gray(img);
end
%==========================================================================
lambda=0.04;
sigma=1; seuil=200; r=6; w=5*sigma;
imd=double(img);
dx=[-1 0 1
    -2 0 2
    -1 0 1]; % derivée horizontale : filtre de Sobel
dy=dx'; % derivée verticale : filtre de Sobel
g = fspecial('gaussian',max(1,fix(w)), sigma);
Ix=conv2(imd,dx,'same');
Iy=conv2(imd,dy,'same');
Ix2=conv2(Ix.^2, g, 'same');
Iy2=conv2(Iy.^2, g, 'same');
Ixy=conv2(Ix.*Iy, g,'same');
detM=Ix2.*Iy2-Ixy.^2;
trM=Ix2+Iy2;
R=detM-lambda*trM.^2;
%==========================================================================
R1=(1000/(1+max(max(R))))*R;
%==========================================================================          
[u,v]=find(R1<=seuil);
nb=length(u);
for k=1:nb
    R1(u(k),v(k))=0;
end
R11=zeros(m+2*r,n+2*r);
R11(r+1:m+r,r+1:n+r)=R1;
[m1,n1]=size(R11);
for i=r+1:m1-r
    for j=r+1:n1-r
        fenetre=R11(i-r:i+r,j-r:j+r);
        ma=max(max(fenetre));
        if fenetre(r+1,r+1)<ma
            R11(i,j)=0;
        end
    end
end
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
imageS=img;
imshow(img);
hold on;
plot(y,x,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(x));
msgbox(message);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.courant_data;
[m,n,d]=size(img);
if(d==3)
    img=rgb2gray(img);
end
%==========================================================================
k=0.04; sigma=1; seuil=100; r=6;
imd=double(img);
dxa=[-sqrt(2)/4 0 sqrt(2)/4 ; -1 0 1 ; -sqrt(2)/4 0 sqrt(2)/4];
dya=dxa'; % derivée verticale
g=fspecial('gaussian',max(1,fix(5*sigma)),sigma); % gaussien
Ixa=conv2(imd,dxa,'same');
Iya=conv2(imd,dya,'same');
Ixa2 = conv2(Ixa.^2, g, 'same');
Iya2 = conv2(Iya.^2, g, 'same');
Ixya = conv2(Ixa.*Iya, g,'same');
R=Ixa2.*Iya2-Ixya.^2-k*(Ixa2+Iya2).^2;
R1=(1000/(max(max(R))))*R; %normalisation
[u,v]=find(R1<=seuil);
nb=length(u);
for k=1:nb
    R1(u(k),v(k))=0;
end
R11=zeros(m+2*r,n+2*r);
R11(r+1:m+r,r+1:n+r)=R1;
[m1,n1]=size(R11);
for i=r+1:m1-r
    for j=r+1:n1-r
        fenetre=R11(i-r:i+r,j-r:j+r);
        ma=max(max(fenetre));
        if fenetre(r+1,r+1)<ma
        R11(i,j)=0;
        end
    end
end
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
imageS=img;
imshow(img);
hold on;
plot(y,x,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(x));
msgbox(message);




% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.*');
%Chargement de l'image et affichage
handles.ima = imread(sprintf('%s',path,file));
%Affichage de l'aperçu
axes(handles.imgOrigine)
handles.courant_data = handles.ima;
%imshow(handles.courant_data);
subimage(handles.courant_data);
axes(handles.imgTritai)
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
