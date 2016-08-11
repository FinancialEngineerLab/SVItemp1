using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using UtilityLib;
using System.Configuration;

namespace WuhuaTianbao
{
    public partial class IndustryAnalysis : Form
    {
        private DateTime dtToday = DateTime.Now;

        public IndustryAnalysis()
        {
            InitializeComponent();
        }

        //// 结果生成显示
        //private StockChart CallStockChart(string strCodeMain, string strCodeCmp, DataSet dsInput, List<List<double>> plPermium, List<List<double>> plFractile, string strTitle, Dictionary<string, string> dicPE)
        //{
        //    // 计算起始日
        //    DateTime dtStart = DateTime.Parse("2005-1-7");

        //    GlobalWind.windEnsureStart();
        //    // Main Exhibition Group
        //    double[,] dInputMain = UtilityWindData.getWindSingleStockHistoryPrice(strCodeMain, dtStart, dtToday);
        //    DateTime[] dtDate = UtilityWindData.getWindHistoryDate(strCodeMain, dtStart, dtToday);

        //    // Compare Group
        //    double[,] dInputCmp = UtilityWindData.getWindSingleStockHistoryPrice(strCodeCmp, dtStart, dtToday);

        //    // Open StockChart
        //    StockChart sc = new StockChart(dtDate, dInputMain, dInputCmp, comboBox1.SelectedItem.ToString(), comboBox2.SelectedItem.ToString(), plPermium, plFractile, dsInput, strTitle, dicPE);

        //    return sc;
        //}

        

        private void ParamsImport_Click(object sender, EventArgs e)
        {
            //GlobalWind.windEnsureStart();
            ////行业历史数据
            //double[] dIndustryHistoryPrice = null;
            ////指数历史数据
            //double[] dIndexHistoryPrice = null;

            // 获取代码
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string strIndustryCode = NCSection[comboBox1.SelectedItem.ToString()].ToString();
            NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("IndexNameToCode");
            string strIndexCode = NCSection[comboBox2.SelectedItem.ToString()].ToString();

            string strIndustryName = comboBox1.SelectedItem.ToString();
            string strIndexName = comboBox2.SelectedItem.ToString();
            List<string> lsInputParams = new List<string> { strIndustryCode, strIndustryName, strIndexCode, strIndexName };

            //// 获取历史数据
            //dIndexHistoryPrice = UtilityWindData.getWindIndustryHistoryPrice(strIndexCode, "2005-1-7", dtToday.ToShortDateString(), "close");
            //dIndustryHistoryPrice = UtilityWindData.getWindIndustryHistoryPrice(strIndustryCode, "2005-1-7", dtToday.ToShortDateString(), "close");


            ///* --------------------------------------------输入变量---------------------------------------------- */
            //// 计算超额收益
            //List<List<double>> plPermium = UtilityMath.getMultiPeriodExcessReturnOverIndex(dIndustryHistoryPrice, dIndexHistoryPrice, Main.iHorizon);
            //// 计算历史分位数
            //List<List<double>> plFractile = UtilityMath.getMultiPeriodFractile(plPermium, Main.iHorizon);
            //// 生成DataView
            //DataSet dsPrem = IndexPremium(plPermium, plFractile);
            //// 超额收益部分标题
            //string strTitle = dtToday.ToShortDateString() + " 当日 " + comboBox1.SelectedItem.ToString() + "板块 相对 " + comboBox2.SelectedItem.ToString() + "指数 超额收益及其分位数";
            //// PE 相关数据
            //Dictionary<string, string> dicPE = UtilityZhaoYangData.getPE_PB_ROE_Quantile_Data(strIndustryCode, strIndexCode);
            //dicPE = UtilityMySQLData.getMySQLVolAmtAndOtherData(strIndustryCode, strIndustryName, dicPE);
            ///* --------------------------------------------调用显示---------------------------------------------- */

            StockChart sc = new StockChart(lsInputParams);
            sc.Show();
            this.Close();
        }
    } 
}
