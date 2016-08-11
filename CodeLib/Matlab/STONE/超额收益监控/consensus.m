function varargout = consensus(varargin)
% CONSENSUS MATLAB code for consensus.fig
%      CONSENSUS, by itself, creates a new CONSENSUS or raises the existing
%      singleton*.
%
%      H = CONSENSUS returns the handle to a new CONSENSUS or the handle to
%      the existing singleton*.
%
%      CONSENSUS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONSENSUS.M with the given input arguments.
%
%      CONSENSUS('Property','Value',...) creates a new CONSENSUS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before consensus_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to consensus_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help consensus

% Last Modified by GUIDE v2.5 30-Jul-2015 10:51:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @consensus_OpeningFcn, ...
                   'gui_OutputFcn',  @consensus_OutputFcn, ...
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


% --- Executes just before consensus is made visible.
function consensus_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to consensus (see VARARGIN)

% Choose default command line output for consensus
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes consensus wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%preset functions
%首先是判断（选择）指数，给定传递的数据
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='801010'
elseif n==2
    index='801020'
elseif n==3
    index='801030'
elseif n==4
    index='801040'
elseif n==5
    index='801050'
elseif n==6
    index='801080'
elseif n==7
    index='801110'
elseif n==8
    index='801120'
elseif n==9
    index='801130'
elseif n==10
    index='801140'
elseif n==11
    index='801150'
elseif n==12
    index='801160'
elseif n==13
    index='801170'
elseif n==14
    index='801180'  
elseif n==15
    index='801200'
elseif n==16
    index='801210'
elseif n==17
    index='801230'
elseif n==18
    index='801710'
elseif n==19
    index='801720'
elseif n==20
    index='801730'
elseif n==21
    index='801740'
elseif n==22
    index='801750'   
elseif n==23
    index='801760'
elseif n==24
    index='801770'
elseif n==25
    index='801780'
elseif n==26
    index='801790'
elseif n==27
    index='801880'
elseif n==28
    index='801890'
end



function [index]  = indexname( n )
% give the string of the index
if n=='801010'
    index='农林牧渔'
elseif n=='801020'
    index='采掘'
elseif n=='801030'
    index='化工'
elseif n=='801040'
    index='钢铁'
elseif n=='801050'
    index='有色金属'
elseif n=='801080'
    index='电子'
elseif n=='801110'
    index='家用电器'
elseif n=='801120'
    index='食品饮料'
elseif n=='801130'
    index='纺织服装'
elseif n=='801140'
    index='轻工制造'
elseif n=='801150'
    index='医药生物'
elseif n=='801160'
    index='公用事业'
elseif n=='801170'
    index='交通运输'
elseif n=='801180' 
    index= '房地产'
elseif n=='801200'
    index='商业贸易'
elseif n=='801210'
    index='休闲服务'
elseif n=='801230'
    index='综合'
elseif n=='801710'
    index='建筑材料'
elseif n=='801720'
    index='建筑装饰'
elseif n=='801730'
    index='电气设备'
elseif n=='801740'
    index='国防军工'
elseif n=='801750'
    index='计算机'   
elseif n=='801760'
    index='传媒'
elseif n=='801770'
    index='通信'
elseif n=='801780'
    index='银行'
elseif n=='801790'
    index='非银金融'
elseif n=='801880'
    index='汽车'
elseif n=='801890'
    index='机械设备'
end

%function for popupmenu
function[r] = pop(b)
if b==1
    r=1;
elseif b==2
    r=3;
elseif b==3
    r=6;
end

%function to get the corresponding results


% --- Outputs from this function are returned to the command line.
function varargout = consensus_OutputFcn(hObject, eventdata, handles) 
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
global table;
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
    B=6;
elseif B==6
    B=1;
end
C = get(handles.popupmenuC,'Value');
if C==1
    C=9;
elseif C==9
    C=1;
end
D = get(handles.popupmenuD,'Value');
if D==1
    D=10;
elseif D==10
    D=1;
end
E = get(handles.popupmenuE,'Value');
if E==1
    E=13;
elseif E==13
    E=1;
