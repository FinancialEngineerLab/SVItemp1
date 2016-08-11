function varargout = industrial(varargin)
% INDUSTRIAL MATLAB code for industrial.fig
%      INDUSTRIAL, by itself, creates a new INDUSTRIAL or raises the existing
%      singleton*.
%
%      H = INDUSTRIAL returns the handle to a new INDUSTRIAL or the handle to
%      the existing singleton*.
%
%      INDUSTRIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDUSTRIAL.M with the given input arguments.
%
%      INDUSTRIAL('Property','Value',...) creates a new INDUSTRIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before industrial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to industrial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help industrial

% Last Modified by GUIDE v2.5 23-Sep-2015 17:18:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @industrial_OpeningFcn, ...
                   'gui_OutputFcn',  @industrial_OutputFcn, ...
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


% --- Executes just before industrial is made visible.
function industrial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to industrial (see VARARGIN)

% Choose default command line output for industrial
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes industrial wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%preset functions
%首先是判断（选择）指数，给定传递的数据
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='801010.SI'
elseif n==2
    index='801020.SI'
elseif n==3
    index='801030.SI'
elseif n==4
    index='801040.SI'
elseif n==5
    index='801050.SI'
elseif n==6
    index='801080.SI'
elseif n==7
    index='801110.SI'
elseif n==8
    index='801120.SI'
elseif n==9
    index='801130.SI'
elseif n==10
    index='801140.SI'
elseif n==11
    index='801150.SI'
elseif n==12
    index='801160.SI'
elseif n==13
    index='801170.SI'
elseif n==14
    index='801180.SI'  
elseif n==15
    index='801200.SI'
elseif n==16
    index='801210.SI'
elseif n==17
    index='801230.SI'
elseif n==18
    index='801710.SI'
elseif n==19
    index='801720.SI'
elseif n==20
    index='801730.SI'
elseif n==21
    index='801740.SI'
elseif n==22
    index='801750.SI'   
elseif n==23
    index='801760.SI'
elseif n==24
    index='801770.SI'
elseif n==25
    index='801780.SI'
elseif n==26
    index='801790.SI'
elseif n==27
    index='801880.SI'
elseif n==28
    index='801890.SI'
end



function [index]  = indexname( n )
% give the string of the index
if n=='801010.SI'
    index='农林牧渔'
elseif n=='801020.SI'
    index='采掘'
elseif n=='801030.SI'
    index='化工'
elseif n=='801040.SI'
    index='钢铁'
elseif n=='801050.SI'
    index='有色金属'
elseif n=='801080.SI'
    index='电子'
elseif n=='801110.SI'
    index='家用电器'
elseif n=='801120.SI'
    index='食品饮料'
elseif n=='801130.SI'
    index='纺织服装'
elseif n=='801140.SI'
    index='轻工制造'
elseif n=='801150.SI'
    index='医药生物'
elseif n=='801160.SI'
    index='公用事业'
elseif n=='801170.SI'
    index='交通运输'
elseif n=='801180.SI' 
    index= '房地产'
elseif n=='801200.SI'
    index='商业贸易'
elseif n=='801210.SI'
    index='休闲服务'
elseif n=='801230.SI'
    index='综合'
elseif n=='801710.SI'
    index='建筑材料'
elseif n=='801720.SI'
    index='建筑装饰'
elseif n=='801730.SI'
    index='电气设备'
elseif n=='801740.SI'
    index='国防军工'
elseif n=='801750.SI'
    index='计算机'   
elseif n=='801760.SI'
    index='传媒'
elseif n=='801770.SI'
    index='通信'
elseif n=='801780.SI'
    index='银行'
elseif n=='801790.SI'
    index='非银金融'
elseif n=='801880.SI'
    index='汽车'
elseif n=='801890.SI'
    index='机械设备'
end

%function for popupmenu
function[r] = pop(b)
if b==1
    r=1;
elseif b==2
    r=3;
elseif b==3
    r=5;
elseif b==4
    r=10;
elseif b==5
    r=20;
elseif b==6
    r=30;
elseif b==7
    r=60;
elseif b==8
    r=120;
elseif b==9
    r=250;
elseif b==10
    r=500;
end

%function to get the corresponding results


% --- Outputs from this function are returned to the command line.
function varargout = industrial_OutputFcn(hObject, eventdata, handles) 
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

