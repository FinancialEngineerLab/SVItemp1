function [DrawDownPercent,DrawDownAbs,MaxDrawDownPercent,MaxDrawDownAbs] = RetraceRatio(Equity)
% 计算最大回撤比例

%% 初始化
len = numel(Equity);
DrawDownPercent = zeros(len, 1);
DrawDownAbs = zeros(len, 1);

%% 计算最大回撤比例
C = Equity(1);
for i = 2:len
    C = max(Equity(i),C);
    if C == Equity(i)
        DrawDownPercent(i) = 0;
    else
        DrawDownPercent(i) = (Equity(i)-C)/C;
    end
end
DrawDownPercent(isinf(DrawDownPercent)) = [];

MaxDrawDownPercent = min(DrawDownPercent);

%% 计算最大回撤绝对数值
C = Equity(1);
for i = 2:len
    C = max(Equity(i),C);
    if C == Equity(i)
        DrawDownAbs(i) = 0;
    else
        DrawDownAbs(i) = (Equity(i)-C);
    end
end
MaxDrawDownAbs = min(DrawDownAbs);
