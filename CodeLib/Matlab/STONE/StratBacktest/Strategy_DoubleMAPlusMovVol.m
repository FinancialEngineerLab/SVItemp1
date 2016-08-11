% ˫���߲����ʲ���
%***********************************************************%
% INPUT:
% DB = price data series
% Params = ���ײ��ԵĲ���
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
MA_ST = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.ST);  %���� ST�վ���
MA_LT = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.LT); %���� LT�վ���
%Asset.Signal(DB.CurrentIndex-1)
if(DB.Close(DB.CurrentIndex) > MA_LT*(1+ Indicator_LogVol(DB.Close, DB.CurrentIndex, Params.VolPeriod)) ) %ST�վ����ϴ�LT�վ���*������ ��
    Signal.Action = 'BUY';
elseif (DB.Close(DB.CurrentIndex) < MA_ST) % ��
    Signal.Action = 'SELL';
end
%  disp(Signal.Action);
end
