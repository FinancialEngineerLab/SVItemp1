function varargout = hurst(varargin)
% HURST MATLAB code for hurst.fig
%      HURST, by itself, creates a new HURST or raises the existing
%      singleton*.
%
%      H = HURST returns the handle to a new HURST or the handle to
%      the existing singleton*.
%
%      HURST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HURST.M with the given input arguments.
%
%      HURST('Property','Value',...) creates a new HURST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hurst_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hurst_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hurst

% Last Modified by GUIDE v2.5 06-Aug-2015 15:53:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hurst_OpeningFcn, ...
                   'gui_OutputFcn',  @hurst_OutputFcn, ...
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


% --- Executes just before hurst is made visible.
function hurst_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hurst (see VARARGIN)

% Choose default command line output for hurst
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hurst wait for user response (see UIRESUME)
% uiwait(handles.figure1);





%preset functions
%首先是判断（选择）指数，给定传递的数据
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='000001.SH'
elseif n==2
    index='000002.SH'
elseif n==3
    index='000003.SH'
elseif n==4
    index='000009.SH'
elseif n==5
    index='000010.SH'
elseif n==6
    index='000015.SH'
elseif n==7
    index='000016.SH'
elseif n==8
    index='000300.SH'
elseif n==9
    index='000903.SH'
elseif n==10
    index='000905.SH'    
elseif n==11
    index='000906.SH'
elseif n==12
    index='399001.SZ'
elseif n==13
    index='399004.SZ'
elseif n==14
    index='399005.SZ'    
elseif n==15
    index='399006.SZ'
elseif n==16
    index='399008.SZ'
elseif n==17
    index='399012.SZ'
elseif n==18
    index='399100.SZ'
elseif n==19
    index='399101.SZ'
elseif n==20
    index='399102.SZ'
elseif n==21
    index='399106.SZ'
elseif n==22
    index='399107.SZ'    
elseif n==23
    index='399108.SZ'
elseif n==24
    index='399344.SZ'
elseif n==25
    index='000904.SH'
elseif n==26
    index='000852.SH'
end
function [n]  = indexname( index )
% give the string of the index 把指数名称转换为wind中的代码
if index=='000001.SH'
    n='上证指数';
elseif index=='000002.SH'
    n='Ａ股指数';
elseif index=='000003.SH'
    n='Ｂ股指数';
elseif index=='000009.SH'
    n='上证380';
elseif index=='000010.SH'
    n='上证180';
elseif index=='000015.SH'
    n='红利指数';
elseif index=='000016.SH'
    n='上证50';
elseif index=='000300.SH'
    n='沪深300';
elseif index=='000903.SH'
    n='中证100';
elseif index=='000904.SH'
    n='中证200';
elseif index=='000905.SH'
    n='中证500';
elseif index=='000906.SH'
    n='中证800';
elseif index=='000852.SH'
    n='中证1000';
elseif index=='399001.SZ'
    n='深证成指';
elseif index=='399004.SZ'
    n='深证100R';
elseif index=='399005.SZ'
    n='中小板指';
elseif index=='399006.SZ'
    n='创业板指';
elseif index=='399008.SZ'
    n='中小300';
elseif index=='399012.SZ'
    n='创业300';
elseif index=='399100.SZ'
    n='新 指 数';
elseif index=='399101.SZ'
    n='中小板综';
elseif index=='399102.SZ'
    n='创业板综';
elseif index=='399106.SZ'
    n='深证综指';
elseif index=='399107.SZ'
    n='深证Ａ指';
elseif index=='399108.SZ'
    n='深证Ｂ指';
elseif index=='399344.SZ'
    n='深证300R';
end

function [n]  = indexnameabb( index )
% give the string of the index   
if index=='000001.SH'
    n='上证';
elseif index=='000002.SH'
    n='Ａ股';
elseif index=='000003.SH'
    n='Ｂ股';
elseif index=='000009.SH'
    n='上380';
elseif index=='000010.SH'
    n='上180';
elseif index=='000015.SH'
    n='红利';
elseif index=='000016.SH'
    n='上50';
elseif index=='000300.SH'
    n='沪深300';
elseif index=='000903.SH'
    n='中100';
elseif index=='000904.SH'
    n='中200';
elseif index=='000905.SH'
    n='中500';
elseif index=='000906.SH'
    n='中800';
elseif index=='000852.SH'
    n='中1000';
elseif index=='399001.SZ'
    n='深成';
elseif index=='399004.SZ'
    n='深100R';
elseif index=='399005.SZ'
    n='中小板指';
elseif index=='399006.SZ'
    n='创业板指';
elseif index=='399008.SZ'
    n='中小300';
elseif index=='399012.SZ'
    n='创业300';
elseif index=='399100.SZ'
    n='新 指 数';
elseif index=='399101.SZ'
    n='中小板综';
elseif index=='399102.SZ'
    n='创业综';
elseif index=='399106.SZ'
    n='深综';
elseif index=='399107.SZ'
    n='深Ａ';
