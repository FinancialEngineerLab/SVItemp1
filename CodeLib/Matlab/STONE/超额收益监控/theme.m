function varargout = theme(varargin)
% THEME MATLAB code for theme.fig
%      THEME, by itself, creates a new THEME or raises the existing
%      singleton*.
%
%      H = THEME returns the handle to a new THEME or the handle to
%      the existing singleton*.
%
%      THEME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THEME.M with the given input arguments.
%
%      THEME('Property','Value',...) creates a new THEME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before theme_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to theme_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help theme

% Last Modified by GUIDE v2.5 23-Sep-2015 14:47:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @theme_OpeningFcn, ...
                   'gui_OutputFcn',  @theme_OutputFcn, ...
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


% --- Executes just before theme is made visible.
function theme_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to theme (see VARARGIN)

% Choose default command line output for theme
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes theme wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%preset functions
%首先是判断（选择）指数，给定传递的数据
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='886001.WI'
elseif n==2
    index='886002.WI'
elseif n==3
    index='886003.WI'
elseif n==4
    index='886004.WI'
elseif n==5
    index='886005.WI'
elseif n==6
    index='886006.WI'
elseif n==7
    index='886007.WI'
elseif n==8
    index='886008.WI'
elseif n==9
    index='886009.WI'
elseif n==10
    index='886010.WI'  
elseif n==11
    index='886011.WI'
elseif n==12
    index='886012.WI'
elseif n==13
    index='886013.WI'
elseif n==14
    index='886014.WI'  
elseif n==15
    index='886015.WI'
elseif n==16
    index='886016.WI'
elseif n==17
    index='886017.WI'
elseif n==18
    index='886018.WI'
elseif n==19
    index='886019.WI'
elseif n==20
    index='886020.WI'
elseif n==21
    index='886021.WI'
elseif n==22
    index='886022.WI'  
elseif n==23
    index='886023.WI'
elseif n==24
    index='886024.WI'
elseif n==25
    index='886025.WI'
elseif n==26
    index='886026.WI'
elseif n==27
    index='886027.WI'
elseif n==28
    index='886028.WI'
elseif n==29
    index='886029.WI'
elseif n==30
    index='886030.WI'
elseif n==31
    index='886031.WI'
elseif n==32
    index='886032.WI'
elseif n==33
    index='886033.WI'
elseif n==34
    index='886034.WI'
elseif n==35
    index='886035.WI'  
elseif n==36
    index='886036.WI'
elseif n==37
    index='886037.WI'
elseif n==38
    index='886038.WI'
elseif n==39
    index='886039.WI'  
elseif n==40
    index='886040.WI'
elseif n==41
    index='886041.WI'
elseif n==42
    index='886042.WI'
elseif n==43
    index='886043.WI'
elseif n==44
    index='886044.WI'
elseif n==45
    index='886045.WI'
elseif n==46
    index='886046.WI'
elseif n==47
    index='886048.WI'  
elseif n==48
    index='886049.WI'
elseif n==49
    index='886050.WI'
elseif n==50
    index='886051.WI'
elseif n==51
    index='886052.WI'
elseif n==52
    index='886053.WI'
elseif n==53
    index='886054.WI'
elseif n==54
    index='886055.WI'
elseif n==55
    index='886057.WI'
elseif n==56
    index='886058.WI'
elseif n==57
    index='886059.WI'
elseif n==58
    index='886060.WI'  
elseif n==59
    index='886061.WI'
elseif n==60
    index='886062.WI'
elseif n==61
    index='886063.WI'
elseif n==62
    index='886064.WI'
elseif n==63
    index='886065.WI'  
elseif n==64
    index='886066.WI'
elseif n==65
    index='886067.WI'
elseif n==66
    index='886068.WI'
elseif n==67
    index='886069.WI'
end
function [n]  = indexname( index )
% give the string of the index
if n=='886001.WI'
    index='能源设备'
elseif n=='886002.WI'
    index='石油天然气'
elseif n=='886003.WI'
    index='煤 炭'
elseif n=='886004.WI'
    index='化工原料'
elseif n=='886005.WI'
    index='化 纤'
