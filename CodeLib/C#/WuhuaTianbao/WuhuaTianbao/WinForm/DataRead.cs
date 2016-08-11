using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Configuration;
using System.Collections.Specialized;
using UtilityLib;


namespace WuhuaTianbao
{
    public partial class DataRead : Form
    {
        DataSet dsResult = new DataSet();

        public DataRead()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Load the options
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string WindCode = NCSection[comboBox1.SelectedItem.ToString()].ToString();
            
            DateTime dtBegin = dateTimePicker1.Value.Date;
            DateTime dtEnd  = dateTimePicker2.Value.Date;

            // Date check
            if (dtBegin > dtEnd)
            {
                MessageBox.Show("开始日期必须早于结束日期！请重新调整", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
            }

            // Select the data needed from the MySQL database
            string strDBType = "MySQL";
            UtilityLib.DBConnect sqlConn = new UtilityLib.DBConnect(strDBType);
            string strQuery = "SELECT date, `" + WindCode + "` FROM industry_close WHERE date > '" + dtBegin.AddDays(-1).ToShortDateString() + "' AND date < '" + dtEnd.AddDays(1).ToShortDateString() + "'";
            dsResult = sqlConn.Select(strQuery);

            string strTitile = WindCode + " 自 " + dtBegin.ToShortDateString() + " 至 " + dtEnd.ToShortDateString() + " 数据：";
            // Show in the new form
            DataExhibit de = new DataExhibit(dsResult, strTitile);
            de.Show();
        }
    }
}
