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
    /// Interaction logic for SmallCapShare.xaml
    /// </summary>
    public partial class SmallCapShare : Window
    {
        private ObservableCollection<UtilityExcessReturn> _SmallCapShare = new ObservableCollection<UtilityExcessReturn>();

        public ObservableCollection<UtilityExcessReturn> Data { get { return _SmallCapShare; } }

        private DateTime dtBegin = new DateTime();
        private DateTime dtEnd = new DateTime();

        public SmallCapShare()
        {
            InitializeComponent();
            FetchData();
        }

        public void FetchData()
        {
            string[] strCode = { "000300.SH", "000852.SH" };
            int[] iDays = { 30, 60 };

            DateTime date = new DateTime();
            double compareCapIndex = 0;
            double benchmarkIndex = 0;
            double ratio = 0;
            double excessReturn30 = 0;
            double excessReturn60 = 0;
            double quantile30 = 0;
            double quantile60 = 0;

            GlobalWind.windEnsureStart();
            if (UtilityTime.isAfterTradeHour(DateTime.Now))
            {
                dtEnd = DateTime.Now;
            }
            else
            {
                dtEnd = UtilityTime.getPrevTradeDay(DateTime.Now, 1);
            }
            dtBegin = UtilityTime.getPrevTradeDay(dtEnd.AddYears(-3), 0);

            DataTable dtData = UtilityWindData.getWindHistoryData(strCode, dtBegin.ToShortDateString(), dtEnd.ToShortDateString(), "close");

            double[] dHS300 = UtilityArray.getColFromTable(dtData, 1);
            double[] dZZ1000 = UtilityArray.getColFromTable(dtData, 2);

            List<List<double>> dExcessReturn = UtilityMath.getMultiPeriodExcessReturnOverIndex(dZZ1000, dHS300, iDays);
            List<List<double>> dQuantile = UtilityMath.getMultiPeriodFractile(dExcessReturn, iDays);

            for (int i = 0; i < iDays.Length; i++)
            {
                dtData.Columns.Add(iDays[i] + "DaysExcessReturn", Type.GetType("System.Double"));
                dtData.Columns.Add(iDays[i] + "DaysQuantile", Type.GetType("System.Double"));
            }

            int iRows = dtData.Rows.Count;
            for (int i = 1; i <= dQuantile[1].Count; i++)
            {
                for (int j = 0; j < iDays.Length; j++)
                {
                    dtData.Rows[iRows - i][j * 2 + 3] = dExcessReturn[j][dExcessReturn[j].Count - i];
                    dtData.Rows[iRows - i][j * 2 + 4] = dQuantile[j][dQuantile[j].Count - i];
                }
            }


            for (int i = 200; i > 0; i--)         //将一年统一为250个交易日以简化计算
            {
                date = (System.DateTime)(dtData.Rows[iRows - i][0]);
                compareCapIndex = double.Parse(dtData.Rows[iRows - i][2].ToString());
                benchmarkIndex = double.Parse(dtData.Rows[iRows - i][1].ToString());
                ratio = compareCapIndex / benchmarkIndex;
                excessReturn30 = double.Parse(dtData.Rows[iRows - i][3].ToString());
                excessReturn60 = double.Parse(dtData.Rows[iRows - i][5].ToString());
                quantile30 = double.Parse(dtData.Rows[iRows - i][4].ToString());
                quantile60 = double.Parse(dtData.Rows[iRows - i][6].ToString());

                _SmallCapShare.Add(
                    new UtilityExcessReturn()
                    {
                        date = date.ToString("yy/MM/dd"),
                        compareCapIndex = compareCapIndex,
                        benchmarkIndex = benchmarkIndex,
                        ratio = ratio,
                        excessReturn30 = excessReturn30,
                        excessReturn60 = excessReturn60,
                        quantile30 = quantile30,
                        quantile60 = quantile60
                    }
                );
            }
            this.DataContext = this;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData();
        }
    }
}
