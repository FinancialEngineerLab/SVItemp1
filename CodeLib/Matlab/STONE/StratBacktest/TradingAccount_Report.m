
%***********************************************************%
% INPUT:
% DB: price data series
% Asset: complete information of trading account asset
%***********************************************************%
% OUTPUT: 
% no output but plot the evolution of the trading account
%***********************************************************%

function [] = TradingAccount_Report(Asset,Params,DB)

Report = Utility_StrategyStat(Asset,Params);
%���²���Ϊ�������ۺͱ������
Report.Path = strcat(Utility_GetFolderPath(),'Report.xls');
xlswrite(Report.Path,{'���Իزⱨ��'},'Sheet1','A1');

%��ֹʱ��
xlswrite(Report.Path,{'������ʼʱ��'},'Sheet1','A3');
xlswrite(Report.Path,{datestr(Asset.Times(1))},'Sheet1','B3');
xlswrite(Report.Path,{'���Խ�ֹʱ��'},'Sheet1','A4');
xlswrite(Report.Path,{datestr(Asset.Times(end))},'Sheet1','B4');

%��ֹ�ʽ�
xlswrite(Report.Path,{'��ʼ�ʽ�'},'Sheet1','A6');
xlswrite(Report.Path,{num2str(Asset.TradingAccount(1))},'Sheet1','B6');
xlswrite(Report.Path,{'��ĩ�ʽ�'},'Sheet1','A7');
xlswrite(Report.Path,{num2str(Asset.TradingAccount(end))},'Sheet1','B7');

%���״�����ʤ��,������
xlswrite(Report.Path,{'���״���'},'Sheet1','A8');
xlswrite(Report.Path,{num2str(Report.NbTrade)},'Sheet1','B8');
xlswrite(Report.Path,{'����ʤ��'},'Sheet1','A9');
xlswrite(Report.Path,{num2str(Report.WinRatio)},'Sheet1','B9');
xlswrite(Report.Path,{'������'},'Sheet1','A10');
xlswrite(Report.Path,{num2str(Report.TotalReturn)},'Sheet1','B10');

%����ʱ�䡢��������,ͷ��
system('tskill excel');
xlswrite(Report.Path,{'��������'},'Sheet1','A12');
xlswrite(Report.Path,Report.TradeIndex,'Sheet1','A13:A1000');
xlswrite(Report.Path,{'����ʱ��'},'Sheet1','B12');

Report.TradeTimeStr = cell(Report.Length,1);
for i = 1 : Report.Length
    Report.TradeTimeStr{i} = datestr(Report.TradeTime(i));
end


xlswrite(Report.Path,Report.TradeTimeStr,'Sheet1','B13');


%for i = 1 : size(Report.TradeTime)
%    pos = strcat('B',num2str(12+i));
%    xlswrite(Report.Path,{datestr(Report.TradeTime(i))},'Sheet1',pos);
%end

xlswrite(Report.Path,{'������'},'Sheet1','C12');
xlswrite(Report.Path,Report.Volume,'Sheet1','C13:C1000');

xlswrite(Report.Path,{'���׼۸�'},'Sheet1','D12');
xlswrite(Report.Path,Report.TradePrice,'Sheet1','D13:D1000');

xlswrite(Report.Path,{'��������'},'Sheet1','E12');
xlswrite(Report.Path,Report.TradePnL,'Sheet1','E13:E1000');

xlswrite(Report.Path,{'���̼�'},'Sheet1','F12');
xlswrite(Report.Path,Report.ClosePrice,'Sheet1','F13:F1000');

xlswrite(Report.Path,{'�ۼƾ�ֵ'},'Sheet1','G12');
xlswrite(Report.Path,Report.TradingAccount,'Sheet1','G13:G1000');


%���س�
xlswrite(Report.Path,{'���س�'},'Sheet1','D6');
xlswrite(Report.Path,{num2str(Report.MaxPercent)},'Sheet1','E6');
xlswrite(Report.Path,{'���س�ʱ��'},'Sheet1','D7');
xlswrite(Report.Path,Report.MaxPoint,'Sheet1','E7');

system('tskill excel');

end 

