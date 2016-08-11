


function [squared_error, A, B, C1, C2 ] = LPPL_squared_error_compute(idx_series, tc, m, omega)

%计算输入天数
% num_idx = length(idx_series);
[A,B,C1,C2,y] = LPPL_get_linear_param(idx_series, tc, m, omega);

% 计算平方差
squared_error = sum((y - log(idx_series)).^2);

end




