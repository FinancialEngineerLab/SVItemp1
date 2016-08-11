function varargout = LPPL(varargin)
% LPPL MATLAB code for LPPL.fig
%      LPPL, by itself, creates a new LPPL or raises the existing
%      singleton*.
%
%      H = LPPL returns the handle to a new LPPL or the handle to
%      the existing singleton*.
%
%      LPPL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LPPL.M with the given input arguments.
%
%      LPPL('Property','Value',...) creates a new LPPL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LPPL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LPPL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LPPL

% Last Modified by GUIDE v2.5 11-Jan-2016 14:36:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LPPL_OpeningFcn, ...
                   'gui_OutputFcn',  @LPPL_OutputFcn, ...
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


% --- Executes just before LPPL is made visible.
function LPPL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LPPL (see VARARGIN)

% Choose default command line output for LPPL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LPPL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LPPL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
% formatOut = 'yyyy-mm-dd';
% set(hObject,'String',datestr(datenum(End_Date)-1,formatOut));
% guidata(hObject, handles);


% *****************************************************************************************************************************************************************
function [omega_lower,omega_upper,m_lower,m_upper,tc_lower,tc_upper,str_date_start,str_date_end,idx_code,freq_sel,algorithm_sel] = get_params_from_GUI(eventdata, handles)
cla(handles.axes1);
set(handles.edit9,'String', '');
set(handles.edit31,'String', '');
set(handles.edit32,'String', '');
set(handles.edit36,'String', '');

set(handles.edit15,'String', '');%omega
set(handles.edit16,'String', '');%m
set(handles.edit17,'String', '');%tc
set(handles.edit18,'String', '');%A
set(handles.edit19,'String', '');%B
set(handles.edit20,'String', '');%C1
set(handles.edit21,'String', '');%C2
set(handles.edit33,'String', '');%Squared Error 


%获取相应输入值
omega_lower = str2double(get(handles.edit1,'String'));
omega_upper = str2double(get(handles.edit2,'String'));

m_lower = str2double(get(handles.edit3,'String'));
m_upper = str2double(get(handles.edit4,'String'));

tc_lower = str2double(get(handles.edit5,'String'));
tc_upper = str2double(get(handles.edit6,'String'));

str_date_start = get(handles.edit12, 'String');
str_date_end = get(handles.edit13, 'String');

idx_code = get(handles.edit14, 'String');

freq_sel = get(handles.popupmenu1,'Value');

algorithm_sel = get(handles.popupmenu2,'Value');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 检查wind连接

global idx_series;
global tc_date;
try
    w = windmatlab;
catch 
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end 
% 获取参数列表
[omega_lower,omega_upper,m_lower,m_upper,tc_lower,tc_upper,str_date_start,str_date_end,idx_code,freq_sel,algorithm_sel] = get_params_from_GUI(eventdata, handles);

if freq_sel == 1
    [idx_series,~,~,w_times,~,~]=w.wsd(idx_code,'open, high, low, close',str_date_start,str_date_end, 'PriceAdj=F','Fill=Previous');
else if freq_sel == 2
        %[IndexSeries,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid]=w.wsi(Index_Code,'high',Date_Start,Date_End,'BarSize=5;Fill=Previous')
        [idx_series,~,~,w_times,~,~]=w.wsi(idx_code,'open, high, low, close',str_date_start,str_date_end,'periodstart=09:35:00;periodend=15:00:00','PriceAdj=F','BarSize=5;Fill=Previous');
    else if freq_sel == 3
            [idx_series,~,~,w_times,~,~]=w.wsi(idx_code,'open, high, low, close',str_date_start,str_date_end,'periodstart=09:35:00;periodend=15:00:00','PriceAdj=F','BarSize=60;Fill=Previous');
        end
    end
end

% 判断初始截止日期是否相等
if datenum(str_date_start) >= datenum(str_date_end)
    errordlg('截止日期未晚于起始日期，请调整','MATLAB ERROR');
    return;
end;

% 判断是否成功读取数据
if iscell(idx_series) && isnan(cell2mat(idx_series(1,1)))
    errordlg('windmatlab 插件获取数据失败, 检查输入代码和拟合时间是否正确','MATLAB ERROR');
    return;
end

[nrow, ~] = size(idx_series);

if tc_lower < nrow
    tc_lower = nrow;
end

if tc_upper < nrow
    errordlg('Tc上限小于输入数据数量，请重新调整','MATLAB ERROR');
    return;
