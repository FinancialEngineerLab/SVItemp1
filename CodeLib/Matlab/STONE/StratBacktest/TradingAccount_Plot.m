
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



% ��x��45��б�����
xtb = get(gca,'XTickLabel');% ��ȡ���������ǩ���
xt = get(gca,'XTick');% ��ȡ��������̶Ⱦ��
yt = get(gca,'YTick'); % ��ȡ��������̶Ⱦ��          
xlim([Asset.Times(1),Asset.Times(DB.Size)]);
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% ��ԭ�еı�ǩ��ȥ


legend('���Ծ�ֵ','��ľ�ֵ',2);

title('���� vs ��� ��ֵ�仯');
