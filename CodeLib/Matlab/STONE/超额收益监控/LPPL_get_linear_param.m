
% INPUT: data(must be 1-d colume vector), nonlinear params tc, m and omega
% OUTPUT: linear params A,B,C1,C2 and LPPL function value y given all these params( in vector/
% 1-d matrix form

function [A,B,C1,C2,y] = LPPL_get_linear_param(idx_series, tc, m, omega)

%计算输入天数
num_idx = length(idx_series);
idx = linspace(0,num_idx-1,num_idx)';
tc_minus_t = tc* ones(num_idx,1) - idx;
tc_nimus_t_m = tc_minus_t.^m;

fi = tc_nimus_t_m;                          % 第二列 f_i
gi = fi.*cos(omega * log(tc_minus_t));  % 第三列 g_i = fi * cos(omega * log((tc - i + 1)));
hi = fi.*sin(omega * log(tc_minus_t));  % 第四列 h_i = fi * sin(omega * log((tc - i + 1)));
X = [ones(num_idx,1), fi, gi,hi];

matrix = X' * X;
b = matrix\X'* log(idx_series);

A = b(1,1);
B = b(2,1);
C1 = b(3,1);
C2 = b(4,1);

y = A+B.*fi + C1.*gi + C2.*hi;


end
