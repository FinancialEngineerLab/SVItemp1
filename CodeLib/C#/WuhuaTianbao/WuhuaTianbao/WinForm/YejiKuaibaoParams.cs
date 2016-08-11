using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WuhuaTianbao.WinForm
{
    public partial class YejiKuaibaoParams : Form
    {
        private Main ssm;

        public YejiKuaibaoParams(Main ssm_)
        {
            InitializeComponent();

            ssm = ssm_;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string strYear = textBox1.Text;
            double roeThreshold = double.Parse(textBox2.Text);
            double netProfitThreshold = double.Parse(textBox5.Text);
            double expectProfitThreshold = double.Parse(textBox3.Text);
            double expectUpwardsThreshold = double.Parse(textBox4.Text);
            double operationIncomeThreshold = double.Parse(textBox6.Text);

            DataTable dtResult = Strategy.StratYejiKuaibao.getYejiKuaibaoResult(strYear, roeThreshold, netProfitThreshold, expectProfitThreshold, operationIncomeThreshold, expectUpwardsThreshold);

            ssm.dataGridView1.DataSource = dtResult;
            ssm.dataGridView1.Columns["快报公布日"].DefaultCellStyle.Format = "yyyy/MM/dd";
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
