
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
    % ����K������
    DB = Data_FromWind(sec_code,start_time,end_time,interval, Params);    
    % ��ʼ���ʲ���
    Asset = TradingAccount_Init(DB);
    
    % ��K��ѭ��
    for K = 1:DB.NbTradeDay
        DB.CurrentIndex = K; %��ǰK��
        [Signal,DB] = StrategyFunc(DB,Asset,Params); %���в��Ժ��������ɽ����ź�
        if( strcmp(Signal.Action,'BUY') == 1) 
            if (Params.Execution.ResetTransactionPrice == 1)
                Asset = TradingAccount_Buy(DB,Asset,1,DB.buyprice(K),NaN,Params); % ��ָ������
            else
                Asset = TradingAccount_Buy(DB,Asset,1,NaN,'CLOSE',Params);  % �����̼���
            end
        elseif( strcmp(Signal.Action,'SELL') == 1 )
            if( Params.Execution.ResetTransactionPrice == 1)
                Asset = TradingAccount_Sell(DB,Asset,1,DB.sellprice(K),NaN,Params);  % ��ָ������
            else
                Asset = TradingAccount_Sell(DB,Asset,1,NaN,'CLOSE',Params);  % �����̼���
            end
        else  % û���ź�ʱ
            Asset = TradingAccount_NoTransaction(DB,Asset);
        end
        
        % ÿ��K�������н���ʱ��Ҫ����
        Asset = TradingAccount_Clearing(DB,Asset,Params);
        
        Asset.Test = Asset.Position.*DB.Close + Asset.Cash; 
    end
    
    Asset = TradingAccount_Evolution(DB,Asset);
    TradingAccount_Plot(DB,Asset, interval);
    if Params.Execution.ExportReport == 1
        TradingAccount_Report(Asset,Params);
    end
    
end