%获取相对应指数数据,计算获得结果,并返回相应table,制作excel表格
%获取相应输入值
day=get(handles.editday,'String');
A = get(handles.popupmenuA,'Value');
B = get(handles.popupmenuB,'Value');
if B==1
    B=21;
elseif B==21
    B=1;
end
C = get(handles.popupmenuC,'Value');
if C==1
    C=24;
elseif C==24
    C=1;
end
D = get(handles.popupmenuD,'Value');
if D==1
    D=25;
elseif D==25
    D=1;
end
E = get(handles.popupmenuE,'Value');
if E==1
    E=26;
elseif E==26
    E=1;
end
F = get(handles.popupmenuF,'Value');
if F==1
    F=27;
elseif F==27
    F=1;
end
G = get(handles.popupmenuG,'Value');
if G==1
    G=28;
elseif G==28
    G=1;
end

A = indexstr(A);
B = indexstr(B);
C = indexstr(C);
D = indexstr(D);
E = indexstr(E);
F = indexstr(F);
G = indexstr(G);




b1=pop(get(handles.popupmenu1,'Value'));
b2=pop(get(handles.popupmenu2,'Value'));
%因为改变了默认的次序,所以需要进行微调
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu3,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu4,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu5,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end

%判断按照字段进行排序
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu29, 'Value'));
sort(2) = pop(get(handles.popupmenu30, 'Value'));
sort(3) = pop(get(handles.popupmenu31, 'Value'));
sort(4) = pop(get(handles.popupmenu32, 'Value'));
sort(5) = pop(get(handles.popupmenu33, 'Value'));

indexes={A;B;C;D;E;F;G};
days=[b1,b2,b3,b4,b5];
%计算
tableA=premium(A,b1,b2,b3,b4,b5,day);
tableB=premium(B,b1,b2,b3,b4,b5,day);
tableC=premium(C,b1,b2,b3,b4,b5,day);
tableD=premium(D,b1,b2,b3,b4,b5,day);
tableE=premium(E,b1,b2,b3,b4,b5,day);
tableF=premium(F,b1,b2,b3,b4,b5,day);
tableG=premium(G,b1,b2,b3,b4,b5,day);

