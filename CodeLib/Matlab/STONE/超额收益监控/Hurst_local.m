function [ local_hurst, e_h, v_n, log_n, log_rs, e_rs ] = Hurst_local(data_close, time_window, move_average )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% 消除收盘价线性依赖
data_close_residuals = Utility_AR(data_close);

% 对收盘价进行移动平均处理(建议使用20个交易日）
data_close_MA = zeros(time_window * 2, 1);
for i = 1 : time_window * 2
    data_close_MA(i) = mean(data_close_residuals(i : min(i + move_average - 1,numel(data_close_residuals))));
end


% 设置参数
% 经验法则：若区间小于10将导致结果不稳定
%（参考Fractal Market Analysis-Applying Chaos Theory to Investment and Economics 1994 Peters P.63)
min_int = 10;
% min_int = 3;
%max_int = floor(time_window * 1.5);
max_int = time_window;
logRS = zeros (max_int - min_int + 1, 1);
logN = zeros(max_int - min_int + 1, 1);
e_rs = zeros(max_int - min_int + 1, 1);

% 设子区间长度为count
for len = min_int : max_int
    % 计算分成区间数目
    seg = floor(numel(data_close_MA) / len);
    
    % 从数据段中选取所需分段数据
    data_array = data_close_MA;
    data_array(1:numel(data_array) - seg * len,:) = [];
    
    % 将数据调整为矩阵
    data_array = reshape(data_array, len, seg);
    
    % 求取子区间平均数
    data_ave = mean(data_array);
    
    % 求取子区间标准差(被除数为n）
    data_stdev = std(data_array, 1);
    
    % 每个元素减去平均值
    data_cumdev1 = data_array - ones(len, 1) * data_ave;
    
    % 估计累积偏移值
    data_cumdev = cumsum(data_cumdev1);
    
    % 计算R/S
    rs = (max (data_cumdev) - min (data_cumdev)) ./ data_stdev;
    
    logRS(len - (min_int - 1)) = log10 (mean(rs));
    
    logN(len - (min_int - 1)) = log10 (len);
    
    % 计算E（H）参考国都证券研究报告
    r = 1 : len - 1;
    n = (ones(len - 1, 1) * len - r') ./ r';
    e_rs(len - (min_int - 1)) = ((len - 0.5) / len) * (len * pi * 0.5) ^ -0.5 * sum (sqrt (n));
        
end

% 计算Local Hurst指数
local_hurst = polyfit(logN, logRS, 1);
local_hurst = local_hurst(1);

% 有效性检验
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