end
F = get(handles.popupmenuF,'Value');
if F==1
    F=20;
elseif F==20
    F=1;
end
G = get(handles.popupmenuG,'Value');
if G==1
    G=21;
elseif G==21
    G=1;
end
H = get(handles.popupmenuH,'Value');
if H==1
    H=22;
elseif H==22
    H=1;
end
I = get(handles.popupmenuI,'Value');
if I==1
    I=23;
elseif I==23
    I=1;
end
J = get(handles.popupmenuJ,'Value');
if J==1
    J=24;
elseif J==24
    J=1;
end
K = get(handles.popupmenuK,'Value');
if K==1
    K=25;
elseif K==25
    K=1;
end
L = get(handles.popupmenuL,'Value');
if L==1
    L=26;
elseif L==26
    L=1;
end
M = get(handles.popupmenuM,'Value');
if M==1
    M=27;
elseif M==27
    M=1;
end
N = get(handles.popupmenuN,'Value');
if N==1
    N=28;
elseif N==28
    N=1;
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




b2=pop(get(handles.popupmenu2,'Value'));
b4=pop(get(handles.popupmenu4,'Value'));

indexes={A;B;C;D;E;F;G;H;I;J;K;L;M;N};
days=[b2,b4];

%从数据库中提取数据
w=windmatlab;

conn=database('gogoal','suntime','admin#123','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.200.200.14;databaseName=gogoal');
if isconnection(conn)==0
    msgbox('连接朝阳永续数据库失败');
    return;
end

formatOut = 'yyyy-mm-dd';

d1=day;
[d2,~,~,~,~,~]=w.tdaysoffset(-20,day);
d2=datestr(datenum(d2),formatOut);
[d3,~,~,~,~,~]=w.tdaysoffset(-60,day);
d3=datestr(datenum(d3),formatOut);
[d4,~,~,~,~,~]=w.tdaysoffset(-120,day);
d4=datestr(datenum(d4),formatOut);




table1=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d1,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d1)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
if length(table1)<10
    errordlg('数据库刷新数据失败','DATABASE ERROR');
    return;
end
table2_1=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d2,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d2)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
table2_2=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d3,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d3)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
table2_3=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d4,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d4)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);

