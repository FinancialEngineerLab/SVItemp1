using System;
using System.Data;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Globalization;
using UtilityLib;
using WAPIWrapperCSharp;

namespace WuhuaTianbao
{
    /// <summary>
    /// Interaction logic for CommodityMkt.xaml
    /// </summary>
    public partial class CommodityMkt : Window
    {
        private DateTime dtCurrent = new DateTime();
        private DateTime dtOneWeekPrev = new DateTime();
        private DateTime dtTwoWeekPrev = new DateTime();
        private DateTime dtOneMonthPrev = new DateTime();
        private DateTime dtOneYearPrev = new DateTime();

        public CommodityMkt()
        {
            InitializeComponent();
            FetchWindData();
            HighlightText();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            //FetchWindData();
        }

        #region 获取商品价格数据
        public void FetchWindData()
        {
            GlobalWind.windEnsureStart();

            dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now, 1);
            dtOneWeekPrev = UtilityTime.getPrevTradeDay(dtCurrent, 5);
            dtTwoWeekPrev = UtilityTime.getPrevTradeDay(dtCurrent, 10);
            dtOneMonthPrev = UtilityTime.getPrevTradeDay(dtCurrent, 20);
            dtOneYearPrev = UtilityTime.getPrevTradeDay(dtCurrent.AddYears(-1), 0);

            /*-------------大宗商品价格--------------*/
            List<Object> lsBulkCommodity = UtilityWindData.getWindBulkCommodities(dtOneMonthPrev.AddDays(-7).ToShortDateString(), dtCurrent.ToShortDateString());

            textBlock52.Text = getAbsoluteRelativeString(lsBulkCommodity, 0, dtCurrent, dtOneWeekPrev);
            textBlock53.Text = getAbsoluteRelativeString(lsBulkCommodity, 1, dtCurrent, dtOneWeekPrev);
            textBlock54.Text = getAbsoluteRelativeString(lsBulkCommodity, 2, dtCurrent, dtOneWeekPrev);

            textBlock37.Text = getAbsoluteRelativeString(lsBulkCommodity, 0, dtCurrent, dtTwoWeekPrev);
            textBlock38.Text = getAbsoluteRelativeString(lsBulkCommodity, 1, dtCurrent, dtTwoWeekPrev);
            textBlock39.Text = getAbsoluteRelativeString(lsBulkCommodity, 2, dtCurrent, dtTwoWeekPrev);

            textBlock22.Text = getAbsoluteRelativeString(lsBulkCommodity, 0, dtCurrent, dtOneMonthPrev);
            textBlock23.Text = getAbsoluteRelativeString(lsBulkCommodity, 1, dtCurrent, dtOneMonthPrev);
            textBlock24.Text = getAbsoluteRelativeString(lsBulkCommodity, 2, dtCurrent, dtOneMonthPrev);

            textBlock81.Text = getLatestPriceString(lsBulkCommodity, 0);
            textBlock82.Text = getLatestPriceString(lsBulkCommodity, 1);
            textBlock83.Text = getLatestPriceString(lsBulkCommodity, 2);

            ///*-------------农产品价格--------------*/
            List<Object> lsFarmProduct = UtilityWindData.getWindFarmProduce(dtOneMonthPrev.AddDays(-30).ToShortDateString(), dtCurrent.ToShortDateString());

            textBlock55.Text = getAbsoluteRelativeString(lsFarmProduct, 0, dtCurrent, dtOneWeekPrev);
            textBlock56.Text = getAbsoluteRelativeString(lsFarmProduct, 1, dtCurrent, dtOneWeekPrev);
            textBlock57.Text = getAbsoluteRelativeString(lsFarmProduct, 2, dtCurrent, dtOneWeekPrev);
            textBlock58.Text = getAbsoluteRelativeString(lsFarmProduct, 3, dtCurrent, dtOneWeekPrev);
            textBlock59.Text = getAbsoluteRelativeString(lsFarmProduct, 4, dtCurrent, dtOneWeekPrev);

            textBlock40.Text = getAbsoluteRelativeString(lsFarmProduct, 0, dtCurrent, dtTwoWeekPrev);
            textBlock41.Text = getAbsoluteRelativeString(lsFarmProduct, 1, dtCurrent, dtTwoWeekPrev);
            textBlock42.Text = getAbsoluteRelativeString(lsFarmProduct, 2, dtCurrent, dtTwoWeekPrev);
            textBlock43.Text = getAbsoluteRelativeString(lsFarmProduct, 3, dtCurrent, dtTwoWeekPrev);
            textBlock44.Text = getAbsoluteRelativeString(lsFarmProduct, 4, dtCurrent, dtTwoWeekPrev);

