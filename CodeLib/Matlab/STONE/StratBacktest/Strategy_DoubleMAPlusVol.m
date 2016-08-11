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

function Signal = Strategy_DoubleMAPlusVol(DB,Params)
Signal.Action = 'NULL';
MA_ST = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.ST);  %���� 20�վ���
MA_LT = Indicator_MovAvg(DB.Close,DB.CurrentIndex,Params.LT); %���� 60�վ���

if(MA_ST > MA_LT*(1+ Params.VolThresh)) %20�վ����ϴ�60�վ���*������ ��
    Signal.Action = 'BUY';
elseif (MA_ST < MA_LT) %20�վ����´�60�վ��� ��
    Signal.Action = 'SELL';
end

end
