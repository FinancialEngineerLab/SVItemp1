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
    /// Interaction logic for ZZ800ExcessReturn.xaml
    /// </summary>
    public partial class ZZ800ExcessReturn : Window
    {
        private ObservableCollection<UtilityIndustryInfo> _data = new ObservableCollection<UtilityIndustryInfo>();

        public ObservableCollection<UtilityIndustryInfo> Data { get { return _data; } }

        public ZZ800ExcessReturn()
        {
            InitializeComponent();
            FetchData();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
        }

        private void FetchData()
        {
            string name = null;
            double pct_chg = 0.0;
            double dIndexSmall = 0.0;
            double dIndexLarge = 0.0;
            int iDay = 0;

            DateTime dtBegin = UtilityTime.getPrevTradeDay(DateTime.Now, 61);
            DataTable dtZZ800 = UtilityMySQLData.getZZ800IndexFromDB(dtBegin.ToShortDateString(), DateTime.Now.ToShortDateString(), "zz800Large,zz800Small");

            int[] iLens = { 1, 3, 5, 10, 30, 60 };
            int iRows = dtZZ800.Rows.Count;
            

            for (int i = 0; i < iLens.Length; i++)
            {
                name = iLens[i].ToString() + "日";

                iDay = iRows - iLens[i];
                dIndexLarge = double.Parse(dtZZ800.Rows[iRows - 1][1].ToString()) / double.Parse(dtZZ800.Rows[iDay - 1][1].ToString());
                dIndexSmall = double.Parse(dtZZ800.Rows[iRows - 1][2].ToString()) / double.Parse(dtZZ800.Rows[iDay - 1][2].ToString());

                pct_chg = dIndexSmall - dIndexLarge;
                _data.Add(new UtilityIndustryInfo() { name = name, pct_chg = pct_chg });
            }
            this.DataContext = this;
        }
    }
}
