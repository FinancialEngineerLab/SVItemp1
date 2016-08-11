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

namespace WuhuaTianbao
{
    /// <summary>
    /// Interaction logic for RongziRongquan.xaml
    /// </summary>
    public partial class RongziRongquan : Window
    {
        private ObservableCollection<UtilityRongziRongquanInfo> _RZRQData = new ObservableCollection<UtilityRongziRongquanInfo>();

        public ObservableCollection<UtilityRongziRongquanInfo> Data { get { return _RZRQData; } }

        private string dtBegin = null;
        private string dtEnd = null;

        public RongziRongquan()
        {
            InitializeComponent();
            AutomaticallyUpdateData();
            FetchData();
            textBlock1.Text = dtBegin + " 至 " + dtEnd + " 融资融券余额（单位：万亿）";
        }

        public void AutomaticallyUpdateData()
        {
            DateTime dtCurrent = new DateTime();
            DateTime dtLast = new DateTime();

            GlobalWind.windEnsureStart();
            if (DateTime.Now.Hour < 9)
            {
                dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now, 2);
            }
            else
            {
                dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now, 1);
            }

            DataTable dtRZRQ = UtilityMySQLData.getRongziRongquanDataFromDB(dtCurrent.AddMonths(-1).ToShortDateString(), dtCurrent.ToShortDateString());
            dtLast = DateTime.ParseExact((dtRZRQ.Rows[dtRZRQ.Rows.Count - 1][0]).ToString(), "yyyy/M/d h:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

            if (dtLast.Date < dtCurrent.Date)
            {
                DateTime dtTrade = UtilityTime.getPrevTradeDay(dtLast, -1);

                List<object> lsRZRQ = UtilityWindData.getWindEDBData("M0075992", dtTrade.ToShortDateString(), dtCurrent.ToShortDateString());

                UtilityMySQLData.saveRongziRongquanIntoDB(lsRZRQ);
            }
        }

        private void FetchData()
        {
            DateTime date = new DateTime();
            double amount = 0;
            double difference = 0;

            GlobalWind.windEnsureStart();
            dtEnd = DateTime.Now.ToShortDateString();
            dtBegin = UtilityTime.getPrevTradeDay(DateTime.Now, 21).ToShortDateString();

            DataTable dtRZRQ = UtilityMySQLData.getRongziRongquanDataFromDB(dtBegin, dtEnd);

            for (int i = 1; i < dtRZRQ.Rows.Count; i++)
            {
                date = (System.DateTime)(dtRZRQ.Rows[i][0]);
                dtEnd = date.ToShortDateString();
                amount = double.Parse(dtRZRQ.Rows[i][1].ToString());
                difference = double.Parse(dtRZRQ.Rows[i][1].ToString()) - double.Parse(dtRZRQ.Rows[i - 1][1].ToString());

                _RZRQData.Add(new UtilityRongziRongquanInfo() { date = date.ToString("MM/dd"), amount = amount, difference = difference });
            }
            this.DataContext = this;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
        }
    }
}
