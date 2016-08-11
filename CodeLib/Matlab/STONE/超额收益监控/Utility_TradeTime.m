function [ timeSeries ] = Utility_TradeTime( timeCount, dateTrade, Type )
%UTILITY_TRADETIME Summary of this function goes here
%   timeCount 输入需转换时间序列的元素数量
%   dateTrade 输入wind函数取得的交易日
%   Type: 1 stands for 1day
%   Type: 2 stands for 5mins
%   Type: 3 stands for 60mins

if Type == 1   
    timeSeries = dateTrade;
    return
end

% 解决分钟数据wind函数取值未包含起始时间点的问题
timeCount = timeCount + 1;

if Type == 2
    Type = 5;
    interval = datenum('1:00:00') - datenum('0:55:00');
    minNumAft = 120 / Type - 1;
else if Type == 3
        Type = 60;
        interval = datenum('1:00:00') - datenum('0:00:00');
        minNumAft = 120 / Type;
    end
end

minNumMor = 120 / Type;
% 全天收盘3:00的数据不包含，故全天5分钟级别数据仅47次
dayCount = floor(timeCount / (minNumMor + minNumAft));

tmM = (1 : 1 : minNumMor)';
tmA = (1 : 1 : minNumAft)';

% 计算交易时间
tmMor = tmM * interval + datenum('09:30:00') - datenum('0:00:00');
tmAft = tmA * interval + datenum('13:00:00') - datenum('0:00:00');

tmtempMor = ones(minNumMor, 1);
tmtempAft = ones(minNumAft, 1);
timeSeries = zeros(1, 1);

% 对完整的一天进行扩充，补全成带分钟数据的日期格式
for i = 1 : dayCount
    TimeSeries_m = tmtempMor * datenum(dateTrade(i)) + tmMor;
    TimeSeries_a = tmtempAft * datenum(dateTrade(i)) + tmAft;
    timeSeries = [timeSeries; TimeSeries_m; TimeSeries_a];
end

% 删除多余的一行，将数据调整为一行的格式
timeSeries(1 , :) = [];


% 计算不为完整一天的数据，全天数据-1的原因同上
tmAdd = timeCount - dayCount * (minNumMor + minNumAft);

% 对剩余数据进行赋值
if tmAdd <= minNumMor 
    for i = 1: tmAdd
        tmtemp = datenum(dateTrade(dayCount + 1)) + datenum('09:30:00') - datenum('0:00:00') + i * interval;
        timeSeries = [timeSeries; tmtemp];
    end
else if tmAdd > minNumMor
        for i = 1: minNumMor
            tmtemp = datenum(dateTrade(dayCount + 1)) + datenum('09:30:00') - datenum('0:00:00') + i * interval;
            timeSeries = [timeSeries; tmtemp];
        end 
        for i = 1 : tmAdd - minNumMor
            tmtemp = datenum(dateTrade(dayCount + 1)) + datenum('13:00:00') - datenum('0:00:00') + i * interval;
            timeSeries = [timeSeries; tmtemp];
        end 
    end
end

end

