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

function Asset = TradingAccount_Sell(DB,Asset,volume,price,flag_tradeprice, Params)
%当前位置
i = DB.CurrentIndex;
flag_volume_determined_method = Params.Execution.UseCompoundVolume;
flag_allow_short = Params.Execution.AllowShort;

%成交价
if(strcmpi(flag_tradeprice,'CLOSE'))
    Asset.Price(i)  = DB.Close(i); %成交价 恒为正
else
    Asset.Price(i) = price;
end

%成交量， 买入为正
if flag_volume_determined_method ==1 
     if Asset.CurrentPosition>0 % 如果已经有持仓的话 就可以卖出
        if flag_allow_short == 0
            Asset.Volume(i) = -Asset.Position(i-1);  %不允许卖空 => 平多头
        else
            Asset.Volume(i) = -2*Asset.Position(i-1);    % 允许卖空 => 平多头 再开空头
        end
     else 
         if flag_allow_short == 1 && Asset.CurrentPosition>=0
             %如果允许做空但是没有持仓 =》做空；做空数量与可以做多的数量相同
             Asset.Volume(i) = ShortVolume(Asset.Cash, Asset.Price,i);        
         else
             Asset.Volume(i) = 0.0;%如果不允许做空而且没有持仓, 或者允许做空，但是已经持有空头 则没有成交
         end
     end
else
    Asset.Volume(i) = -volume; 
end;

Asset.Signal(i) = 0.0;
Asset.ClosePrice(i) = DB.Close(i);
end



function ret = ShortVolume(Cash, Price,i)
if i == 1 
    ret = -Cash(i)/Price(i);
else
    ret = -Cash(i-1)/Price(i);
end
end