table3=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d1,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d1)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
table4_1=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d2,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d2)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
table4_2=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d3,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d3)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
table4_3=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d4,''' and stock_type=4 and stock_code in (''',A,''',''',B,''',''',C,''',''',D,''',''',E,''',''',F,''',''',G,''',''',H,''',''',I,''',''',J,''',''',K,''',''',L,''',''',M,''',''',N,''') and rpt_date=''',num2str(year(d4)),''' order by case stock_code when ''',A,''' then 1 when ''',B,''' then 2 when ''',C,''' then 3 when ''',D,''' then 4 when ''',E,''' then 5 when ''',F,''' then 6 when ''',G,''' then 7 when ''',H,''' then 8 when ''',I,''' then 9 when ''',J,''' then 10 when ''',K,''' then 11 when ''',L,''' then 12 when ''',M,''' then 13 when ''',N,''' then 14 end ']);
close(conn);


% convert to middle by num2str
[m,n]=size(table1);
for i=1:m
    mid=cell2mat(table1(i,1));
    table1per(i,1)={['             ',sprintf('%5.2f',mid)]};   
end

if b2==1
    table2=table2_1;
elseif b2==3
    table2=table2_2;
elseif b2==6
    table2=table2_3;
end
% convert to middle by num2str
[m,n]=size(table2);
for i=1:m
    mid=cell2mat(table2(i,1));
    table2per(i,1)={['           ',sprintf('%5.2f',mid)]};   
end

% convert to middle by num2str
[m,n]=size(table3);
for i=1:m
    mid=cell2mat(table3(i,1));
    table3per(i,1)={['             ',sprintf('%4.3f',mid),'%']};   
end

if b4==1
    table4=table4_1;
elseif b4==3
    table4=table4_2;
elseif b4==6
    table4=table4_3;
end
% convert to middle by num2str
[m,n]=size(table4);
for i=1:m
    mid=cell2mat(table4(i,1));
    table4per(i,1)={['                ',sprintf('%4.3f',mid),'%']};   
end
table5=(cell2mat(table1)-cell2mat(table2_1))./cell2mat(table2_1);
% convert to middle by num2str
[m,n]=size(table5);
for i=1:m
    mid=100*table5(i,1);
    table5per(i,1)={['           ',sprintf('%4.2f',mid),'%']};   
    table5excel(i,1)={[num2str(mid)]};  
end

table6=(cell2mat(table3)-cell2mat(table4_1));
% convert to middle by num2str
[m,n]=size(table5);
for i=1:m
    mid=table6(i,1);
    table6per(i,1)={['       ',sprintf('%4.3f',mid),'%']};  
    table6excel(i,1)={[num2str(mid)]};   
end

table=[table1,table2_1,table2_2,table2_3,table3,table4_1,table4_2,table4_3,table5excel,table6excel];

%set(handles.uitable1,'FontSize',10);
set(handles.uitable1,'data',table1per);
set(handles.uitable2,'data',table2per);
set(handles.uitable3,'data',table3per);
set(handles.uitable4,'data',table4per);
set(handles.uitable5,'data',table5per);
set(handles.uitable6,'data',table6per);

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
global table;
global indexes;
table=table';
namerow={'代码','行业','日期','最新PEI','1个月前PEI','3个月前PEI','6个月前PEI','最新一致预期净利增长','1个月前一致预期净利增长','3个月前一致预期净利增长','6个月前一致预期净利增长','PEI环比变化','一致预期净利润增长变化'};
col1=indexes;
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)));indexname(char(indexes(7)));indexname(char(indexes(8)));indexname(char(indexes(9)));indexname(char(indexes(10)));indexname(char(indexes(11)));indexname(char(indexes(12)));indexname(char(indexes(13)));indexname(char(indexes(14)))};
da=get(handles.editday,'String');
col3={da;da;da;da;da;da;da;da;da;da;da;da;da;da};
[filename, pathname] = uiputfile({ '*.xls','xls File (*.xls)'}, ... 
        'Save excel as','default');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
xlswrite([pathname,filename],[namerow;col1,col2,col3,table(:,1),table(:,2),table(:,3),table(:,4),table(:,5),table(:,6),table(:,7),table(:,8),table(:,9),table(:,10)]);

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
global table;
global indexes;
global days;

da=get(handles.editday,'String');
index1=indexname(char(indexes(1)));
index2=indexname(char(indexes(2)));
index3=indexname(char(indexes(3)));
index4=indexname(char(indexes(4)));
index5=indexname(char(indexes(5)));
index6=indexname(char(indexes(6)));
index7=indexname(char(indexes(7)));
index8=indexname(char(indexes(8)));
index9=indexname(char(indexes(9)));
index10=indexname(char(indexes(10)));
index11=indexname(char(indexes(11)));
index12=indexname(char(indexes(12)));
index13=indexname(char(indexes(13)));
index14=indexname(char(indexes(14)));

col2={index1,index2,index3,index4,index5,index6,index7,index8,index9,index10,index11,index12,index13,index14};

%因为table是cell格式,所以要转化成数值形式
yy=table(:,9);
y=1:length(yy);
for i=1:length(yy)
    y(i)=str2num(cell2mat(yy(i)));
end
zz=table(:,10);
z=1:length(zz);
for i=1:length(zz)
    z(i)=str2num(cell2mat(zz(i)));
end
figure;

subplot(2,1,1)
bar(y,0.4);
ylabel('%');
title([num2str(da),'  PEI环比变化']);
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
ylabel('%');
set(gca,'XTickLabel',col2);
set(gca, 'yLim',[0 1.1]);

xtb = get(gca,'XTickLabel');% 获取横坐标轴标签句柄
xt = get(gca,'XTick');% 获取横坐标轴刻度句柄
yt = get(gca,'YTick'); % 获取纵坐标轴刻度句柄          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% 将原有的标签隐去

title([num2str(da),'  一致预期净利润增长变化']);

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


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