table1=[tableA(1,:);tableB(1,:);tableC(1,:);tableD(1,:);tableE(1,:);tableF(1,:);tableG(1,:)];
[m,n]=size(table1);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table1(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table1(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,2)={['    ',mid,'']};   
end
table2=[tableA(2,:);tableB(2,:);tableC(2,:);tableD(2,:);tableE(2,:);tableF(2,:);tableG(2,:)];
[m,n]=size(table2);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table2(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table2(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,2)={['    ',mid,'']};   
end
table3=[tableA(3,:);tableB(3,:);tableC(3,:);tableD(3,:);tableE(3,:);tableF(3,:);tableG(3,:)];
[m,n]=size(table3);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table3(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table3(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,2)={['    ',mid,'']};   
end
table4=[tableA(4,:);tableB(4,:);tableC(4,:);tableD(4,:);tableE(4,:);tableF(4,:);tableG(4,:)];
[m,n]=size(table4);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table4(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table4(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,2)={['    ',mid,'']};   
end
table5=[tableA(5,:);tableB(5,:);tableC(5,:);tableD(5,:);tableE(5,:);tableF(5,:);tableG(5,:)];
[m,n]=size(table5);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table5(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table5per(i,1)={['  ',mid,'%']};   
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

guidata(hObject,handles);

msgbox('刷新完成');



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



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
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
namerow={'代码','名称','日期',[num2str(b1),'日超额收益'],[num2str(b1),'日超额收益分位数'],[num2str(b2),'日超额收益'],[num2str(b2),'日超额收益分位数'],[num2str(b3),'日超额收益'],[num2str(b3),'日超额收益分位数'],[num2str(b4),'日超额收益'],[num2str(b4),'日超额收益分位数'],[num2str(b5),'日超额收益'],[num2str(b5),'日超额收益分位数']};
col1=indexes;
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)));indexname(char(indexes(7)))};
da=get(handles.editday,'String');
col3={da;da;da;da;da;da;da};
[filename, pathname] = uiputfile({ '*.xls','xls File (*.xls)'}, ... 
        'Save excel as','default');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
xlswrite([pathname,filename],[namerow;col1,col2,col3,num2cell(table1),num2cell(table2),num2cell(table3),num2cell(table4),num2cell(table5)]);
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
index1=indexname(char(indexes(1)));
index2=indexname(char(indexes(2)));
index3=indexname(char(indexes(3)));
index4=indexname(char(indexes(4)));
index5=indexname(char(indexes(5)));
index6=indexname(char(indexes(6)));
index7=indexname(char(indexes(7)));


col2={index1,index2,index3,index4,index5,index6,index7};
y=tableb(1:7,1);
z=tableb(1:7,2);
figure;

subplot(2,1,1)
bar(y,0.4);
ylabel('%');
title([num2str(days(b)),'日超额收益']);
set(gca, 'XTicklabel',col2);   % X轴的记号
xtb = get(gca,'XTickLabel');% 获取横坐标轴标签句柄
xt = get(gca,'XTick');% 获取横坐标轴刻度句柄
yt = get(gca,'YTick'); % 获取纵坐标轴刻度句柄          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% 将原有的标签隐去



subplot(2,1,2)
bar(z,0.4);
set(gca,'XTickLabel',col2);
set(gca, 'yLim',[0 1.1]);

xtb = get(gca,'XTickLabel');% 获取横坐标轴标签句柄
xt = get(gca,'XTick');% 获取横坐标轴刻度句柄
yt = get(gca,'YTick'); % 获取纵坐标轴刻度句柄          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% 将原有的标签隐去

title([num2str(days(b)),'日超额收益分位数']);


%y=tableb(1:6,2);
%bar(y,0.4);
%set(gca,'XTickLabel',col2);
%set(gca, 'yLim',[0 1.1]);      % y轴的数据显示范围
%title([num2str(days(b)),'日超额收益分位数']);
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


% --- Executes on selection change in popupmenuG.
function popupmenuG_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuG contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuG


% --- Executes during object creation, after setting all properties.
function popupmenuG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuO.
function popupmenuO_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuO


% --- Executes during object creation, after setting all properties.
function popupmenuO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuP.
function popupmenuP_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuP contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuP


% --- Executes during object creation, after setting all properties.
function popupmenuP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu24.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu24 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu24


% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu25.
function popupmenu25_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu25 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu25


% --- Executes during object creation, after setting all properties.
function popupmenu25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu26.
function popupmenu26_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu26 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu26


% --- Executes during object creation, after setting all properties.
function popupmenu26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu27.
function popupmenu27_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu27 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu27


% --- Executes during object creation, after setting all properties.
function popupmenu27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu28.
function popupmenu28_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu28 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu28


% --- Executes during object creation, after setting all properties.
function popupmenu28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu29.
function popupmenu29_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu29 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu29


% --- Executes during object creation, after setting all properties.
function popupmenu29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu30.
function popupmenu30_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu30 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu30


% --- Executes during object creation, after setting all properties.
function popupmenu30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu31.
function popupmenu31_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu31 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu31


% --- Executes during object creation, after setting all properties.
function popupmenu31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu32.
function popupmenu32_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu32 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu32


% --- Executes during object creation, after setting all properties.
function popupmenu32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu33.
function popupmenu33_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu33 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu33


% --- Executes during object creation, after setting all properties.
function popupmenu33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.edit7);

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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
day=get(handles.edit7,'String');


b1=pop(get(handles.popupmenu24,'Value'));
b2=pop(get(handles.popupmenu25,'Value'));
%因为改变了默认的次序,所以需要进行微调
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu26,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu27,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu28,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end

indexCode = {'801010.SI';'801020.SI';'801030.SI';'801040.SI';'801050.SI';'801080.SI';'801110.SI';'801120.SI';'801130.SI';'801140.SI';'801150.SI';'801160.SI';'801170.SI';'801180.SI';'801200.SI';'801210.SI';'801230.SI';'801710.SI';'801720.SI';'801730.SI';'801740.SI';'801750.SI';'801760.SI';'801770.SI';'801780.SI';'801790.SI';'801880.SI';'801890.SI'};
indexName = {'农林牧渔';'采 掘';'化 工';'钢 铁';'有色金属';'电 子';'家用电器';'食品饮料';'纺织服装';'轻工制造'; '医药生物';'公用事业';'交通运输';'房地产';'商业贸易';'休闲服务';'综 合';'建筑材料';'建筑装饰';'电气设备';'国防军工';'计算机';'传 媒';'通 信';'银 行';'非银金融';'汽 车';'机械设备'};
index = [indexCode;indexName];
[r1, r2, r3, r4, r5]=premiumOfAll(indexCode,b1,b2,b3,b4,b5,day); 

