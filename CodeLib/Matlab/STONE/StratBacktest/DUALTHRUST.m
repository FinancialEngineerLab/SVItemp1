% dualthrust2隔夜
%***********************************************************%
% INPUT:
% DB = price data series
% Params = 交易策略的参数
% Params.stockid ="399905.SZ";
% Params.ns = 3;     %上轨天数
% Params.nx = 2;     %下轨天数
% Params.ks = 0.2;   %上轨系数
% Params.kx = 0.4;   %下轨系数
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%


clc
clear
w=windmatlab
% 豆粕（M1309.DCE）作为标的。
strStockList='399905.SZ';
%[w_wsd_data]=w.wsd(strStockList,'open,high,low,close','2015-04-11','2015-10-27');
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000905.SH','open,high,low,close','2015-04-27','2015-10-27','Fill=Previous');
% 开高低收
DB.Open = w_wsd_data(:,1);
DB.High = w_wsd_data(:,2);
DB.Low  = w_wsd_data(:,3);
DB.Close= w_wsd_data(:,4);
DB.Times = w_wsd_times;
DB.Size = length(DB.Open);
%%新加的几列
DB.Shanggui = zeros(DB.Size,1);
DB.Xiagui   = zeros(DB.Size,1);


%% 读取4月12日的分钟价格
NK = DB.Size;
    for k = 5:NK
        DB.CurrentIndex = k; %当前K线
        date = DB.Times(k);  % 日期
     
        %%
        %%上轨的计算
        nhs = DB.High(k-3:k-1);   %%参数ns
        ncs = DB.Close(k-3:k-1);
        nls = DB.Low(k-3:k-1);
        nhh = max(nhs);
        nhc = max(ncs);
        nlc = min(ncs);
        nll = min(nls);
        ranges = max(nhh-nlc,nhc-nll);
        shanggui = DB.Open(k)+0.2*ranges;  %%参数ks
        DB.Shanggui(k) = shanggui;
        %%
        %%下轨的计算
        nhx = DB.High(k-2:k-1);   %%参数ns
        ncx = DB.Close(k-2:k-1);
        nlx = DB.Low(k-2:k-1);
        nhh = max(nhx);
        nhc = max(ncx);
        nlc = min(ncx);
        nll = min(nlx);
        rangex = max(nhh-nlc,nhc-nll);
        xiagui = DB.Open(k)-0.4*rangex;  %%参数ks
        DB.Xiagui(k) = xiagui;
        
        date;
        begt1 = date+0.2;
        endt1 = date+0.7;
       [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid]=w.wsi('399905.SZ','open,high,low,close',begt1,endt1,'barsize','1');
       

        
    end
    
 





