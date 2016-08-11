function varargout = zzbl(varargin)
% ZZBL MATLAB code for zzbl.fig
%      ZZBL, by itself, creates a new ZZBL or raises the existing
%      singleton*.
%
%      H = ZZBL returns the handle to a new ZZBL or the handle to
%      the existing singleton*.
%
%      ZZBL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZZBL.M with the given input arguments.
%
%      ZZBL('Property','Value',...) creates a new ZZBL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zzbl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zzbl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zzbl

% Last Modified by GUIDE v2.5 07-Sep-2015 16:06:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zzbl_OpeningFcn, ...
                   'gui_OutputFcn',  @zzbl_OutputFcn, ...
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


% --- Executes just before zzbl is made visible.
function zzbl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zzbl (see VARARGIN)

% Choose default command line output for zzbl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zzbl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = zzbl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function editday1_Callback(hObject, eventdata, handles)
% hObject    handle to editday1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editday1 as text
%        str2double(get(hObject,'String')) returns contents of editday1 as a double


% --- Executes during object creation, after setting all properties.
function editday1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editday1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editday2_Callback(hObject, eventdata, handles)
% hObject    handle to editday2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editday2 as text
%        str2double(get(hObject,'String')) returns contents of editday2 as a double


% --- Executes during object creation, after setting all properties.
function editday2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editday2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editday3_Callback(hObject, eventdata, handles)
% hObject    handle to editday3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editday3 as text
%        str2double(get(hObject,'String')) returns contents of editday3 as a double


% --- Executes during object creation, after setting all properties.
function editday3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editday3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查wind连接
try
    w=windmatlab
catch 
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end 
%获取相应输入值
day1=get(handles.editday1,'String');
day2=get(handles.editday2,'String');
day3=get(handles.editday3,'String');
input=str2num(day3)

y1=w.wsd('000905.SH','close',day1,day2,'Fill=Previous')
y2=w.wsd('000903.SH','close',day1,day2,'Fill=Previous')

y3=w.wsd('000905.SH','amt',day1,day2,'Fill=Previous')
y4=w.wsd('000903.SH','amt',day1,day2,'Fill=Previous')

windowSize = input;
b1=filter(ones(1,windowSize)/windowSize,1,y3);
b2=filter(ones(1,windowSize)/windowSize,1,y4);

A=y1./y2
B=b1./b2

d=w.tdayscount(day1,day2); % 计算交易日天数
t=w.tdays(day1,day2);

% datetick('t','yyyy/mm/dd');

% xData = linspace(day1,day2,d);
% plotyy(xData,A,xData,B)
% set(gca,'XTick',xData)
% set(gca,'XTicklabel','')

x=datenum(t)

figure()
[AX,H1,H2]=plotyy(x,A,x,B,'plot')

datetick('x','yyyy/mm/dd','keepticks');
set(AX(2),'xtick',[]);
x_start = x(1)
iLast = length(x);
x_end = x(iLast)
xlim(AX(1),[x_start,x_end+10]);
xlim(AX(2),[x_start,x_end+10]);
xtb = get(gca,'XTickLabel');% 获取横坐标轴标签句柄
xt = get(gca,'XTick');% 获取横坐标轴刻度句柄
yt = get(gca,'YTick'); % 获取纵坐标轴刻度句柄          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% 将原有的标签隐去



%[AX,H1,H2]=plotyy(t,A,t,B,'plot')
set(AX(1),'XColor','k','YColor','b')
set(AX(2),'XColor','k','YColor','r')
HH1=get(AX(1),'Ylabel')
set(HH1,'String','中证500/中证100指数比率')
set(HH1,'color','b')
HH2=get(AX(2),'Ylabel')
set(HH2,'String','中证500/中证100成交额比率')
set(HH2,'color','r')
set(H1,'LineStyle','-')
set(H1,'color','b')
set(H2,'LineStyle','-')
set(H2,'color','r')
legend([H1,H2],{'中证500/中证100指数比率';'中证500/中证100成交额比率'})
% datetick('x',2)

title(['中证500/中证100指数和成交额比率']);
