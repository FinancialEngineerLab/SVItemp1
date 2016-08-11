function varargout = Hurst_exp(varargin)
% HURST_EXP MATLAB code for Hurst_exp.fig
%      HURST_EXP, by itself, creates a new HURST_EXP or raises the existing
%      singleton*.
%
%      H = HURST_EXP returns the handle to a new HURST_EXP or the handle to
%      the existing singleton*.
%
%      HURST_EXP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HURST_EXP.M with the given input arguments.
%
%      HURST_EXP('Property','Value',...) creates a new HURST_EXP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Hurst_exp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Hurst_exp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Hurst_exp

% Last Modified by GUIDE v2.5 25-Dec-2015 16:55:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Hurst_exp_OpeningFcn, ...
                   'gui_OutputFcn',  @Hurst_exp_OutputFcn, ...
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


% --- Executes just before Hurst_exp is made visible.
function Hurst_exp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Hurst_exp (see VARARGIN)

% Choose default command line output for Hurst_exp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Hurst_exp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Hurst_exp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% -------
function [wind_code,date_end,time_wnd,move_avg,ref,period] = get_params_from_GUI(eventdata, handles)
% 提取参数
wind_code = get(handles.edit1, 'String');
date_end = get(handles.edit2, 'String');
time_wnd = str2double(get(handles.edit3, 'String'));
move_avg = str2double(get(handles.edit4, 'String'));
ref = str2double(get(handles.edit13, 'String'));
period = str2double(get(handles.edit14, 'String'));

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
cla;

% 打开wind数据接口
try
    w=windmatlab;
catch
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end

% 提取参数
[wind_code,date_end,time_wnd,move_avg,ref,period] = get_params_from_GUI(eventdata, handles);

msg = msgbox('拟合运算中','消息提示');

try
    % 计算提取数据起始日期
    [date_start,~,~,~,~,~]=w.tdaysoffset(- (time_wnd * 2 + move_avg + 1), date_end);

    % 从wind获取标的收盘价数据
    [data_close,~,~,~,~,~]=w.wsd(wind_code,'close',date_start,date_end,'Fill=Previous');
catch
    errordlg('无法获取wind数据','MATLAB ERROR');
end

% 计算当日Hurst指数
[ local_hurst, e_h ] = Hurst_local( data_close, time_wnd, move_avg );

set(handles.edit7, 'String', local_hurst(1,1));
set(handles.edit8, 'String', e_h(1,1));

% plot function
move_forward = str2double(get(handles.edit11, 'String'));
try
    % 画图初始日期
    [date_begin,~,~,~,~,~] = w.tdaysoffset(-move_forward + 1,date_end);
    % 初试日期提取数据所需
    [date_start,~,~,~,~,~]=w.tdaysoffset(- (time_wnd * 2 + move_avg + 1), date_begin);
    % 从wind获取标的收盘价数据
    [data_all,~,~,w_times,~,~]=w.wsd(wind_code,'open, high, low, close',date_start,date_end,'Fill=Previous');
    % 从wind获取时间序列
    [data_string,~,~,~,~,~]=w.tdays(date_begin , date_end);
catch
    errordlg('无法获取wind数据','MATLAB ERROR');
end

% 建立存储空间
local_hurst_vec = zeros(move_forward, 1);
e_hurst_vec = zeros(move_forward, 1);

for i = 1 : move_forward
    [local_hurst_vec(i), e_hurst_vec(i)] = Hurst_local( data_all(i : (time_wnd * 2 + move_avg + i), 4), time_wnd, move_avg );
end;

