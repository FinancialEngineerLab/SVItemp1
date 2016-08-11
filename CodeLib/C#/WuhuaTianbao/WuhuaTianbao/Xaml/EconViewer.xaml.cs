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
    /// Interaction logic for EconViewer.xaml
    /// </summary>
    public partial class EconViewer : Window
    {
        private DateTime dtCurrent = new DateTime();
        private DateTime dtOneWeek = new DateTime();
        private DateTime dtTwoWeek = new DateTime();
        private DateTime dtOneMonth = new DateTime();

        public EconViewer()
        {
            InitializeComponent();
        }

        private DateTime dtRecentTradeDay;
        private DateTime dtOneYearPrevious;

        # region 获取宏观市场数据
        public void FetchData()
        {
            GlobalWind.windEnsureStart();

            dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now.AddDays(-1), 0);
            dtOneWeek = UtilityTime.getPrevTradeDay(dtCurrent.AddDays(-7), 0);
            dtTwoWeek = UtilityTime.getPrevTradeDay(dtCurrent.AddDays(-14), 0);
            dtOneMonth = UtilityTime.getPrevTradeDay(dtCurrent.AddMonths(-1), 0);

            dtRecentTradeDay = dtCurrent;
            dtOneYearPrevious = UtilityTime.getPrevTradeDay(dtCurrent.AddYears(-1).AddMonths(-2), 0);

            /* ------------------人民币汇率------------------ */
            List<object> lsRMBFX = UtilityWindData.getWindFXMkt(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dRMBMiddleRate = (double[,])lsRMBFX[1];
            DateTime[] dtTradeDate = (DateTime[])lsRMBFX[0];

            // One week
            string strRMBOneWeek = getAbsoluteRelativeChange(dRMBMiddleRate, 0, dtTradeDate, dtCurrent, dtOneWeek);
            string strNDFOneWeek = getAbsoluteRelativeChange(dRMBMiddleRate, 1, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strRMBTwoWeek = getAbsoluteRelativeChange(dRMBMiddleRate, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            string strNDFTwoWeek = getAbsoluteRelativeChange(dRMBMiddleRate, 1, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strRMBOneMonth = getAbsoluteRelativeChange(dRMBMiddleRate, 0, dtTradeDate, dtCurrent, dtOneMonth);
            string strNDFOneMonth = getAbsoluteRelativeChange(dRMBMiddleRate, 1, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock9.Text = strRMBOneWeek;
            textBlock17.Text = strRMBTwoWeek;
            textBlock25.Text = strRMBOneMonth;

            textBlock10.Text = strNDFOneWeek;
            textBlock18.Text = strNDFTwoWeek;
            textBlock26.Text = strNDFOneMonth;

            textBlock81.Text = getLatestPriceString(dRMBMiddleRate, dtTradeDate, 0);
            textBlock82.Text = getLatestPriceString(dRMBMiddleRate, dtTradeDate, 1);

            /* ------------------SHIBOR------------------ */
            List<object> lsSHIBOR = UtilityWindData.getWindIRMkt(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dSHIBOR = (double[,])lsSHIBOR[1];
            dtTradeDate = (DateTime[])lsSHIBOR[0];

            // One week
            string strSHIBOROneWeek = getAbsoluteRelativeChange(dSHIBOR, 0, dtTradeDate, dtCurrent, dtOneWeek);
            string strSHIBOROneWeek2 = getAbsoluteRelativeChange(dSHIBOR, 1, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strSHIBORTwoWeek = getAbsoluteRelativeChange(dSHIBOR, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            string strSHIBORTwoWeek2 = getAbsoluteRelativeChange(dSHIBOR, 1, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strSHIBOROneMonth = getAbsoluteRelativeChange(dSHIBOR, 0, dtTradeDate, dtCurrent, dtOneMonth);
            string strSHIBOROneMonth2 = getAbsoluteRelativeChange(dSHIBOR, 1, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock15.Text = strRMBOneWeek;
            textBlock23.Text = strRMBTwoWeek;
            textBlock31.Text = strRMBOneMonth;

            textBlock16.Text = strNDFOneWeek;
            textBlock24.Text = strNDFTwoWeek;
            textBlock32.Text = strNDFOneMonth;

            textBlock87.Text = getLatestPriceString(dSHIBOR, dtTradeDate, 0);
            textBlock88.Text = getLatestPriceString(dSHIBOR, dtTradeDate, 1);

            /* ------------------票据贴现------------------ */
            List<object> lsNoteMkt = UtilityWindData.getWindNoteMkt(dtOneMonth.AddDays(-5).ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dNoteMkt = (double[,])lsNoteMkt[1];
            dtTradeDate = (DateTime[])lsNoteMkt[0];

            // One week
            string strZhiTieOneWeek = getAbsoluteRelativeChange(dNoteMkt, 0, dtTradeDate, dtCurrent, dtOneWeek);
            string strZhuanTieOneWeek = getAbsoluteRelativeChange(dNoteMkt, 1, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strZhiTieTwoWeek = getAbsoluteRelativeChange(dNoteMkt, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            string strZhuanTieTwoWeek = getAbsoluteRelativeChange(dNoteMkt, 1, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strZhiTieOneMonth = getAbsoluteRelativeChange(dNoteMkt, 0, dtTradeDate, dtCurrent, dtOneMonth);
            string strZhuanTieOneMonth = getAbsoluteRelativeChange(dNoteMkt, 1, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock14.Text = strZhiTieOneWeek;
            textBlock22.Text = strZhiTieTwoWeek;
            textBlock30.Text = strZhiTieOneMonth;

            textBlock13.Text = strZhuanTieOneWeek;
            textBlock21.Text = strZhuanTieTwoWeek;
            textBlock29.Text = strZhuanTieOneMonth;

            textBlock85.Text = getLatestPriceString(dNoteMkt, dtTradeDate, 0);
            textBlock86.Text = getLatestPriceString(dNoteMkt, dtTradeDate, 1);

            /* ------------------央行利率------------------ */
            List<object> lsCentralBankBill = UtilityWindData.getWindCentralBankBill(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dCentralNoteBank = (double[,])lsCentralBankBill[1];
            dtTradeDate = (DateTime[])lsCentralBankBill[0];

            // One week
            string strExpireOneWeek = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strExpireTwoWeek = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strExpireOneMonth = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock12.Text = strExpireOneWeek;
            textBlock20.Text = strExpireTwoWeek;
            textBlock28.Text = strExpireOneMonth;

            textBlock84.Text = getLatestPriceString(dCentralNoteBank, dtTradeDate, 0);

            /* ------------------美元指数------------------ */
            List<object> lsDollarIndex = UtilityWindData.getWindDollarIndex(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dDollarIndex = (double[,])lsDollarIndex[1];
            dtTradeDate = (DateTime[])lsDollarIndex[0];

            // One week
            textBlock70.Text = getAbsoluteRelativeChange(dDollarIndex, 0, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            textBlock71.Text = getAbsoluteRelativeChange(dDollarIndex, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            textBlock72.Text = getAbsoluteRelativeChange(dDollarIndex, 0, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock83.Text = getLatestPriceString(dDollarIndex, dtTradeDate, 0);

            /* ------------------国债到期收益率------------------ */
            List<object> lsTreasuryBond = UtilityWindData.getWindTreasuryBond(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dTreasuryBond = (double[,])lsTreasuryBond[1];
            dtTradeDate = (DateTime[])lsTreasuryBond[0];

            // One week
            string strChinaOneWeek = getAbsoluteRelativeChange(dTreasuryBond, 0, dtTradeDate, dtCurrent, dtOneWeek);
            string strUSAOneWeek = getAbsoluteRelativeChange(dTreasuryBond, 1, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strChinaTwoWeek = getAbsoluteRelativeChange(dTreasuryBond, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            string strUSATwoWeek = getAbsoluteRelativeChange(dTreasuryBond, 1, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strChinaOneMonth = getAbsoluteRelativeChange(dTreasuryBond, 0, dtTradeDate, dtCurrent, dtOneMonth);
            string strUSAOneMonth = getAbsoluteRelativeChange(dTreasuryBond, 1, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock53.Text = strChinaOneWeek;
            textBlock55.Text = strChinaTwoWeek;
            textBlock57.Text = strChinaOneMonth;

            textBlock54.Text = strUSAOneWeek;
            textBlock56.Text = strUSATwoWeek;
            textBlock58.Text = strUSAOneMonth;

            textBlock89.Text = getLatestPriceString(dTreasuryBond, dtTradeDate, 0);
            textBlock90.Text = getLatestPriceString(dTreasuryBond, dtTradeDate, 1);

            /* ------------------央行公开市场操作------------------ */
            List<object> lsOMOs = UtilityWindData.getWindCentralBankOMOs(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dOMOs = (double[,])lsOMOs[1];
            dtTradeDate = (DateTime[])lsOMOs[0];

            textBlock61.Text = getAbsoluteRelativeChange(dOMOs, 0, dtTradeDate, dtCurrent, dtOneWeek);
            textBlock62.Text = getAbsoluteRelativeChange(dOMOs, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            textBlock63.Text = getAbsoluteRelativeChange(dOMOs, 0, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock91.Text = getLatestPriceString(dOMOs, dtTradeDate, 0);
        }

        private string getAbsoluteRelativeChange(double[,] dInputMatrix, int iCols, DateTime[] dtTradeDate, DateTime dtCurrent, DateTime dtFormer)
        {
            double dAbsolute = 0.0;
            double dRelative = 0.0;
            double dFormer = 0.0;
            double dCurrent = 0.0;

            int iNum = 0;

            // One week
            for (int i = 0; i < dtTradeDate.Length; i++)
            {
                if (dtTradeDate[i] == dtCurrent.Date)
                {
                    iNum = i;
                    while (double.IsNaN(dInputMatrix[iNum, iCols]))
                    {
                        iNum--;
                    }
                    dCurrent = dInputMatrix[iNum, iCols];
                }
                if (dtTradeDate[i] <= dtFormer.Date && dtTradeDate[i+1] >= dtFormer.Date)
                {
                    iNum = i;
                    while (double.IsNaN(dInputMatrix[iNum, iCols]))
                    {
                        iNum--;
                    }
                    dFormer = dInputMatrix[iNum, iCols];
                }
            }
            dAbsolute = dCurrent - dFormer;
            dRelative = dCurrent / dFormer - 1;

            string strResult = dAbsolute.ToString("0.00") + " / " + dRelative.ToString("0.00%");
            return strResult;
        }

        private string getLatestPriceString(double[,] dInputMatrix, DateTime[] dtTradeTime, int iCols)
        {
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

        # endregion

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
            HighlightText();
        }
        

        # region 央行票据
        
        private void 央行票据1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsCentralBankBill = UtilityWindData.getWindCentralBankBill(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "1年到期收益率", "央票利率" };
            MarcoMkt1 mm = new MarcoMkt1(lsCentralBankBill, strSerialNames);
            mm.Show();
        }
        # endregion

        # region 票据贴现

        private void 票据贴现1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsNoteMkt = UtilityWindData.getWindNoteMkt(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "票据转贴月利率6个月", "票据直贴月利率6个月长三角", "票据贴现利率" };
            MarcoMkt mm = new MarcoMkt(lsNoteMkt,strSerialNames);
            mm.Show();
        }

        # endregion

        # region SHIBOR

        private void SHIBOR1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsIRMkt = UtilityWindData.getWindIRMkt(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "7天银行间回购加权利率", "SHIBOR3个月", "银行间利率" };
            MarcoMkt mm = new MarcoMkt(lsIRMkt, strSerialNames);
            mm.Show();
        }

        # endregion

        # region Dollar Index

        private void DollarIndex1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsDI = UtilityWindData.getWindDollarIndex(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "频率：日", "美元指数" };
            MarcoMkt1 mm = new MarcoMkt1(lsDI, strSerialNames);
            mm.Show();
        }

        # endregion

        # region 央行公开市场操作

        private void OmOs1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsOmOs = UtilityWindData.getWindCentralBankOMOs(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "货币净投放(亿元)", "央行公开市场操作(周)" };
            MarcoMkt1 mm = new MarcoMkt1(lsOmOs, strSerialNames);
            mm.Show();
        }

        # endregion

        # region 人民币汇率

        private void 人民币汇率1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsFXMkt = UtilityWindData.getWindFXMkt(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "美元兑人民币中间价", "美元兑人民币NDF12个月", "人民币汇率" };
            MarcoMkt mm = new MarcoMkt(lsFXMkt, strSerialNames);
            mm.Show();
        }

        # endregion

        # region 国债利率

        private void 国债利率1Year_MouseDown(object sender, MouseButtonEventArgs e)
        {
            List<object> lsFXMkt = UtilityWindData.getWindTreasuryBond(dtOneYearPrevious.ToShortDateString(), dtRecentTradeDay.ToShortDateString());
            string[] strSerialNames = { "10年期国债到期收益率：中国", "10年期国债到期收益率：美国", "国债利率" };
            MarcoMkt mm = new MarcoMkt(lsFXMkt, strSerialNames);
            mm.Show();
        }

        # endregion

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

            if (valueCheck(textBlock70.Text, 3.0))
            {
                textBlock70.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock71.Text, 3.0))
            {
                textBlock71.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock72.Text, 5.0))
            {
                textBlock72.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock9.Text, 3.0))
            {
                textBlock9.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock10.Text, 3.0))
            {
                textBlock10.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock12.Text, 3.0))
            {
                textBlock12.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock13.Text, 3.0))
            {
                textBlock13.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock14.Text, 3.0))
            {
                textBlock14.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock15.Text, 3.0))
            {
                textBlock15.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock16.Text, 3.0))
            {
                textBlock16.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock17.Text, 3.0))
            {
                textBlock17.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock18.Text, 3.0))
            {
                textBlock18.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock20.Text, 3.0))
            {
                textBlock20.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock21.Text, 3.0))
            {
                textBlock21.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock22.Text, 3.0))
            {
                textBlock22.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock23.Text, 3.0))
            {
                textBlock23.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock24.Text, 3.0))
            {
                textBlock24.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock25.Text, 5.0))
            {
                textBlock25.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock26.Text, 5.0))
            {
                textBlock26.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock28.Text, 5.0))
            {
                textBlock28.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock29.Text, 5.0))
            {
                textBlock29.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock30.Text, 5.0))
            {
                textBlock30.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock31.Text, 5.0))
            {
                textBlock31.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock32.Text, 5.0))
            {
                textBlock32.Background = new SolidColorBrush(color);
            }


            if (valueCheck(textBlock53.Text, 3.0))
            {
                textBlock53.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock54.Text, 3.0))
            {
                textBlock54.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock55.Text, 3.0))
            {
                textBlock55.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock56.Text, 3.0))
            {
                textBlock56.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock57.Text, 5.0))
            {
                textBlock57.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock58.Text, 5.0))
            {
                textBlock58.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock61.Text, 5.0))
            {
                textBlock61.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock62.Text, 5.0))
            {
                textBlock62.Background = new SolidColorBrush(color);
            }

            if (valueCheck(textBlock63.Text, 5.0))
            {
                textBlock63.Background = new SolidColorBrush(color);
            }
        }
        #endregion

    }
}