end

%对实际数据作K线图
axes(handles.axes1); 
cla;
% fts_idx = fints(w_times, idx_series, {'Open', 'High', 'Low', 'Close'},1);
% fts_idx.desc = '日K线价格';
% h1 = candle(fts_idx, 'r');

msg = msgbox('拟合运算中','消息提示');

% 拟合
[sol,min_sqr_err_ten_paths] = LPPL_calib(m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series(:,4),algorithm_sel);

% 对Result进行赋值

if freq_sel == 1 % 日线
    freq_per_day = 1;
else if freq_sel == 2 % 5分钟线
        freq_per_day = 47;
    else if freq_sel == 3 % 60分钟线
            freq_per_day = 4;
        end
    end
end

tc_date_end = w.tdaysoffset(floor(sol(1)/freq_per_day) ,str_date_start, 'Days=Trading','Period=D','TradingCalendar=SSE');
%最优路径的tc最小值
tc_idx = round(min(min_sqr_err_ten_paths(:,1)));
tc_range_start = w.tdaysoffset(floor(tc_idx/freq_per_day),str_date_start, 'Days=Trading','Period=D','TradingCalendar=SSE');
%最优路径的tc最大值
tc_idx = round(max(min_sqr_err_ten_paths(:,1)));
tc_range_end = w.tdaysoffset(floor(tc_idx/freq_per_day),str_date_start, 'Days=Trading','Period=D','TradingCalendar=SSE');

if iscell(idx_series) && isnan(cell2mat(tc_date_end))
    errordlg('反转时间离拟合终点太远，请降低Tc参数约束条件的最大值','MATLAB ERROR');
    return;
end


tc_range_start = datestr(tc_range_start);
set(handles.edit31,'String', tc_range_start);
tc_range_end = datestr(tc_range_end);
set(handles.edit32,'String', tc_range_end);

set(handles.edit15,'String', sol(3));%omega
set(handles.edit16,'String', sol(2));%m
set(handles.edit17,'String', sol(1)); %tc
set(handles.edit18,'String', sol(4));%A
set(handles.edit19,'String', sol(5));%B
set(handles.edit20,'String', sol(6));%C1
set(handles.edit21,'String', sol(7));%C2
set(handles.edit33,'String', sol(8));%Squared Error 


% 作图
idx = linspace(0,sol(1),sol(1)+1)';
tc_minus_t = sol(1)* ones(sol(1)+1,1) - idx;
tc_nimus_t_m = tc_minus_t.^sol(2);
calib_idx = sol(4) * ones(sol(1)+1,1) + sol(5).* tc_nimus_t_m + sol(6).* tc_nimus_t_m.* cos(sol(3) * log(tc_minus_t))+ sol(7).* tc_nimus_t_m.* sin(sol(3) * log(tc_minus_t));

% 对拟合结果作图
date_trade = w.tdays(str_date_start,tc_date_end,'Days=Trading','Period=D','TradingCalendar=SSE');
date_trade = Utility_TradeTime(sol(1), date_trade, freq_sel);
% fts_LPPL = fints(datenum(date_trade), exp(calib_idx));
% axes(handles.axes1);
% h2 = plot(fts_LPPL);

if (freq_sel == 1)
    % 市场K线
    axes(handles.axes1);
    fts_idx = fints(w_times, idx_series, {'Open', 'High', 'Low', 'Close'},1);
    fts_idx.desc = '日K线价格';
    h1 = candle(fts_idx, 'r');
    hold on;
    
    % 拟合结果
    fts_LPPL = fints(datenum(date_trade), exp(calib_idx));
    axes(handles.axes1);
    h2 = plot(fts_LPPL);
    hold off;
    legend([h1(1,1),h2],idx_code,'拟合结果', 2);
    
    tc_date = datestr(tc_date_end);
    set(handles.edit9,'String', tc_date);
else
    axes(handles.axes1);
    % 对收盘价K线作图
    h1 = plot(handles.axes1,idx_series(:,4),'r');
    hold on;
    
    % 对拟合结果作图
    h2 = plot(handles.axes1,exp(calib_idx));
    hold off;
    grid on;
    legend([h1,h2],idx_code,'拟合结果', 2);
        date_end = datestr(date_trade(numel(date_trade)));
    set(handles.edit9,'String', date_end(1:11));
    set(handles.edit36,'String', date_end(13:20));
end

close(msg);
msgbox('数据刷新完成','消息提示');



