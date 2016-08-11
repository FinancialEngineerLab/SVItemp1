
%��������ʼ����
d1 = '2012-08-24'; 
d2 = '2015-08-21';  
index = '000001.SH';  
% index = '399001.SZ';
period1 = 240;   
p=40;

%����Hurst_strategy_new���õ�����ʱ�����Ӧ�۸�
[buy,sell,in1,time] = Hurst_strategy_new(d1,d2,index,period1,p);


%���²���Ϊ�������ۺͱ������

xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���Իزⱨ��'},'Sheet1','A1');

%��ֹʱ��
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'������ʼʱ��'},'Sheet1','A2');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{datestr(time(1))},'Sheet1','B2');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���Խ�ֹʱ��'},'Sheet1','C2');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{datestr(time(end))},'Sheet1','D2');

%��ֹ�ʽ�
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'��ʼ�ʽ�'},'Sheet1','A3');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(10000)},'Sheet1','B3');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'��ĩ�ʽ�'},'Sheet1','C3');
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
 xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(money(lastcol))},'Sheet1','D3');   

%���״�����ʤ��
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���״���'},'Sheet1','A4');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(2*size(buy,2))},'Sheet1','B4');

xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'ʤ��'},'Sheet1','C4');
wintimes = 0;
for j= 1:lastcol
    if add(j)>0
        wintimes = wintimes +1;
    end
end
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(wintimes/size(buy,2))},'Sheet1','D4');       

%�������س�
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���س�����'},'Sheet1','A5');
money1 = [10000,money];
[maxpercent,maxpoint] = retraceratio(money1);
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(maxpercent)},'Sheet1','B5');

xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���س��״η���ʱ��'},'Sheet1','C5');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{datestr(sell{1,maxpoint-1})},'Sheet1','D5');

%������Ժͱ���������ʡ��껯������
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'Hurst������������'},'Sheet1','A6');
hurst_profit = (money(lastcol)-10000)/10000;
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(hurst_profit)},'Sheet1','B6');

xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���ָ��������'},'Sheet1','C6');
object_revenue = 10000/in1(1)*in1(end);
object_profit = (object_revenue-10000)/10000;
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(object_profit)},'Sheet1','D6');

xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'Hurst�����껯������'},'Sheet1','A7');
annual_hurst = (1+hurst_profit)^(1/3)-1;
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(annual_hurst)},'Sheet1','B7');
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{'���ָ���껯������'},'Sheet1','C7');
annual_object = (1+object_profit)^(1/3)-1;
xlswrite('D:\������\Hurst����\�زⱨ��.xls',{num2str(annual_object)},'Sheet1','D7');

