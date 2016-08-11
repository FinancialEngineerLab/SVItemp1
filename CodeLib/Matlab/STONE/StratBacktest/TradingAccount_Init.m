
%***********************************************************%
% INPUT:
% DB = price data series
%***********************************************************%
% OUTPUT: 
% Asset = initialized trading account asset 
%***********************************************************%
function Asset = TradingAccount_Init(DB)
NT = length(DB.Close);

Asset.Size = NT;
% 当前持仓量
Asset.CurrentPosition = 0;
% 成交量
Asset.Volume = zeros(NT,1);
% 成交价
Asset.Price = zeros(NT,1);
% 持仓量
Asset.Position = zeros(NT,1);
% 资产
Asset.Cash = zeros(NT,1);
% 初始资产为1.0
Asset.Cash(1) = 1.0;
% 对应时间
Asset.Time = zeros(NT,1);
% 交易账户
Asset.TradingAccount= zeros(NT,1);
% 交易信号
Asset.Signal = zeros(NT,1);
% 成交日收盘价
Asset.ClosePrice = zeros(NT,1);

end

