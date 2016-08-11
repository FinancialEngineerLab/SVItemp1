function [DrawDownPercent,DrawDownAbs,MaxDrawDownPercent,MaxDrawDownAbs] = RetraceRatio(Equity)
% �������س�����

%% ��ʼ��
len = numel(Equity);
DrawDownPercent = zeros(len, 1);
DrawDownAbs = zeros(len, 1);

%% �������س�����
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

%% �������س�������ֵ
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
