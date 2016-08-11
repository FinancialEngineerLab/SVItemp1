
%***********************************************************%
% INPUT:
% NAV_Data = NAV information data set( NAV changes, positions etc)
%***********************************************************%
% OUTPUT: 
% .MaxPercent: max drawdown %
% .MaxPoint: index of NAV_Data where maxdrawdown happens
% .NbTrade: num of trades
%***********************************************************%

function ret = Utility_StrategyStat(Asset,Params)

NAV_Data = Asset.TradingAccount;
Volume = Asset.Volume;
Times = Asset.Times;
TradingAccount = Asset.TradingAccount;
TradePrice = Asset.Price;
Position = Asset.Position;
ClosePrice = Asset.ClosePrice;

len = numel(NAV_Data);
drawdownpercent = zeros(len,1);

ret.NbTrade = 0;
ret.WinRatio = 0;

PreviousTradeIndex = 1;

MaxNAV = NAV_Data(1);

for i = 1:len
    % ���㽻�״���
    if Volume(i) ~= 0   
        
       ret.NbTrade = ret.NbTrade + 1;
       
       if ret.NbTrade == 1 
           ret.TradeIndex = i;
           ret.TradeTime = Times(i); 
           ret.TradePnL = 0;     %�״ν���û��PnL 
           ret.Volume = Volume(i);
           ret.TradePrice = TradePrice(i);
           ret.TradingAccount = TradingAccount(i);
           ret.ClosePrice = ClosePrice(i);
            PreviousTradeIndex = i; % ��ס�ɱ�
       else
           ret.TradeIndex = [ret.TradeIndex; i];
           ret.TradeTime = [ret.TradeTime; Times(i)];
           ret.Volume = [ret.Volume; Volume(i)];
           ret.TradePrice =[ ret.TradePrice; TradePrice(i)]; 
           ret.TradingAccount = [ ret.TradingAccount; TradingAccount(i)]; 
           ret.ClosePrice = [ ret.ClosePrice; ClosePrice(i)]; 
           if Params.Execution.AllowShort == 0 %����������
               if Volume(i) > 0  % buy 
                    PreviousTradeIndex = i; % ��ס�ɱ�
                    ret.TradePnL = [ret.TradePnL; 0];
               else   % sell          
                   ret.TradePnL = [ret.TradePnL;  ret.Volume(ret.NbTrade-1)*(TradePrice(i) - TradePrice(PreviousTradeIndex)) ];
               end
           else % ��������
               if Volume(i) > 0 %buy
                   if Position(i-1) < 0 
                        ret.TradePnL = [ret.TradePnL; ret.Volume(ret.NbTrade-1)*(TradePrice(PreviousTradeIndex) - TradePrice(i))];  % ƽ��ͷ
                   else
                        ret.TradePnL = [ret.TradePnL; 0]; % ������
                        PreviousTradeIndex = i; % ��ס�ɱ�
                   end
               else
                   if Position(i-1) > 0 
                        ret.TradePnL = [ret.TradePnL; -ret.Volume(ret.NbTrade-1)*(TradePrice(i) - TradePrice(PreviousTradeIndex)) ];  % ƽ��ͷ
                   else
                        PreviousTradeIndex = i; % ��ס�ɱ�
                        ret.TradePnL = [ret.TradePnL; 0]; % ������
                   end
               end
           end  
       end   
    end
    
    % �������س�
    MaxNAV = max(NAV_Data(i),MaxNAV);
    if MaxNAV == NAV_Data(i)
        drawdownpercent(i) = 0;
    else
        drawdownpercent(i) = (NAV_Data(i)-MaxNAV)/MaxNAV;   
    end
end

%ret.MaxPercent = abs(min(drawdownpercent));
ret.MaxPoint = find(drawdownpercent == min(drawdownpercent));
ret.MaxPercent = drawdownpercent(ret.MaxPoint);

% ʤ��
NbWinTrade = size(find(ret.TradePnL>0));
if Params.Execution.AllowShort == 0 %���������� 
    ret.WinRatio = NbWinTrade(1)/ret.NbTrade*2;
else
    ret.WinRatio = NbWinTrade(1)/ret.NbTrade;
end
% ����
ret.TotalReturn = TradingAccount(end) - TradingAccount(1);

ret.Length = ret.NbTrade ;

end