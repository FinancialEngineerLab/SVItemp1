function fun = LPPL_squared_error_compute_fmincon(x, idx_series)
% function [squared_error, A, B, C1, C2 ] = squared_error_compute(IndexSeries, tc, m, omega)

%计算输入天数
% num_idx = length(idx_series);
% [A,B,C1,C2,y] = get_linear_param(IndexSeries, tc, m, omega);
[~,~,~,~,y] = LPPL_get_linear_param(idx_series, x(1), x(2), x(3));

% 计算平方差
% squared_error = sum((y - log(IndexSeries)).^2);
fun = sum((y - log(idx_series(:,4))).^2);

end