            textBlock25.Text = getAbsoluteRelativeString(lsFarmProduct, 0, dtCurrent, dtOneMonthPrev);
            textBlock26.Text = getAbsoluteRelativeString(lsFarmProduct, 1, dtCurrent, dtOneMonthPrev);
            textBlock27.Text = getAbsoluteRelativeString(lsFarmProduct, 2, dtCurrent, dtOneMonthPrev);
            textBlock28.Text = getAbsoluteRelativeString(lsFarmProduct, 3, dtCurrent, dtOneMonthPrev);
            textBlock29.Text = getAbsoluteRelativeString(lsFarmProduct, 4, dtCurrent, dtOneMonthPrev);

            textBlock84.Text = getLatestPriceString(lsFarmProduct, 0);
            textBlock85.Text = getLatestPriceString(lsFarmProduct, 1);
            textBlock86.Text = getLatestPriceString(lsFarmProduct, 2);
            textBlock87.Text = getLatestPriceString(lsFarmProduct, 3);
            textBlock88.Text = getLatestPriceString(lsFarmProduct, 4);

            /*-------------金属价格--------------*/
            List<Object> lsMetalPrice = UtilityWindData.getWindMetalPrice(dtOneMonthPrev.AddDays(-7).ToShortDateString(), dtCurrent.ToShortDateString());

            textBlock60.Text = getAbsoluteRelativeString(lsMetalPrice, 0, dtCurrent, dtOneWeekPrev);
            textBlock61.Text = getAbsoluteRelativeString(lsMetalPrice, 1, dtCurrent, dtOneWeekPrev);
            textBlock62.Text = getAbsoluteRelativeString(lsMetalPrice, 2, dtCurrent, dtOneWeekPrev);
            textBlock63.Text = getAbsoluteRelativeString(lsMetalPrice, 3, dtCurrent, dtOneWeekPrev);
            textBlock64.Text = getAbsoluteRelativeString(lsMetalPrice, 4, dtCurrent, dtOneWeekPrev);
            textBlock65.Text = getAbsoluteRelativeString(lsMetalPrice, 5, dtCurrent, dtOneWeekPrev);
            textBlock66.Text = getAbsoluteRelativeString(lsMetalPrice, 6, dtCurrent, dtOneWeekPrev);

            textBlock45.Text = getAbsoluteRelativeString(lsMetalPrice, 0, dtCurrent, dtTwoWeekPrev);
            textBlock46.Text = getAbsoluteRelativeString(lsMetalPrice, 1, dtCurrent, dtTwoWeekPrev);
            textBlock47.Text = getAbsoluteRelativeString(lsMetalPrice, 2, dtCurrent, dtTwoWeekPrev);
            textBlock48.Text = getAbsoluteRelativeString(lsMetalPrice, 3, dtCurrent, dtTwoWeekPrev);
            textBlock49.Text = getAbsoluteRelativeString(lsMetalPrice, 4, dtCurrent, dtTwoWeekPrev);
            textBlock50.Text = getAbsoluteRelativeString(lsMetalPrice, 5, dtCurrent, dtTwoWeekPrev);
            textBlock51.Text = getAbsoluteRelativeString(lsMetalPrice, 6, dtCurrent, dtTwoWeekPrev);

            textBlock30.Text = getAbsoluteRelativeString(lsMetalPrice, 0, dtCurrent, dtOneMonthPrev);
            textBlock31.Text = getAbsoluteRelativeString(lsMetalPrice, 1, dtCurrent, dtOneMonthPrev);
            textBlock32.Text = getAbsoluteRelativeString(lsMetalPrice, 2, dtCurrent, dtOneMonthPrev);
            textBlock33.Text = getAbsoluteRelativeString(lsMetalPrice, 3, dtCurrent, dtOneMonthPrev);
            textBlock34.Text = getAbsoluteRelativeString(lsMetalPrice, 4, dtCurrent, dtOneMonthPrev);
            textBlock35.Text = getAbsoluteRelativeString(lsMetalPrice, 5, dtCurrent, dtOneMonthPrev);
            textBlock36.Text = getAbsoluteRelativeString(lsMetalPrice, 6, dtCurrent, dtOneMonthPrev);

