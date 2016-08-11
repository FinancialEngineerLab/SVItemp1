using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.OleDb;
using System.IO;
using System.Diagnostics;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;

namespace SuperNova
{

    public partial class Form1 : Form
    {
        DBOperation dbOper = new DBOperation();
        DataTableOperation dtOper = new DataTableOperation();
        StringOperation strOper = new StringOperation();
        OleDbConnection OleCon = new OleDbConnection();
        DataSet dsOutputData1 = new DataSet();
        DataSet dsOutputData_ZhongcangGu = new DataSet();
        DataSet dsOutputData_NAV = new DataSet();
        DataTable dtZCGList = new DataTable();
       

        static int iOpenFrm2 = 0;
        static int iOpenFrm3 = 0;
        Form2 frm2;
        Form3 frm3;

        string strExportXLSPath = @"\\10.90.100.180\lhtz\SuperNova\重仓股数据\";
        string strExportMDBPath = @"\\10.90.100.180\lhtz\SuperNova\重仓股数据\ZCG.mdb";
        string strHS300FilePath = @"\\10.90.100.180\lhtz\Data\IndexCompo\HS300.txt";

        // 提取基金编号和敞口等信息的SQL语句
        /*string sSQL1 = "select aa.fundid 编号,aa.fundname 基金名称,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值,"
            + "round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产, bb.en_nav 单位净值,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口," +
            "round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口  from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2) duo1," +
            "round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) duo2,round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2) kong  from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c "+
            "where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and (b.vc_mixed_type is null or b.vc_mixed_type like '%B') and a.l_current_amount > 0 and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id ";*/
        /*string sSQL1 = "select aa.fundid 基金编号,aa.fundname 基金名称,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值,"
            + "round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,bb.en_nav 单位净值,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口,"+
            "round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口  from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2) duo1,"+
            "round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) duo2,round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2) kong  from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c "+
            "where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id ";
        */

        //  string sSQL1 = "select aa.fundid 基金编号,aa.fundname 基金名称,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值,round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,bb.en_nav 单位净值,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口,round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口 "
        //+ "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)+nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2),0) duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) +nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2),0)duo2,nvl(round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2)-round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2),0) kong "  
        //        + "from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id";

        //string sSQL1 = "select aa.fundid 基金编号,aa.fundname 基金名称,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值,round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,bb.en_nav 单位净值,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口,round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口， round(aa.duo1/bb.en_fund_value*100,2)/100 不含停牌_仓位，round(aa.duo2/bb.en_fund_value*100,2)/100 含停牌_仓位 "
          //+ "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)+nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) +nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0)duo2,nvl(round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*decode(substr(a.vc_inter_code,1,2),'IC',200,300)),2)-round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) kong "
                  //+ "from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id and aa.duo1 >10000";

        string sSQL2 = "select aa.fundid 基金编号,aa.fundname 基金名称,bb.en_nav 单位净值，round(aa.duo2/bb.en_fund_value*100,2)/100 含停牌_仓位, round(aa.duo2/bb.en_fund_value*100,2)/100-round(aa.duo1/bb.en_fund_value*100,2)/100 停牌_占比, round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值,round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口,round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口， round(aa.duo1/bb.en_fund_value*100,2)/100 不含停牌_仓位 "
            + "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)+nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) +nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0)duo2,nvl(round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*decode(substr(a.vc_inter_code,1,2),'IC',200,300)),2)-round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) kong "
            + "from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id and aa.duo1 >10000";

        string sSQL1 = "select aa.fundid 基金编号,aa.fundname 基金名称,round(bb.en_fund_value/10000) 基金净资产, bb.en_nav 单位净值，round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口, round(aa.duo2/bb.en_fund_value*100,2)/100 含停牌_仓位, round(aa.duo2/bb.en_fund_value*100,2)/100-round(aa.duo1/bb.en_fund_value*100,2)/100 停牌_占比  "
            + "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)+nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) +nvl(round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0)duo2,nvl(round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*decode(substr(a.vc_inter_code,1,2),'IC',200,300)),2)-round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*decode(substr(a.vc_inter_code,1,2),'IC',200,300)*decode(b.c_asset_class,'9',b.en_last_price)),2),0) kong "
            + "from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id and aa.duo1 >10000";
           

