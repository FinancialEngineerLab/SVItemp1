function [ local_hurst, e_h, v_n, log_n, log_rs, e_rs ] = Hurst_local(data_close, time_window, move_average )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% �������̼���������
data_close_residuals = Utility_AR(data_close);

% �����̼۽����ƶ�ƽ������(����ʹ��20�������գ�
data_close_MA = zeros(time_window * 2, 1);
for i = 1 : time_window * 2
    data_close_MA(i) = mean(data_close_residuals(i : min(i + move_average - 1,numel(data_close_residuals))));
end


% ���ò���
% ���鷨��������С��10�����½�����ȶ�
%���ο�Fractal Market Analysis-Applying Chaos Theory to Investment and Economics 1994 Peters P.63)
min_int = 10;
% min_int = 3;
%max_int = floor(time_window * 1.5);
max_int = time_window;
logRS = zeros (max_int - min_int + 1, 1);
logN = zeros(max_int - min_int + 1, 1);
e_rs = zeros(max_int - min_int + 1, 1);

% �������䳤��Ϊcount
for len = min_int : max_int
    % ����ֳ�������Ŀ
    seg = floor(numel(data_close_MA) / len);
    
    % �����ݶ���ѡȡ����ֶ�����
    data_array = data_close_MA;
    data_array(1:numel(data_array) - seg * len,:) = [];
    
    % �����ݵ���Ϊ����
    data_array = reshape(data_array, len, seg);
    
    % ��ȡ������ƽ����
    data_ave = mean(data_array);
    
    % ��ȡ�������׼��(������Ϊn��
    data_stdev = std(data_array, 1);
    
    % ÿ��Ԫ�ؼ�ȥƽ��ֵ
    data_cumdev1 = data_array - ones(len, 1) * data_ave;
    
    % �����ۻ�ƫ��ֵ
    data_cumdev = cumsum(data_cumdev1);
    
    % ����R/S
    rs = (max (data_cumdev) - min (data_cumdev)) ./ data_stdev;
    
    logRS(len - (min_int - 1)) = log10 (mean(rs));
    
    logN(len - (min_int - 1)) = log10 (len);
    
    % ����E��H���ο�����֤ȯ�о�����
    r = 1 : len - 1;
    n = (ones(len - 1, 1) * len - r') ./ r';
    e_rs(len - (min_int - 1)) = ((len - 0.5) / len) * (len * pi * 0.5) ^ -0.5 * sum (sqrt (n));
        
end

% ����Local Hurstָ��
local_hurst = polyfit(logN, logRS, 1);
local_hurst = local_hurst(1);

% ��Ч�Լ���
% [b,bint,r,rint,stats] = regress(logRS,[ones(numel(logN), 1), logN],0.0001);
% [fitobject,gof] = fit(logN, logRS, 'poly1');
% figure;
% rcoplot(r,rint);
e_h = polyfit(logN, log10(e_rs), 1);
e_h = e_h(1);

nonlog_n = 10.^(logN);
v_n = 10.^(logRS)./sqrt(nonlog_n);
log_n = logN;
log_rs = logRS ;

end

