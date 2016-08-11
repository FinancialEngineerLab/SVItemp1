%Regime Switching Indicator
%If it’s bigger than its moving average, we consider that market is systemic and momentum strategy is
%implemented as trending is expected. Otherwise there is spread decorrelation, and range trading being
%expected to perform better, the Bollinger signals are used

%PeriodSigma：period used to caculate sigma in the regime switching indicator
%WindowSize: interval between which indicator is revised
%ShortPeriod: MA strategy
%LongPeriod: MA & bollinger band

function [Profit,AccumulatedProfit]=Regime_Switching_Indicator(PeriodSigma,WindowSize,ShortPeriod,LongPeriod,InitialBank,Commission)

Price=xlsread('test.xlsx');       %第一列指数,后面几列权重股走势 数据没挖到
T=size(Price,1);
NumIndex=size(Price,2)-1;
SigmaIndex=zeros(T-PeriodSigma+1,1);
Weight=ones(NumIndex,1)/NumIndex;  %equally weighted                        %%Regime Switching Indicator
SigmaSecurity=zeros(T-PeriodSigma+1,NumIndex);
RegimeSwitchingIndicator=zeros(T-PeriodSigma+1,1);       
MovingAverageIndicator=zeros(T-PeriodSigma-LongPeriod+2,1);
TotalProfit=0;
EndProfit=0;

for i=1:T-PeriodSigma+1
    SigmaIndex(i)=std(Price(i:i+PeriodSigma-1,1),1);
    for j=1:NumIndex
        SigmaSecurity(i,j)=std(Price(i:i+PeriodSigma-1,j+1),1);
    end
    RegimeSwitchingIndicator(i)=SigmaIndex(i)^2/(SigmaSecurity(i,:)*Weight)^2;
end

for k=1:T-PeriodSigma-LongPeriod+2
    MovingAverageIndicator(k)=mean(RegimeSwitchingIndicator(k:k+LongPeriod-1));
end
 
for l=1:WindowSize:T-PeriodSigma-LongPeriod+2
    if RegimeSwitchingIndicator(l+LongPeriod-1)>MovingAverageIndicator(l) %strong trend--Momentum
        Profit=Momentum_Stratagy(ShortPeriod,LongPeriod,InitialBank+EndProfit,Commission,l,l+WindowSize);      %开盘，收盘价要改
    else                %range trading-Bollinger Band
        Profit=Bollinger_Band(LongPeriod,2,InitialBank+EndProfit,Commission,l,l+WindowSize);
    end
   
    TotalProfit=combine(TotalProfit,Profit);
    EndProfit=sum(TotalProfit);
    AccumulatedProfit=cumsum(TotalProfit);
end

subplot(2,1,1);
plot(TotalProfit);
subplot(2,1,2);
plot(AccumulatedProfit);

end




        
    
    


