%***********************************************************%
% INPUT:
% DB = price data series
% Asset = intial trading account asset
%***********************************************************%
% OUTPUT: 
% Asset = new trading account asset after clearing 
%***********************************************************%

function Asset = TradingAccount_Clearing(DB,Asset,Params)
%��ǰK��λ��
i = DB.CurrentIndex;
iAllowShort = Params.Execution.AllowShort;

%���µ�ǰ�ֲ�
if(i == 1)
    Asset.CurrentPosition = Asset.Volume(i); 
else
    Asset.CurrentPosition = Asset.Volume(i) + Asset.Position(i-1);  
end


% ��ʼ�ֽ�Ϊ1.0
if iAllowShort == 0  %ֻ����
    if Asset.Volume(i)>0 %��ǰ���� 
        Asset.Cash(i) = 0.0;  %�гֲ�����ζ���ֽ�ȫ�����������˱��
    elseif Asset.Volume(i)<0 % ��ǰ����
        if i >1
            if Asset.Position(i-1) >0  % ��ʱ�������ֲ�
                Asset.Cash(i) = Asset.Position(i-1)*Asset.Price(i); %��ʱ���ȫ������
            else
                Asset.Cash(i) = Asset.Cash(i-1); %���������ʾ����ﻹû���ף�һֱ�����ֽ�
            end
        else 
            errordlg('TradingAccount_Clearing: ���������յ������,��һʱ�������','MATLAB ERROR');
        end
    else
        if i>1
            Asset.Cash(i) =  Asset.Cash(i-1);
        end 
    end
else   %��������
    if Asset.Volume(i)>0    %��ǰ����  
        Asset.Cash(i) = 0.0;  %ƽ��ͷ�������࣬�ֽ�ȫ�����������˱��
    elseif Asset.Volume(i)<0    %��ǰ����  
        if i == 1
            Asset.Cash(i) = Asset.Cash(i) -  Asset.CurrentPosition *Asset.Price(i);
        else
            if Asset.Position(i-1) > 0
                Asset.Cash(i) = 2*Asset.Position(i-1)*Asset.Price(i);%ƽ����ͷ,������
            elseif Asset.Position(i-1) == 0
                Asset.Cash(i) =Asset.Cash(i-1) - Asset.Volume(i)*Asset.Price(i);% ��������  
            end
        end
    else % ʲô������
        if i >1
            Asset.Cash(i) = Asset.Cash(i-1);
        end
    end
end

Asset.Position(i) = Asset.CurrentPosition; 
Asset.Times(i) = DB.Times(i);
end