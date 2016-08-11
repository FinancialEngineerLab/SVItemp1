%technical index

% %{1��MA���ƶ�ƽ����
% 2��MACD��ָ��ƽ����ͬ�ƶ�ƽ���ߣ�
% MACD �ļ��㣺
% ��1��������ڣ�S�գ�ָ���ƶ�ƽ���ߺͳ��ڣ�L�գ�ָ���ƶ�ƽ����EMA1��EMA2��
% ��2���������ֵDIF=EMA1-EMA2��
% ��3������ DIF��N��ָ���ƶ�ƽ���ߣ���DEA��
% ��4������MACD=2*(DIF-DEA)��
% 3��DMA��ƽ���߲�ָ�꣩
% DMA�ļ��㣺
% ��1��������ڣ�S�գ��ƶ����ߺͳ��ڣ�L�գ��ƶ�����MA1��MA2��
% ��2������ƽ���߲�DMA=MA1-MA2��
% ��3������DMA��M���ƶ�ƽ���ߣ���AMA��
% 4��TRIX������ָ��ƽ���ƶ�ƽ��ָ�꣩
% TRIX�ļ��㣺
% ��1������N�յ�ָ���ƶ�ƽ����EMA��
% ��2��������EMA�ٽ�������N ��ָ���ƶ�ƽ����õ�TR��
% ��3������TRIX=(TR-����TR)/����TR*100��
% ��4������TRIX��M�ռ��ƶ�ƽ��MATRIX��%}

%% MA
Dataset=xlsread('zz500sh.xlsx');  %�ոߵͿ� ��֤500
S1=5;
L1=20;
[SMA,LMA]=movavg(Dataset(:,1),S1,L1,0);
SMA(1:S1-1) = NaN;
LMA(1:L1-1) = NaN;

scrsz = get(0,'ScreenSize');
figure('Position',[1 1 scrsz(3)*4/5 scrsz(4)]);

subplot(2,2,1);
O=Dataset(:,4);
H=Dataset(:,2);
L=Dataset(:,3);
C=Dataset(:,1);
candle(H,L,C,O);

hold on;
H1 = plot(SMA,'g','LineWidth',1.5);
H2 = plot(LMA,'r','LineWidth',1.5);
title('SMA(���ƶ�ƽ����)', 'FontWeight','Bold', 'FontSize', 15);
M = {'MA5';'MA20'};
legend([H1,H2],M);

%% MACD
S2=5;
L2=10;
[EMA1,EMA2]=movavg(Dataset(:,1),S2,L2,'e');
DIFF=EMA1-EMA2;
M2=10;
DEA=movavg(DIFF,M2,M2,'e');
MACD=2*(DIFF-DEA);

subplot(2,2,2);
MACD_p = MACD;
MACD_n = MACD;
MACD_p(MACD_p<0) = 0;
MACD_n(MACD_n>0) = 0;
bar(MACD_p,'r','EdgeColor','r');
hold on;
bar(MACD_n,'b','EdgeColor','b');
plot(DIFF,'k','LineWidth',1.5);
plot(DEA,'g','LineWidth',1.5); 

title('MACD(ָ��ƽ����ͬ�ƶ�ƽ����)', 'FontWeight','Bold', 'FontSize', 15);


%% DMA
DMA = SMA-LMA;
M3= 5;
AMA = movavg(DMA, M3, M3);
AMA(1:M3-1) = NaN;

subplot(2,2,3);

hold on;
plot(DMA,'k','LineWidth',1.5);
plot(AMA,'r','LineWidth',1.5);
title('DMA(ƽ���߲�ָ��)', 'FontWeight','Bold', 'FontSize', 15);
legend('DMA','AMA');



%% TRIX
N = 2;
ema = movavg(Dataset(:,1),N,N,'e');
M4 = 20;
TR = movavg( movavg(ema,N,N,'e'),N,N,'e');
TRIX = ( TR(2:end)-TR(1:end-1) )./TR(1:end-1)*100;
TRIX = [NaN; TRIX];
MATRIX = movavg(TRIX, M4, M4);

subplot(2,2,4);
hold on;
plot(TRIX,'k','LineWidth',1.5);
plot(MATRIX,'r','LineWidth',1.5);
title('TRIX(����ָ��ƽ���ƶ�ƽ��ָ��)', 'FontWeight','Bold', 'FontSize', 15);
legend('TRIX','MATRIX');