%判断按照字段进行排序
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu29, 'Value'));
sort(2) = pop(get(handles.popupmenu30, 'Value'));
sort(3) = pop(get(handles.popupmenu31, 'Value'));
sort(4) = pop(get(handles.popupmenu32, 'Value'));
sort(5) = pop(get(handles.popupmenu33, 'Value'));

sortnum = 5;

if sort(1) == 1||sort(1) == 3
    if sort(1) == 1
        r1=sortrows(r1,2);
    end
    if sort(1) == 3
        r1=sortrows(r1,3);
    end
%         table1per = table1per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r1(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table1per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r1(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table1per(i,3)={['    ',mid,'']};  
        table1per(i,1)= index(r1(i,1)+length(index)/2,1);
    end
    set(handles.uitable11,'data',table1per);
    [m,n]=size(r1);
    for i=1:sortnum
        mid=num2str(r1(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table6per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r1(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table6per(sortnum+1-i,3)={['    ',mid,'']};  
        table6per(sortnum+1-i,1)= index(r1(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable6,'data',table6per);
end


if sort(2) == 1||sort(2) == 3
    if sort(2) ==1
        r2=sortrows(r2,2);
    end
    if sort(2) == 3
        r2=sortrows(r2,3);
    end
%         table2per = table2per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r2(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table2per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r2(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table2per(i,3)={['    ',mid,'']};  
        table2per(i,1)= index(r2(i,1)+length(index)/2,1);
    end
    set(handles.uitable12,'data',table2per);
    [m,n]=size(r2);
    for i=1:sortnum
        mid=num2str(r2(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table7per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r2(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table7per(sortnum+1-i,3)={['    ',mid,'']};  
        table7per(sortnum+1-i,1)= index(r2(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable7,'data',table7per);
end


if sort(3) == 1||sort(3) == 3
    if sort(3) == 1
        r3=sortrows(r3,2);
    end
    if sort(3) == 3
        r3=sortrows(r3,3);
    end
%         table3per = table3per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r3(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table3per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r3(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table3per(i,3)={['    ',mid,'']};  
        table3per(i,1)= index(r3(i,1)+length(index)/2,1);
    end
    set(handles.uitable13,'data',table3per);
    [m,n]=size(r3);
    for i=1:sortnum
        mid=num2str(r3(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table8per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r3(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table8per(sortnum+1-i,3)={['    ',mid,'']};  
        table8per(sortnum+1-i,1)= index(r3(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable8,'data',table8per);
end



if sort(4) == 1 || sort(4) == 3
    if sort(4) == 1
        r4=sortrows(r4,2);
    end
    if sort(4) == 3
        r4=sortrows(r4,3);
    end
%         table4per = table4per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r4(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table4per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r4(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table4per(i,3)={['    ',mid,'']};  
        table4per(i,1)= index(r4(i,1)+length(index)/2,1);
    end
    set(handles.uitable14,'data',table4per);
    [m,n]=size(r4);
    for i=1:sortnum
        mid=num2str(r4(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table9per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r4(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table9per(sortnum+1-i,3)={['    ',mid,'']};  
        table9per(sortnum+1-i,1)= index(r4(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable9,'data',table9per);
end



if sort(5) == 1 || sort(5) == 3
    if sort(5) == 1
        r5=sortrows(r5,2);
    end
    if sort(5) == 3
        r5=sortrows(r5,3);
    end
%         table5per = table5per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r5(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table5per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r5(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table5per(i,3)={['    ',mid,'']};  
        table5per(i,1)= index(r5(i,1)+length(index)/2,1);
    end
    set(handles.uitable15,'data',table5per);
    [m,n]=size(r5);
    for i=1:sortnum
        mid=num2str(r5(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table10per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r5(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table10per(sortnum+1-i,3)={['    ',mid,'']};  
        table10per(sortnum+1-i,1)= index(r5(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable10,'data',table10per);
end


% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
