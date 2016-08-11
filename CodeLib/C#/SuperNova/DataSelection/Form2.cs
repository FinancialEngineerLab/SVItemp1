using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.OleDb;
using System.IO;
using System.Diagnostics;

namespace SuperNova
{
    public partial class Form2 : Form
    {
        private int iStartCol = 5;

        public Form2()
        {
            InitializeComponent();
        }

        public void refreshDataGridView_ZhongcangGu(DataTable dtSource)
        {
            dataGridView_ZhongcangGu.DataSource = dtSource;
            // 第一列： 股票名称
            dataGridView_ZhongcangGu.Columns["股票名称"].Width = 80; 
            
            // 第二列： 代码
            dataGridView_ZhongcangGu.Columns["股票代码"].Width = 80; 

            // 第三列： 总数量
            dataGridView_ZhongcangGu.Columns["总持仓"].Width = 90;
            dataGridView_ZhongcangGu.Columns["总持仓"].DefaultCellStyle.Format = "0,000";

            // 第四列： 总市值
            dataGridView_ZhongcangGu.Columns["总市值"].Width = 90;
            dataGridView_ZhongcangGu.Columns["总市值"].DefaultCellStyle.Format = "0,000";

            // 第五列： 当日涨幅
            dataGridView_ZhongcangGu.Columns["当日涨幅"].Width = 60;
            dataGridView_ZhongcangGu.Columns["当日涨幅"].DefaultCellStyle.Format = "0.00%";
            dataGridView_ZhongcangGu.Columns["当日涨幅"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            // 第六列以后： 产品
            for (int i = iStartCol; i < dataGridView_ZhongcangGu.ColumnCount; i++)
            {
                dataGridView_ZhongcangGu.Columns[i].Width = 60;
                dataGridView_ZhongcangGu.Columns[i].DefaultCellStyle.Format = "0.00%";
                dataGridView_ZhongcangGu.Columns[i].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            }

            dataGridView_ZhongcangGu.AllowUserToAddRows = false;          
        }


        public void reformatDataGridView_ZhongcangGu()
        {
            dataGridView_ZhongcangGu.Columns["当日涨幅"].Frozen = true;

            dataGridView_ZhongcangGu.Rows[0].Frozen = true;

            for (int i = 1; i < dataGridView_ZhongcangGu.Rows.Count; i++)
            {
                // 涨幅或者跌幅过大
                if (double.Parse(dataGridView_ZhongcangGu.Rows[i].Cells[4].Value.ToString()) > 0.05)
                {
                    dataGridView_ZhongcangGu.Rows[i].Cells[4].Style.BackColor = Color.Red;
                }
                else if (double.Parse(dataGridView_ZhongcangGu.Rows[i].Cells[4].Value.ToString()) < -0.05)
                {
                    dataGridView_ZhongcangGu.Rows[i].Cells[4].Style.BackColor = Color.Green;
                }

                // 持仓占比例过大
                for (int j = iStartCol; j < dataGridView_ZhongcangGu.Columns.Count; j++)
                {
                    if (double.Parse(dataGridView_ZhongcangGu.Rows[i].Cells[j].Value.ToString()) > 0.01)
                    {
                        dataGridView_ZhongcangGu.Rows[i].Cells[j].Style.BackColor = Color.LightBlue;
                    }
                }
            }
        }

        public void DataGridView_ZhongcangGu_RowPostPaint(object sender, DataGridViewRowPostPaintEventArgs e)
        {
            System.Drawing.Rectangle rectangle = new System.Drawing.Rectangle(e.RowBounds.Location.X,
                e.RowBounds.Location.Y,
                dataGridView_ZhongcangGu.RowHeadersWidth - 4,
                e.RowBounds.Height);

            TextRenderer.DrawText(e.Graphics, (e.RowIndex + 1).ToString(),
                dataGridView_ZhongcangGu.RowHeadersDefaultCellStyle.Font,
                rectangle,
                dataGridView_ZhongcangGu.RowHeadersDefaultCellStyle.ForeColor,
                TextFormatFlags.VerticalCenter | TextFormatFlags.Right);
        }



    }
}
