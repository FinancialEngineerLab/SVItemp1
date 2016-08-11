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
using System.Windows.Forms;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Globalization;
using UtilityLib;

namespace WuhuaTianbao
{
    /// <summary>
    /// Interaction logic for IndustryReport.xaml
    /// </summary>
    public partial class IndustryReport : Window
    {
        private ObservableCollection<UtilityIndustryInfo> _data = new ObservableCollection<UtilityIndustryInfo>();

        public ObservableCollection<UtilityIndustryInfo> Data { get { return _data; } }
        private string dtDate = null;

        public IndustryReport()
        {
            InitializeComponent();
            AutomaticallyUpdate();
            FetchData();
            textBlock1.Text = dtDate + " 申万一级行业资金流入流出情况（单位：亿）";
            textBlock2.Text = dtDate + " 申万一级行业涨跌情况";
            
        }

        public void AutomaticallyUpdate()
        {
            DateTime dtCurrent = new DateTime();
            DateTime dtLast = new DateTime();

            GlobalWind.windEnsureStart();
            
            if (UtilityTime.isAfterTradeHour(DateTime.Now))
            {
                dtCurrent = DateTime.Now;
            }
            else
            {
                dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now, 1);
            }

            DataTable dtIndustryFlow = UtilityMySQLData.getIndustryFlowFromDB(dtCurrent.AddMonths(-1).ToShortDateString(), dtCurrent.ToShortDateString(), "*");
            dtLast = DateTime.ParseExact((dtIndustryFlow.Rows[dtIndustryFlow.Rows.Count - 1][0]).ToString(), "yyyy/M/d h:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

            if (dtLast.Date != dtCurrent.Date)
            {
                DateTime[] dtTrade = UtilityWindData.getTradeDays(UtilityTime.getPrevTradeDay(dtLast, -1), dtCurrent);
                for (int i = 0; i < dtTrade.Length; i++)
                {
                    NameValueCollection NCsection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
                    string[] strIndustryGroupMember = ConfigHelper.GetAppConfigWholeArray("ShenWanIndustryNameToCode");
                    string[] strIndustryGroupMemberName = ConfigHelper.GetAppKeyWholeArray("ShenWanIndustryNameToCode");

                    string[] strNetCapitalInflow = new string[strIndustryGroupMember.Length];
                    for (int k = 0; k < strIndustryGroupMember.Length; k++)
                    {
                        strNetCapitalInflow[k] = UtilityWindData.getWindIndustryNetCapitalInflow(strIndustryGroupMember[k], dtTrade[i]).ToString();
                    }
                    UtilityMySQLData.saveShenWanIndustryInflowIntoDB(strIndustryGroupMemberName, strNetCapitalInflow, dtTrade[i]);
                }             
            }
        }

        private void FetchData()
        {
            string name = null;
            double pct_chg = 0;
            double flow = 0;
            
            GlobalWind.windEnsureStart();           
            if (UtilityTime.isTradeDay(DateTime.Now) && UtilityTime.isAfterTradeHour(DateTime.Now))
            {
                dtDate = DateTime.Now.ToShortDateString();
            }
            else
            {
                dtDate = UtilityTime.getPrevTradeDay(DateTime.Now, 1).ToShortDateString();
            }

            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            DataTable dtIndustry = UtilityWindData.getPercentageChange(NCSection, dtDate, dtDate);
            dtIndustry = UtilityMySQLData.getIndustryCashflowFromDB(dtIndustry, dtDate);
            if (dtIndustry == null)
            {
                System.Windows.Forms.MessageBox.Show("今日行业资金流向数据尚未更新！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
            DataView dvIndustry = dtIndustry.DefaultView;
            dvIndustry.Sort = "涨跌幅 asc";
            dtIndustry = dvIndustry.ToTable();

            for (int i = 0; i < dtIndustry.Rows.Count; i++)
            {
                name = (dtIndustry.Rows[i][0].ToString());
                pct_chg = double.Parse(dtIndustry.Rows[i][1].ToString()) / 100;
                flow = double.Parse(dtIndustry.Rows[i][2].ToString());
                _data.Add(new UtilityIndustryInfo() { name = name, pct_chg = pct_chg , cashflow = flow});
            }
            this.DataContext = this;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
        }
    }
}
