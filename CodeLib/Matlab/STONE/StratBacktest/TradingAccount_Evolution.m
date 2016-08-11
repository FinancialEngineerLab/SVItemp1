
%***********************************************************%
% INPUT:
% DB: price data series
%***********************************************************%
% OUTPUT: 
% Asset: the evolution of the trading account
%***********************************************************%

function Asset = TradingAccount_Evolution(DB,Asset)
    Asset.TradingAccount = Asset.Position.*DB.Close + Asset.Cash; 
end