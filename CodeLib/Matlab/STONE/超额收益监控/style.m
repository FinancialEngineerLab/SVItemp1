function varargout = style(varargin)
% STYLE MATLAB code for style.fig
%      STYLE, by itself, creates a new STYLE or raises the existing
%      singleton*.
%
%      H = STYLE returns the handle to a new STYLE or the handle to
%      the existing singleton*.
%
%      STYLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STYLE.M with the given input arguments.
%
%      STYLE('Property','Value',...) creates a new STYLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before style_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to style_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help style

% Last Modified by GUIDE v2.5 28-Jul-2015 11:14:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @style_OpeningFcn, ...
                   'gui_OutputFcn',  @style_OutputFcn, ...
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


% --- Executes just before style is made visible.
function style_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to style (see VARARGIN)

% Choose default command line output for style
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes style wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%preset functions
%首先是判断（选择）指数，给定传递的数据
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='801811.SI'
elseif n==2
    index='801812.SI'
elseif n==3
    index='801813.SI'
elseif n==4
    index='801821.SI'
elseif n==5
    index='801822.SI'
elseif n==6
    index='801823.SI'
elseif n==7
    index='801831.SI'
elseif n==8
    index='801832.SI'
elseif n==9
    index='801833.SI'
elseif n==10
    index='801841.SI'
elseif n==11
    index='801842.SI'
elseif n==12
    index='801843.SI'
elseif n==13
    index='801851.SI'
elseif n==14
    index='801852.SI'  
elseif n==15
    index='801853.SI'
elseif n==16
    index='801862.SI'
elseif n==17
    index='801863.SI'
end



function [index]  = indexname( n )
% give the string of the index
if n=='801811.SI'
    index='大盘指数'
elseif n=='801812.SI'
    index='中盘指数'
elseif n=='801813.SI'
    index='小盘指数'
elseif n=='801821.SI'
    index='高市盈率指数'
elseif n=='801822.SI'
    index='中市盈率指数'
elseif n=='801823.SI'
    index='低市盈率指数'
elseif n=='801831.SI'
    index='高市净率指数'
elseif n=='801832.SI'
    index='中市净率指数'
elseif n=='801833.SI'
    index='低市净率指数'
elseif n=='801841.SI'
    index='高价股指数'
elseif n=='801842.SI'
    index='中价股指数'
elseif n=='801843.SI'
    index='低价股指数'
elseif n=='801851.SI'
    index='亏损股指数'
elseif n=='801852.SI' 
    index='微利股指数'
elseif n=='801853.SI'
    index='绩优股指数'
elseif n=='801862.SI'
    index='活跃指数'
elseif n=='801863.SI'
    index='新股指数'
end


function [index]  = indexnameabb( n )
% give the string of the index
if n=='801811.SI'
    index='大盘'
elseif n=='801812.SI'
    index='中盘'
elseif n=='801813.SI'
    index='小盘'
elseif n=='801821.SI'
    index='高市盈率'
elseif n=='801822.SI'
    index='中市盈率'
elseif n=='801823.SI'
    index='低市盈率'
elseif n=='801831.SI'
    index='高市净率'
elseif n=='801832.SI'
    index='中市净率'
elseif n=='801833.SI'
    index='低市净率'
elseif n=='801841.SI'
    index='高价股'
elseif n=='801842.SI'
    index='中价股'
elseif n=='801843.SI'
    index='低价股'
elseif n=='801851.SI'
    index='亏损股'
elseif n=='801852.SI' 
    index='微利股'
elseif n=='801853.SI'
    index='绩优股'
elseif n=='801862.SI'
    index='活跃'
elseif n=='801863.SI'
    index='新股'
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
function varargout = style_OutputFcn(hObject, eventdata, handles) 
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
    B=2;
elseif B==2
    B=1;
end
C = get(handles.popupmenuC,'Value');
if C==1
    C=3;