        // 提取基金持仓信息的SQL语句
        // 不包含停牌
        string sSQL_ZhongcangGu = "select b.vc_fund_name 基金名称,t.vc_inter_code 股票代码,c.vc_stock_name 股票名称,t.l_current_amount 股票数量,"
                                + "round(decode (c.c_market_no,'7',t.en_current_cost/(300*t.l_current_amount),t.en_untransfered_invest/t.l_current_amount),3) 成本, c.en_last_price 市价,c.en_yesterday_close_price  昨日收盘价 "
                                 + "from trade.tfundstock t,trade.tfundinfo b,trade.tstockinfo c "
                                + "where t.l_fund_id = b.l_fund_id and t.vc_inter_code = c.vc_inter_code and t.l_current_amount > 0 and t.l_current_amount>1000 and (t.vc_inter_code not "
                                + "like 'I%' and c.vc_stock_name not "
                                + "like '___G%' and c.vc_stock_name not "
                                + "like '%货币%' and c.vc_stock_name not like '%添益%' and c.vc_stock_name not like '%日利' and c.vc_stock_name not like '理财%') and c.c_stop_flag <>1  and t.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id)"
                                + "order by t.l_fund_id, vc_stock_name";
        // 提取基金净资产的SQL语句
        string sSQL_NAV = "select aa.fundname 基金名称,bb.en_fund_value 基金净资产, bb.en_nav 单位净值 "
           + "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2) duo1," +
           "round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) duo2,round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2) kong  from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c " +
           "where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and (b.vc_mixed_type is null or b.vc_mixed_type like '%B') and a.l_current_amount > 0 and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id ";


        public Form1()
        {
            InitializeComponent();
        }
        
        //******************************************** Main functions **************************************************
        private void refreshDataGridView()
        {
            if (checkBox2.CheckState == CheckState.Unchecked)
            {
                dgvOutput.DataSource = dsOutputData1.Tables[0];
                dgvOutput.Columns[0].Width = 45;  //产品编号
                dgvOutput.Columns[1].Width = 130; // 产品名称
                dgvOutput.Columns[2].Width = 110;  //净资产
                dgvOutput.Columns[2].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[3].Width = 110;  //净值
                dgvOutput.Columns[3].DefaultCellStyle.Format = "0.000";
                dgvOutput.Columns[4].Width = 110;  //敞口含停牌
                dgvOutput.Columns[4].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[5].Width = 110;  //仓位含停牌
                dgvOutput.Columns[5].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[6].Width = 110;  //停牌占比
                dgvOutput.Columns[6].DefaultCellStyle.Format = "0.00%";
            }
            else
            {
                dgvOutput.DataSource = dsOutputData1.Tables[0];
                dgvOutput.Columns[0].Width = 25;  //产品编号
                dgvOutput.Columns[1].Width = 130; // 产品名称
                dgvOutput.Columns[2].Width = 50;  //净值
                dgvOutput.Columns[2].DefaultCellStyle.Format = "0.000";
                dgvOutput.Columns[3].Width = 70;  //仓位含停牌
                dgvOutput.Columns[3].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[4].Width = 70;  //停牌占比
                dgvOutput.Columns[4].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[5].Width = 80;  // 多头不含停牌
                dgvOutput.Columns[5].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[6].Width = 80; //多头含停牌
                dgvOutput.Columns[6].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[7].Width = 80; //空头
                dgvOutput.Columns[7].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[8].Width = 80;  //净资产
                dgvOutput.Columns[8].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[9].Width = 70;  //敞口不含停牌
                dgvOutput.Columns[9].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[10].Width = 70;  //敞口含停牌
                dgvOutput.Columns[10].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[11].Width = 70;  //仓位不含停牌
                dgvOutput.Columns[11].DefaultCellStyle.Format = "0.00%";
            }

            if (dgvOutput.ColumnCount > 12) // datagridview for fut computation
            {
                dgvOutput.Columns[0].Width = 25;  //产品编号
                dgvOutput.Columns[1].Width = 130; // 产品名称
                dgvOutput.Columns[2].Width = 45;  //净值
                dgvOutput.Columns[2].DefaultCellStyle.Format = "0.000";
                dgvOutput.Columns[3].Width = 70;  //仓位含停牌
                dgvOutput.Columns[3].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[4].Width = 70;  //停牌占比
                dgvOutput.Columns[4].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[5].Width = 80;  // 多头不含停牌
                dgvOutput.Columns[5].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[6].Width = 80; //多头含停牌
                dgvOutput.Columns[6].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[7].Width = 80; //空头
                dgvOutput.Columns[7].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[8].Width = 65;  //净资产
                dgvOutput.Columns[8].DefaultCellStyle.Format = "0,000";
                dgvOutput.Columns[9].Width = 70;  //敞口不含停牌
                dgvOutput.Columns[9].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[10].Width = 70;  //敞口含停牌
                dgvOutput.Columns[10].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[11].Width = 70;  //仓位不含停牌
                dgvOutput.Columns[11].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[12].Width = 65;  //目标敞口
                dgvOutput.Columns[12].DefaultCellStyle.Format = "0.00%";
                dgvOutput.Columns[13].Width = 60;  //目标敞口
                dgvOutput.Columns[13].DefaultCellStyle.Format = "0.0";
            }
        }
   