            textBlock89.Text = getLatestPriceString(lsMetalPrice, 0);
            textBlock90.Text = getLatestPriceString(lsMetalPrice, 1);
            textBlock91.Text = getLatestPriceString(lsMetalPrice, 2);
            textBlock92.Text = getLatestPriceString(lsMetalPrice, 3);
            textBlock93.Text = getLatestPriceString(lsMetalPrice, 4);
            textBlock94.Text = getLatestPriceString(lsMetalPrice, 5);
            textBlock95.Text = getLatestPriceString(lsMetalPrice, 6);
        }

        private string getAbsoluteRelativeString(List<Object> lsResult, int iCols, DateTime dtCurrent, DateTime dtFormer)
        {
            double[,] dPriceMatrix = (double[,])lsResult[1];
            DateTime[] dtTradeTime = (DateTime[])lsResult[0];

            double dCurrent = 0.0;
            double dFormer = 0.0;
            double dAbsolute = 0.0;
            double dRelative = 0.0;
            int k = 0;

            for (int i = 0; i < dtTradeTime.Length - 1; i++)
            {
                if (dtCurrent.Date >= dtTradeTime[i] && dtCurrent.Date < dtTradeTime[i + 1])
                {
                    k = 0;
                    while (double.IsNaN(dPriceMatrix[i + k, iCols]))
                    {
                        k--;
                    }
                    dCurrent = dPriceMatrix[i + k, iCols];
                }
                else if (dtCurrent.Date == dtTradeTime[dtTradeTime.Length - 1])
                {
                    k = 0;
                    while (double.IsNaN(dPriceMatrix[dtTradeTime.Length - 1 + k, iCols]))
                    {
                        k--;
                    }
                    dCurrent = dPriceMatrix[dtTradeTime.Length - 1 + k, iCols];
                }
                if (dtFormer.Date >= dtTradeTime[i] && dtFormer < dtTradeTime[i + 1])
                {
                    k = 0;
                    while (double.IsNaN(dPriceMatrix[i + k, iCols]))
                    {
                        k--;
                    }
                    dFormer = dPriceMatrix[i + k, iCols];
                }
            }

            dAbsolute = dCurrent - dFormer;
            dRelative = dCurrent / dFormer - 1;

            string strResult = dAbsolute.ToString("0.00") + " / " + dRelative.ToString("0.00%");
            return strResult;
        }

        private string getLatestPriceString(List<Object> lsObject, int iCols)
        {
            double[,] dInputMatrix = (double[,])lsObject[1];
            DateTime[] dtTradeTime = (DateTime[])lsObject[0];
            int iCount = 1;
            string strPrice = null;
            while (double.IsNaN(dInputMatrix[dtTradeTime.Length - iCount, iCols]))
            {
                iCount++;
            }
            if (iCount == 1)
            {
                strPrice = dInputMatrix[dtTradeTime.Length - iCount, iCols].ToString("0.000");
            }
            else
            {
                strPrice = dtTradeTime[dtTradeTime.Length - iCount].ToShortDateString() + " : " + dInputMatrix[dtTradeTime.Length - iCount, iCols].ToString("0.000");
            }
            return strPrice;
        }

        #endregion

