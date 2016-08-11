% dualthrust2��ҹ
%***********************************************************%
% INPUT:
% DB = price data series
% Params = ���ײ��ԵĲ���
% Params.id ="399905.SZ";+
% Params.ns = �Ϲ�����
% Params.nx = �¹�����
% Params.ks = �Ϲ�ϵ��
% Params.kx = �¹�ϵ��
%***********************************************************%
% OUTPUT: 
% Signal = 'BUY'/'SELL' signals
%***********************************************************%

function [Signal,DB] = Strategy_Dualthrust2(DB,Asset,Params)

Signal.Action = 'NULL';
ns = Params.Strat.ns;
nx = Params.Strat.nx;
ks = Params.Strat.ks;
kx = Params.Strat.kx;
stockid = Params.Strat.id;%'399905.SZ';

if (DB.CurrentIndex>1) 
  date0 = DB.Times(DB.CurrentIndex-1);
else
  date0 = 1;
end
date  = DB.Times(DB.CurrentIndex);

%ͬһ��ķ����߲���Ҫ�ټ������¹죬ֱ������ǰһ�������ߵ����¹죻
if (fix(date) > fix(date0)) 
   DB_Local = GetShangXiaGuiDB(stockid, date); 
   xiagui   = dualthrust2_xiagui(nx,kx,DB_Local);   %�¹�ļ��㺯��
   shanggui = dualthrust2_shanggui(ns,ks,DB_Local); %�Ϲ�ļ��㺯��
   DB.shanggui(DB.CurrentIndex) = shanggui;
   DB.xiagui(DB.CurrentIndex)  = xiagui;
   
elseif  (DB.CurrentIndex>1) 
   xiagui   = DB.xiagui(DB.CurrentIndex-1);
   shanggui = DB.shanggui(DB.CurrentIndex-1);
   DB.shanggui(DB.CurrentIndex) = shanggui;
   DB.xiagui(DB.CurrentIndex)  = xiagui;
   
end
%Asset.Signal(DB.CurrentIndex-1)
if(DB.High(DB.CurrentIndex) > shanggui)     % ��߼��ϴ��Ϲ� ��
    Signal.Action = 'BUY';
    DB.buyprice(DB.CurrentIndex) = max(shanggui,DB.Open(DB.CurrentIndex));
elseif (DB.Low(DB.CurrentIndex) < xiagui)   % ��ͼ��´��¹�  ��
    Signal.Action = 'SELL';
    DB.sellprice(DB.CurrentIndex) = min(xiagui,DB.Open(DB.CurrentIndex));
end

end






% �������¹������
function DB = GetShangXiaGuiDB(stockid, date)
w = windmatlab;
[w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd(stockid,'open,high,low,close','ED-20D',date,'Fill=Previous','PriceAdj=F');
% ���ߵ���
DB.Open = w_wsd_data(:,1);
DB.High = w_wsd_data(:,2);
DB.Low  = w_wsd_data(:,3);
DB.Close= w_wsd_data(:,4);
DB.Times = w_wsd_times;
DB.Size = length(DB.Open);

end

% stockid ="399905.SZ";
% ns = 3;     %�Ϲ�����
% nx = 2;     %�¹�����
% ks = 0.2;   %�Ϲ�ϵ��
% kx = 0.4;   %�¹�ϵ��
function xiagui = dualthrust2_xiagui(ns,ks,DB)

k = length(DB.Open); 
nhs = DB.High(k-ns:k-1);   %%����ns
ncs = DB.Close(k-ns:k-1);
nls = DB.Low(k-ns:k-1);
nhh = max(nhs);
nhc = max(ncs);
nlc = min(ncs);
nll = min(nls);
ranges = max(nhh-nlc,nhc-nll);
xiagui = DB.Open(k)-ks*ranges;  %%����ks     

end


function shanggui = dualthrust2_shanggui(ns,ks,DB)
 k = length(DB.Open); 
   
%%�Ϲ�ļ���
nhs = DB.High(k-ns:k-1);   %%����ns
ncs = DB.Close(k-ns:k-1);
nls = DB.Low(k-ns:k-1);
nhh = max(nhs);
nhc = max(ncs);
nlc = min(ncs);
nll = min(nls);
ranges = max(nhh-nlc,nhc-nll);
shanggui = DB.Open(k)+ks*ranges;  %%����ks

end


