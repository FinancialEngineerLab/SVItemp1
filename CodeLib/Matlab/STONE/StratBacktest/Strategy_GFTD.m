% 广发TD修正策略
%***********************************************************%
% INPUT:
% DB = price data series
% Asset = 资产账户
% Params = 交易策略的参数
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
% DB = 更新后的数据库，记录一些附属信息
%***********************************************************%

function [Signal DB] = Strategy_GFTD(DB,Asset,Params)
Signal.Action = 'NULL';
i = DB.CurrentIndex;
if i > 6 
   DB.Stage(i) = Check_Start_Stage(DB);
   if DB.Stage(i)==1  
        if Check_New_Stage(DB.Stage(i),DB.Stage(i-1)) ~= 1  %继续买入计数
           DB.GFTDBuyCount1(i) = DB.GFTDBuyCount1(i-1) + Buy_Criteria_1(DB);
           DB.GFTDBuyCount2(i) = DB.GFTDBuyCount2(i-1) + Buy_Criteria_2(DB);
           if GFTDBuyCount1(i) >= 8 || GFTDBuyCount2(i) >= 4  
               Signal.Action = 'BUY';
           end
        else %启动阶段变化，由卖 =》 买
            DB.GFTDBuyCount1(i) = Buy_Criteria_1(DB);
            DB.GFTDBuyCount2(i) = Buy_Criteria_2(DB);
        end
   elseif  DB.Stage(i)==-1 
       if Check_New_Stage(DB.Stage(i),DB.Stage(i-1)) ~= 1  %继续卖出计数    
           DB.GFTDSellCount1(i) = DB.GFTDSellCount1(i-1) + Sell_Criteria_1(DB);
           DB.GFTDSellCount2(i) = DB.GFTDSellCount2(i-1) + Sell_Criteria_2(DB);
           if GFTDSellCount1(i) >= 8 || GFTDSellCount2(i) >= 4  
               Signal.Action = 'SELL';
           end 
       else %启动阶段变化，由买 =》 卖， 重新计数
            DB.GFTDSellCount1(i) = Sell_Criteria_1(DB);
            DB.GFTDSellCount2(i) = Sell_Criteria_2(DB);
       end
   end
end


end


% 判断现在处于哪个启动阶段
function ret = Check_Start_Stage(DB)

if Buy_Start_Stage(DB)== 1
   ret = 1; 
elseif  Sell_Start_Stage(DB) == 1
   ret = -1;
else
    ret = 0;
end

end


% 判断是否进入新的启动阶段
function ret = Check_New_Stage(prev_stage, current_stage)
    if (prev_stage ==1 && current_stage == -1) || (prev_stage ==-1 && current_stage == 1) 
        ret = 1;
    else
       ret = 0; 
    end
end

% 买入启动：连续六根K线，其收盘价比之前第四根K线收盘价低
function ret = Buy_Start_Stage(DB)
i = DB.CurrentIndex;
if(DB.Close(i)<= DB.Close(i-4) &&...
        DB.Close(i-1)<= DB.Close(i-5) &&...
        DB.Close(i-2)<= DB.Close(i-6) &&...
        DB.Close(i-3)<= DB.Close(i-7) &&... 
        DB.Close(i-4)<= DB.Close(i-8) &&...
        DB.Close(i-5)<= DB.Close(i-9))
    ret = 1;
else
    ret = 0;
end
end

% 卖出启动：连续六根K线，其收盘价比之前第四根K线收盘价高
function ret = Sell_Start_Stage(DB)
i = DB.CurrentIndex;
if(DB.Close(i)>= DB.Close(i-4) &&...
        DB.Close(i-1)>= DB.Close(i-5) &&...
        DB.Close(i-2)>= DB.Close(i-6) &&...
        DB.Close(i-3)>= DB.Close(i-7) &&... 
        DB.Close(i-4)>= DB.Close(i-8) &&...
        DB.Close(i-5)>= DB.Close(i-9))
    ret = 1;
else
    ret = 0;
end
end

% 买入条件1： 收盘价小于或等于之前第2 根K 线最低价；最低价小于之前第1根K 线的最低价；收盘价小于之前第1 个计数处的收盘价
function ret = Buy_Criteria_1(DB)
i = DB.CurrentIndex;
if(DB.Close(i)<= DB.Low(i-2) && DB.Low(i) <  DB.Low(i-1) && DB.Close(i) < DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% 买入条件2： 收盘价大于或等于之前第2 根K 线最高价；最高价大于之前第1根K 线的最高价；收盘价大于之前第1 个计数处的收盘价
function ret = Buy_Criteria_2(DB)
i = DB.CurrentIndex;
if(DB.Close(i)>= DB.High(i-2) && DB.High(i) >  DB.High(i-1) && DB.Close(i) > DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% 卖出条件1：收盘价大于或等于之前第2 根K 线最高价；最高价大于之前第1根K 线的最高价；收盘价大于之前第1 个计数处的收盘价
function ret = Sell_Criteria_1(DB)
i = DB.CurrentIndex;
if(DB.Close(i)>= DB.High(i-2) && DB.High(i) >  DB.High(i-1) && DB.Close(i) > DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% 卖出条件2： 收盘价小于或等于之前第2 根K 线最低价；最低价小于之前第1根K 线的最低价；收盘价小于之前第1 个计数处的收盘价
function ret = Sell_Criteria_2(DB)
i = DB.CurrentIndex;
if(DB.Close(i)<= DB.Low(i-2) && DB.Low(i) <  DB.Low(i-1) && DB.Close(i) < DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end