        #region 历史走势图
        private void 德州轻质原油MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindBulkCommodities(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "美元/桶", "现货价:原油:美国西德克萨斯中级轻质原油(WTI)" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 0);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 布伦特原油MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindBulkCommodities(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "美元/桶", "现货价:原油:英国布伦特Dtd" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 1);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 铁矿石MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindBulkCommodities(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "期货结算价(活跃合约):铁矿石" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 2);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 铜MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "现货结算价:LME铜" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 0);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 铅MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "现货结算价:LME铅" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 1);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 锌MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "现货结算价:LME锌" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 3);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 玉米MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindFarmProduce(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "期货结算价(活跃合约):黄玉米" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 0);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 鸡蛋MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindFarmProduce(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "期货结算价(活跃合约):鸡蛋" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 1);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 猪肉MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindFarmProduce(dtOneYearPrev.AddDays(-30).ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/千克", "50个城市平均价：猪肉：五花肉" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 2);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 鸡肉MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindFarmProduce(dtOneYearPrev.AddDays(-30).ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/千克", "50个城市平均价：鸡肉：白条鸡" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 3);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 猪粮比MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindFarmProduce(dtOneYearPrev.AddDays(-30).ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "猪粮比价", "每周猪粮比价" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 4);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 铝MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "现货结算价:LME铝" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 2);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 焦煤MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "期货结算价(活跃合约):焦煤" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 4);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 螺纹钢MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "元/吨", "期货结算价(活跃合约):螺纹钢" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 5);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }

        private void 黄金MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<Object> lsWTI = UtilityWindData.getWindMetalPrice(dtOneYearPrev.ToShortDateString(), dtCurrent.ToShortDateString());
            string[] strSerialNames = { "美元/盎司", "期货结算价(活跃合约):COMEX黄金" };

            double[,] dMatrix = UtilityArray.getColFromDoubleMatrix((double[,])lsWTI[1], 6);
            List<Object> lsInput = new List<object>();
            lsInput.Add((DateTime[])lsWTI[0]);
            lsInput.Add(dMatrix);

            MarcoMkt1 mm = new MarcoMkt1(lsInput, strSerialNames);
            mm.Show();
        }
        #endregion

        # region 数据超过一定数值修改背景颜色
        private bool valueCheck(string strText, double dbasis)
        {
            int iLocation = strText.IndexOf("/");
            string strPercentage = strText.Substring(iLocation + 1, 5);
            double dPercentage = double.Parse(strPercentage);

            if (dPercentage >= dbasis || dPercentage <= -dbasis)
            {
                return true;
            }
            return false;
        }

        private void HighlightText()
        {
            Color color = (Color)ColorConverter.ConvertFromString("LightCoral");

            if (valueCheck(textBlock22.Text, 10.0))
            {
                textBlock22.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock57.Text, 10.0))
            {
                textBlock57.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock58.Text, 10.0))
            {
                textBlock58.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock59.Text, 10.0))
            {
                textBlock59.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock42.Text, 10.0))
            {
                textBlock42.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock43.Text, 10.0))
            {
                textBlock43.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock44.Text, 10.0))
            {
                textBlock44.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock27.Text, 10.0))
            {
                textBlock27.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock28.Text, 10.0))
            {
                textBlock28.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock29.Text, 10.0))
            {
                textBlock29.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock23.Text, 10.0))
            {
                textBlock23.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock24.Text, 10.0))
            {
                textBlock24.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock25.Text, 10.0))
            {
                textBlock25.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock26.Text, 10.0))
            {
                textBlock26.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock30.Text, 10.0))
            {
                textBlock30.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock31.Text, 10.0))
            {
                textBlock31.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock32.Text, 10.0))
            {
                textBlock32.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock33.Text, 10.0))
            {
                textBlock33.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock34.Text, 10.0))
            {
                textBlock34.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock35.Text, 10.0))
            {
                textBlock35.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock36.Text, 10.0))
            {
                textBlock36.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock37.Text, 10.0))
            {
                textBlock37.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock38.Text, 10.0))
            {
                textBlock38.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock39.Text, 10.0))
            {
                textBlock39.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock40.Text, 10.0))
            {
                textBlock40.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock41.Text, 10.0))
            {
                textBlock41.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock45.Text, 10.0))
            {
                textBlock45.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock46.Text, 10.0))
            {
                textBlock46.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock47.Text, 10.0))
            {
                textBlock48.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock48.Text, 10.0))
            {
                textBlock48.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock49.Text, 10.0))
            {
                textBlock49.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock50.Text, 10.0))
            {
                textBlock50.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock51.Text, 10.0))
            {
                textBlock51.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock51.Text, 10.0))
            {
                textBlock51.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock52.Text, 10.0))
            {
                textBlock52.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock53.Text, 10.0))
            {
                textBlock53.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock54.Text, 10.0))
            {
                textBlock54.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock55.Text, 10.0))
            {
                textBlock55.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock56.Text, 10.0))
            {
                textBlock56.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock60.Text, 10.0))
            {
                textBlock60.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock61.Text, 10.0))
            {
                textBlock61.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock62.Text, 10.0))
            {
                textBlock62.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock63.Text, 10.0))
            {
                textBlock63.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock64.Text, 10.0))
            {
                textBlock64.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock65.Text, 10.0))
            {
                textBlock65.Background = new SolidColorBrush(color);
            }
            if (valueCheck(textBlock66.Text, 10.0))
            {
                textBlock66.Background = new SolidColorBrush(color);
            }
        }
        #endregion
    }
}
