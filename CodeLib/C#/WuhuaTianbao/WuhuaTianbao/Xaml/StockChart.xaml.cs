using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO;
using System.Reflection;
using System.Globalization;
using WAPIWrapperCSharp;
using UtilityLib;


namespace WuhuaTianbao
{
    /// <summary>
    /// Interaction logic for StockChart.xaml
    /// </summary>

    public partial class StockChart : Window
    {
        
        public List<UtilityChartInfo> Data { get; set; }

        private string stockName;
        private string strIndustryCode;
        private string strIndexCode;

        List<List<double>> dPermium = null;
        List<List<double>> dFractile = null;
        DateTime[] dtTimeSeries = null;

        public StockChart(List<string> lsInputParams)
        {
            InitializeComponent();

            strIndustryCode = lsInputParams[0];
            string strIndustryName = lsInputParams[1];
            strIndexCode = lsInputParams[2];
            string strIndexName = lsInputParams[3];

            object[] objExcessReturn = ParamsCalculate(strIndustryCode, strIndexCode, strIndustryName);
            dtTimeSeries = (System.DateTime[])objExcessReturn[2];
            dPermium = ((List<List<double>>)(objExcessReturn[3]));
            dFractile = ((List<List<double>>)(objExcessReturn[4]));

            // 生成作图所用数据
            LoadData(dtTimeSeries, (double[,])objExcessReturn[0], (double[,])objExcessReturn[1], strIndustryName, strIndexName);
            stockSet1.ItemsSource = Data;

            // DataGrid 标题
            label1.Content = DateTime.Now.ToShortDateString() + " 当日 " + strIndustryName + "板块 相对 " + strIndexName + "指数 超额收益及其分位数"; ;
            //dataGrid1.ItemsSource = ((DataSet)objExcessReturn[5]).Tables[0].DefaultView;
            textBox16.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][1].ToString();
            textBox17.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][1].ToString();
            textBox18.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][2].ToString();
            textBox19.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][2].ToString();
            textBox20.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][3].ToString();
            textBox21.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][3].ToString();
            textBox22.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][4].ToString();
            textBox23.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][4].ToString();
            textBox24.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][5].ToString();
            textBox25.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][5].ToString();
            textBox26.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[0][6].ToString();
            textBox27.Text = (((DataSet)objExcessReturn[5]).Tables[0]).Rows[1][6].ToString();

            Dictionary<string, string> dicPE = (Dictionary<string, string>)objExcessReturn[6];

            // PE相关赋值
            textBox1.Text = dicPE["PE"];
            textBox2.Text = dicPE["PB"];
            textBox3.Text = dicPE["相对PE"];
            textBox4.Text = dicPE["相对PB"];
            textBox5.Text = dicPE["PE分位数"];
            textBox6.Text = dicPE["PB分位数"];
            textBox7.Text = dicPE["相对PE分位数"];
            textBox8.Text = dicPE["相对PB分位数"];
            textBox9.Text = dicPE["ROE"];
            textBox10.Text = dicPE["净利同比"];
            textBox11.Text = dicPE["周频换手率"];
            textBox12.Text = dicPE["周频量比"];
            textBox13.Text = dicPE["周频成交金额"];
            textBox14.Text = dicPE["周频成交量"];
    
        }

        private List<UtilityChartInfo> LoadStockInfo(DateTime[] dtDate, double[,] plInputMain, double[,] plInputCmp, string strName = null)
        {
            stockName = strName;

            var res = new List<UtilityChartInfo>();

            for (int i = 0; i < dtDate.Length; i++ )
            {
                DateTime date = dtDate[i];
                double open = double.Parse(plInputMain[i, 0].ToString());
                double high = double.Parse(plInputMain[i, 1].ToString());
                double low = double.Parse(plInputMain[i, 2].ToString());
                double close = double.Parse(plInputMain[i, 3].ToString());
                // close2 存储用于生成比较用趋势线的参考指数收盘价
                double close2 = double.Parse(plInputCmp[i, 3].ToString());
                double volumn = double.Parse(plInputMain[i, 4].ToString());

                res.Add
                    (
                    new UtilityChartInfo
                        {
                            date = date,
                            open = open,
                            high = high,
                            low = low,
                            close = close,
                            close2 = close2,
                            volume = volumn
                        }
                    );
            }
            return res;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            this.DataContext = this;
        }

        private void LoadData(DateTime[] dtDate, double[,] dInputMain, double[,] dInputCmp, string strNameMain, string strNameCmp)
        {
            Data = LoadStockInfo(dtDate, dInputMain, dInputCmp, strNameMain);

            // 命名K线代表指数名
            stockChart.Charts[1].Graphs[0].Title = strNameMain;
            // 作参考的趋势线
            stockChart.Charts[1].Graphs[1].Title = strNameCmp;
            // 成交量生产的柱状图
            stockChart.Charts[2].Graphs[0].Title = strNameMain;

            stockChart.Charts[0].Collapse();
        }

        private void dataGrid1_PreviewMouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            // 获取所选单元格列数
            int iCol = 6;

            // 获取历史数据
            int iSize = dFractile[iCol].Count;          
            var lData = new List<UtilityChartInfo>();
            for (int i = 0; i < iSize; i++)
            {
                DateTime date = dtTimeSeries[dtTimeSeries.Length - iSize + i];
                double data1 = dPermium[iCol][dPermium[iCol].Count - iSize + i];
                double data2 = dFractile[iCol][i];

                lData.Add
                    (
                    new UtilityChartInfo
                        {
                            date = date,
                            open = data1,
                            close = data2
                        }
                    );
            }
            Dictionary<string, string> dicSetting = new Dictionary<string,string>();
            dicSetting["图例标题"] = "超额收益及分位数历史趋势";
            dicSetting["线1标题"] = "超额收益";
            dicSetting["线2标题"] = "分位数";

            Premium pr = new Premium(lData, dicSetting);
            pr.Show();
            pr.Topmost = true;
        }

        private object[] ParamsCalculate(string strIndustryCode, string strIndexCode, string strIndustryName)
        {
            GlobalWind.windEnsureStart();

            double[] dIndustryHistoryPrice = null;
            double[] dIndexHistoryPrice = null;

            //设定起始截止日期
            DateTime dtBegin = DateTime.Now.AddYears(-3);
            DateTime dtEnd = DateTime.Now;

            // 获取历史数据
            dIndustryHistoryPrice = UtilityWindData.getWindHistoryPrice(strIndustryCode, dtBegin.ToShortDateString(), dtEnd.ToShortDateString(), "close");
            dIndexHistoryPrice = UtilityWindData.getWindHistoryPrice(strIndexCode, dtBegin.ToShortDateString(), dtEnd.ToShortDateString(), "close");

            // 计算超额收益
            List<List<double>> plPermium = UtilityMath.getMultiPeriodExcessReturnOverIndex(dIndustryHistoryPrice, dIndexHistoryPrice, Main.iHorizon);
            // 计算历史分位数
            List<List<double>> plFractile = UtilityMath.getMultiPeriodFractile(plPermium, Main.iHorizon);
            // 生成DataView
            DataSet dsPrem = IndexPremium(plPermium, plFractile);
            // PE 相关数据
            Dictionary<string, string> dicPE = UtilityZhaoYangData.getPE_PB_ROE_Quantile_Data(strIndustryCode, strIndexCode);
            dicPE = UtilityMySQLData.getMySQLVolAmtAndOtherData(strIndustryCode, strIndustryName, dicPE);

            //获取历史价格
            double[, ] dInputMain = UtilityWindData.getWindSingleStockHistoryPrice(strIndustryCode, dtBegin, dtEnd);
            double[,] dInputCmp = UtilityWindData.getWindSingleStockHistoryPrice(strIndexCode, dtBegin, dtEnd);
            DateTime[] dtTime = UtilityWindData.getWindHistoryDate(strIndustryCode, dtBegin, dtEnd);

            object[] objExcessReturn = new object[7];
            objExcessReturn[0] = dInputMain;
            objExcessReturn[1] = dInputCmp;
            objExcessReturn[2] = dtTime;
            objExcessReturn[3] = plPermium;
            objExcessReturn[4] = plFractile;
            objExcessReturn[5] = dsPrem;
            objExcessReturn[6] = dicPE;

            return objExcessReturn;
        }

        // 生成DataView
        private DataSet IndexPremium(List<List<double>> plPermium, List<List<double>> plFractile)
        {
            DataTable dtPrem = new DataTable();                  //得到的数据所要关联的数据源    

            //数据绑定
            dtPrem.Columns.Add("内容");
            dtPrem.Columns.Add("1日");
            dtPrem.Columns.Add("5日");
            dtPrem.Columns.Add("10日");
            dtPrem.Columns.Add("60日");
            dtPrem.Columns.Add("120日");
            dtPrem.Columns.Add("250日");

            DataRow nRow = dtPrem.NewRow();
            nRow["内容"] = "超额收益";
            for (int j = 0; j < plPermium.Count; j++)
            {
                int iEnd = plPermium[j].Count;
                nRow[j + 1] = plPermium[j][iEnd - 1].ToString("0.00%");
            }
            dtPrem.Rows.Add(nRow);

            nRow = dtPrem.NewRow();
            nRow["内容"] = "分位数";
            for (int j = 0; j < plFractile.Count; j++)
            {
                int iEnd = plFractile[j].Count;
                nRow[j + 1] = plFractile[j][iEnd - 1].ToString("0.000");
            }
            dtPrem.Rows.Add(nRow);

            DataSet dsPrem = new DataSet();
            dsPrem.Tables.Add(dtPrem);

            return dsPrem;
        }

        private void textBoxDoubleClick(int iCol)
        {
            // 获取历史数据
            int iSize = dFractile[iCol].Count;
            var lData = new List<UtilityChartInfo>();
            for (int i = 0; i < iSize; i++)
            {
                DateTime date = dtTimeSeries[dtTimeSeries.Length - iSize + i];
                double data1 = dPermium[iCol][dPermium[iCol].Count - iSize + i];
                double data2 = dFractile[iCol][i];

                lData.Add
                    (
                    new UtilityChartInfo
                    {
                        date = date,
                        open = data1,
                        close = data2
                    }
                    );
            }
            Dictionary<string, string> dicSetting = new Dictionary<string, string>();
            dicSetting["图例1标题"] = "分位数历史趋势";
            dicSetting["图例2标题"] = "超额收益历史趋势";
            dicSetting["线1标题"] = "超额收益";
            dicSetting["线2标题"] = "分位数";

            Premium pr = new Premium(lData, dicSetting);
            pr.Show();
            pr.Topmost = true;
        }

        private void textBox16_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(0);
        }

        private void textBox17_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(0);
        }

        private void textBox18_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(1);
        }

        private void textBox19_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(1);
        }

        private void textBox20_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(2);
        }

        private void textBox21_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(2);
        }

        private void textBox22_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(3);
        }

        private void textBox23_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(3);
        }

        private void textBox24_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(4);
        }

        private void textBox25_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(4);
        }

        private void textBox26_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(5);
        }

        private void textBox27_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBoxDoubleClick(5);
        }

        private int iTimeLens = 250;
        private int iPrevLens = 300;

        private void PEtextBox1_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {           
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode, iTimeLens + 1, 1, "pe_ttm");
            DateTime[] dtDateArray = wd.timeList;
            double[,] dData = (double[,])wd.getDataByFunc("wsd");

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "PE历史走势");
            ope.Show();
        }

        private void PBtextBox2_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode, iTimeLens + 1, 1, "pb_lf");
            DateTime[] dtDateArray = wd.timeList;
            float[] fData = (float[])wd.getDataByFunc("wsd");
            double[,] dData = new double[dtDateArray.Length, 1];

            for (int i = 0; i < dtDateArray.Length; i++)
            {
                dData[i, 0] = fData[i];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "PB历史走势");
            ope.Show();
        }

        private void RelativePEtextBox3_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode + "," + strIndexCode, iTimeLens + 1, 1, "pe_ttm");
            DateTime[] dtDateArray = wd.timeList;
            double[,] dDataArray = (double[,])wd.getDataByFunc("wsd");
            double[,] dData = new double[dtDateArray.Length, 1];

            for (int i = 0; i < dtDateArray.Length; i++)
            {
                dData[i, 0] = dDataArray[i, 0] / dDataArray[i, 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "相对PE历史走势");
            ope.Show();
        }

        private void RelativePBtextBox4_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode + "," + strIndexCode, iTimeLens + 1, 1, "pb_lf");
            DateTime[] dtDateArray = wd.timeList;
            float[] dDataArray = (float[])wd.getDataByFunc("wsd");
            double[,] dData = new double[dtDateArray.Length, 1];

            for (int i = 0; i < dtDateArray.Length; i++)
            {
                dData[i, 0] = dDataArray[i * 2] / dDataArray[i * 2 + 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "相对PB历史走势");
            ope.Show();
        }

        private void QuantilePEtextBox5_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode, iTimeLens + 1 + iPrevLens, 1, "pe_ttm");
            DateTime[] dtDateArrayPE = wd.timeList;
            double[,] dDataPE = (double[,])wd.getDataByFunc("wsd");
            double[,] dData = new double[iTimeLens + 1, 1];
            DateTime[] dtDateArray = new DateTime[iTimeLens + 1];

            for (int i = 0; i < iTimeLens + 1; i++)
            {
                double dTest = dDataPE[i + iPrevLens, 0];
                double[] dHistoricData = new double[i + iPrevLens];
                for (int j = 0; j < i + iPrevLens; j++)
                {
                    dHistoricData[j] = dDataPE[j, 0];
                }
                dData[i, 0] = UtilityMath.QF(dHistoricData, dTest);
                dtDateArray[i] = dtDateArrayPE[i + dtDateArrayPE.Length - iTimeLens - 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "PE分位数历史走势");
            ope.Show();
        }

        private void QuantileRelativePEtextBox7_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode + "," + strIndexCode, iTimeLens + 1 + iPrevLens, 1, "pe_ttm");
            DateTime[] dtDateArrayPE = wd.timeList;
            double[,] dDataArray = (double[,])wd.getDataByFunc("wsd");
            double[,] dDataRelative = new double[dtDateArrayPE.Length, 1];
            double[,] dData = new double[iTimeLens + 1, 1];
            DateTime[] dtDateArray = new DateTime[iTimeLens + 1];

            for (int i = 0; i < dtDateArrayPE.Length; i++)
            {
                dDataRelative[i, 0] = dDataArray[i, 0] / dDataArray[i, 1];
            }

            for (int i = 0; i < iTimeLens + 1; i++)
            {
                double dTest = dDataRelative[i + iPrevLens, 0];
                double[] dHistoricData = new double[i + iPrevLens];
                for (int j = 0; j < i + iPrevLens; j++)
                {
                    dHistoricData[j] = dDataRelative[j, 0];
                }
                dData[i, 0] = UtilityMath.QF(dHistoricData, dTest);
                dtDateArray[i] = dtDateArrayPE[i + dtDateArrayPE.Length - iTimeLens - 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "相对PE分位数历史走势");
            ope.Show();
        }

        private void QuantileRelativePBtextBox8_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode + "," + strIndexCode, iTimeLens + 1 + iPrevLens, 1, "pb_lf");
            DateTime[] dtDateArrayPB = wd.timeList;
            float[] fDataArray = (float[])wd.getDataByFunc("wsd");
            double[,] dDataRelative = new double[dtDateArrayPB.Length, 1];
            double[,] dData = new double[iTimeLens + 1, 1];
            DateTime[] dtDateArray = new DateTime[iTimeLens + 1];

            for (int i = 0; i < dtDateArrayPB.Length; i++)
            {
                dDataRelative[i, 0] = fDataArray[i * 2] / fDataArray[i * 2 + 1];
            }

            for (int i = 0; i < iTimeLens + 1; i++)
            {
                double dTest = dDataRelative[i + iPrevLens, 0];
                double[] dHistoricData = new double[i + iPrevLens];
                for (int j = 0; j < i + iPrevLens; j++)
                {
                    dHistoricData[j] = dDataRelative[j, 0];
                }
                dData[i, 0] = UtilityMath.QF(dHistoricData, dTest);
                dtDateArray[i] = dtDateArrayPB[i + dtDateArrayPB.Length - iTimeLens - 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "相对PB历史走势");
            ope.Show();
        }

        private void QuantilePBtextBox6_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            WindData wd = UtilityWindData.getWindDataByType(strIndustryCode, iTimeLens + 1 + iPrevLens, 1, "pb_lf");
            DateTime[] dtDateArrayPB = wd.timeList;
            float[] fData = (float[])wd.getDataByFunc("wsd");
            double[,] dDataPB = new double[dtDateArrayPB.Length, 1];

            for (int i = 0; i < dtDateArrayPB.Length; i++)
            {
                dDataPB[i, 0] = fData[i];
            }

            double[,] dData = new double[iTimeLens + 1, 1];
            DateTime[] dtDateArray = new DateTime[iTimeLens + 1];

            for (int i = 0; i < iTimeLens + 1; i++)
            {
                double dTest = dDataPB[i + iPrevLens, 0];
                double[] dHistoricData = new double[i + iPrevLens];
                for (int j = 0; j < i + iPrevLens; j++)
                {
                    dHistoricData[j] = dDataPB[j, 0];
                }
                dData[i, 0] = UtilityMath.QF(dHistoricData, dTest);
                dtDateArray[i] = dtDateArrayPB[i + dtDateArrayPB.Length - iTimeLens - 1];
            }

            Xaml.IndexEvolution ope = new Xaml.IndexEvolution(dtDateArray, dData, "PB分位数历史走势");
            ope.Show();
        }


    }
}
