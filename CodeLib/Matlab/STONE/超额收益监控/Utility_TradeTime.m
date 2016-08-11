function [ timeSeries ] = Utility_TradeTime( timeCount, dateTrade, Type )
%UTILITY_TRADETIME Summary of this function goes here
%   timeCount ������ת��ʱ�����е�Ԫ������
%   dateTrade ����wind����ȡ�õĽ�����
%   Type: 1 stands for 1day
%   Type: 2 stands for 5mins
%   Type: 3 stands for 60mins

if Type == 1   
    timeSeries = dateTrade;
    return
end

% �����������wind����ȡֵδ������ʼʱ��������
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
% ȫ������3:00�����ݲ���������ȫ��5���Ӽ������ݽ�47��
dayCount = floor(timeCount / (minNumMor + minNumAft));

tmM = (1 : 1 : minNumMor)';
tmA = (1 : 1 : minNumAft)';

% ���㽻��ʱ��
tmMor = tmM * interval + datenum('09:30:00') - datenum('0:00:00');
tmAft = tmA * interval + datenum('13:00:00') - datenum('0:00:00');

tmtempMor = ones(minNumMor, 1);
tmtempAft = ones(minNumAft, 1);
timeSeries = zeros(1, 1);

% ��������һ��������䣬��ȫ�ɴ��������ݵ����ڸ�ʽ
for i = 1 : dayCount
    TimeSeries_m = tmtempMor * datenum(dateTrade(i)) + tmMor;
    TimeSeries_a = tmtempAft * datenum(dateTrade(i)) + tmAft;
    timeSeries = [timeSeries; TimeSeries_m; TimeSeries_a];
end

% ɾ�������һ�У������ݵ���Ϊһ�еĸ�ʽ
timeSeries(1 , :) = [];


% ���㲻Ϊ����һ������ݣ�ȫ������-1��ԭ��ͬ��
tmAdd = timeCount - dayCount * (minNumMor + minNumAft);

% ��ʣ�����ݽ��и�ֵ
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

