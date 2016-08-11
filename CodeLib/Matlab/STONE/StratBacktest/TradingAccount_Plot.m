
%***********************************************************%
% INPUT:
% Asset: complete information of trading account asset
%***********************************************************%
% OUTPUT: 
% no output but plot the evolution of the trading account
%***********************************************************%

function Asset = TradingAccount_Plot(DB,Asset, interval)

benchmark = Utility_NormalizePriceVector(DB.Close);

%[AX,H1,H2]=plotyy(Asset.Times,Asset.TradingAccount,Asset.Times,benchmark,'plot');
plot(Asset.Times,Asset.TradingAccount,'r');
if strcmp(interval,'day')
    datetick('x','yyyy/mm/dd','keepticks');
elseif strcmp(interval,'min')
    datetick('x','mm/dd HH:MM','keepticks');
else
     errordlg('TradingAccount_Plot: interval must be either day or min','MATLAB ERROR');
end

hold on 
plot(Asset.Times,benchmark);

hold off

%set(AX(2),'xtick',[]);
%set(AX(2),'ytick',[]);
%xlim(AX(1),[Asset.Times(1),Asset.Times(DB.Size)]);
%xlim(AX(2),[Asset.Times(1),Asset.Times(DB.Size)]);
%ylim(AX(1),[min(min(Asset.TradingAccount), min(benchmark))*0.95,max(max(Asset.TradingAccount), max(benchmark))*1.05]);
%ylim(AX(2),[min(min(Asset.TradingAccount), min(benchmark))*0.95,max(max(Asset.TradingAccount), max(benchmark))*1.05]);



% 将x轴45度斜向放置
xtb = get(gca,'XTickLabel');% 获取横坐标轴标签句柄
xt = get(gca,'XTick');% 获取横坐标轴刻度句柄
yt = get(gca,'YTick'); % 获取纵坐标轴刻度句柄          
xlim([Asset.Times(1),Asset.Times(DB.Size)]);
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% 将原有的标签隐去


legend('策略净值','标的净值',2);

title('策略 vs 标的 净值变化');
