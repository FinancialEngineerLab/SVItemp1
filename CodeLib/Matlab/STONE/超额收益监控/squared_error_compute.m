
function [squared_error, A, B, C1, C2 ] = squared_error_compute(IndexSeries, tc, m, omega)

%计算输入天数
NbData = length(IndexSeries);
[A,B,C1,C2,y] = get_linear_param(IndexSeries, tc, m, omega);

% 计算平方差
squared_error = sum((y - log(IndexSeries)).^2);

end

function [squared_error, A, B, C1, C2 ] = squared_error_compute(IndexSeries, tc, m, omega)

%计算输入天数
NbData = length(IndexSeries);
[A,B,C1,C2,y] = get_linear_param(IndexSeries, tc, m, omega);

% 计算平方差
squared_error = sum((y - log(IndexSeries)).^2);

end





% INPUT: data(must be 1-d colume vector), nonlinear params tc, m and omega
% OUTPUT: linear params A,B,C1,C2 and LPPL function value y given all these params( in vector/
% 1-d matrix form
function [A,B,C1,C2,y] = get_linear_param(IndexSeries, tc, m, omega)

%计算输入天数
NbData = length(IndexSeries);
idx = linspace(0,NbData-1,NbData)';
tc_minus_t = tc* ones(NbData,1) - idx;
tc_nimus_t_m = tc_minus_t.^m;

fi = tc_nimus_t_m;                          % 第二列 f_i
gi = fi.*cos(omega * log(tc_minus_t));  % 第三列 g_i = fi * cos(omega * log((tc - i + 1)));
hi = fi.*sin(omega * log(tc_minus_t));  % 第四列 h_i = fi * sin(omega * log((tc - i + 1)));
X = [ones(NbData,1), fi, gi,hi];

Matrix = X' * X;
b = Matrix\X'* log(IndexSeries);

A = b(1,1);
B = b(2,1);
C1 = b(3,1);
C2 = b(4,1);

y = A+B.*fi + C1.*gi + C2.*hi;


end

