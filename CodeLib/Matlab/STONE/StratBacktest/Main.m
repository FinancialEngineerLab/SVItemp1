clear all;
close all;


Params.Execution.ResetTransactionPrice = 1;
Params.Execution.AllowShort = 1;
Params.Execution.UseCompoundVolume = 1;
Params.Execution.ExportReport = 0;

StratName = 'DualThrust';
switch StratName
    case 'DualThrust'
        Params.Strat.id = '399905.SZ';
        Params.Strat.ns = 3;
        
        Params.Strat.nx = 2;
        Params.Strat.ks = 0.2;
        Params.Strat.kx = 0.4;
        Params.Strat.Name = 'DualThrust';
        Main_Backtest(@Strategy_Dualthrust2,Params.Strat.id,'2016-02-01','2016-02-15','day',Params);
    case 'Hurst'
        Params.Strat.Name = 'Hurst';
        Params.Strat.PrevNDayHurst = 5;
        Params.Strat.MAWindow = 1;
        Params.Strat.TimeWindow = 30;
        Main_Backtest(@Strategy_Hurst,'399905.SZ','2010-03-23','2016-01-05','day',Params);
end



