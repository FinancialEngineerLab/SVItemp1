using System;
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
using UtilityLib;
using System.Data;

namespace WuhuaTianbao.Xaml
{
    /// <summary>
    /// Interaction logic for ZZ800EqualWeightII.xaml
    /// </summary>
    public partial class ZZ800EqualWeightII : Window
    {
        public List<Utiltity800Index> Data { get; set; }

        private DateTime dtBegin = new DateTime();
        private DateTime dtEnd = new DateTime();

        public ZZ800EqualWeightII()
        {
            InitializeComponent();

            AutomaticallyUpdateData();
            LoadData();
            ZZ800EqualWeightDataSet.ItemsSource = Data;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            AutomaticallyUpdateData();
            LoadData();

            this.DataContext = this;
        }

        // 启动之前自动刷新数据至最新
        public void AutomaticallyUpdateData()
        {
            DateTime dtCurrent = new DateTime();
            DateTime dtLast = new DateTime();

            // 收盘前更新至前一交易日，收盘后更新至今日数据
            GlobalWind.windEnsureStart();
            if (UtilityTime.isAfterTradeHour(DateTime.Now))
            {
                dtCurrent = DateTime.Now;
            }
            else
            {
                dtCurrent = UtilityTime.getPrevTradeDay(DateTime.Now, 1);
            }

            // 获取MySQL数据库中最后一条数据确定最后一次更新的时间
            DataTable dtZZ800 = UtilityMySQLData.getZZ800IndexFromDB(dtCurrent.AddMonths(-1).ToShortDateString(), dtCurrent.ToShortDateString(), "zz800Full");
            dtLast = DateTime.ParseExact((dtZZ800.Rows[dtZZ800.Rows.Count - 1][0]).ToString(), "yyyy/M/d h:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

            if (dtLast.Date != dtCurrent.Date)
            {
                // 获取交易日期序列（去掉上一交易日）
                DateTime[] dtTrade = UtilityWindData.getTradeDays(UtilityTime.getPrevTradeDay(dtLast, -1), dtCurrent);
                DateTime dtBegin = dtTrade[0];

                //计算指数数据
                double[,] dZZ800Index = UtilityWindData.getZZ800EqualWeightIndex(dtBegin, dtCurrent, "ZZ800Full");
                // 批量保存至MySQL
                UtilityMySQLData.saveZZ800IndexIntoDB(dtTrade, dZZ800Index);
            }
        }

        private List<Utiltity800Index> FetchData()
        {
            // 获取1年期数据
            dtEnd = DateTime.Now;
            dtBegin = DateTime.ParseExact("2011/12/30", "yyyy/MM/dd", System.Globalization.CultureInfo.CurrentCulture);

            DataTable dtZZ800 = UtilityMySQLData.getZZ800IndexFromDB(dtBegin.ToShortDateString(), dtEnd.ToShortDateString(), "zz800Full,zz800Large,zz800Small");

            var res = new List<Utiltity800Index>();
            for (int i = 0; i < dtZZ800.Rows.Count; i++)
            {
                DateTime dt = DateTime.ParseExact((dtZZ800.Rows[i][0]).ToString(), "yyyy/M/d h:mm:ss", System.Globalization.CultureInfo.InvariantCulture);

                res.Add(
                    new Utiltity800Index()
                    {
                        datetime = dt,
                        zz800Full = double.Parse(dtZZ800.Rows[i][1].ToString()),
                        zz800Large = double.Parse(dtZZ800.Rows[i][2].ToString()),
                        zz800Small = double.Parse(dtZZ800.Rows[i][3].ToString()),
                        zz800Ratio = double.Parse(dtZZ800.Rows[i][3].ToString()) / double.Parse(dtZZ800.Rows[i][2].ToString()) * 100
                    }
                    );
            }
            return res;
        }

        private void LoadData()
        {
            Data = FetchData();

            ZZ800EqualWeight2.Charts[1].Graphs[0].Title = "中证800等权重指数";
            ZZ800EqualWeight2.Charts[0].Collapse();
        }
    }
}
