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
    /// Interaction logic for SHHKStock.xaml
    /// </summary>
    public partial class SHHKStock : Window
    {
        private ObservableCollection<UtiltiySHHKInfo> _SHHKdata = new ObservableCollection<UtiltiySHHKInfo>();

        public ObservableCollection<UtiltiySHHKInfo> Data { get { return _SHHKdata; } }

        public SHHKStock()
        {
            InitializeComponent();
            FetchData();
        }

        private void FetchData()
        {
            DateTime date = new DateTime();
            double SH = 0;
            double HK = 0;

            GlobalWind.windEnsureStart();
            string dtEnd = DateTime.Now.ToShortDateString();
            string dtBegin = UtilityTime.getPrevTradeDay(DateTime.Now, 20).ToShortDateString();

            DataTable dtRZRQ = UtilityMySQLData.getHuGangTongDataFromDB(dtBegin, dtEnd);

            for (int i = 0; i < dtRZRQ.Rows.Count; i++)
            {
                date = (System.DateTime)(dtRZRQ.Rows[i][0]);
                SH = double.Parse(dtRZRQ.Rows[i][1].ToString());
                HK = double.Parse(dtRZRQ.Rows[i][2].ToString());

                _SHHKdata.Add(new UtiltiySHHKInfo() { date = date.ToString("MM/dd"), SH = SH, HK = HK });
            }
            this.DataContext = this;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
        }
    }
}
