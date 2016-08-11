% �㷢TD��������
%***********************************************************%
% INPUT:
% DB = price data series
% Asset = �ʲ��˻�
% Params = ���ײ��ԵĲ���
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
% DB = ���º�����ݿ⣬��¼һЩ������Ϣ
%***********************************************************%

function [Signal DB] = Strategy_GFTD(DB,Asset,Params)
Signal.Action = 'NULL';
i = DB.CurrentIndex;
if i > 6 
   DB.Stage(i) = Check_Start_Stage(DB);
   if DB.Stage(i)==1  
        if Check_New_Stage(DB.Stage(i),DB.Stage(i-1)) ~= 1  %�����������
           DB.GFTDBuyCount1(i) = DB.GFTDBuyCount1(i-1) + Buy_Criteria_1(DB);
           DB.GFTDBuyCount2(i) = DB.GFTDBuyCount2(i-1) + Buy_Criteria_2(DB);
           if GFTDBuyCount1(i) >= 8 || GFTDBuyCount2(i) >= 4  
               Signal.Action = 'BUY';
           end
        else %�����׶α仯������ =�� ��
            DB.GFTDBuyCount1(i) = Buy_Criteria_1(DB);
            DB.GFTDBuyCount2(i) = Buy_Criteria_2(DB);
        end
   elseif  DB.Stage(i)==-1 
       if Check_New_Stage(DB.Stage(i),DB.Stage(i-1)) ~= 1  %������������    
           DB.GFTDSellCount1(i) = DB.GFTDSellCount1(i-1) + Sell_Criteria_1(DB);
           DB.GFTDSellCount2(i) = DB.GFTDSellCount2(i-1) + Sell_Criteria_2(DB);
           if GFTDSellCount1(i) >= 8 || GFTDSellCount2(i) >= 4  
               Signal.Action = 'SELL';
           end 
       else %�����׶α仯������ =�� ���� ���¼���
            DB.GFTDSellCount1(i) = Sell_Criteria_1(DB);
            DB.GFTDSellCount2(i) = Sell_Criteria_2(DB);
       end
   end
end


end


% �ж����ڴ����ĸ������׶�
function ret = Check_Start_Stage(DB)

if Buy_Start_Stage(DB)== 1
   ret = 1; 
elseif  Sell_Start_Stage(DB) == 1
   ret = -1;
else
    ret = 0;
end

end


% �ж��Ƿ�����µ������׶�
function ret = Check_New_Stage(prev_stage, current_stage)
    if (prev_stage ==1 && current_stage == -1) || (prev_stage ==-1 && current_stage == 1) 
        ret = 1;
    else
       ret = 0; 
    end
end

% ������������������K�ߣ������̼۱�֮ǰ���ĸ�K�����̼۵�
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

% ������������������K�ߣ������̼۱�֮ǰ���ĸ�K�����̼۸�
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

% ��������1�� ���̼�С�ڻ����֮ǰ��2 ��K ����ͼۣ���ͼ�С��֮ǰ��1��K �ߵ���ͼۣ����̼�С��֮ǰ��1 �������������̼�
function ret = Buy_Criteria_1(DB)
i = DB.CurrentIndex;
if(DB.Close(i)<= DB.Low(i-2) && DB.Low(i) <  DB.Low(i-1) && DB.Close(i) < DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% ��������2�� ���̼۴��ڻ����֮ǰ��2 ��K ����߼ۣ���߼۴���֮ǰ��1��K �ߵ���߼ۣ����̼۴���֮ǰ��1 �������������̼�
function ret = Buy_Criteria_2(DB)
i = DB.CurrentIndex;
if(DB.Close(i)>= DB.High(i-2) && DB.High(i) >  DB.High(i-1) && DB.Close(i) > DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% ��������1�����̼۴��ڻ����֮ǰ��2 ��K ����߼ۣ���߼۴���֮ǰ��1��K �ߵ���߼ۣ����̼۴���֮ǰ��1 �������������̼�
function ret = Sell_Criteria_1(DB)
i = DB.CurrentIndex;
if(DB.Close(i)>= DB.High(i-2) && DB.High(i) >  DB.High(i-1) && DB.Close(i) > DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end

% ��������2�� ���̼�С�ڻ����֮ǰ��2 ��K ����ͼۣ���ͼ�С��֮ǰ��1��K �ߵ���ͼۣ����̼�С��֮ǰ��1 �������������̼�
function ret = Sell_Criteria_2(DB)
i = DB.CurrentIndex;
if(DB.Close(i)<= DB.Low(i-2) && DB.Low(i) <  DB.Low(i-1) && DB.Close(i) < DB.Close(i-1))
    ret = 1;
else
    ret = 0;
end
end





