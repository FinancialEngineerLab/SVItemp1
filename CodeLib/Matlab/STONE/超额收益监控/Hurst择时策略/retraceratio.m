function [maxpercent,maxpoint] = retraceratio(data)
len = numel(data);
drawdownpercent = zeros(len,1);

%计算最大回撤比例
c = data(1);
for i = 2:len
    c = max(data(i),c);
    if c == data(i)
        drawdownpercent(i) = 0;
        point = i;
    else
        drawdownpercent(i) = (data(i)-c)/c;
        point = i;
    end
end
maxpercent = abs(min(drawdownpercent));
maxpoint = find(drawdownpercent == min(drawdownpercent));
