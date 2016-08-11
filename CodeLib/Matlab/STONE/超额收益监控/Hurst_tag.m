function count = Hurst_tag( date_vec, hurst_vec, ref, clr, today )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hurst_mat = [datenum(date_vec) hurst_vec];
list = find(hurst_mat(:,2) < ref);
count = 0;

flag = 1;
for i = 1 : numel(list) - 1
    if list(i) + 1 ~= list(i + 1) || i + 1 == numel(list)
        if i == numel(list) - 1 && list(i) + 1 ~= list(i + 1)
            flag = i + 1;
        end
        text(hurst_mat(list(flag), 1), hurst_mat(list(flag), 2),...
            datestr(hurst_mat(list(flag), 1)), 'color', clr, 'FontSize', 8);
        % 判定至今已达标天数
        if hurst_mat(list(i + 1), 1) == datenum(today)
            count = numel(list) - flag + 1;
        end  
        flag = i + 1;
    end
end

end