        private void button1_Click(object sender, EventArgs e)
        {
            dbOper.connectToOracleDB(OleCon);
            if(checkBox2.CheckState == CheckState.Unchecked)
            {
                dbOper.filterOutData(OleCon, sSQL1, dsOutputData1);
            }
            else
            {
                dbOper.filterOutData(OleCon, sSQL2, dsOutputData1);
            }
            OleCon.Close();
            refreshDataGridView();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string sSQL = " select t.en_last_price 期货价格 from trade.tstockinfo t where t.c_market_no='7'  and t.vc_report_code= '" + textBox2.Text + "'";
            string strFutPriceTemp = null;
            double dTargetExposure = 0.0;
            string sSQLNew = null;

            if (OleCon.State == ConnectionState.Closed)
            {
                dbOper.connectToOracleDB(OleCon);
            }
            
            OleDbCommand OleCmd = new OleDbCommand(sSQL);
            OleDbDataAdapter OleDa = new OleDbDataAdapter(sSQL, OleCon);
            DataSet dsOutputDataTemp = new DataSet();

            OleDa.Fill(dsOutputDataTemp);
            OleDa.Dispose();

            if(dsOutputDataTemp.Tables[0].Rows.Count == 0)
            {
                MessageBox.Show("请确认期货品种代码！");
                return;
            }
            strFutPriceTemp = dsOutputDataTemp.Tables[0].Rows[0]["期货价格"].ToString();


            try
            {
                dTargetExposure = double.Parse(targetExposure.Text);
                if (dTargetExposure > 1 || dTargetExposure < 0)
                {
                    MessageBox.Show("目标敞口必须介于0-1！");
                    return;
                }
            }
            catch(Exception)
            {
                MessageBox.Show("目标敞口请正确设置！");
                return;
            }

            if (checkBox1.Checked == false) //不包含停牌
            {
                sSQLNew = "select aa.fundid 编号,aa.fundname 基金名称,bb.en_nav 单位净值,round(aa.duo2/bb.en_fund_value*100,2)/100 含停牌_仓位，round(aa.duo2/bb.en_fund_value*100,2)/100-round(aa.duo1/bb.en_fund_value*100,2)/100 停牌_占比,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值," +
               "round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口," +
               "round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口,round(aa.duo1/bb.en_fund_value*100,2)/100 不含停牌_仓位，"
               + targetExposure.Text + " 目标敞口,(aa.duo1 - bb.en_fund_value*" + (dTargetExposure).ToString() + " - kong ) / (" + strFutPriceTemp +
                "300) 期货调整手数 ";
               //"*decode(substr(a.vc_inter_code,1,2),'IC',200,300)) 期货调整手数 ";
            }
            else
            {
                sSQLNew = "select aa.fundid 编号,aa.fundname 基金名称,bb.en_nav 单位净值, round(aa.duo2/bb.en_fund_value*100,2)/100 含停牌_仓位，round(aa.duo2/bb.en_fund_value*100,2)/100-round(aa.duo1/bb.en_fund_value*100,2)/100 停牌_占比,round(aa.duo1/10000) 不含停牌多头市值,round(aa.duo2/10000) 含停牌_多头市值," +
                "round(aa.kong/10000) 空头市值,round(bb.en_fund_value/10000) 基金净资产,round((aa.duo1-aa.kong)/bb.en_fund_value *100,2)/100 不含停牌_敞口," +
                "round((aa.duo2-aa.kong)/bb.en_fund_value *100,2)/100 含停牌敞口,round(aa.duo1/bb.en_fund_value*100,2)/100 不含停牌_仓位，"
                + targetExposure.Text + " 目标敞口,(aa.duo2 - bb.en_fund_value*" + (dTargetExposure).ToString() + " - kong ) / (" + strFutPriceTemp +
            "*300) 期货调整手数 ";
            
            /*+"from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode (b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)" +
            " duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) duo2,round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2) kong  from trade.tfundstock a," +
            "trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_current_amount > 0 and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id )" +
            " aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id";*/
            }
            sSQLNew = sSQLNew + "from (select a.l_fund_id fundid,min(c.vc_fund_name) fundname,round(sum( decode(b.c_stop_flag,'1',0,decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0))*a.l_current_amount),2)+round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2) duo1,round(sum( decode(b.c_asset_class,'2',b.en_last_price,'4',b.en_last_price,0)*a.l_current_amount),2) +round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2)duo2,round(sum(decode(b.c_asset_class,'9',b.en_last_price,0)*a.l_current_amount*300),2)-round(sum(decode(a.c_position_flag,'1',a.l_current_amount,0)*300*decode(b.c_asset_class,'9',b.en_last_price)),2) kong "  
                + "from trade.tfundstock a,trade.tstockinfo b,trade.tfundinfo c where a.vc_inter_code=b.vc_inter_code(+) and  a.l_fund_id=c.l_fund_id and a.l_current_amount > 0 and (b.vc_mixed_type is null or b.vc_mixed_type like '%B%' and b.vc_mixed_type not like 'B2') and a.l_fund_id in (select l_fund_id from trade.TOPFUNDRIGHT where l_operator_no=8208 group by l_fund_id) group by a.l_fund_id ) aa, trade.tfundasset bb where aa.fundid = bb.l_fund_id";
        
            dbOper.filterOutData(OleCon, sSQLNew, dsOutputData1);
            OleCon.Close();
            refreshDataGridView();
        }




