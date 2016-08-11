
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
%以下部分为策略评价和报告输出
Report.Path = strcat(Utility_GetFolderPath(),'Report.xls');
xlswrite(Report.Path,{'策略回测报告'},'Sheet1','A1');

%起止时间
xlswrite(Report.Path,{'测试起始时间'},'Sheet1','A3');
xlswrite(Report.Path,{datestr(Asset.Times(1))},'Sheet1','B3');
xlswrite(Report.Path,{'测试截止时间'},'Sheet1','A4');
xlswrite(Report.Path,{datestr(Asset.Times(end))},'Sheet1','B4');

%起止资金
xlswrite(Report.Path,{'初始资金'},'Sheet1','A6');
xlswrite(Report.Path,{num2str(Asset.TradingAccount(1))},'Sheet1','B6');
xlswrite(Report.Path,{'期末资金'},'Sheet1','A7');
xlswrite(Report.Path,{num2str(Asset.TradingAccount(end))},'Sheet1','B7');

%交易次数与胜率,总收益
xlswrite(Report.Path,{'交易次数'},'Sheet1','A8');
xlswrite(Report.Path,{num2str(Report.NbTrade)},'Sheet1','B8');
xlswrite(Report.Path,{'交易胜率'},'Sheet1','A9');
xlswrite(Report.Path,{num2str(Report.WinRatio)},'Sheet1','B9');
xlswrite(Report.Path,{'总收益'},'Sheet1','A10');
xlswrite(Report.Path,{num2str(Report.TotalReturn)},'Sheet1','B10');

%交易时间、交易收益,头寸
system('tskill excel');
xlswrite(Report.Path,{'交易序列'},'Sheet1','A12');
xlswrite(Report.Path,Report.TradeIndex,'Sheet1','A13:A1000');
xlswrite(Report.Path,{'交易时间'},'Sheet1','B12');

Report.TradeTimeStr = cell(Report.Length,1);
for i = 1 : Report.Length
    Report.TradeTimeStr{i} = datestr(Report.TradeTime(i));
end


xlswrite(Report.Path,Report.TradeTimeStr,'Sheet1','B13');


%for i = 1 : size(Report.TradeTime)
%    pos = strcat('B',num2str(12+i));
%    xlswrite(Report.Path,{datestr(Report.TradeTime(i))},'Sheet1',pos);
%end

xlswrite(Report.Path,{'交易量'},'Sheet1','C12');
xlswrite(Report.Path,Report.Volume,'Sheet1','C13:C1000');

xlswrite(Report.Path,{'交易价格'},'Sheet1','D12');
xlswrite(Report.Path,Report.TradePrice,'Sheet1','D13:D1000');

xlswrite(Report.Path,{'交易收益'},'Sheet1','E12');
xlswrite(Report.Path,Report.TradePnL,'Sheet1','E13:E1000');

xlswrite(Report.Path,{'收盘价'},'Sheet1','F12');
xlswrite(Report.Path,Report.ClosePrice,'Sheet1','F13:F1000');

xlswrite(Report.Path,{'累计净值'},'Sheet1','G12');
xlswrite(Report.Path,Report.TradingAccount,'Sheet1','G13:G1000');


%最大回撤
xlswrite(Report.Path,{'最大回撤'},'Sheet1','D6');
xlswrite(Report.Path,{num2str(Report.MaxPercent)},'Sheet1','E6');
xlswrite(Report.Path,{'最大回撤时间'},'Sheet1','D7');
xlswrite(Report.Path,Report.MaxPoint,'Sheet1','E7');

system('tskill excel');

end 

