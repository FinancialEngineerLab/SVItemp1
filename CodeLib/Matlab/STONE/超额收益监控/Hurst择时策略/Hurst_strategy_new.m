function [buy,sell,in1,time] = Hurst_strategy_new(d1,d2,index,period1,p)

w=windmatlab;
[w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid]=w.wsi(index,'close',d1,d2,'BarSize=15');
if exist('w_wsi_codes')==0
    msgbox('Wind链接失败','警告','信息对话框图标');
end
in = w_wsi_data;

time=w_wsi_times((period1+1):end);
% time1 = datestr(time);
in1 = w_wsi_data((period1+1):end);
 
[Hurst,EH]=Hurst_Exponent_Log_whole (in, period1, p);
Hurst1=Hurst';
Hurst1(1)=Hurst(2);
EH1=EH';
EH1(1)=EH1(2);

%测试策略收益率 EH1 Hurst1 in1
buy = {};
sell = {};

buy{1,1} = time(1);
buy{2,1} = in1(1); %初始时买入
full = 1; %判断仓位是否满
chance = false; %判断之前是否已利用过该机会
long = numel(EH1);
b1 = 2;
s1 = 1;
for i = 4:long-2
    if Hurst1(i-2)< EH(i-2) && Hurst1(i-1)< Hurst1(i-2) && Hurst1(i)< Hurst1(i-1) && Hurst1(i)< Hurst1(i+1) && Hurst1(i+1)<Hurst1(i+2)
        if in1(i)> (in1(i-1)+in1(i-2)+in(i-3))/3
            if full >-1 && chance == false
                sell{1,s1} = time(i);
                sell{2,s1} = in1(i);
                full = full - 1;
                chance = true;
                s1 = s1+1;
            end
        else
            if full <1 && chance == false
               buy{1,b1} = time(i);
               buy{2,b1} = in1(i);
               full = full + 1;
               chance = true;
               b1 = b1+1;
            end
        end
    end
    if Hurst(i)>EH(i)
        chance = false;
    end
end
% sell(1,:) = datestr(sell(1,:));
% buy(1,:) = datestr(buy(1,:));

