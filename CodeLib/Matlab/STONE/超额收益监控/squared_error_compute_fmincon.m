function fun = squared_error_compute_fmincon(x, IndexSeries)
% function [squared_error, A, B, C1, C2 ] = squared_error_compute(IndexSeries, tc, m, omega)

%������������
NbData = length(IndexSeries);
% [A,B,C1,C2,y] = get_linear_param(IndexSeries, tc, m, omega);
[A,B,C1,C2,y] = get_linear_param(IndexSeries, x(1), x(2), x(3));

% ����ƽ����
% squared_error = sum((y - log(IndexSeries)).^2);
fun = sum((y - log(IndexSeries(:,4))).^2);

end

