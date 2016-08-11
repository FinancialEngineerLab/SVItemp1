
%***********************************************************%
% INPUT:
% windcode = "600000.SH"
% start_time/end_time = "2013-01-02"
% interval = "day" or "min"
%***********************************************************%
% OUTPUT: 
% DB.Open, DB.High, DB.Low, DB.Close, DB.Size, DB.CurrentIndex 
% �۸�ǰ��Ȩ
%***********************************************************%
function  DB = Data_FromWind(windcode, start_time, end_time, interval, Params)
% ���wind����
try
    w = windmatlab;
catch 
    errordlg('�Ҳ���windmatlab���','MATLAB ERROR');
end 

if strcmp(interval,'day')
    if( strcmp(Params.Strat.Name,'Hurst'))
        [start_time_adj,~,~,~,~,~]=w.tdaysoffset(- (Params.Strat.TimeWindow * 2 + Params.Strat.MAWindow + 1), start_time);
        [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid] = w.wsd(windcode,'open,high,low,close',start_time_adj,end_time, 'PriceAdj=F','Fill=Previous');   %ǰ��Ȩ ��ֵ����֮ǰ��ֵ
    else
        [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid] = w.wsd(windcode,'open,high,low,close',start_time,end_time, 'PriceAdj=F','Fill=Previous');   %ǰ��Ȩ ��ֵ����֮ǰ��ֵ
    end
elseif strcmp(interval,'min')
    if( strcmp(Params.Strat.Name,'Hurst'))
         errdlog('GetWindData: Hurst���Բ���ʹ�÷�������','MATLAB ERROR'); 
    else
        [w_wsi_data,w_wsi_codes,w_wsi_fields,w_wsi_times,w_wsi_errorid,w_wsi_reqid] = w.wsi(windcode,'open,high,low,close',start_time,end_time,'periodstart=09:35:00;periodend=15:00:00','PriceAdj=F','Fill=Previous');
    end
else
    errdlog('GetWindData: interval����ֻ��ȡday����min','MATLAB ERROR');
end 

% ���ߵ���
DB.Open = w_wsi_data(:,1);
DB.High = w_wsi_data(:,2);
DB.Low  = w_wsi_data(:,3);
DB.Close= w_wsi_data(:,4);
DB.Times = w_wsi_times;
DB.Size = length(DB.Open);

if( strcmp(Params.Strat.Name,'Hurst'))
    DB.CurrentIndex = Params.Strat.TimeWindow * 2 + Params.Strat.MAWindow + 2; % ��λ�α�λ�õ������ĳ�ʼ�۸�
    DB.NbTradeDay = DB.Size - Params.Strat.TimeWindow * 2 - Params.Strat.MAWindow - 1;
else
    DB.CurrentIndex = 1; % ��λ�α�λ�õ���һ���۸�
    DB.NbTradeDay = DB.Size;
end
% DualThrust������Ҫ�ĸ�������
if( strcmp(Params.Strat.Name,'DualThrust'))
    DB.shanggui = zeros(DB.Size,1);
    DB.xiagui   = zeros(DB.Size,1);
    DB.buyprice = zeros(DB.Size,1);
    DB.sellprice = zeros(DB.Size,1);
end

% Hurst������Ҫ�ĸ�������
if( strcmp(Params.Strat.Name,'Hurst'))
    DB.PrevNDayHurst = zeros(Params.Strat.PrevNDayHurst,1);
end


end 