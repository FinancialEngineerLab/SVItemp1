%***********************************************************%
% INPUT:
% DB = price data series
% Asset = intial trading account asset
% volume = trading volume
% price = trading price
% flag_tradeprice = trading at which type of price, use 'CLOSE' or the price in the params 
% flag_volume_determined_method = 0,1   
%       0: trade volume = volume input 1:trade volume = asset.cash/price
%***********************************************************%
% OUTPUT: 
% Asset = new trading account asset 
%***********************************************************%

function Asset = TradingAccount_Sell(DB,Asset,volume,price,flag_tradeprice, Params)
%��ǰλ��
i = DB.CurrentIndex;
flag_volume_determined_method = Params.Execution.UseCompoundVolume;
flag_allow_short = Params.Execution.AllowShort;

%�ɽ���
if(strcmpi(flag_tradeprice,'CLOSE'))
    Asset.Price(i)  = DB.Close(i); %�ɽ��� ��Ϊ��
else
    Asset.Price(i) = price;
end

%�ɽ����� ����Ϊ��
if flag_volume_determined_method ==1 
     if Asset.CurrentPosition>0 % ����Ѿ��гֲֵĻ� �Ϳ�������
        if flag_allow_short == 0
            Asset.Volume(i) = -Asset.Position(i-1);  %���������� => ƽ��ͷ
        else
            Asset.Volume(i) = -2*Asset.Position(i-1);    % �������� => ƽ��ͷ �ٿ���ͷ
        end
     else 
         if flag_allow_short == 1 && Asset.CurrentPosition>=0
             %����������յ���û�гֲ� =�����գ�������������������������ͬ
             Asset.Volume(i) = ShortVolume(Asset.Cash, Asset.Price,i);        
         else
             Asset.Volume(i) = 0.0;%������������ն���û�гֲ�, �����������գ������Ѿ����п�ͷ ��û�гɽ�
         end
     end
else
    Asset.Volume(i) = -volume; 
end;

Asset.Signal(i) = 0.0;
Asset.ClosePrice(i) = DB.Close(i);
end



function ret = ShortVolume(Cash, Price,i)
if i == 1 
    ret = -Cash(i)/Price(i);
else
    ret = -Cash(i-1)/Price(i);
end
end
