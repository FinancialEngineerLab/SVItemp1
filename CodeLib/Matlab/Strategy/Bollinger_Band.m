% N1:moving average time period
% N2:number of sigma added on(subtracted from) mean to form bollinger bands
function [Profit,AccumulatedProfit,NumTransaction]=Bollinger_Band(N1,N2,InitialBank,Commission,StartPoint,EndPoint,Equity)

Dataset=Equity;  %ÊÕ¸ßµÍ¿ª
Length=size(Dataset,1);
if EndPoint>Length
    EndPoint=Length;
end
Price=Dataset(StartPoint:EndPoint,:);
T=size(Price,1);
MovingAverage=zeros(T-N1+1,1);
Sigma=zeros(T-N1+1,1);
 
Profit=zeros(T-N1,1);
AccumulatedProfit=zeros(T-N1,1);

NumTransaction=0;                                 %record number of transactions
HoldorSold=0;

for i=1:T-N1+1
    MovingAverage(i)=mean(Price(i:i+N1-1,1)); %1:close price
    Sigma(i)=std(Price(i:i+N1-1,1),0);
end

UpperBound=MovingAverage+N2*Sigma;
LowerBound=MovingAverage-N2*Sigma;

for i=1:T-N1
    if i~=1
        AccumulatedProfit(i)=AccumulatedProfit(i-1);
    end
     if Price(i+N1-1,1)>UpperBound(i) && HoldorSold==0
        EntryPrice=Price(i+N1,4)+Commission;  %4:open price
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =1;
        NumTransaction=NumTransaction+1;
    end
    if Price(i+N1-1,1)<LowerBound(i) && HoldorSold==0
        EntryPrice=Price(i+N1,4)-Commission; 
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =-1;
        NumTransaction=NumTransaction+1;
    end
    if HoldorSold==1 && Price(i+N1-1,1)<MovingAverage(i)
        %Profit(k)=Price(i+N1,4)-Commission-EntryPrice; 
        Profit(i)=(Price(i+N1,4)-Commission-EntryPrice)*NumStock; 
        %AccumulatedProfit(k)=sum(Profit(1:k));
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold =0;
    end
    if HoldorSold==-1 && Price(i+N1-1,1)>MovingAverage(i)
        %Profit(k)=EntryPrice-Price(i+N1,4)-Commission; 
        Profit(i)=(EntryPrice-Price(i+N1,4)-Commission)*NumStock; 
        %AccumulatedProfit(k)=sum(Profit(1:k));
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold=0;
    end
    
    subplot(2,1,1);
    plot(Profit);
    subplot(2,1,2);
    plot(AccumulatedProfit);
    
end

        
        
    
