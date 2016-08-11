% Momentum: 
%if MA(ShortPeriod)>MA(LongPeriod): signal for buy
%if MA(ShortPeriod)<MA(LongPeriod): signal for sell

function [Profit,TotalReturn,CumulativeProfit,CumulativeReturn] = Momentum_Stratagy(ShortPeriod,LongPeriod)

Price=xlsread('zz500.xlsx');  %只取数字格式矩阵块
O=size(Price,1);
DiffPrice=diff(Price);
DiffPrice=DiffPrice(:,1);
Return=diff(Price)./Price(1:O-1,:);
%Return=diff(log(Price));
Return=Return(:,1);

T=size(Return,1);
Position = zeros(T-LongPeriod+1,1);

for i=1:T-LongPeriod+1
    MA_Long=mean(Price(i:i+LongPeriod-1,:),1);  %MA(Long period)
    MA_Long_Close=MA_Long(1);          %MA(1):close_price
    MA_Short=mean(Price(i+LongPeriod-ShortPeriod:i+LongPeriod-1,:),1);
    MA_Short_Close=MA_Short(1);
    if MA_Short_Close>MA_Long_Close
            Position(i)=1;              %1：buy/hold
                                        %position(1):LongPeriod+1 buy at open(assume=LongPeriod close)     
    else if(i>1 &&Position(i-1)~=0)
            Position(i)=-1;             %-1:sold(works only if the prior period is hold or sold)
        end
    end
end

Profit=Position'*DiffPrice(LongPeriod:T);
TotalReturn=Position'*Return(LongPeriod:T);
CumulativeProfit=cumsum(Position.*DiffPrice(LongPeriod:T));
CumulativeReturn=cumsum(Position.*Return(LongPeriod:T));

plot(CumulativeProfit,'r')
hold on
plot(Price(LongPeriod:T))

end
    
    


