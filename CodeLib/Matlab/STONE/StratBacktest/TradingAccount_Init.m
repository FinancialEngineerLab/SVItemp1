
%***********************************************************%
% INPUT:
% DB = price data series
%***********************************************************%
% OUTPUT: 
% Asset = initialized trading account asset 
%***********************************************************%
function Asset = TradingAccount_Init(DB)
NT = length(DB.Close);

Asset.Size = NT;
% ��ǰ�ֲ���
Asset.CurrentPosition = 0;
% �ɽ���
Asset.Volume = zeros(NT,1);
% �ɽ���
Asset.Price = zeros(NT,1);
% �ֲ���
Asset.Position = zeros(NT,1);
% �ʲ�
Asset.Cash = zeros(NT,1);
% ��ʼ�ʲ�Ϊ1.0
Asset.Cash(1) = 1.0;
% ��Ӧʱ��
Asset.Time = zeros(NT,1);
% �����˻�
Asset.TradingAccount= zeros(NT,1);
% �����ź�
Asset.Signal = zeros(NT,1);
% �ɽ������̼�
Asset.ClosePrice = zeros(NT,1);

end

