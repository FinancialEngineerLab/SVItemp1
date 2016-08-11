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

function Asset = TradingAccount_Buy(DB,Asset,volume,price,flag_tradeprice,Params)
%��ǰK��λ��
i = DB.CurrentIndex;
flag_volume_determined_method = Params.Execution.UseCompoundVolume;

%�ɽ���
if(strcmpi(flag_tradeprice,'CLOSE'))
    Asset.Price(i)  = DB.Close(i); %�ɽ��� ��Ϊ��
else
    Asset.Price(i) = price;
end

%�ɽ����� ����Ϊ��
if flag_volume_determined_method ==1 
    if Asset.CurrentPosition>0 % ����Ѿ��гֲֵĻ� �ͼ������� û�гɽ�
        Asset.Volume(i) = 0;
    elseif Asset.CurrentPosition<0 % ֮ǰ�п�ͷ
        Asset.Volume(i) = -Asset.CurrentPosition + (Asset.Cash(i-1) + Asset.CurrentPosition * Asset.Price(i))/Asset.Price(i);  % ƽ����ͷ ������ͷ - �ڿ����յ������
    else
        Asset.Volume(i) = LongVolume(Asset.Cash, Asset.Price,i);%֮ǰ�޿�ͷ, ����
    end 
else
    Asset.Volume(i) = volume; 
end

Asset.Signal(i) = 1.0;
Asset.ClosePrice(i) = DB.Close(i);

end




function ret = LongVolume(Cash, Price,i)
if i == 1 
    ret = Cash(i)/Price(i);
else
    ret = Cash(i-1)/Price(i);
end
end