elseif n=='886006.WI'
    index='精细化工'
elseif n=='886007.WI'
    index='化肥农药'
elseif n=='886008.WI'
    index='建 材'
elseif n=='886009.WI'
    index='包 装'
elseif n=='886010.WI'
    index='基本金属'
elseif n=='886011.WI'
    index='贵金属'
elseif n=='886012.WI'
    index='钢 铁'
elseif n=='886013.WI'
    index='林 木'
elseif n=='886014.WI'
    index='造 纸'
elseif n=='886015.WI'
    index='航天军工'
elseif n=='886016.WI'
    index='建 筑'
elseif n=='886017.WI'
    index='电工电网'
elseif n=='886018.WI'
    index='发电设备'
elseif n=='886019.WI'
    index='综合类'
elseif n=='886020.WI'
    index='重型机械'
elseif n=='886021.WI'
    index='工业机械'
elseif n=='886022.WI'
    index='贸 易'   
elseif n=='886023.WI'
    index='商业服务'
elseif n=='886024.WI'
    index='环 保'
elseif n=='886025.WI'
    index='办公用品'
elseif n=='886026.WI'
    index='航 空'
elseif n=='886027.WI'
    index='海 运'
elseif n=='886028.WI'
    index='陆路运输'
elseif n=='886029.WI'
    index='机 场'
elseif n=='886030.WI'
    index='公 路'
elseif n=='886031.WI'
    index='港 口'
elseif n=='886032.WI'
    index='汽车零部件'
elseif n=='886033.WI'
    index='汽 车'
elseif n=='886034.WI'
    index='摩托车'
elseif n=='886035.WI'
    index='家用电器'
elseif n=='886036.WI'
    index='家居用品'
elseif n=='886037.WI'
    index='休闲用品'
elseif n=='886038.WI'
    index='纺织服装'
elseif n=='886039.WI'
    index='餐饮旅游'
elseif n=='886040.WI'
    index='教 育'
elseif n=='886041.WI'
    index='文化传媒'
elseif n=='886042.WI'
    index='零 售'
elseif n=='886043.WI'
    index='酒 类'
elseif n=='886044.WI'
    index='软饮料'
elseif n=='886045.WI'
    index='农 业'
elseif n=='886046.WI'
    index='食 品'
elseif n=='886048.WI'
    index='日用化工'
elseif n=='886049.WI'
    index='医疗保健'
elseif n=='886050.WI'
    index='生物科技'   
elseif n=='886051.WI'
    index='制 药'
elseif n=='886052.WI'
    index='银 行'
elseif n=='886053.WI'
    index='多元金融'
elseif n=='886054.WI'
    index='券 商'
elseif n=='886055.WI'
    index='保 险'
elseif n=='886057.WI'
    index='房地产'
elseif n=='886058.WI'
    index='互联网'
elseif n=='886059.WI'
    index='软 件'
elseif n=='886060.WI'
    index='通信设备'   
elseif n=='886061.WI'
    index='电脑硬件'
elseif n=='886062.WI'
    index='电子元器件'
elseif n=='886063.WI'
    index='半导体'
elseif n=='886064.WI'
    index='电 信'
elseif n=='886065.WI'
    index='电 力'
elseif n=='886066.WI'
    index='燃 气'
elseif n=='886067.WI'
    index='水 务'
elseif n=='886068.WI'
    index='工程机械'
elseif n=='886069.WI'
    index='石油化工'
end

function [n]  = indexnameabb( index )
% give the string of the index
if index=='886001.WI'
    n='能源设备'
elseif index=='886002.WI'
    n='石油天然气'
elseif index=='886003.WI'
    n='煤 炭'
elseif index=='886004.WI'
    n='化工原料'
elseif index=='886005.WI'
    n='化 纤'
elseif index=='886006.WI'
    n='精细化工'
elseif index=='886007.WI'
    n='化肥农药'
elseif index=='886008.WI'
    n='建 材'
elseif index=='886009.WI'
    n='包 装'
elseif index=='886010.WI'
    n='基本金属'
elseif index=='886011.WI'
    n='贵金属'
elseif index=='886012.WI'
    n='钢 铁'
