function [r] = Hurst_calculation(a,b1,b2,b3,b4,b5,d1,d2)
w=windmatlab;
%����aΪ��Ӧָ������string,����b1,b2,b3,b4Ϊ���������ʻ�׼����

[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(a,'close',d1,d2,'Fill=Previous');
if exist('w_wsd_codes')==0
    msgbox('Wind����ʧ��','����','��Ϣ�Ի���ͼ��');
end
in = w_wsd_data;

%�ֲ�ͬ��׼�������� b1
%b1=1;%������䣬��ʽ����ɾ��
in1 = in;
[Hurst_N,Hurst]=Hurst_Exponent_Log (in1, b1, floor(b1/5));
hurst1_N = Hurst_N(1);
hurst1= Hurst;
                                                                                                                                                                                 
l1=length(hurst1);
quantile1=sum(hurst1<hurst1_N)/l1;

%�ֲ�ͬ��׼�������� b2
%b2=3;%������䣬��������ɾ��
in2 = in;
[Hurst_N,Hurst]=Hurst_Exponent_Log (in2, b2, floor(b2/5));
hurst2_N = Hurst_N(1);
hurst2= Hurst;
                                                                                                                                                                                 
l2=length(hurst2);
quantile2=sum(hurst2<hurst2_N)/l2;


%�ֲ�ͬ��׼�������� b3
%b3=5;%������䣬��������ɾ��
in3 = in;
[Hurst_N,Hurst]=Hurst_Exponent_Log (in3, b3, floor(b3/5));
hurst3_N = Hurst_N(1);
hurst3= Hurst;
                                                                                                                                                                                 
l3=length(hurst3);
quantile3=sum(hurst3<hurst3_N)/l3;


%�ֲ�ͬ��׼�������� b5
%b4=10;%������䣬��������ɾ��
in4 = in;
[Hurst_N,Hurst]=Hurst_Exponent_Log (in4, b4, floor(b4/5));
hurst4_N = Hurst_N(1);
hurst4= Hurst;
                                                                                                                                                                                 
l4=length(hurst4);
quantile4=sum( hurst4<hurst4_N)/l4;


%�ֲ�ͬ��׼�������� b5
%b5=10;%������䣬��������ɾ��
in5 = in;
[Hurst_N,Hurst]=Hurst_Exponent_Log (in5, b5, floor(b5/5));
hurst5_N = Hurst_N(1);
hurst5 = Hurst;
                                                                                                                                                                                 
l5=length(hurst5);
quantile5=sum( hurst5<hurst5_N)/l5;

%���ؽ��
r=[hurst1_N,quantile1;hurst2_N,quantile2;hurst3_N,quantile3;hurst4_N,quantile4;hurst5_N,quantile5]




