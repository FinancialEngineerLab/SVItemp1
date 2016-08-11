% dualthrust2隔夜
%***********************************************************%
% INPUT:
% DB = price data series
% Params = 交易策略的参数
% Params.ma = 对指数进行MA平滑处理的周期天数
% Params.time_window = 周期天数
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%

function [Signal,DB] = Strategy_Hurst(DB,Asset,Params)

Signal.Action = 'NULL';
ma_window = Params.Strat.MAWindow;
time_window = Params.Strat.TimeWindow;
stockid = Params.Strat.id;%'399905.SZ';
% 当前hurst指数
[local_hurst, e_hurst,~] = Indicator_Hurst(DB.Close(DB.CurrentIndex - (time_window * 2 + ma_window) : DB.CurrentIndex), time_window, ma_window );
% 存储之前若干天的hurst指数
DB.PrevNDayHurst = Prev_n_Day_Hurst(DB.PrevNDayHurst, local_hurst);

if(is_Downtrend(DB.Close(DB.CurrentIndex - (time_window * 2 + ma_window) : DB.CurrentIndex)) == 1 && is_All_Lower_Than_Expectation(DB.PrevNDayHurst,e_hurst) == 1)     % 下降趋势 逆转
    Signal.Action = 'BUY';
    DB.buyprice(DB.CurrentIndex) = DB.Close(DB.CurrentIndex);
elseif (is_Uptrend(DB.Close(DB.CurrentIndex - (time_window * 2 + ma_window) : DB.CurrentIndex)) == 1 && is_All_Lower_Than_Expectation(DB.PrevNDayHurst,e_hurst) == 1)    % 上升趋势 逆转
    Signal.Action = 'SELL';
    DB.sellprice(DB.CurrentIndex) = DB.Close(DB.CurrentIndex);
end

end



% 更新保存的前日以及今日hurst指数
function [ret] = Prev_n_Day_Hurst(Prev_n_Day_Hurst, CurrentHurst)
    Prev_n_Day_Hurst = Prev_n_Day_Hurst(2:numel(Prev_n_Day_Hurst));
    Prev_n_Day_Hurst = [Prev_n_Day_Hurst;CurrentHurst ];
    ret = Prev_n_Day_Hurst;
end

% 判断是否都低于e-hurst
function ret = is_All_Lower_Than_Expectation(Prev_n_Day_Hurst,e_hurst)
    ret = 1;
    for i = 1: length(Prev_n_Day_Hurst)
        if( Prev_n_Day_Hurst(i) > e_hurst)
            ret = 0;
        end
    end
end

% 判断指数是否处于上升趋势
function ret = is_Uptrend(ClosePrice)
    ret = 1;
    len = length(ClosePrice);
    if ClosePrice(1) > ClosePrice(len)
        ret = 0;
    end 
    if ClosePrice(1) > ClosePrice(round(len/2)) && ClosePrice(1) > ClosePrice(round(len*0.75))
        ret = 0; 
    end
    
end

% 判断指数是否处于下降趋势
function ret = is_Downtrend(ClosePrice)
    ret = 1;
    len = length(ClosePrice);
    if ClosePrice(1) < ClosePrice(len)
        ret = 0;
    end 
    if ClosePrice(1) < ClosePrice(round(len/2)) && ClosePrice(1) < ClosePrice(round(len*0.75))
        ret = 0;
    end
    
end



