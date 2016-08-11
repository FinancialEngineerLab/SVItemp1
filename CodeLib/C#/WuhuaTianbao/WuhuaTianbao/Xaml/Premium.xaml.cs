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


namespace WuhuaTianbao
{
    /// <summary>
    /// Interaction logic for Premium.xaml
    /// </summary>
    public partial class Premium : Window
    {

        public List<UtilityChartInfo> Data { get; set; }

        public Premium(List<UtilityChartInfo> lInputData, Dictionary<string, string> dicSetting)
        {
            InitializeComponent();

            LoadData(lInputData, dicSetting);
            stockSet1.ItemsSource = Data;
        }

        private void LoadData(List<UtilityChartInfo> lInputData, Dictionary<string, string> dicSetting)
        {
            Data = lInputData;

            premium.Charts[1].Title = dicSetting["图例1标题"].ToString();
            // 命名K线代表指数名
            premium.Charts[1].Graphs[0].Title = dicSetting["线1标题"].ToString();
            premium.Charts[0].Collapse();

            premium.Charts[1].Title = dicSetting["图例2标题"].ToString();
            // 作参考的趋势线
            premium.Charts[2].Graphs[0].Title = dicSetting["线2标题"].ToString();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            this.DataContext = this;
        }
    }
}
