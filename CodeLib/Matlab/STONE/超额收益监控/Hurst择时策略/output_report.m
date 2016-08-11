
%输入计算初始参数
d1 = '2012-08-24'; 
d2 = '2015-08-21';  
index = '000001.SH';  
% index = '399001.SZ';
period1 = 240;   
p=40;

%调用Hurst_strategy_new，得到买卖时点和相应价格
[buy,sell,in1,time] = Hurst_strategy_new(d1,d2,index,period1,p);


%以下部分为策略评价和报告输出

xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'策略回测报告'},'Sheet1','A1');

%起止时间
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'测试起始时间'},'Sheet1','A2');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{datestr(time(1))},'Sheet1','B2');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'测试截止时间'},'Sheet1','C2');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{datestr(time(end))},'Sheet1','D2');

%起止资金
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'初始资金'},'Sheet1','A3');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(10000)},'Sheet1','B3');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'期末资金'},'Sheet1','C3');
    money = zeros(1);
    add = zeros(1);
    lastcol = max(size(buy,2),size(sell,2));
    if size(buy,2)>size(sell,2)    
        sell{1,lastcol} = time(end);
        sell{2,lastcol} = in1(end);
    else
        buy{1,lastcol} = time(end);
        buy{2,lastcol} = in1(end);
    end
    for i= 1:lastcol
        if buy{1,i}< sell{1,i}
            if i ==1
                add(i) = (10000/buy{2,i})*sell{2,i}-10000;
                money(i) = 10000 + add(i);
            else
                add(i) = (money(i-1)/buy{2,i})*sell{2,i}-money(i-1);
                money(i) = money(i-1) + add(i);
            end
        else
            if i ==1
                add(i) = (10000/sell{2,i})*buy{2,i}-10000;
                money(i) = 10000 + add(i);
            else
                add(i) = (money(i-1)/sell{2,i})*buy{2,i}-money(i-1);
                money(i) = money(i-1) + add(i);
            end
        end
    end
 xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(money(lastcol))},'Sheet1','D3');   

%交易次数与胜率
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'交易次数'},'Sheet1','A4');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(2*size(buy,2))},'Sheet1','B4');

xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'胜率'},'Sheet1','C4');
wintimes = 0;
for j= 1:lastcol
    if add(j)>0
        wintimes = wintimes +1;
    end
end
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(wintimes/size(buy,2))},'Sheet1','D4');       

%计算最大回撤
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'最大回撤比例'},'Sheet1','A5');
money1 = [10000,money];
[maxpercent,maxpoint] = retraceratio(money1);
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(maxpercent)},'Sheet1','B5');

xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'最大回撤首次发生时间'},'Sheet1','C5');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{datestr(sell{1,maxpoint-1})},'Sheet1','D5');

%计算策略和标的总收益率、年化收益率
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'Hurst策略总收益率'},'Sheet1','A6');
hurst_profit = (money(lastcol)-10000)/10000;
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(hurst_profit)},'Sheet1','B6');

xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'标的指数收益率'},'Sheet1','C6');
object_revenue = 10000/in1(1)*in1(end);
object_profit = (object_revenue-10000)/10000;
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(object_profit)},'Sheet1','D6');

xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'Hurst策略年化收益率'},'Sheet1','A7');
annual_hurst = (1+hurst_profit)^(1/3)-1;
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(annual_hurst)},'Sheet1','B7');
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{'标的指数年化收益率'},'Sheet1','C7');
annual_object = (1+object_profit)^(1/3)-1;
xlswrite('D:\纪尹杰\Hurst测试\回测报告.xls',{num2str(annual_object)},'Sheet1','D7');

