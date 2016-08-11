% Relative_Strength_Index Strategy 
%if RSI<30: signal for buy
%if RSI>70: signal for sell
function [Profit,AccumulatedProfit,NumTransaction]=Relative_Strength_Index(Period,InitialBank,Commission,Equity)

% matlab functtion: rsindex  %14 periods
Price=Equity; 
DiffPrice=diff(Price);
DiffPrice=DiffPrice(:,1); %closing price
T=size(DiffPrice,1);

RSI=zeros(T-Period+1,1);
NumUp=0;
NumDown=0;
LevelUp=0;
LevelDown=0;

Profit=zeros(T-Period+1,1);
AccumulatedProfit=zeros(T-Period+1,1);

NumTransaction=0;                         
HoldorSold=0;

for i=1:T-Period+1
    for j=1:Period
        if DiffPrice(i+j-1)>0
            NumUp=NumUp+1;
            LevelUp=LevelUp+DiffPrice(i+j-1);
        else
            NumDown=NumDown+1;
            LevelDown=LevelDown+DiffPrice(i+j-1);  
        end
    end
    RSI(i)=(LevelUp/NumUp)/(LevelUp/NumUp+LevelDown/NumDown)*100;
    %RSI(i)= LevelUp/(LevelUp+LevelDown)*100;
end

for i=1:T-Period+1
    if i~=1
        Profit(i)=Profit(i-1);
        AccumulatedProfit(i)=AccumulatedProfit(i-1);
    end
    
     if RSI(i)<30 && HoldorSold==0
        EntryPrice=Price(i+Period,4)+Commission;  %4:open price
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =1;
        NumTransaction=NumTransaction+1;
     end
    
    if RSI(i)>70 && HoldorSold==0
        EntryPrice=Price(i+Period,4)-Commission; 
        if i==1
            NumStock=floor(InitialBank/EntryPrice);
        else
            NumStock=floor((InitialBank+AccumulatedProfit(i-1))/EntryPrice);
        end
        HoldorSold =-1;
        NumTransaction=NumTransaction+1;
    end
    
    if HoldorSold==1 && RSI(i)>70
        Profit(i)=(Price(i+Period,4)-Commission-EntryPrice)*NumStock; 
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold =0;
    end
    
    if HoldorSold==-1 && RSI(i)<30
        Profit(i)=(EntryPrice-Price(i+Period,4)-Commission)*NumStock; 
        AccumulatedProfit(i)=AccumulatedProfit(i-1)+Profit(i);
        HoldorSold=0;
    end
    
    subplot(2,1,1);
    plot(Profit);
    subplot(2,1,2);
    plot(AccumulatedProfit);
    
end

        
            
            