elseif C==3
    C=1;
end
D = get(handles.popupmenuD,'Value');
if D==1
    D=4;
elseif D==4
    D=1;
end
E = get(handles.popupmenuE,'Value');
if E==1
    E=5;
elseif E==5
    E=1;
end
F = get(handles.popupmenuF,'Value');
if F==1
    F=6;
elseif F==6
    F=1;
end
G = get(handles.popupmenuG,'Value');
if G==1
    G=7;
elseif G==7
    G=1;
end
H = get(handles.popupmenuH,'Value');
if H==1
    H=8;
elseif H==8
    H=1;
end
I = get(handles.popupmenuI,'Value');
if I==1
    I=9;
elseif I==9
    I=1;
end
J = get(handles.popupmenuJ,'Value');
if J==1
    J=10;
elseif J==10
    J=1;
end
K = get(handles.popupmenuK,'Value');
if K==1
    K=11;
elseif K==11
    K=1;
end
L = get(handles.popupmenuL,'Value');
if L==1
    L=12;
elseif L==12
    L=1;
end
M = get(handles.popupmenuM,'Value');
if M==1
    M=13;
elseif M==13
    M=1;
end
N = get(handles.popupmenuN,'Value');
if N==1
    N=14;
elseif N==14
    N=1;
end
O = get(handles.popupmenuO,'Value');
if O==1
    O=15;
elseif O==15
    O=1;
end
P = get(handles.popupmenuP,'Value');
if P==1
    P=16;
elseif P==16
    P=1;
end
Q = get(handles.popupmenuQ,'Value');
if Q==1
    Q=17;
elseif Q==17
    Q=1;
end

A = indexstr(A);
B = indexstr(B);
C = indexstr(C);
D = indexstr(D);
E = indexstr(E);
F = indexstr(F);
G = indexstr(G);
H = indexstr(H);
I = indexstr(I);
J = indexstr(J);
K = indexstr(K);
L = indexstr(L);
M = indexstr(M);
N = indexstr(N);
O = indexstr(O);
P = indexstr(P);
Q = indexstr(Q);



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

indexes={A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q};
days=[b1,b2,b3,b4,b5];

%计算
tableA=premium(A,b1,b2,b3,b4,b5,day);
tableB=premium(B,b1,b2,b3,b4,b5,day);
tableC=premium(C,b1,b2,b3,b4,b5,day);
tableD=premium(D,b1,b2,b3,b4,b5,day);
tableE=premium(E,b1,b2,b3,b4,b5,day);
tableF=premium(F,b1,b2,b3,b4,b5,day);
tableG=premium(G,b1,b2,b3,b4,b5,day);
tableH=premium(H,b1,b2,b3,b4,b5,day);
tableI=premium(I,b1,b2,b3,b4,b5,day);
tableJ=premium(J,b1,b2,b3,b4,b5,day);
tableK=premium(K,b1,b2,b3,b4,b5,day);
tableL=premium(L,b1,b2,b3,b4,b5,day);
tableM=premium(M,b1,b2,b3,b4,b5,day);
tableN=premium(N,b1,b2,b3,b4,b5,day);
tableO=premium(O,b1,b2,b3,b4,b5,day);
tableP=premium(P,b1,b2,b3,b4,b5,day);
tableQ=premium(Q,b1,b2,b3,b4,b5,day);

