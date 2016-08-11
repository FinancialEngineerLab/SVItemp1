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

namespace WuhuaTianbao.Xaml
{
    /// <summary>
    /// Interaction logic for IndexEvolution.xaml
    /// </summary>
    public partial class IndexEvolution : Window
    {
        public List<UtilityChartInfo> Data { get; set; }

        public IndexEvolution(DateTime[] dtDateArray, double[,] dData, string strGraphName)
        {
            InitializeComponent();

            LoadData(dtDateArray, dData, strGraphName);
            ParameterDataSet.ItemsSource = Data;
        }
        private void LoadData(DateTime[] dtDateArray, double[,] dData, string strGraphName)
        {
            Data = FetchData(dtDateArray, dData);

            ParameterExhibition.Charts[0].Collapse();
            ParameterExhibition.Charts[1].Graphs[0].Title = strGraphName;
        }

        private List<UtilityChartInfo> FetchData(DateTime[] dtDateArray, double[,] dData)
        {
            DateTime dtDate = new DateTime();
            double dInput = 0;

            var res = new List<UtilityChartInfo>();

            for (int i = 0; i < dtDateArray.Length; i++)
            {
                dtDate = dtDateArray[i];
                dInput = dData[i, 0];

                res.Add
                    (
                    new UtilityChartInfo
                    {
                        date = dtDate,
                        close = dInput
                    }
                    );
            }
            return res;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            this.DataContext = this;
        }
    }
}