        // **************************************************************************************************
        // *************************************重仓股*************************************************

        
        // 创建重仓股列表
        private void createDataTable_ZhongcangGu(int iUseForStressTest = 0)
        {
             DataRow[] drStockVolList = null;
             DataRow drSumStockPctList = null;
             double dNAV = 0;
             double dStockVol = 0;
             double dSumStockVol = 0;
             double dStockReturn = 0;
             string strStockCode = null;
             string[] strHS300StockList = null;
             double dNbStock = 0; 
             double dSumNbStock = 0;
             int iStartCol = 5;

            //************************************************************
             // 股票名称 / 股票代码 / 总持仓 /总市值 / 当日涨跌幅 /  产品1 / 产品2 / .....
            //*************************************************************

             // 创建一个重仓股的DataTable
             // 取得无重复的股票名称列表
            dtZCGList = dsOutputData_ZhongcangGu.Tables[0].DefaultView.ToTable(true,"股票名称");

            dtZCGList.Columns.Add("股票代码", typeof(string));
            dtZCGList.Columns.Add("总持仓", typeof(double));
            dtZCGList.Columns.Add("总市值", typeof(double));
            dtZCGList.Columns.Add("当日涨幅", typeof(double));

            //  取得无重复的产品名 => 产品名字横向放置  
            DataTable drProductList = dsOutputData_ZhongcangGu.Tables[0].DefaultView.ToTable(true, "基金名称");
            for (int i = 0; i < drProductList.Rows.Count; i++)
            {
                dtZCGList.Columns.Add(drProductList.Rows[i][0].ToString(), typeof(double));
            }

            // 取得基金产品的净资产
            dbOper.filterOutData(OleCon,sSQL_NAV, dsOutputData_NAV);
            
            // 在drZCGList中对每个产品的持仓进行填充
            for (int i = 0; i < dtZCGList.Rows.Count; i++)
            {
                dSumStockVol = 0;
                dStockReturn = 0;
                strStockCode = null;
                dSumNbStock = 0;

                for (int j = iStartCol; j < dtZCGList.Columns.Count; j++)
                {
                    drStockVolList = dsOutputData_ZhongcangGu.Tables[0].Select("股票名称='" + dtZCGList.Rows[i][0].ToString() + "'" +
                        "and 基金名称='" + drProductList.Rows[j - iStartCol]["基金名称"].ToString() + "'");
                    if (drStockVolList.Length == 0) // 如果产品没有该只股票的持仓
                    {
                        dtZCGList.Rows[i][j] = 0.0;
                        dStockVol = 0.0;
                        dNbStock = 0.0;
                    }
                    else
                    {
                        if (dStockReturn == 0)// 如果当日涨幅还没有赋值
                        {
                            dStockReturn = double.Parse(drStockVolList[0].ItemArray[5].ToString()) - double.Parse(drStockVolList[0].ItemArray[6].ToString());
                            dStockReturn /= double.Parse(drStockVolList[0].ItemArray[6].ToString());
                        }
                        dStockVol = double.Parse(drStockVolList[0].ItemArray[3].ToString()) * double.Parse(drStockVolList[0].ItemArray[5].ToString());
                        dNbStock = double.Parse(drStockVolList[0].ItemArray[3].ToString());

                        dNAV = strOper.getFundNAV(drProductList.Rows[j - iStartCol]["基金名称"].ToString(), dsOutputData_NAV.Tables[0]);
                        //dNAV = double.Parse(dsOutputData_NAV.Tables[0].Rows[j - iStartCol][1].ToString()); 
                        dtZCGList.Rows[i][j] = dStockVol / dNAV;
                    }
                    dSumStockVol += dStockVol;
                    dSumNbStock += dNbStock;
                    //strStockCode = drStockVolList[0].ItemArray[1].ToString();
                    if (drStockVolList.Length != 0)
                    {
                        strStockCode = strOper.convertToWindCode(drStockVolList[0].ItemArray[1].ToString());
                    }               
                }
                dtZCGList.Rows[i]["股票代码"] = strStockCode; // 股票代码
                dtZCGList.Rows[i]["总持仓"] = dSumNbStock; // 股票数量
                dtZCGList.Rows[i]["总市值"] = dSumStockVol; // 总市值
                dtZCGList.Rows[i]["当日涨幅"] = dStockReturn; // 当日涨幅
            }
            dtZCGList.DefaultView.Sort = "总市值 desc";
            
            
            // 插入一行 计算持仓总和
            drSumStockPctList = dtZCGList.NewRow();
            drSumStockPctList[2] = dtOper.getColumnSum(dtZCGList, 2);
            drSumStockPctList[3] = dtOper.getColumnSum(dtZCGList, 3);

            for( int j = iStartCol; j < dtZCGList.Columns.Count; j++)
            {

                drSumStockPctList[j] = dtOper.getColumnSum(dtZCGList, j);
            }
            dtZCGList.Rows.InsertAt(drSumStockPctList, 0);

            //填入表首空白单元格
            dtZCGList.Rows[0]["股票名称"] = "#N/A";
            dtZCGList.Rows[0]["股票代码"] = "#N/A";

            //计算持仓总涨跌幅
            dtZCGList.Rows[0]["当日涨幅"] = dtOper.weightedAverage(dtZCGList, iStartCol - 2, iStartCol - 1);   // iStartCol - 2 总持仓； iStartCol - 1 总市值
            
            if(iUseForStressTest != 0)
            {
                // 检查是否属于沪深300成分股
                strHS300StockList = strOper.readStockList(strHS300FilePath);
                dtZCGList.Columns.Add("沪深300", typeof(bool));
                //  第一行因为是各产品的持仓总和 =》 此处标记为不属于沪深300
                for(int i = 0; i < dtZCGList.Rows.Count; i++)
                {
                    dtZCGList.Rows[i]["沪深300"] = strOper.isInStockList(dtZCGList.Rows[i]["股票代码"].ToString(), strHS300StockList);
                }
            }

            
        }