elseif index=='399108.SZ'
    n='深Ｂ';
elseif index=='399344.SZ'
    n='深300R';
end

%function for popupmenu
function[r] = pop(b)
if b==1
    r=50;
elseif b==2
    r=100;
elseif b==3
    r=150;
elseif b==4
    r=200;
elseif b==5
    r=250;
elseif b==6
    r=300;
elseif b==7
    r=350;
elseif b==8
    r=400;
elseif b==9
    r=450;
elseif b==10
    r=500;
end

%function to get the corresponding results


% --- Outputs from this function are returned to the command line.
function varargout = hurst_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenuA.
function popupmenuA_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuA


% --- Executes during object creation, after setting all properties.
function popupmenuA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global ind;
global indexes;
global days;

% 检查wind连接
try
    x = windmatlab;
catch 
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end 

msgbox('正在计算中，请耐心等待...','消息提示');

%获取相对应指数数据,计算获得结果,并返回相应table,制作excel表格
%获取相应输入值
day1=get(handles.editday1,'String');
day2=get(handles.editday,'String');
A = get(handles.popupmenuA,'Value');
A = indexstr(A);
B = get(handles.popupmenuB,'Value');
B = indexstr(B);
%因为改变了默认的次序,所以需要进行微调
if B=='000001.SH'
    B='000903.SH';
elseif B=='000903.SH'
    B='000001.SH';
end
C = get(handles.popupmenuC,'Value');
C = indexstr(C);
if C=='000001.SH'
    C='000904.SH';
elseif C=='000904.SH';
    C='000001.SH'
end
D = get(handles.popupmenuD,'Value');
D = indexstr(D);
if D=='000001.SH'
    D='000905.SH';
elseif D=='000905.SH';
    D='000001.SH'
end
E = get(handles.popupmenuE,'Value');
E = indexstr(E);
if E=='000001.SH'
    E='000852.SH';
elseif E=='000852.SH';
    E='000001.SH'
end
F = get(handles.popupmenuF,'Value');
F = indexstr(F);
if F=='000001.SH'
    F='399102.SZ';
elseif F=='399102.SZ';
    F='000001.SH'
end


b1=pop(get(handles.popupmenu1,'Value'));
b2=pop(get(handles.popupmenu2,'Value'));
%因为改变了默认的次序,所以需要进行微调
if b2==50
    b2=100;
elseif b2==100
    b2=50;
end
b3=pop(get(handles.popupmenu3,'Value'));
if b3==50
    b3=150;
elseif b3==150
    b3=50;
end
b4=pop(get(handles.popupmenu4,'Value'));
if b4==200
    b4=50;
elseif b4==50
    b4=200;
end
b5=pop(get(handles.popupmenu5,'Value'));
if b5==250
    b5=50;
elseif b5==50
    b5=250;
end