table1=[tableA(1,:);tableB(1,:);tableC(1,:);tableD(1,:);tableE(1,:);tableF(1,:);tableG(1,:);tableH(1,:);tableI(1,:);tableJ(1,:);tableK(1,:);tableL(1,:);tableM(1,:);tableN(1,:);tableO(1,:);tableP(1,:);tableQ(1,:)];
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
table2=[tableA(2,:);tableB(2,:);tableC(2,:);tableD(2,:);tableE(2,:);tableF(2,:);tableG(2,:);tableH(2,:);tableI(2,:);tableJ(2,:);tableK(2,:);tableL(2,:);tableM(2,:);tableN(2,:);tableO(2,:);tableP(2,:);tableQ(2,:)];
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
table3=[tableA(3,:);tableB(3,:);tableC(3,:);tableD(3,:);tableE(3,:);tableF(3,:);tableG(3,:);tableH(3,:);tableI(3,:);tableJ(3,:);tableK(3,:);tableL(3,:);tableM(3,:);tableN(3,:);tableO(3,:);tableP(3,:);tableQ(3,:)];
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
table4=[tableA(4,:);tableB(4,:);tableC(4,:);tableD(4,:);tableE(4,:);tableF(4,:);tableG(4,:);tableH(4,:);tableI(4,:);tableJ(4,:);tableK(4,:);tableL(4,:);tableM(4,:);tableN(4,:);tableO(4,:);tableP(4,:);tableQ(4,:)];
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
table5=[tableA(5,:);tableB(5,:);tableC(5,:);tableD(5,:);tableE(5,:);tableF(5,:);tableG(5,:);tableH(5,:);tableI(5,:);tableJ(5,:);tableK(5,:);tableL(5,:);tableM(5,:);tableN(5,:);tableO(5,:);tableP(5,:);tableQ(5,:)];
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
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)));indexname(char(indexes(7)));indexname(char(indexes(8)));indexname(char(indexes(9)));indexname(char(indexes(10)));indexname(char(indexes(11)));indexname(char(indexes(12)));indexname(char(indexes(13)));indexname(char(indexes(14)));indexname(char(indexes(15)));indexname(char(indexes(16)));indexname(char(indexes(17)))};
da=get(handles.editday,'String');
col3={da;da;da;da;da;da;da;da;da;da;da;da;da;da;da;da;da};
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
index1=indexnameabb(char(indexes(1)));
index2=indexnameabb(char(indexes(2)));
index3=indexnameabb(char(indexes(3)));
index4=indexnameabb(char(indexes(4)));
index5=indexnameabb(char(indexes(5)));
index6=indexnameabb(char(indexes(6)));
index7=indexnameabb(char(indexes(7)));
index8=indexnameabb(char(indexes(8)));
index9=indexnameabb(char(indexes(9)));
index10=indexnameabb(char(indexes(10)));
index11=indexnameabb(char(indexes(11)));
index12=indexnameabb(char(indexes(12)));
index13=indexnameabb(char(indexes(13)));
index14=indexnameabb(char(indexes(14)));
index15=indexnameabb(char(indexes(15)));
index16=indexnameabb(char(indexes(16)));
index17=indexnameabb(char(indexes(17)));

col2={index1,index2,index3,index4,index5,index6,index7,index8,index9,index10,index11,index12,index13,index14,index15};
%,index17
y=tableb(1:15,1);
z=tableb(1:15,2);
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


% --- Executes on selection change in popupmenuH.
function popupmenuH_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuH contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuH


% --- Executes during object creation, after setting all properties.
function popupmenuH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuI.
function popupmenuI_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuI


% --- Executes during object creation, after setting all properties.
function popupmenuI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuJ.
function popupmenuJ_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuJ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuJ


% --- Executes during object creation, after setting all properties.
function popupmenuJ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuK.
function popupmenuK_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuK contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuK


% --- Executes during object creation, after setting all properties.
function popupmenuK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuL.
function popupmenuL_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuL contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuL


% --- Executes during object creation, after setting all properties.
function popupmenuL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuM.
function popupmenuM_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuM


% --- Executes during object creation, after setting all properties.
function popupmenuM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuN.
function popupmenuN_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuN


% --- Executes during object creation, after setting all properties.
function popupmenuN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuN (see GCBO)
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


% --- Executes on selection change in popupmenuQ.
function popupmenuQ_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuQ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuQ


% --- Executes during object creation, after setting all properties.
function popupmenuQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