         private void refreshDataGridView_ZhongcangGu()
        {
            // 把重仓股列表传递给Form2

            // 此处设置成每次点击按钮都会重新打开一个datagridview
            if (iOpenFrm2 == 1)
            {
                frm2.Close();
            }
            
             frm2 = new Form2();
             iOpenFrm2 = 1;
            
            frm2.refreshDataGridView_ZhongcangGu(dtZCGList);
            frm2.Show();
            frm2.reformatDataGridView_ZhongcangGu();
                         
        }

        private void button3_Click(object sender, EventArgs e)
        {
            // 检查数据库链接
            if (OleCon.State == ConnectionState.Closed)
            {
                dbOper.connectToOracleDB(OleCon);
            }

            // 筛选出数据 
            dbOper.filterOutData(OleCon, sSQL_ZhongcangGu, dsOutputData_ZhongcangGu);
            OleCon.Close();

            createDataTable_ZhongcangGu();
            refreshDataGridView_ZhongcangGu();

            if (comboBox1.SelectedIndex == 1)
            {
                dtOper.exportToAccess(dtZCGList, strExportMDBPath);
            }
            else if (comboBox1.SelectedIndex == 2)
            {
                dtOper.exportToExcel(dtZCGList, strExportXLSPath);
            }
           
        }