% --- Executes on button press in pushbutton4
function pushbutton4_Callback(hObject, eventdata, handles)
global idx_series;

%获取相应输入值
A = str2double(get(handles.edit18,'String'));
B = str2double(get(handles.edit19,'String'));
tc = str2double(get(handles.edit17,'String'));
m = str2double(get(handles.edit16,'String'));

if A == 0 && B==0 && tc ==0 
    msgbox('残差分析错误：拟合参数为空，请先完成拟合计算','消息提示');
    return;
end

num_idx = length(idx_series);
if num_idx == 0 
    msgbox('残差分析错误：历史数据无法读取','消息提示');
    return;
end

% res = zeros(NbData,1);
idx = linspace(0,num_idx-1,num_idx)';
tc_minus_t = tc* ones(num_idx,1) - idx;
tc_nimus_t_m = tc_minus_t.^m;
non_cos_part = A - B.*tc_nimus_t_m;
res = log(idx_series(:,4)) - non_cos_part;
res = res - mean(res)./std(res);
res = [log(tc_minus_t) res];

% Calibration with Lomb
Utility_Lombscargle(res);


% --- Executes on button press in pushbutton4
function pushbutton5_Callback(hObject, eventdata, handles)

try
    w = windmatlab;
catch 
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end 
% 获取参数列表
[omega_lower,omega_upper,m_lower,m_upper,tc_lower,tc_upper,str_date_start,str_date_end,idx_code,~,algorithm_sel] = get_params_from_GUI(eventdata, handles);

str_date_begin = str_date_start;

tc_vector = zeros(8,1);
date_end_vector = zeros(8,1);

count = str2double(get(handles.edit34,'String'));

msg = msgbox('拟合运算中','消息提示');
for i = 1:count % 暂时计算八个t_c
    %str_date_start =  w.tdaysoffset(-2*i ,str_date_start, 'Days=Trading','Period=D','TradingCalendar=SSE');
    % 固定开始的时间
    str_date_end_CLIP =w.tdaysoffset(-2*i ,str_date_end, 'Days=Trading','Period=D','TradingCalendar=SSE');
    [idx_series,~,~,~,~,~]=w.wsd(idx_code,'open, high, low, close',str_date_start,str_date_end_CLIP, 'PriceAdj=F','Fill=Previous');
   
    % 判断初始截止日期是否相等
    if datenum(str_date_start) >= datenum(str_date_end_CLIP)
        errordlg('截止日期未晚于起始日期，请调整','MATLAB ERROR');
        return;
    end;

    % 判断是否成功读取数据
    if iscell(idx_series) && isnan(cell2mat(idx_series(1,1)))
        errordlg('windmatlab 插件获取数据失败, 检查输入代码和拟合时间是否正确','MATLAB ERROR');
        return;
    end

    [nrow, ~] = size(idx_series);

    if tc_lower < nrow
        tc_lower = nrow;
    end

    if tc_upper < nrow
        errordlg('Tc上限小于输入数据数量，请重新调整','MATLAB ERROR');
        return;
    end
    % 拟合
    [sol,~] = LPPL_calib(m_lower,m_upper,omega_lower,omega_upper,tc_lower,tc_upper, idx_series(:,4),algorithm_sel);
    tc_vector(i) = sol(1);
    date_end_vector(i) = datenum(str_date_end_CLIP);
end
close(msg);

% 对结果作图
[str_date_max,~,~,~,~,~]=w.tdaysoffset(max(tc_vector),str_date_begin);
[str_date_series,~,~,~,~,~]=w.tdays(str_date_begin,str_date_max);
tc_trade = cell(1, numel(tc_vector));
for i = 1 : numel(tc_vector)
    tc_trade(i) = str_date_series(tc_vector(i));
end

fts_CLIP = fints(date_end_vector, datenum(tc_trade));
figure
h = plot(fts_CLIP, '.-b');
datetick('y','dd-mmm-yyyy');
legend(h,'Tc', 2);
title('Crash Lock-In Plot(CLIP)');
for i = 1 : numel(date_end_vector)
    text(date_end_vector(i), datenum(tc_trade(i)), tc_trade(i),...
         'color', 'b', 'FontSize', 8);
end

msgbox('数据刷新完成','消息提示');

function edit12_Callback(hObject, ~, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
format_out = 'yyyy-mm-dd';
set(hObject,'String',datestr(datenum(date)-1,format_out));
guidata(hObject, handles);



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
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



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
