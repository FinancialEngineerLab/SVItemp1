% Momentum: 
%if MA(ShortPeriod)>MA(LongPeriod): signal for buy
%if MA(ShortPeriod)<MA(LongPeriod): signal for sell

function [Profit,AccumulatedProfit,NumTransaction]=Momentum_Strategy(ShortPeriod,LongPeriod,InitialBank,Commission,StartPoint,EndPoint,Equity)

N1=ShortPeriod;
N2=LongPeriod;
Dataset=Equity;  %ÊÕ¸ßµÍ¿ª
Length=size(Dataset,1);
if EndPoint>Length
    EndPoint=Length;
end
Price=Dataset(StartPoint:EndPoint,:);
T=size(Price,1);
MovingAverageShort=zeros(T-N2+1,1);
MovingAverageLong=zeros(T-N2+1,1);

Profit=zeros(T-N2,1);
AccumulatedProfit=zeros(T-N2,1);

NumTransaction=0;                                 %record number of transactions
HoldorSold=0;

for i=N2:T
    MovingAverageShort(i-N2+1)=mean(Price(i-N1+1:i,1)); %1:close price
    MovingAverageLong(i-N2+1)=mean(Price(i-N2+1:i,1));
end

for i=1:T-N2
    if i~=1
        AccumulatedProfit(i)=AccumulatedProfit(i-1);
    end
    
     if MovingAverageShort(i)>MovingAverageLong(i) && HoldorSold==0
        EntryPrice=Price(i+N2,4)+Commission;  %4:open price
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =1;
        NumTransaction=NumTransaction+1;
     end
    
    if MovingAverageShort(i)<MovingAverageLong(i) && HoldorSold==0
        EntryPrice=Price(i+N2,4)-Commission; 
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =-1;
        NumTransaction=NumTransaction+1;
    end
    
    if HoldorSold==1 && MovingAverageShort(i)<MovingAverageLong(i) 
        Profit(i)=(Price(i+N2,4)-Commission-EntryPrice)*NumStock; 
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold =0;
    end
    
    if HoldorSold==-1 && MovingAverageShort(i)>MovingAverageLong(i) 
        Profit(i)=(EntryPrice-Price(i+N2,4)-Commission)*NumStock; 
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold=0;
    end
    
    subplot(2,1,1);
    plot(Profit);
    subplot(2,1,2);
    plot(AccumulatedProfit);
    
end




