function [r] = pei(a,d)
w=windmatlab;

conn=database('gogoal','suntime','admin#123','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.200.200.14;databaseName=gogoal');
if isconnection(conn)==0
    msgbox('连接朝阳永续数据库失败');
    return;
end

formatOut = 'yyyy-mm-dd';

d1=d;
[d2,~,~,~,~,~]=w.tdaysoffset(-20,d);
d2=datestr(datenum(d2),formatOut);
[d3,~,~,~,~,~]=w.tdaysoffset(-60,d);
d3=datestr(datenum(d3),formatOut);
[d4,~,~,~,~,~]=w.tdaysoffset(-120,d);
d4=datestr(datenum(d4),formatOut);

y1=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d1,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d1)),'''']);
y2=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d2,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d2)),'''']);
y3=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d3,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d3)),'''']);
y4=fetch(conn,['SELECT [PEI] FROM CON_PER WHERE con_date=''',d4,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d4)),'''']);
%编辑到这儿经过测试可以
y5=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d1,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d1)),'''']);
y6=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d2,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d2)),'''']);
y7=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d3,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d3)),'''']);
y8=fetch(conn,['SELECT [C7] FROM CON_FORECAST_SW WHERE con_date=''',d4,''' and stock_type=4 and stock_code=''',a,''' and rpt_date=''',num2str(year(d4)),'''']);
y9=num2cell(100*(cell2mat(y1)-cell2mat(y2))/cell2mat(y2));
y10=num2cell(cell2mat(y5)-cell2mat(y6));
close(conn);
r=[y1,y2,y3,y4,y5,y6,y7,y8,y9,y10];