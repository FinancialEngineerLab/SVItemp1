 
Equity=xlsread('zz500sh.xlsx');  %�ոߵͿ�
N1=20;
N2=2;
InitialBank=10000;
Commission=0.003;
StartPoint=1;
EndPoint=2520;
ShortPeriod=5;
LongPeriod=20;
Period=20;

[DrawDownPercentBench,DrawDownAbsBench,MaxDrawDownPercentBench,MaxDrawDownAbsBench] = RetraceRatio(Equity(:,1));
SigmaBench=std(Equity(:,1))
GainsBB=Equity(end,1)-Equity(1,1)
MaxDrawDownPercentBench
MaxDrawDownAbsBench

[ProfitBB,AccumulatedProfitBB,NumTransactionBB]=Bollinger_Band(N1,N2,InitialBank,Commission,StartPoint,EndPoint,Equity);
 % 20���ƶ�ƽ����+_2��sigma�����½磻��ʼ�ʽ�10000��Ӷ��0.03����֤500��ʷ����
[DrawDownPercentBB,DrawDownAbsBB,MaxDrawDownPercentBB,MaxDrawDownAbsBB] = RetraceRatio(AccumulatedProfitBB);
SigmaBB=std(AccumulatedProfitBB)
GainsBB=AccumulatedProfitBB(end)
MaxDrawDownPercentBB
MaxDrawDownAbsBB

[ProfitMA,AccumulatedProfitMA,NumTransactionMA]=Momentum_Strategy(ShortPeriod,LongPeriod,InitialBank,Commission,StartPoint,EndPoint,Equity);
%��5��;��2��; ��>��:��; ��<��:��
[DrawDownPercentMA,DrawDownAbsMA,MaxDrawDownPercentMA,MaxDrawDownAbsMA] = RetraceRatio(AccumulatedProfitMA);
SigmaMA=std(AccumulatedProfitMA)
GainsMA=AccumulatedProfitMA(end)
MaxDrawDownPercentMA
MaxDrawDownAbsMA

[ProfitRSI,AccumulatedProfitRSI,NumTransactionRSI]=Relative_Strength_Index(Period,InitialBank,Commission,Equity);
%60��; RSI>30: signal for buy; RSI<70: signal for sell
[DrawDownPercentRSI,DrawDownAbsRSI,MaxDrawDownPercentRSI,MaxDrawDownAbsRSI] = RetraceRatio(AccumulatedProfitRSI);
SigmaRSI=std(AccumulatedProfitRSI)
GainsRSI=AccumulatedProfitRSI(end)
MaxDrawDownPercentRSI
MaxDrawDownAbsRSI