% Hurst MA (默认周期20，参考华泰联合）
hurst_MA = zeros(numel(local_hurst_vec) - period, 1);
for i = 0 : numel(local_hurst_vec) - period 
    hurst_MA(i + 1) = mean(local_hurst_vec(1 + i: period + i));
end

% axes1作图
axes(handles.axes1);
cla;
% Hurst指数作图
fts_hurst_m = fints(datenum(data_string), local_hurst_vec);
h1 = plot(fts_hurst_m, '.-b');
hold on;
% E(H) 指数作图
fts_eh_m = fints(datenum(data_string), e_hurst_vec);
h2 = plot(fts_eh_m, 'm');
% Hurst MA指数作图
fts_hurst_MA = fints(datenum(data_string(period : numel(data_string))), hurst_MA);
h3 = plot(fts_hurst_MA, 'g');
% 参考线作图
fts_ref = fints(datenum(data_string), ones(numel(data_string), 1) * ref);
h4 = plot(fts_ref, 'r');

legend([h1, h3, h2, h4], 'Hurst指数','Hurst MA指数','E(H)','参考线', 2);

% %判定显性区间进行标记，显性日期计数（最小值）
% Hurst_matrix = [datenum(date_string) Local_h];
% result = find(Hurst_matrix(:,2)<Eh(1));
% Invl_start = 1;
% for i = 1 : numel(result) - 1  
%     if result(i) + 1 ~= result(i + 1) || i + 1 == numel(result)
%         Invl_end = i;
%         [~, col] = min(Hurst_matrix(result(Invl_start) : result(Invl_end), 2));
%         text(Hurst_matrix(result(Invl_start) + col - 1, 1),Hurst_matrix(result(Invl_start) ...
%             + col - 1, 2),datestr(Hurst_matrix(result(Invl_start) + col - 1, 1)),'color', 'm','FontSize',8);
%         Invl_start = i + 1;
%     end
% end    

% 标记标语E(H)的日期
count = Hurst_tag(data_string, local_hurst_vec, e_hurst_vec(1), 'm', date_end);
set(handles.edit9, 'String', count);

% 标记小于参考值的日期
count_2 = Hurst_tag(data_string, local_hurst_vec, ref, 'r', date_end);
set(handles.edit12, 'String', count_2);

hold off;

axes(handles.axes2);
cla;

% 对分析的K线作图
fts_price = fints( w_times( numel(w_times)-move_forward + 1: numel(w_times), : ),...
    data_all( numel(w_times)-move_forward + 1: numel(w_times), : ), {'Open', 'High', 'Low', 'Close'},1);
fts_price.desc = '日K线价格';
h3 = candle(fts_price, 'r');
legend(h3, wind_code, 2);


%********************************作图合并*********************************%
% try
%     hf1 = figure;
% 
%     % 对分析的K线作图
%     fts_price = fints( w_times( numel(w_times)-move_forward + 1: numel(w_times), : ),...
%         data_all( numel(w_times)-move_forward + 1: numel(w_times), : ), {'Open', 'High', 'Low', 'Close'},1);
%     fts_price.desc = '日K线价格';
%     candle(fts_price,'r');
%     datetick('x','dd-mmm-yyyy');
%     hc=get(gca, 'children');
% 
%     axes(handles.axes2);
%     
% 
%     %******************************辅助线作图*********************************%
%     % % E(H) 指数作图
%     % fts_eh_m = fints(datenum(data_string), e_hurst_vec);
%     % plot(fts_eh_m, 'm');
%     % hold on;
%     % 
%     % % Hurst MA指数作图
%     % fts_hurst_MA = fints(datenum(data_string(period : numel(data_string))), hurst_MA);
%     % h3 = plot(fts_hurst_MA, 'g');
%     % 
%     % % 参考线作图
%     % fts_ref = fints(datenum(data_string), ones(numel(data_string), 1) * ref);
%     % h4 = plot(fts_ref, 'r');
% 
% 
%     % axes(handles.axes2);
%     [AX, H1, H2] = plotyy(datenum(data_string), local_hurst_vec,datenum(data_string),...
%         data_all( numel(w_times)-move_forward + 1: numel(w_times), 4 ) );
%     delete(H2);
%     set(hc, 'parent', AX(2));
%     datetick('x','dd-mmm-yyyy');
%     close(hf1);
% 
%     % hold on;
%     % % E(H) 指数作图
%     % fts_eh_m = fints(datenum(data_string), e_hurst_vec);
%     % h2 = plot(fts_eh_m, 'm');
%     % 
%     % % Hurst MA指数作图
%     % fts_hurst_MA = fints(datenum(data_string(period : numel(data_string))), hurst_MA);
%     % h3 = plot(fts_hurst_MA, 'g');
%     % 
%     % % 参考线作图
%     % fts_ref = fints(datenum(data_string), ones(numel(data_string), 1) * ref);
%     % h4 = plot(fts_ref, 'r');
% 
%     hold off;
% catch
%     errordlg('作图出错','MATLAB ERROR');
% end

close(msg);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbutton2.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 打开wind数据接口
try
    w=windmatlab;
catch
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end

% 提取参数
[wind_code,date_end,~,move_avg,ref,period] = get_params_from_GUI(eventdata, handles);

msg = msgbox('拟合运算中','消息提示');

time_wnd = 100;
try
    % 初试日期提取数据所需
    [date_start,~,~,~,~,~]=w.tdaysoffset(- (2*time_wnd + move_avg + 1), date_end);
    % 从wind获取标的收盘价数据
    [data_close,~,~,~,~,~]=w.wsd(wind_code,'close',date_start,date_end,'PriceAdj=F','Fill=Previous');
catch
    errordlg('无法获取wind数据','MATLAB ERROR');
    close(msg);
end


[local_hurst,~ ,v_n, log_n, log_rs, e_rs ] = Hurst_local(data_close, time_wnd, move_avg);
figure
%subplot(2,1,1);
%plot(time_window,local_hurst, '.-b');
%title('不同窗口长度的Husrt指数');
%subplot(2,1,2);
% plot(log_n,v_n, log_n,log_rs, log_n,log10(e_rs), log_n,0.5*log_n);
plot(log_n,v_n, log_n,log_rs, log_n,log10(e_rs), log_n,0.5*log_n);
title('log(n) - log(R/S) -Vn 图 300天测试图');
legend('V - 统计量','log(R/S)','E(R/S)','H=0.5参考线',2);
xlabel('log(n)');
close(msg);


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
formatOut = 'yyyy-mm-dd';
set(hObject,'String',datestr(datenum(date)-1,formatOut));
guidata(hObject, handles);


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



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 打开wind数据接口
try
    w=windmatlab;
catch
    errordlg('找不到windmatlab插件','MATLAB ERROR');
end

[wind_code,date_end,time_wnd,move_avg,~,~] = get_params_from_GUI(eventdata, handles);

msg = msgbox('拟合运算中','消息提示');

try
    % 初试日期提取数据所需
    [date_start,~,~,~,~,~]=w.tdaysoffset(- (2*time_wnd + move_avg + 1), date_end);
    % 从wind获取标的收盘价数据
    [data_close,~,~,~,~,~]=w.wsd(wind_code,'close',date_start,date_end,'PriceAdj=F','Fill=Previous');
catch
    errordlg('无法获取wind数据','MATLAB ERROR');
    close(msg);
end

step_min = 10;
% [local_hurst,~ ,v_n, log_n, log_rs, e_rs ] = Hurst_local(data_close, time_wnd, move_avg);

local_hurst_vec = zeros(time_wnd - step_min, 1);

for n = step_min : time_wnd
    [local_hurst_vec(n - step_min + 1),~,~,~,~] = Hurst_local(data_close, n, move_avg);
end

figure;
plot(step_min : time_wnd, local_hurst_vec);
legend('Hurst指数');
xlabel('回测长度');

close(msg);
