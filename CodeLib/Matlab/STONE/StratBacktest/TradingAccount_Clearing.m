%***********************************************************%
% INPUT:
% DB = price data series
% Asset = intial trading account asset
%***********************************************************%
% OUTPUT: 
% Asset = new trading account asset after clearing 
%***********************************************************%

function Asset = TradingAccount_Clearing(DB,Asset,Params)
%当前K线位置
i = DB.CurrentIndex;
iAllowShort = Params.Execution.AllowShort;

%更新当前持仓
if(i == 1)
    Asset.CurrentPosition = Asset.Volume(i); 
else
    Asset.CurrentPosition = Asset.Volume(i) + Asset.Position(i-1);  
end


% 初始现金为1.0
if iAllowShort == 0  %只做多
    if Asset.Volume(i)>0 %当前做多 
        Asset.Cash(i) = 0.0;  %有持仓是意味着现金全部用来购买了标的
    elseif Asset.Volume(i)<0 % 当前做空
        if i >1
            if Asset.Position(i-1) >0  % 该时点卖出持仓
                Asset.Cash(i) = Asset.Position(i-1)*Asset.Price(i); %此时标的全部变现
            else
                Asset.Cash(i) = Asset.Cash(i-1); %此种情况表示标的物还没交易，一直持有现金
            end
        else 
            errordlg('TradingAccount_Clearing: 不允许做空的情况下,第一时间点做空','MATLAB ERROR');
        end
    else
        if i>1
            Asset.Cash(i) =  Asset.Cash(i-1);
        end 
    end
else   %允许做空
    if Asset.Volume(i)>0    %当前做多  
        Asset.Cash(i) = 0.0;  %平空头，再做多，现金全部用来购买了标的
    elseif Asset.Volume(i)<0    %当前做空  
        if i == 1
            Asset.Cash(i) = Asset.Cash(i) -  Asset.CurrentPosition *Asset.Price(i);
        else
            if Asset.Position(i-1) > 0
                Asset.Cash(i) = 2*Asset.Position(i-1)*Asset.Price(i);%平掉多头,再做空
            elseif Asset.Position(i-1) == 0
                Asset.Cash(i) =Asset.Cash(i-1) - Asset.Volume(i)*Asset.Price(i);% 继续做空  
            end
        end
    else % 什么都不做
        if i >1
            Asset.Cash(i) = Asset.Cash(i-1);
        end
    end
end

Asset.Position(i) = Asset.CurrentPosition; 
Asset.Times(i) = DB.Times(i);
end