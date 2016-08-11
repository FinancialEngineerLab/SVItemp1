using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using UtilityLib;
using System.Data.OleDb;



namespace WuhuaTianbao
{
    public partial class Params : Form
    {
        public Params(Main ssm_)
        {
            InitializeComponent();
            textBox1.Text = DateTime.Now.AddYears(-1).Year.ToString();
            textBox2.Text = "90";
            ssm = ssm_;
        }
        private Main ssm;

        private void button1_Click_1(object sender, EventArgs e)
        {
            string strYear = textBox1.Text;
            double dPercentile = Convert.ToDouble(textBox2.Text);
            bool bStatus = checkBox1.Checked;
            DataTable dtResult = Strategy.PEAD.result_YejiKuaibaoStrat(strYear, dPercentile);

            MessageBox.Show("提取的股票数据在3月30号之后有可能为一季报数据，使用时需注意！", "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning);

            /* ------------------------------ 假如选择不显示停牌股 ------------------------------ */
            if (bStatus == false)
            {
                for (int i = dtResult.Rows.Count -1; i >= 0; i--)
                {
                    if (dtResult.Rows[i]["交易状态"].ToString() != "今日交易")
                    {
                        dtResult.Rows[i].Delete();
                    }
                }
                dtResult.AcceptChanges();
            }            

            ssm.dataGridView1.DataSource = dtResult;
            ssm.dataGridView1.Columns["报告日"].DefaultCellStyle.Format = "yyyy/MM/dd";
            ssm.dataGridView1.Sort(ssm.dataGridView1.Columns[0], ListSortDirection.Descending);
            ssm.dataGridView1.RowPostPaint += new System.Windows.Forms.DataGridViewRowPostPaintEventHandler(this.DataGridView_RowPostPaint);
            
            this.Hide();
            ssm.Show();
        }

        public void DataGridView_RowPostPaint(object sender, DataGridViewRowPostPaintEventArgs e)
        {
            System.Drawing.Rectangle rectangle = new System.Drawing.Rectangle(e.RowBounds.Location.X,
                e.RowBounds.Location.Y,
                ssm.dataGridView1.RowHeadersWidth - 4,
                e.RowBounds.Height);

            TextRenderer.DrawText(e.Graphics, (e.RowIndex + 1).ToString(),
                ssm.dataGridView1.RowHeadersDefaultCellStyle.Font,
                rectangle,
                ssm.dataGridView1.RowHeadersDefaultCellStyle.ForeColor,
                TextFormatFlags.VerticalCenter | TextFormatFlags.Right);
        }
    }
}
