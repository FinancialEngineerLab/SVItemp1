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


namespace WuhuaTianbao.Xaml
{
    /// <summary>
    /// Interaction logic for InterestCommodityMarket.xaml
    /// </summary>
    public partial class InterestCommodityMarket : Window
    {
        public InterestCommodityMarket()
        {
            InitializeComponent();
        }

        private DateTime dtCurrent = new DateTime();
        private DateTime dtOneWeek = new DateTime();
        private DateTime dtTwoWeek = new DateTime();
        private DateTime dtOneMonth = new DateTime();

        public void FetchData()
        {
            GlobalWind.windEnsureStart();

            dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now.AddDays(-1), 0);
            dtOneWeek = UtilityTime.getPrevTradeDay(dtCurrent.AddDays(-7), 0);
            dtTwoWeek = UtilityTime.getPrevTradeDay(dtCurrent.AddDays(-14), 0);
            dtOneMonth = UtilityTime.getPrevTradeDay(dtCurrent.AddMonths(-1), 0);
            

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

            /* ------------------票据贴现------------------ */
            List<object> lsNoteMkt = UtilityWindData.getWindCentralBankBill(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
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

            /* ------------------央行票据------------------ */
            List<object> lsCentralBankBill = UtilityWindData.getWindNoteMkt(dtOneMonth.ToShortDateString(), dtCurrent.ToShortDateString());
            double[,] dCentralNoteBank = (double[,])lsCentralBankBill[1];
            dtTradeDate = (DateTime[])lsCentralBankBill[0];

            // One week
            string strIssueOneWeek = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtOneWeek);
            string strExpireOneWeek = getAbsoluteRelativeChange(dCentralNoteBank, 1, dtTradeDate, dtCurrent, dtOneWeek);
            // Two week
            string strIssueTwoWeek = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtTwoWeek);
            string strExpireTwoWeek = getAbsoluteRelativeChange(dCentralNoteBank, 1, dtTradeDate, dtCurrent, dtTwoWeek);
            // One Month
            string strIssueOneMonth = getAbsoluteRelativeChange(dCentralNoteBank, 0, dtTradeDate, dtCurrent, dtOneMonth);
            string strExpireOneMonth = getAbsoluteRelativeChange(dCentralNoteBank, 1, dtTradeDate, dtCurrent, dtOneMonth);

            textBlock11.Text = strIssueOneWeek;
            textBlock19.Text = strIssueTwoWeek;
            textBlock27.Text = strIssueOneMonth;

            textBlock12.Text = strExpireOneWeek;
            textBlock20.Text = strExpireTwoWeek;
            textBlock28.Text = strExpireOneMonth;
         }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
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
                    while(double.IsNaN(dInputMatrix[iNum, iCols]))
                    {
                        iNum--;
                    }
                    dCurrent = dInputMatrix[iNum, iCols];
                }
                if (dtTradeDate[i] == dtFormer.Date)
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

            string strResult = dAbsolute.ToString("0.000") + " / " + dRelative.ToString("0.000%");
            return strResult;
        }

        #region  FX Graph Loading
        private void textBlock9_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            List<object> lsFXMkt = null;
            string strEndDate = DateTime.Now.ToShortDateString();
            string strStartDate = DateTime.Now.AddYears(-1).ToShortDateString();

            lsFXMkt = UtilityWindData.getWindFXMkt(strStartDate, strEndDate);
            double[,] dFXMkt = (double[,])lsFXMkt[1];
            DateTime[] dtTradeDate = (DateTime[])lsFXMkt[0];
            string[] strLineName = { "绝对变化", "相对变化" };

            MacroMkt mm = new MacroMkt(dtTradeDate, dFXMkt, "人民币中间价", strLineName);
            mm.Show();
        }

        private void textBlock10_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock9_MouseDoubleClick(sender, e);
        }

        private void textBlock17_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock9_MouseDoubleClick(sender, e);
        }

        private void textBlock18_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock9_MouseDoubleClick(sender, e);
        }

        private void textBlock25_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock9_MouseDoubleClick(sender, e);
        }

        private void textBlock26_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock9_MouseDoubleClick(sender, e);
        }

        #endregion

        #region 央票利率曲线
        private void textBlock11_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            List<object> lsCentralBankBillMkt = null;
            string strEndDate = DateTime.Now.ToShortDateString();
            string strStartDate = DateTime.Now.AddYears(-1).ToShortDateString();

            lsCentralBankBillMkt = UtilityWindData.getWindCentralBankBill(strStartDate, strEndDate);
        }

        private void textBlock12_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock11_MouseDoubleClick(sender, e);
        }

        private void textBlock19_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock11_MouseDoubleClick(sender, e);
        }

        private void textBlock20_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock11_MouseDoubleClick(sender, e);
        }

        private void textBlock27_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock11_MouseDoubleClick(sender, e);
        }

        private void textBlock28_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock11_MouseDoubleClick(sender, e);
        }
        #endregion

        #region 票据贴现利率
        private void textBlock13_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            List<object> lsNoteMkt = null;
            string strEndDate = DateTime.Now.ToShortDateString();
            string strStartDate = DateTime.Now.AddYears(-1).ToShortDateString();

            lsNoteMkt = UtilityWindData.getWindNoteMkt(strStartDate, strEndDate);
        }

        private void textBlock14_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock13_MouseDoubleClick(sender, e);
        }

        private void textBlock21_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock13_MouseDoubleClick(sender, e);
        }

        private void textBlock22_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock13_MouseDoubleClick(sender, e);
        }

        private void textBlock29_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock13_MouseDoubleClick(sender, e);
        }

        private void textBlock30_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock13_MouseDoubleClick(sender, e);
        }
        #endregion

        #region 银行间市场利率
        private void textBlock15_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            List<object> lsInterBankMkt = null;
            string strEndDate = DateTime.Now.ToShortDateString();
            string strStartDate = DateTime.Now.AddYears(-1).ToShortDateString();

            lsInterBankMkt = UtilityWindData.getWindIRMkt(strStartDate, strEndDate);
        }

        private void textBlock16_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock15_MouseDoubleClick(sender, e);
        }

        private void textBlock23_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock15_MouseDoubleClick(sender, e);
        }

        private void textBlock24_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock15_MouseDoubleClick(sender, e);
        }

        private void textBlock31_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock15_MouseDoubleClick(sender, e);
        }

        private void textBlock32_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            textBlock15_MouseDoubleClick(sender, e);
        }
        #endregion

    }
}
