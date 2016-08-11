% 双均线波动率策略
%***********************************************************%
% INPUT:
% DB = price data series
% Params = 交易策略的参数
% Params.ST = short term period
% Params.LT = long term period
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%

function Signal = Strategy_DoubleMAPlusMovVol(DB,Asset,Params)
% disp(DB);
% disp(Asset);
Signal.Action = 'NULL';
MA_ST = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.ST);  %昨日 ST日均线
MA_LT = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.LT); %昨日 LT日均线
%Asset.Signal(DB.CurrentIndex-1)
if(DB.Close(DB.CurrentIndex) > MA_LT*(1+ Indicator_LogVol(DB.Close, DB.CurrentIndex, Params.VolPeriod)) ) %ST日均线上穿LT日均线*波动率 买
    Signal.Action = 'BUY';
elseif (DB.Close(DB.CurrentIndex) < MA_ST) % 卖
    Signal.Action = 'SELL';
end
%  disp(Signal.Action);
end
