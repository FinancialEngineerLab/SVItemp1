using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using System.Timers;
using System.Reflection;
using System.Runtime.InteropServices;
using UtilityLib;

namespace WuhuaTianbao.WinForm
{
    public partial class MarketMonitorAlert : Form
    {
        public MarketMonitorAlert(string strName, DataTable dtResult)
        {
            InitializeComponent();

            label_IndustryName.Text = strName;
            dataGridView1.DataSource = dtResult;
        }

        public void label_IndustryName_TextChanged(object sender, EventArgs e)
        {
            System.Threading.Thread t1 = new System.Threading.Thread(new ParameterizedThreadStart(UtilityThread.BackgroundFlashing));
            t1.IsBackground = true;
            t1.Start((object)label_IndustryName);
        }

        
    }
}