        // ******************************************************************************************
        // ***************************** 压力测试 ***************************************************
     
        // 打开Form3, 并把需要的数据传递给Form3
        private void button4_Click(object sender, EventArgs e)
        {
            // 检查数据库链接
            if (OleCon.State == ConnectionState.Closed)
            {
                dbOper.connectToOracleDB(OleCon);
            }

            // 筛选出数据 
            dbOper.filterOutData(OleCon, sSQL_ZhongcangGu, dsOutputData_ZhongcangGu);
            OleCon.Close();

            // 整理成各产品的重仓股表格，包含是否为沪深300成分股的信息
            createDataTable_ZhongcangGu(1);

            if (iOpenFrm3 == 1)
            {
                frm3.Close();
            }

            frm3 = new Form3();
            iOpenFrm3 = 1;

            frm3.Show();
            frm3.setDataTable(dtZCGList,
                              dsOutputData_NAV.Tables[0],
                              dsOutputData_ZhongcangGu.Tables[0].DefaultView.ToTable(true, "基金名称"));
        }

      

       

       /* private void button4_Click(object sender, EventArgs e)
        {
            // 检查数据库链接
            if (OleCon.State == ConnectionState.Closed)
            {
                dbOper.connectToOracleDB(OleCon);
            }

            // 筛选出数据 
            dbOper.filterOutData(OleCon, sSQL_ZhongcangGu, dsOutputData_ZhongcangGu);
            OleCon.Close();

            // 整理成各产品的重仓股表格，包含是否为沪深300成分股的信息
            createDataTable_ZhongcangGu(1);

            if (iOpenFrm3 == 1)
            {
                frm3.Close();
            }

            frm3 = new Form3();
            iOpenFrm3 = 1;

            frm3.Show();
            frm3.setDataTable(dtZCGList,
                              dsOutputData_NAV.Tables[0],
                              dsOutputData_ZhongcangGu.Tables[0].DefaultView.ToTable(true, "基金名称"));

        }*/

       


       
    }
}