indexes={A;B;C;D;E;F};
days=[b1,b2,b3,b4,b5];
%计算
tableA=Hurst_calculation(A,b1,b2,b3,b4,b5,day1,day2);
tableB=Hurst_calculation(B,b1,b2,b3,b4,b5,day1,day2);
tableC=Hurst_calculation(C,b1,b2,b3,b4,b5,day1,day2);
tableD=Hurst_calculation(D,b1,b2,b3,b4,b5,day1,day2);
tableE=Hurst_calculation(E,b1,b2,b3,b4,b5,day1,day2);
tableF=Hurst_calculation(F,b1,b2,b3,b4,b5,day1,day2);
table1=[tableA(1,:);tableB(1,:);tableC(1,:);tableD(1,:);tableE(1,:);tableF(1,:)];
[m,n]=size(table1);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table1(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,1)={['  ',mid,'']};   
end
for i=1:m
    mid=num2str(table1(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,2)={['    ',mid,'']};   
end
table2=[tableA(2,:);tableB(2,:);tableC(2,:);tableD(2,:);tableE(2,:);tableF(2,:)];
[m,n]=size(table2);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table2(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,1)={['  ',mid,'']};   
end
for i=1:m
    mid=num2str(table2(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,2)={['    ',mid,'']};   
end
table3=[tableA(3,:);tableB(3,:);tableC(3,:);tableD(3,:);tableE(3,:);tableF(3,:)];
[m,n]=size(table3);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table3(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,1)={['  ',mid,'']};   
end
for i=1:m
    mid=num2str(table3(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,2)={['    ',mid,'']};   
end
table4=[tableA(4,:);tableB(4,:);tableC(4,:);tableD(4,:);tableE(4,:);tableF(4,:)];
[m,n]=size(table4);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table4(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,1)={['  ',mid,'']};   
end
for i=1:m
    mid=num2str(table4(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,2)={['    ',mid,'']};   
end
table5=[tableA(5,:);tableB(5,:);tableC(5,:);tableD(5,:);tableE(5,:);tableF(5,:)];
[m,n]=size(table5);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table5(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table5per(i,1)={['  ',mid,'']};   
end
for i=1:m
    mid=num2str(table5(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table5per(i,2)={['    ',mid,'']};   
end

%set(handles.uitable1,'FontSize',10);
set(handles.uitable1,'data',table1per);
set(handles.uitable2,'data',table2per);
set(handles.uitable3,'data',table3per);
set(handles.uitable4,'data',table4per);
set(handles.uitable5,'data',table5per);

%set popupmenuday
set(handles.popupmenuday,'String',{[num2str(days(1)),'日'];[num2str(days(2)),'日'];[num2str(days(3)),'日'];[num2str(days(4)),'日'];[num2str(days(5)),'日'];});
cla(handles.axes1);
cla(handles.axes2);
guidata(hObject,handles);

msgbox('刷新完成','消息提示','modal');


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1



    

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on popupmenu1 and none of its controls.
function popupmenu1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on key press with focus on uitable2 and none of its controls.
function uitable2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenuB.
function popupmenuB_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuB



% --- Executes during object creation, after setting all properties.
function popupmenuB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuC.
function popupmenuC_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuC


% --- Executes during object creation, after setting all properties.
function popupmenuC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuD.
function popupmenuD_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuD


% --- Executes during object creation, after setting all properties.
function popupmenuD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuE.
function popupmenuE_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuE


% --- Executes during object creation, after setting all properties.
function popupmenuE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuF.
function popupmenuF_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuF


% --- Executes during object creation, after setting all properties.
function popupmenuF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editday_Callback(hObject, eventdata, handles)
% hObject    handle to editday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editday as text
%        str2double(get(hObject,'String')) returns contents of editday as a double


% --- Executes during object creation, after setting all properties.
function editday_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
formatOut = 'yyyy-mm-dd';
set(hObject,'String',datestr(datenum(date)-1,formatOut));
guidata(hObject, handles);




% --- Executes on key press with focus on editday and none of its controls.
function editday_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editday (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to editday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editday as text
%        str2double(get(hObject,'String')) returns contents of editday as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global indexes;
global days;
b1=days(1);
b2=days(2);
b3=days(3);
b4=days(4);
b5=days(5);
namerow={'代码','名称','起始日期','截止日期',[num2str(b1),'Hurst指数'],[num2str(b1),'Hurst指数分位数'],[num2str(b2),'Hurst指数'],[num2str(b2),'Hurst指数分位数'],[num2str(b3),'Hurst指数'],[num2str(b3),'Hurst指数分位数'],[num2str(b4),'Hurst指数'],[num2str(b4),'Hurst指数分位数'],[num2str(b5),'Hurst指数'],[num2str(b5),'Hurst指数分位数']};
col1=indexes;
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)))};
da1=get(handles.editday1,'String');
da=get(handles.editday,'String');
col3={da1;da1;da1;da1;da1;da1};
col4={da;da;da;da;da;da};
[filename, pathname] = uiputfile({ '*.xls','xls File (*.xls)'}, ... 
        'Save excel as','Hurst Indice');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
xlswrite([pathname,filename],[namerow;col1,col2,col3,col4,num2cell(table1),num2cell(table2),num2cell(table3),num2cell(table4),num2cell(table5)]);
% table=[table1]
% xlswrite(['D:\Workarea\files\wind matlab\GUIDE\','handles.editday','.xls'],[namerow,table1]);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global indexes;
global days;

b=get(handles.popupmenuday,'Value');

eval(['tableb=table',num2str(b)])

da=get(handles.editday,'String');
index1=indexnameabb(char(indexes(1)));
index2=indexnameabb(char(indexes(2)));
index3=indexnameabb(char(indexes(3)));
index4=indexnameabb(char(indexes(4)));
index5=indexnameabb(char(indexes(5)));
index6=indexnameabb(char(indexes(6)));

col2={index1,index2,index3,index4,index5,index6};
axes(handles.axes1); 
y=tableb(1:6,1);
bar(y,0.4);
set(gca,'XTickLabel',col2);
ylabel('%');
title([num2str(days(b)),'日Hurst指数']);

axes(handles.axes2); 
y=tableb(1:6,2);
bar(y,0.4);
set(gca,'XTickLabel',col2);
set(gca, 'yLim',[0 1.1]);      % y轴的数据显示范围
title([num2str(days(b)),'日Hurst指数分位数']);
guidata(hObject, handles);
%pix=getframe(handles.axes1);
%imwrite(pix.cdata,['D:\Workarea\files\wind matlab\GUIDE\',da,' 1日','超额收益','.png'],'jpg')


% --- Executes on selection change in popupmenuday.
function popupmenuday_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuday contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuday


% --- Executes during object creation, after setting all properties.
function popupmenuday_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savePlotWithinGUI(handles.axes1);
savePlotWithinGUI(handles.axes2);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.editday);


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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


% --- Executes on selection change in popupmenuA.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuA


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuB.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuB


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuC.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuC


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuD.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuD


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuE.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuE


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuF.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuF


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.editday1);
