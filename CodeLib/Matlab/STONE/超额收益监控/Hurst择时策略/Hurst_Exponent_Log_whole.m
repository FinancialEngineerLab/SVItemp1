
%�����ƶ�����Hurstָ�����Թ�ָ��������������
%DataΪ�г�ָ�����̼ۣ�
%PeriodsΪѡȡ��ʱ�䴰���ڣ�
%ItemsΪ����ʱһ�ηָ���������Ԫ�ء�
%���ʱ�����е�Hurstָ�����


function [Hurst,EH]=Hurst_Exponent_Log_whole (Data, Periods, Items)

%�����ƶ�����
for day=1: length(Data) - Periods - 1
    
    Xt_Data_Period = zeros(1);
    Yt_Data_Period = zeros(1);
    
    %��ȫ�������н�ȡ���賤������
    for ipoints = 1 : Periods 
        Xt_Data_Period(ipoints) = log(Data(length(Data) - day + ipoints - Periods ) / Data(length(Data) - day + ipoints - Periods - 1 ));
        Yt_Data_Period(ipoints) = log(Data(length(Data) - day + ipoints - Periods + 1 ) / Data(length(Data) - day + ipoints - Periods ));
    end
    
    Xt_Data_Period = Xt_Data_Period'
    Xt_Data_Period = [ones(Periods,1) , Xt_Data_Period];
    
    %����в�
    [~,~,Data_Period,~,~]=regress(Yt_Data_Period' , Xt_Data_Period);

    %�½��洢����
    logRS = zeros(1);
    logERS = zeros(1);
    logN = zeros(1);
    EH_N = zeros(1);
    Data_Adjust = zeros(1);
    t=0;

    for Elements = 3 : Items
        %��ѡȡ�����ݷֳ�Elements��Ԫ��һ��
        Intervals = floor(Periods / Elements);

        Data_Adjust = zeros(1);
        %�ӽ�ȡ������ѡȡ�ֶ����������
        for ipoints = 1 : Intervals * Elements
            Data_Adjust(ipoints) = Data_Period(length(Data_Period) - Intervals * Elements + ipoints);
        end

        %�������������
        Data_Array = reshape(Data_Adjust, Elements, Intervals);

        %����ÿ��������ƽ��ֵ
        ave = mean(Data_Array);

        %��ÿ��Ԫ���м�ȥƽ��ֵ
        cumdev_1 = Data_Array - ones(Elements,1) * ave;

        %�����ۼ�ƫ��ֵ
        cumdev = cumsum(cumdev_1);

        %���Ʊ�׼��
        stdev = std (Data_Array);

        %����rs
        rs = (max (cumdev) - min (cumdev)) ./ stdev;

        %�õ�ƽ��ֵ
        logRS(Elements - 2) = log(mean(rs));
        
        %����E(R/S)
        t = 0;
        for i = 1:(Elements-1)
            t = t + ((Elements-i)/i)^0.5;
        end
        logERS(Elements-2) = log(((Elements-0.5)/Elements)*(Elements*pi/2)^(-0.5)*t);

        %�õ�LogN
        logN(Elements - 2) = log(Elements);

    end

    %�����ƶ�Hurstָ��������Hurstָ������
    Hurst_N = polyfit(logN, logRS, 1);
    Hurst(1, length(Data) - day -Periods +1) = Hurst_N(1,1);
    EH_N = polyfit(logN, logERS, 1);
    EH(1, length(Data) - day -Periods +1) = EH_N(1,1);
end
