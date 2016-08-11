
%***********************************************************%
% INPUT:
% StrategyFunc = strategy function 
% sec_code = security code
% start_time/end_time = '2013-10-08'
% interval = 'day' or 'min'
%***********************************************************%
% OUTPUT: 
% Asset = initialized trading account asset 
%***********************************************************%




function Main_Backtest(StrategyFunc,sec_code,start_time,end_time,interval,Params)
    % 加载K线数据
    DB = Data_FromWind(sec_code,start_time,end_time,interval, Params);    
    % 初始化资产池
    Asset = TradingAccount_Init(DB);
    
    % 按K线循环
    for K = 1:DB.NbTradeDay
        DB.CurrentIndex = K; %当前K线
        [Signal,DB] = StrategyFunc(DB,Asset,Params); %运行策略函数，生成交易信号
        if( strcmp(Signal.Action,'BUY') == 1) 
            if (Params.Execution.ResetTransactionPrice == 1)
                Asset = TradingAccount_Buy(DB,Asset,1,DB.buyprice(K),NaN,Params); % 按指定价买
            else
                Asset = TradingAccount_Buy(DB,Asset,1,NaN,'CLOSE',Params);  % 按收盘价买
            end
        elseif( strcmp(Signal.Action,'SELL') == 1 )
            if( Params.Execution.ResetTransactionPrice == 1)
                Asset = TradingAccount_Sell(DB,Asset,1,DB.sellprice(K),NaN,Params);  % 按指定价卖
            else
                Asset = TradingAccount_Sell(DB,Asset,1,NaN,'CLOSE',Params);  % 按收盘价买
            end
        else  % 没有信号时
            Asset = TradingAccount_NoTransaction(DB,Asset);
        end
        
        % 每条K线在运行结束时都要清算
        Asset = TradingAccount_Clearing(DB,Asset,Params);
        
        Asset.Test = Asset.Position.*DB.Close + Asset.Cash; 
    end
    
    Asset = TradingAccount_Evolution(DB,Asset);
    TradingAccount_Plot(DB,Asset, interval);
    if Params.Execution.ExportReport == 1
        TradingAccount_Report(Asset,Params);
    end
    
end