elseif index=='886013.WI'
    n='林 木'
elseif index=='886014.WI'
    n='造 纸'
elseif index=='886015.WI'
    n='航天军工'
elseif index=='886016.WI'
    n='建 筑'
elseif index=='886017.WI'
    n='电工电网'
elseif index=='886018.WI'
    n='发电设备'
elseif index=='886019.WI'
    n='综合类'
elseif index=='886020.WI'
    n='重型机械'
elseif index=='886021.WI'
    n='工业机械'
elseif index=='886022.WI'
    n='贸 易'   
elseif index=='886023.WI'
    n='商业服务'
elseif index=='886024.WI'
    n='环 保'
elseif index=='886025.WI'
    n='办公用品'
elseif index=='886026.WI'
    n='航 空'
elseif index=='886027.WI'
    n='海 运'
elseif index=='886028.WI'
    n='陆路运输'
elseif index=='886029.WI'
    n='机 场'
elseif index=='886030.WI'
    n='公 路'
elseif index=='886031.WI'
    n='港 口'
elseif index=='886032.WI'
    n='汽车零部件'
elseif index=='886033.WI'
    n='汽 车'
elseif index=='886034.WI'
    n='摩托车'
elseif index=='886035.WI'
    n='家用电器'
elseif index=='886036.WI'
    n='家居用品'
elseif index=='886037.WI'
    n='休闲用品'
elseif index=='886038.WI'
    n='纺织服装'
elseif index=='886039.WI'
    n='餐饮旅游'
elseif index=='886040.WI'
    n='教 育'
elseif index=='886041.WI'
    n='文化传媒'
elseif index=='886042.WI'
    n='零 售'
elseif index=='886043.WI'
    n='酒 类'
elseif index=='886044.WI'
    n='软饮料'
elseif index=='886045.WI'
    n='农 业'
elseif index=='886046.WI'
    n='食 品'
elseif index=='886048.WI'
    n='日用化工'
elseif index=='886049.WI'
    n='医疗保健'
elseif index=='886050.WI'
    n='生物科技'   
elseif index=='886051.WI'
    n='制 药'
elseif index=='886052.WI'
    n='银 行'
elseif index=='886053.WI'
    n='多元金融'
elseif index=='886054.WI'
    n='券 商'
elseif index=='886055.WI'
    n='保 险'
elseif index=='886057.WI'
    n='房地产'
elseif index=='886058.WI'
    n='互联网'
elseif index=='886059.WI'
    n='软 件'
elseif index=='886060.WI'
    n='通信设备'   
elseif index=='886061.WI'
    n='电脑硬件'
elseif index=='886062.WI'
    n='电子元器件'
elseif index=='886063.WI'
    n='半导体'
elseif index=='886064.WI'
    n='电 信'
elseif index=='886065.WI'
    n='电 力'
elseif index=='886066.WI'
    n='燃 气'
elseif index=='886067.WI'
    n='水 务'
elseif index=='886068.WI'
    n='工程机械'
elseif index=='886069.WI'
    n='石油化工'
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
function varargout = theme_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when entered data in editable cell(s) in uitable5.
function uitable5_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable5 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
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
day=get(handles.edit1,'String');
A = get(handles.popupmenu7,'Value');
B = get(handles.popupmenu8,'Value');
if B==17
    B=46;
elseif B==46
    B=17;
end
C = get(handles.popupmenu9,'Value');
if C==17
    C=33;
elseif C==33
    C=17;
end
D = get(handles.popupmenu10,'Value');
if D==17
    D=58;
elseif D==58
    D=17;
end
E = get(handles.popupmenu11,'Value');
if E==17
    E=15;
elseif E==15
    E=17;
end
F = get(handles.popupmenu12,'Value');
if F==17
    F=4;
elseif F==4
    F=17;
end

A = indexstr(A);
B = indexstr(B);
C = indexstr(C);
D = indexstr(D);
E = indexstr(E);
F = indexstr(F);


