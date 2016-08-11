function [r] = premium(a,b1,b2,b3,b4,b5,d)
w=windmatlab;
%输入a为对应指数代码string,输入b1,b2,b3,b4为超额收益率基准天数
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000300.SH','close','2005-01-07',d,'Fill=Previous');
if exist('w_wsd_codes')==0
    msgbox('Wind链接失败','警告','信息对话框图标');
end
sz = w_wsd_data;
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(a,'close','2005-01-07',d,'Fill=Previous');
if exist('w_wsd_codes')==0
    msgbox('Wind链接失败','警告','信息对话框图标');
end
in = w_wsd_data;
% 删除没有数据的天数,统一数据起始日期
if length(in(~isnan(in)))>length(sz(~isnan(sz)))
    in=in(~isnan(sz));
    sz=sz(~isnan(sz));
else
    sz=sz(~isnan(in));
    in=in(~isnan(in));
end
l=length(in);

%分不同基准天数计算 b1
%b1=1;%测试语句，正式运行删除
in1=in
sz1=sz
for i=l:-1:(b1+1)
    in1(i)=100*(in1(i)-in1(i-b1))/in1(i-b1);
    sz1(i)=100*(sz1(i)-sz1(i-b1))/sz1(i-b1);
end
in1(1:b1)=[];
sz1(1:b1)=[];
prem1 = in1 - sz1;
l1=length(prem1);
quantile1=sum(prem1<prem1(l1))/l1;

%分不同基准天数计算 b2
%b2=3;%测试语句，正是运行删除
in2=in
sz2=sz
for i=l:-1:(b2+1)
    in2(i)=100*(in2(i)-in2(i-b2))/in2(i-b2);
    sz2(i)=100*(sz2(i)-sz2(i-b2))/sz2(i-b2);
end
in2(1:b2)=[];
sz2(1:b2)=[];
prem2 = in2 - sz2;
l2=length(prem2);
quantile2=sum(prem2<prem2(l2))/l2;

%分不同基准天数计算 b3
%b3=5;%测试语句，正是运行删除
in3=in
sz3=sz
for i=l:-1:(b3+1)
    in3(i)=100*(in3(i)-in3(i-b3))/in3(i-b3);
    sz3(i)=100*(sz3(i)-sz3(i-b3))/sz3(i-b3);
end
in3(1:b3)=[];
sz3(1:b3)=[];
prem3 = in3 - sz3;
l3=length(prem3);
quantile3=sum(prem3<prem3(l3))/l3;

%分不同基准天数计算 b5
%b4=10;%测试语句，正是运行删除
in4=in
sz4=sz
%计算各个的b日收益率
for i=l:-1:(b4+1)
    in4(i)=100*(in4(i)-in4(i-b4))/in4(i-b4);
    sz4(i)=100*(sz4(i)-sz4(i-b4))/sz4(i-b4);
end
in4(1:b4)=[];
sz4(1:b4)=[];
%计算超额的收益
prem4 = in4 - sz4;
l4=length(prem4);
quantile4=sum(prem4<prem4(l4))/l4;

%分不同基准天数计算 b5
%b5=10;%测试语句，正是运行删除
in5=in
sz5=sz
%计算各个的b日收益率
for i=l:-1:(b5+1)
    in5(i)=100*(in5(i)-in5(i-b5))/in5(i-b5);
    sz5(i)=100*(sz5(i)-sz5(i-b5))/sz5(i-b5);
end
in5(1:b5)=[];
sz5(1:b5)=[];
%计算超额的收益
prem5 = in5 - sz5;
l5=length(prem5);
quantile5=sum(prem5<prem5(l5))/l5;

%返回结果
r=[prem1(l1),quantile1;prem2(l2),quantile2;prem3(l3),quantile3;prem4(l4),quantile4;prem5(l5),quantile5]
