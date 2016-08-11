using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using UtilityLib;
using System.Windows.Forms;

namespace WuhuaTianbao
{
    public partial class OptionArbs : Form
    {
        public string strFutureContract = null;
        public string strCallOption = null;
        public string strPutOption = null;
             
        public OptionArbs()
        {
            InitializeComponent();
        }

        private void StartRetrieve_Click(object sender, EventArgs e)
        {
            strFutureContract = GlobalWind.windCodeCheck(textBox1.Text, ".CFE");
            strCallOption = GlobalWind.windCodeCheck(textBox2.Text, ".SH");
            strPutOption = GlobalWind.windCodeCheck(textBox3.Text, ".SH");
            double dAlertVal = Convert.ToDouble(textBox4.Text) / 100;

            GlobalWind.windEnsureStart();
            double[,] dExePrice = UtilityWindData.getExercisePrice(strCallOption + "," + strPutOption);
            if (dExePrice[0, 0] != dExePrice[0, 1])
            {
                MessageBox.Show("认购期权、认沽期权不匹配！请检查", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
            }

            OptionMonitor om = new OptionMonitor(strFutureContract, strCallOption, strPutOption, dAlertVal);
            om.Show();
            this.Close();
        }
    }
}
