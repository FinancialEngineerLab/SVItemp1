using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SuperNova
{

    public partial class Form3 : Form
    {
        
        DataTableOperation dtOper = new DataTableOperation();
        DataTable dtZCGList = new DataTable();
        DataTable dtNAV = new DataTable();
        DataTable dtProductList = new DataTable();

        public Form3()
        {
            InitializeComponent();
        }

        public void setDataTable(DataTable dtZCGList_, DataTable dtNAV_, DataTable dtProductList_)
        {
            dtZCGList = dtZCGList_.Copy();
            dtNAV = dtNAV_.Copy();
            dtProductList = dtProductList_.Copy();
        }

        public DataTable createDataTable_StressTest()
         {
             DataTable dtStressTest = new DataTable();
             double dHS300Return = 0.0;
             double dNonHS300Return = 0.0;
             double dHS300Prop = 0.0;
             double dNonHS300Prop = 0.0;
             double dHedgeProp = 0.0;
             int iStartCol = 5;

             dHS300Return = double.Parse(textBox1.Text);
             dNonHS300Return = double.Parse(textBox2.Text);
             dHedgeProp = double.Parse(textBox3.Text);

             //  输入参数有效性测试
             bool bValidity = inputParametersCheck(dtZCGList, dtNAV, dHS300Return, dNonHS300Return);
             
             //  取得无重复的产品名 => 产品名字纵向放置  
            
             dtStressTest.Columns.Add("产品名称", typeof(string));

             for (int i = 0; i < dtProductList.Rows.Count; i++)
             {
                 dtStressTest.Rows.Add(dtProductList.Rows[i]["基金名称"].ToString());
             }

             dtStressTest.Columns.Add("%沪深300", typeof(double));
             dtStressTest.Columns.Add("%非沪深300", typeof(double));
             dtStressTest.Columns.Add("当前净值", typeof(double));
             dtStressTest.Columns.Add("压力测试净值变化", typeof(double));
             dtStressTest.Columns.Add("压力测试后净值", typeof(double));

             for (int i = 0; i < dtStressTest.Rows.Count; i++)
             {
                 // 第二列： 每个产品的沪深300股票比例 - 该比例为占净值比例
                 dtStressTest.Rows[i]["%沪深300"] = dtOper.getColumnSum(dtZCGList, iStartCol + i, dtZCGList.Columns.Count - 1);

                 // 第三列： 每个产品的非沪深300股票比例       
                 dtStressTest.Rows[i]["%非沪深300"] = double.Parse(dtZCGList.Rows[0][iStartCol + i].ToString()) - double.Parse(dtStressTest.Rows[i]["%沪深300"].ToString());

                 // 第四列：当前净值
                 dtStressTest.Rows[i]["当前净值"] = double.Parse(dtNAV.Rows[i][2].ToString());

                 // 第五列：净值变化
                 dHS300Prop = double.Parse(dtStressTest.Rows[i]["%沪深300"].ToString());
                 dNonHS300Prop = double.Parse(dtStressTest.Rows[i]["%非沪深300"].ToString());
                 dtStressTest.Rows[i]["压力测试净值变化"] = (dHS300Return * dHS300Prop + dNonHS300Prop * dNonHS300Return - dHedgeProp / 100.0 * (dHS300Prop + dNonHS300Prop) * dHS300Return) / 100.0;

                 // 第六列：压力净值
                 dtStressTest.Rows[i]["压力测试后净值"] = double.Parse(dtStressTest.Rows[i]["当前净值"].ToString()) + double.Parse(dtStressTest.Rows[i]["压力测试净值变化"].ToString());

             }

             return dtStressTest;
         }

        public bool inputParametersCheck(DataTable dtZCGList, DataTable dtNAV, double dHS300Return, double dNonHS300Return)
        {
            if (dtZCGList.Rows.Count == 0)
            {
                MessageBox.Show("重仓股数据为空，无法进行压力测试!");
                return false;
            }

            if (dtNAV.Rows.Count == 0)
            {
                MessageBox.Show("净值数据为空， 无法进行压力测试");
                return false;
            }

            if (dHS300Return > 10 || dHS300Return < -10 || dNonHS300Return > 10 || dHS300Return < -10)
            {
                MessageBox.Show("沪深300或者非沪深300涨跌幅不得超过10%");
                return false;
            }

            return true;
        }

        public DataTable createDataTable_ProportionTest()
        {
            DataTable dtProportionTest = new DataTable();
            double dHS300Return = 0.0;
            double dNonHS300Return = 0.0;
            double dHS300Prop = 0.0;
            double dNonHS300Prop = 0.0;
            double dHedgeProp = 0.0;
            double dNAVChg = 0.0;
            double dCurrentNAVChg = 0.0;
            int iStartCol = 5;

            dHS300Return = double.Parse(textBox1.Text);
            dNonHS300Return = double.Parse(textBox2.Text);
            dHedgeProp = double.Parse(textBox3.Text);
            dNAVChg = double.Parse(textBox4.Text) / 100.0;

            //  输入参数有效性测试
            bool bValidity = inputParametersCheck(dtZCGList, dtNAV, dHS300Return, dNonHS300Return);

            // 第一列： 取得无重复的产品名 => 产品名字纵向放置  
            dtProportionTest.Columns.Add("产品名称", typeof(string));

            for (int i = 0; i < dtProductList.Rows.Count; i++)
            {
                dtProportionTest.Rows.Add(dtProductList.Rows[i][0].ToString());
            }

            dtProportionTest.Columns.Add("%沪深300", typeof(double));
            dtProportionTest.Columns.Add("%非沪深300", typeof(double));
            dtProportionTest.Columns.Add("当前净值", typeof(double));
            dtProportionTest.Columns.Add("仓位调整后净值", typeof(double));
            dtProportionTest.Columns.Add("持有股票调整比例", typeof(double));

            for (int i = 0; i < dtProportionTest.Rows.Count; i++)
            {
                // 第二列： 每个产品的沪深300股票比例 - 该比例为占净值比例
                dtProportionTest.Rows[i]["%沪深300"] = dtOper.getColumnSum(dtZCGList, iStartCol + i, dtZCGList.Columns.Count - 1);

                // 第三列： 每个产品的非沪深300股票比例       
                dtProportionTest.Rows[i]["%非沪深300"] = double.Parse(dtZCGList.Rows[0][iStartCol + i].ToString()) - double.Parse(dtProportionTest.Rows[i]["%沪深300"].ToString());

                // 第四列：当前净值
                dtProportionTest.Rows[i]["当前净值"] = double.Parse(dtNAV.Rows[i][2].ToString());

                // 第五列：仓位调整后净值
                dtProportionTest.Rows[i]["仓位调整后净值"] = double.Parse(dtNAV.Rows[i][2].ToString()) * (1 + dNAVChg);

                // 第六列：持有股票调整比例
                dHS300Prop = double.Parse(dtProportionTest.Rows[i]["%沪深300"].ToString());
                dNonHS300Prop = double.Parse(dtProportionTest.Rows[i]["%非沪深300"].ToString());
                dCurrentNAVChg = (dHS300Return * dHS300Prop + dNonHS300Prop * dNonHS300Return - dHedgeProp / 100.0 * (dHS300Prop + dNonHS300Prop) * dHS300Return) / 100.0;

                dtProportionTest.Rows[i]["持有股票调整比例"] = (dHS300Prop + dNonHS300Prop) * (dNAVChg / dCurrentNAVChg - 1);

            }

            return dtProportionTest;
        }

        public void refreshDataGridView_StressTest(DataTable dtSource)
        {
            dgvStressTest.DataSource = dtSource;
            // 产品名称
            dgvStressTest.Columns["产品名称"].Width = 150;
            
            // 沪深300比例
            dgvStressTest.Columns["%沪深300"].Width = 100;
            dgvStressTest.Columns["%沪深300"].DefaultCellStyle.Format = "0.00%";
            dgvStressTest.Columns["%沪深300"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            
            // 非沪深300比例
            dgvStressTest.Columns["%非沪深300"].Width = 100;
            dgvStressTest.Columns["%非沪深300"].DefaultCellStyle.Format = "0.00%";
            dgvStressTest.Columns["%非沪深300"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 当前净值
            dgvStressTest.Columns["当前净值"].DefaultCellStyle.Format = "0.000";
            dgvStressTest.Columns["当前净值"].Width = 80;
            dgvStressTest.Columns["当前净值"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 净值变化
            dgvStressTest.Columns["压力测试净值变化"].DefaultCellStyle.Format = "0.000";
            dgvStressTest.Columns["压力测试净值变化"].Width = 80;
            dgvStressTest.Columns["压力测试净值变化"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 最终净值
            dgvStressTest.Columns["压力测试后净值"].Width = 80;
            dgvStressTest.Columns["压力测试后净值"].DefaultCellStyle.Format = "0.000";
            dgvStressTest.Columns["压力测试后净值"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;            
        }

        public void refreshDataGridView_ProportionTest(DataTable dtSource)
        {
            dgvStressTest.DataSource = dtSource;
            // 产品名称
            dgvStressTest.Columns["产品名称"].Width = 150;

            // 沪深300比例
            dgvStressTest.Columns["%沪深300"].Width = 100;
            dgvStressTest.Columns["%沪深300"].DefaultCellStyle.Format = "0.00%";
            dgvStressTest.Columns["%沪深300"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 非沪深300比例
            dgvStressTest.Columns["%非沪深300"].Width = 100;
            dgvStressTest.Columns["%非沪深300"].DefaultCellStyle.Format = "0.00%";
            dgvStressTest.Columns["%非沪深300"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 当前净值
            dgvStressTest.Columns["当前净值"].DefaultCellStyle.Format = "0.000";
            dgvStressTest.Columns["当前净值"].Width = 80;
            dgvStressTest.Columns["当前净值"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 净值变化
            dgvStressTest.Columns["仓位调整后净值"].DefaultCellStyle.Format = "0.000";
            dgvStressTest.Columns["仓位调整后净值"].Width = 80;
            dgvStressTest.Columns["仓位调整后净值"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 最终净值
            dgvStressTest.Columns["持有股票调整比例"].Width = 80;
            dgvStressTest.Columns["持有股票调整比例"].DefaultCellStyle.Format = "0.00%";
            dgvStressTest.Columns["持有股票调整比例"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        public void DataGridView_StressTest_RowPostPaint(object sender, DataGridViewRowPostPaintEventArgs e)
        {
            System.Drawing.Rectangle rectangle = new System.Drawing.Rectangle(e.RowBounds.Location.X,
                e.RowBounds.Location.Y,
                dgvStressTest.RowHeadersWidth - 4,
                e.RowBounds.Height);

            TextRenderer.DrawText(e.Graphics, (e.RowIndex + 1).ToString(),
                dgvStressTest.RowHeadersDefaultCellStyle.Font,
                rectangle,
                dgvStressTest.RowHeadersDefaultCellStyle.ForeColor,
                TextFormatFlags.VerticalCenter | TextFormatFlags.Right);
        }

        public void button1_Click(object sender, EventArgs e)
        {
            DataTable dtStressTest = new DataTable();
            dtStressTest = createDataTable_StressTest();
            refreshDataGridView_StressTest(dtStressTest);
        }

        public void ProportionsUpdate_Click(object sender, EventArgs e)
        {
            DataTable dtProportionTest = new DataTable();
            dtProportionTest = createDataTable_ProportionTest();
            refreshDataGridView_ProportionTest(dtProportionTest);
        }
   
    }
}
