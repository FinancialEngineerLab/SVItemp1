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
using Microsoft.Office.Interop.Excel;
using System.Data.SqlClient;


namespace LinktoDatabase
{
    public partial class Form1 : Form
    {
        string dbname;
        private OleDbConnection myConnection;

        //防止多次实例化
        private static Form1 form_test;
        public static Form1 activated_form
        {
            get
            {
                if (form_test == null)
                    form_test = new Form1();
                return form_test;
            }
        }

        //建立连接
        public void _initiate(string dbname)
        {
            this.dbname = dbname;
            string conString = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" + dbname;
            myConnection = new OleDbConnection(conString);
        }

        //填充数据
        public System.Data.DataTable Select(string queryString)
        {
            System.Data.DataTable data_Table = new System.Data.DataTable();
            if (myConnection.State == ConnectionState.Closed)
                myConnection.Open();
            System.Data.OleDb.OleDbDataAdapter adapter =
                new OleDbDataAdapter(queryString, myConnection);
            adapter.Fill(data_Table);
            return data_Table;
        }

        //执行SQL语句
        public bool Execute(string queryString)
        {
            bool juge = true;
            if (myConnection.State == ConnectionState.Closed)
                myConnection.Open();
            OleDbCommand sc = new OleDbCommand(queryString, myConnection);
            sc.ExecuteNonQuery();
            return juge;
        }

        //写入Excel
        public static bool SaveDataTableToExcel(System.Data.DataTable excelTable, string filePath)
        {
            Microsoft.Office.Interop.Excel.Application app =
                new Microsoft.Office.Interop.Excel.ApplicationClass();
            try
            {
                app.Visible = false;
                Workbook wBook = app.Workbooks.Add(true);
                Worksheet wSheet = wBook.Worksheets[1] as Worksheet;
                if (excelTable.Rows.Count > 0)
                {
                    int row = excelTable.Rows.Count;
                    int col = excelTable.Columns.Count;
                    for (int i = 0; i < row; i++)
                    {
                        for (int j = 0; j < col; j++)
                        {
                            string str = excelTable.Rows[i][j].ToString();
                            wSheet.Cells[i + 2, j + 1] = str;//跳过标题行，从第二行开始
                        }
                    }
                }

                int size = excelTable.Columns.Count;
                for (int i = 0; i < size; i++)
                {
                    wSheet.Cells[1, 1 + i] = excelTable.Columns[i].ColumnName;
                }   
                app.DisplayAlerts = false;
                app.AlertBeforeOverwriting = false; 
                wBook.Save();
                app.Save(filePath);
                app.SaveWorkspace(filePath);
                app.Quit();
                app = null;
                MessageBox.Show("顺利导出到Excel");
                return true;

            }
            catch (Exception err)
            {
                MessageBox.Show("导出Excel出错！错误原因：" + err.Message, "提示信息",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }
            finally
            {
            }
        }


        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        //按键效果
        private void button1_Click(object sender, EventArgs e)
        {
            
            string appath = Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath);
            //Form1.activated_form._initiate(appath + "\\Database1.mdb");
            //System.Data.SqlClient.SqlConnection verify = new System.Data.SqlClient.sql("xsq","xsq");
            //System.Data.SqlClient.SqlCredential verify = new System.Data.SqlClient.SqlCredential("xsq", "xsq");
            string conString = "data source=10.80.10.6; Database=;user id=xsq; password=xsq";
            SqlConnection myconnection = new SqlConnection(conString);
            myconnection.Open();
            
            //数据库SQL查询语句
            string queryString = "select t.l_date TradeDate,b.vc_fund_name FundName,t.vc_inter_code SecurityCode,c.vc_stock_name Secu"
                + "rityName,t.l_current_amount NbStock,round(decode (c.c_market_no,'7',t.en_current_cost/(300*t.l_current_amount),t.en_u"
                + "ntransfered_invest/t.l_current_amount),3) Cost from trade.tfundstock t,trade.tfundinfo b,trade.tstockinfo c where t.l_"
                + "fund_id = b.l_fund_id and t.vc_inter_code = c.vc_inter_code and t.l_current_amount > 0 order by t.l_fund_id, vc_stock_name";

            System.Data.SqlClient.SqlConnection cmd = new System.Data.SqlClient.SqlConnection(queryString);
            
           
            System.Data.DataTable dt = Form1.activated_form.Select(queryString);
            SaveDataTableToExcel(dt, appath+"\\Book1.xls");
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {
            
        }

        //private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        //{

        //}
    }
}