b1=pop(get(handles.popupmenu2,'Value'));
b2=pop(get(handles.popupmenu3,'Value'));
%因为改变了默认的次序,所以需要进行微调
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu4,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu5,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu6,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end
%判断按照字段进行排序
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu18, 'Value'));
sort(2) = pop(get(handles.popupmenu19, 'Value'));
sort(3) = pop(get(handles.popupmenu20, 'Value'));
sort(4) = pop(get(handles.popupmenu21, 'Value'));
sort(5) = pop(get(handles.popupmenu22, 'Value'));

indexes={A;B;C;D;E;F};
days=[b1,b2,b3,b4,b5];
%计算
tableA=premium(A,b1,b2,b3,b4,b5,day);
tableB=premium(B,b1,b2,b3,b4,b5,day);
tableC=premium(C,b1,b2,b3,b4,b5,day);
tableD=premium(D,b1,b2,b3,b4,b5,day);
tableE=premium(E,b1,b2,b3,b4,b5,day);
tableF=premium(F,b1,b2,b3,b4,b5,day);

table1=[tableA(1,:);tableB(1,:);tableC(1,:);tableD(1,:);tableE(1,:);tableF(1,:)];
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
% for i=1:m
% %     table1per(i,1)=cellstr(indexname(indexstr(i)));
%     table1per(i,1)=cellstr(indexname(indexes{i}));
% end
table2=[tableA(2,:);tableB(2,:);tableC(2,:);tableD(2,:);tableE(2,:);tableF(2,:)];
[m,n]=size(table2);
% convert to percentage by num2str
% for i=1:m
%     table2per(i,1)=cellstr(indexname(indexes{i}));
% end
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
table3=[tableA(3,:);tableB(3,:);tableC(3,:);tableD(3,:);tableE(3,:);tableF(3,:)];
[m,n]=size(table3);
% convert to percentage by num2str
% for i=1:m
%     table3per(i,1)=cellstr(indexname(indexes{i}));
% end
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
table4=[tableA(4,:);tableB(4,:);tableC(4,:);tableD(4,:);tableE(4,:);tableF(4,:)];
[m,n]=size(table4);
% convert to percentage by num2str
% for i=1:m
%     table4per(i,1)=cellstr(indexname(indexes{i}));
% end
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
table5=[tableA(5,:);tableB(5,:);tableC(5,:);tableD(5,:);tableE(5,:);tableF(5,:)];
[m,n]=size(table5);
% convert to percentage by num2str
% % for i=1:m
% %     table5per(i,1)=cellstr(indexname(indexes{i}));
% % end
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

%set(handles.uitable5,'FontSize',10);
set(handles.uitable5,'data',table1per);
set(handles.uitable1,'data',table2per);
set(handles.uitable2,'data',table3per);
set(handles.uitable3,'data',table4per);
set(handles.uitable4,'data',table5per);

%set popupmenuday
set(handles.popupmenu1,'String',{[num2str(days(1)),'日'];[num2str(days(2)),'日'];[num2str(days(3)),'日'];[num2str(days(4)),'日'];[num2str(days(5)),'日'];});
% cla(handles.axes1);
% cla(handles.axes2);
guidata(hObject,handles);

msgbox('刷新完成');


% --- Executes when selected cell(s) is changed in uitable5.
function uitable5_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable5 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on popupmenu13 and none of its controls.
function popupmenu13_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
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

% --- Executes on key press with focus on edit2 and none of its controls.
function edit2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

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
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)))};
da=get(handles.edit2,'String');
col3={da;da;da;da;da;da};
[filename, pathname] = uiputfile({ '*.xls','xls File (*.xls)'}, ... 
        'Save excel as','default');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
