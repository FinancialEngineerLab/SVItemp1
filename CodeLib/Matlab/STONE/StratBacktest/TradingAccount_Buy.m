%***********************************************************%
% INPUT:
% DB = price data series
% Asset = intial trading account asset
% volume = trading volume
% price = trading price
% flag_tradeprice = trading at which type of price, use 'CLOSE' or the price in the params 
% flag_volume_determined_method = 0,1   
%       0: trade volume = volume input 1:trade volume = asset.cash/price
%***********************************************************%
% OUTPUT: 
% Asset = new trading account asset 
%***********************************************************%

function Asset = TradingAccount_Buy(DB,Asset,volume,price,flag_tradeprice,Params)
%当前K线位置
i = DB.CurrentIndex;
flag_volume_determined_method = Params.Execution.UseCompoundVolume;

%成交价
if(strcmpi(flag_tradeprice,'CLOSE'))
    Asset.Price(i)  = DB.Close(i); %成交价 恒为正
else
    Asset.Price(i) = price;
end

%成交量， 买入为正
if flag_volume_determined_method ==1 
    if Asset.CurrentPosition>0 % 如果已经有持仓的话 就继续持有 没有成交
        Asset.Volume(i) = 0;
    elseif Asset.CurrentPosition<0 % 之前有空头
        Asset.Volume(i) = -Asset.CurrentPosition + (Asset.Cash(i-1) + Asset.CurrentPosition * Asset.Price(i))/Asset.Price(i);  % 平掉空头 再做多头 - 在可卖空的情况下
    else
        Asset.Volume(i) = LongVolume(Asset.Cash, Asset.Price,i);%之前无空头, 做多
    end 
else
    Asset.Volume(i) = volume; 
end

Asset.Signal(i) = 1.0;
Asset.ClosePrice(i) = DB.Close(i);

end




function ret = LongVolume(Cash, Price,i)
if i == 1 
    ret = Cash(i)/Price(i);
else
    ret = Cash(i-1)/Price(i);
end
end