% 最简单的双均线策略
%***********************************************************%
% INPUT:
% DB = price data series
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%

function Signal = Strategy_DoubleMA(DB)
Signal.Action = 'NULL';
MA5 = Indicator_MovAvg(DB.Close,DB.CurrentIndex,5);  %昨日 5日均线
MA20 = Indicator_MovAvg(DB.Close,DB.CurrentIndex,20); %昨日 20日均线
if(MA5 > MA20) %5日均线上穿20日均线 买
    Signal.Action = 'BUY';
elseif (MA5 < MA20) %5日均线下穿20日均线 卖
    Signal.Action = 'SELL';
end

end
