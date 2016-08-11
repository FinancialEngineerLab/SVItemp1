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

function Signal = Strategy_DoubleMAPlusVol(DB,Params)
Signal.Action = 'NULL';
MA_ST = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.ST);  %昨日 20日均线
MA_LT = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.LT); %昨日 60日均线

if(MA_ST > MA_LT*(1+ Params.VolThresh)) %20日均线上穿60日均线*波动率 买
    Signal.Action = 'BUY';
elseif (MA_ST < MA_LT) %20日均线下穿60日均线 卖
    Signal.Action = 'SELL';
end

end
