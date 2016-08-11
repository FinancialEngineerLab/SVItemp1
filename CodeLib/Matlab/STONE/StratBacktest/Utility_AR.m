
% return the residuals of AR(1)
function residual_ar = Utility_AR( price_data )

time_seq1 = price_data;
time_seq1(numel(time_seq1),:) = [];
time_seq = price_data;
time_seq(1,:) = [];
St = log(time_seq ./ time_seq1);
St1 = St;
St1(numel(St1), :) = [];
St1 = [ones(numel(St1), 1), St1];
St(1, :) = [];
[~,~,residual_ar,~,~] = regress(St, St1);

end