xlswrite([pathname,filename],[namerow;col1,col2,col3,num2cell(table1),num2cell(table2),num2cell(table3),num2cell(table4),num2cell(table5)]);
% table=[table1]
% xlswrite(['D:\Workarea\files\wind matlab\GUIDE\','handles.editday','.xls'],[namerow,table1]);



% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global indexes;
global days;
figure(2);
b=get(handles.popupmenu1,'Value');
eval(['tableb=table',num2str(b)])

da=get(handles.edit2,'String');
index1=indexnameabb(char(indexes(1)));
index2=indexnameabb(char(indexes(2)));
index3=indexnameabb(char(indexes(3)));
index4=indexnameabb(char(indexes(4)));
index5=indexnameabb(char(indexes(5)));
index6=indexnameabb(char(indexes(6)));

col2={index1,index2,index3,index4,index5,index6};
% axes(handles.axes1); 
y=tableb(1:6,1);
bar(y,0.4);
set(gca,'XTickLabel',col2);
ylabel('%');
title([num2str(days(b)),'日超额收益']);

figure(3);
% axes(handles.axes2); 
y=tableb(1:6,2);
bar(y,0.4);
set(gca,'XTickLabel',col2);
set(gca, 'yLim',[0 1.1]);      % y轴的数据显示范围
title([num2str(days(b)),'日超额收益分位数']);
% guidata(hObject, handles);
%pix=getframe(handles.axes1);
%imwrite(pix.cdata,['D:\Workarea\files\wind matlab\GUIDE\',da,' 1日','超额收益','.png'],'jpg')


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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print(2, '-dpng','premium');
print(3, '-dpng','mid');

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.edit2);

% --- Executes during object creation, after setting all properties.
function pushbutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function uitable5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu20.
function popupmenu20_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20


% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
day=get(handles.edit2,'String');

b1=pop(get(handles.popupmenu13,'Value'));
b2=pop(get(handles.popupmenu14,'Value'));
%因为改变了默认的次序,所以需要进行微调
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu15,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu16,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu17,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end

indexCode = {'886001.WI';'886002.WI';'886003.WI';'886004.WI';'886005.WI';'886006.WI';'886007.WI';'886008.WI';'886009.WI';'886010.WI';'886011.WI';'886012.WI';'886013.WI';'886014.WI';'886015.WI';'886016.WI';'886017.WI';'886018.WI';'886019.WI';'886020.WI';'886021.WI';'886022.WI';'886023.WI';'886024.WI';'886025.WI';'886026.WI';'886027.WI';'886028.WI';'886029.WI';'886030.WI';'886031.WI';'886032.WI';'886033.WI';'886034.WI';'886035.WI';'886036.WI';'886037.WI';'886038.WI';'886039.WI';'886040.WI';'886041.WI';'886042.WI';'886043.WI';'886044.WI';'886045.WI';'886046.WI';'886048.WI';'886049.WI';'886050.WI';'886051.WI';'886052.WI';'886053.WI';'886054.WI';'886055.WI';'886057.WI';'886058.WI';'886059.WI';'886060.WI';'886061.WI';'886062.WI';'886063.WI';'886064.WI';'886065.WI';'886066.WI';'886067.WI';'886068.WI';'886069.WI'};
indexName = {'能源设备';'石油天然气';'煤 炭';'化工原料';'化 纤';'精细化工';'化肥农药';'建 材';'包 装';'基本金属'; '贵金属';'钢 铁';'林 木';'造 纸';'航天军工';'建 筑';'电工电网';'发电设备';'综合类';'重型机械';'工业机械';'贸 易';'商业服务';'环 保';'办公用品';'航 空';'海 运';'陆路运输';'机 场';'公 路';'港 口';'汽车零部件'; '汽 车';'摩托车';'家用电器';'家居用品';'休闲用品';'纺织服装';'餐饮旅游';'教 育';'文化传媒';'零 售';'酒 类';'软饮料';'农 业';'食 品';'日用化工';'医疗保健';'生物科技';'制 药';'银 行';'多元金融';'券 商';'保 险'; '房地产';'互联网';'软 件';'通信设备';'电脑硬件';'电子元器件';'半导体';'电 信';'电 力';'燃 气';'水 务';'工程机械';'石油化工'};
index = [indexCode;indexName];
[r1, r2, r3, r4, r5]=premiumOfAll(indexCode,b1,b2,b3,b4,b5,day);  

%判断按照字段进行排序
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu18, 'Value'));
sort(2) = pop(get(handles.popupmenu19, 'Value'));
sort(3) = pop(get(handles.popupmenu20, 'Value'));
sort(4) = pop(get(handles.popupmenu21, 'Value'));
sort(5) = pop(get(handles.popupmenu22, 'Value'));

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

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.edit1);


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


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
