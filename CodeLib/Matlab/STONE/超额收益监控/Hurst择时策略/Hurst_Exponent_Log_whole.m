
%计算移动周期Hurst指数（对股指消除线性依赖）
%Data为市场指数收盘价；
%Periods为选取的时间窗口期；
%Items为计算时一次分隔包含几个元素。
%输出时间序列的Hurst指数结果


function [Hurst,EH]=Hurst_Exponent_Log_whole (Data, Periods, Items)

%计算移动周期
for day=1: length(Data) - Periods - 1
    
    Xt_Data_Period = zeros(1);
    Yt_Data_Period = zeros(1);
    
    %从全部数据中截取所需长度数据
    for ipoints = 1 : Periods 
        Xt_Data_Period(ipoints) = log(Data(length(Data) - day + ipoints - Periods ) / Data(length(Data) - day + ipoints - Periods - 1 ));
        Yt_Data_Period(ipoints) = log(Data(length(Data) - day + ipoints - Periods + 1 ) / Data(length(Data) - day + ipoints - Periods ));
    end
    
    Xt_Data_Period = Xt_Data_Period'
    Xt_Data_Period = [ones(Periods,1) , Xt_Data_Period];
    
    %计算残差
    [~,~,Data_Period,~,~]=regress(Yt_Data_Period' , Xt_Data_Period);

    %新建存储矩阵
    logRS = zeros(1);
    logERS = zeros(1);
    logN = zeros(1);
    EH_N = zeros(1);
    Data_Adjust = zeros(1);
    t=0;

    for Elements = 3 : Items
        %将选取的数据分成Elements个元素一段
        Intervals = floor(Periods / Elements);

        Data_Adjust = zeros(1);
        %从截取数据中选取分段所需的数据
        for ipoints = 1 : Intervals * Elements
            Data_Adjust(ipoints) = Data_Period(length(Data_Period) - Intervals * Elements + ipoints);
        end

        %建立子区间矩阵
        Data_Array = reshape(Data_Adjust, Elements, Intervals);

        %计算每个子区间平均值
        ave = mean(Data_Array);

        %从每个元素中减去平均值
        cumdev_1 = Data_Array - ones(Elements,1) * ave;

        %估计累计偏移值
        cumdev = cumsum(cumdev_1);

        %估计标准差
        stdev = std (Data_Array);

        %计算rs
        rs = (max (cumdev) - min (cumdev)) ./ stdev;

        %得到平均值
        logRS(Elements - 2) = log(mean(rs));
        
        %计算E(R/S)
        t = 0;
        for i = 1:(Elements-1)
            t = t + ((Elements-i)/i)^0.5;
        end
        logERS(Elements-2) = log(((Elements-0.5)/Elements)*(Elements*pi/2)^(-0.5)*t);

        %得到LogN
        logN(Elements - 2) = log(Elements);

    end

    %计算移动Hurst指数，生成Hurst指数矩阵
    Hurst_N = polyfit(logN, logRS, 1);
    Hurst(1, length(Data) - day -Periods +1) = Hurst_N(1,1);
    EH_N = polyfit(logN, logERS, 1);
    EH(1, length(Data) - day -Periods +1) = EH_N(1,1);
end
