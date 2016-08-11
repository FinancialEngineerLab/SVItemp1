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
    /// Interaction logic for MarcoMkt.xaml
    /// </summary>
    public partial class MarcoMkt : Window
    {
        private ObservableCollection<UtilityMarcoMkt> _MacroMkt = new ObservableCollection<UtilityMarcoMkt>();

        public ObservableCollection<UtilityMarcoMkt> Data { get { return _MacroMkt; } }
        public List<object> lsInput;

        public MarcoMkt(List<object> lsData, string[] strSerialNames)
        {
            InitializeComponent();
            FetchData(lsData);
            lsInput = lsData;
            MacroData.Graphs[0].Title = strSerialNames[0];
            MacroData.Graphs[1].Title = strSerialNames[1];
            label1.Content = strSerialNames[2];
        }

        public void FetchData(List<object> lsData)
        {
            try
            {
                DateTime[] dtTimeArray = (DateTime[])lsData[0];
                double[,] dDataArray = (double[,])lsData[1];
                int iRow0 = 0;
                int iRow1 = 0;

                for (int i = 0; i < dtTimeArray.Length; i++)
                {
                    iRow0 = i;
                    iRow1 = i;
                    while (double.IsNaN(dDataArray[iRow0, 0]))
                    {
                        if (iRow0 != 0)
                        {
                            iRow0--;
                        }
                    }
                    while (double.IsNaN(dDataArray[iRow1, 1]))
                    {
                        if (iRow1 != 0)
                        {
                            iRow1--;
                        }
                    }

                    _MacroMkt.Add(
                    new UtilityMarcoMkt()
                    {
                        date = dtTimeArray[i].ToString("yy/MM/dd"),
                        group1 = dDataArray[iRow0, 0],
                        group2 = dDataArray[iRow1, 1]
                    }
                    );
                }
                this.DataContext = this;
            }
            catch
            {
                throw new Exception("MacroMkt.FetchData:数据不正确！");
            }
            
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            FetchData(lsInput);
        }
    }
}
