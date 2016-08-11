% ��򵥵�˫���߲���
%***********************************************************%
% INPUT:
% DB = price data series
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%

function Signal = Strategy_DoubleMA(DB)
Signal.Action = 'NULL';
MA5 = Indicator_MovAvg(DB.Close,DB.CurrentIndex,5);  %���� 5�վ���
MA20 = Indicator_MovAvg(DB.Close,DB.CurrentIndex,20); %���� 20�վ���
if(MA5 > MA20) %5�վ����ϴ�20�վ��� ��
    Signal.Action = 'BUY';
elseif (MA5 < MA20) %5�վ����´�20�վ��� ��
    Signal.Action = 'SELL';
end

end
