%***********************************************************%
% INPUT:
% DB = price data series
% Asset = intial trading account asset
%***********************************************************%
% OUTPUT: 
% Asset = new trading account asset 
%***********************************************************%

function Asset = TradingAccount_NoTransaction(DB,Asset)
 
i = DB.CurrentIndex;

 if(i == 1)
      Asset.Signal(i) = 0;
 else
      Asset.Signal(i) = Asset.Signal(i-1);
 end

end