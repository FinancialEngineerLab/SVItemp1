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
using WindDataCOMLib;
using WAPIWrapperCSharp;
using System.Diagnostics;


namespace DataSelection
{

    
    public partial class Form1 : Form
    {
        private string filepath = "C://Users/yangyanzhe/Desktop";
        private string filename = "20150528.csv";
        //private string ouput = "C:/Users/yangyanzhe/Desktop/20150529.csv";
        private WindAPI m_w = null;

        //开启Wind接口
        private bool start()
        {
            if (null == m_w)
            {
                m_w = new WindAPI();
            }

            int nStatus = 0;
            if (!m_w.isconnected())
                nStatus = m_w.start();
            if (0 != nStatus)
                return false;
            return true;
        }


        //修改证券代码
        public string Adjust_SecCode(string strSecCode)
        {
            string new_str = strSecCode.Insert(6, ".");

            if (new_str[8] == 'S')
            {
                //strSecCode[8] = 'H';
                new_str = new_str.Insert(8, "H");
                new_str = new_str.Remove(9);
            }
            return new_str;
        }

        //获取证券价格
        public DataTable priceSec(DataTable ds)
        {
            double[] d_priceSec;
            string strSecName=string.Empty;

            if (!start())
                MessageBox.Show("连接失败");

            //建立股票字符串
            DataView dvSecName = new DataView(ds);
            DataTable ds_SecName = dvSecName.ToTable(true, "SECURITYCODE");
            for(int i=0; i<ds_SecName.Rows.Count;i++,strSecName+=",")
                strSecName+=ds_SecName.Rows[i][0].ToString();
           
            //更新价格
            WindData r_last = m_w.wsq(strSecName, "rt_last", "option1=value1;option2=value2");
            d_priceSec=(double[]) r_last.data;
            
            //建立查询数据表
            DataTable dtSecPri = new DataTable();
            dtSecPri.Columns.Add(new DataColumn("SECURITYCODE"));
            dtSecPri.Columns.Add(new DataColumn("PRICE"));
            for (int i = 0; i < ds_SecName.Rows.Count; i++)
            {
                DataRow newRow = dtSecPri.NewRow();
                newRow["SECURITYCODE"] = ds_SecName.Rows[i][0].ToString();
                newRow["PRICE"] = d_priceSec[i];
                dtSecPri.Rows.Add(newRow);
            }

            //更新全部股票数据
            DataView dv = new DataView(dtSecPri);
            for (int i = 0; i < ds.Rows.Count; i++)
            {
                DataRow[] temp=dtSecPri.Select("SECURITYCODE='"+ds.Rows[i][3]+"'");
                ds.Rows[i][6] = temp[0][1];
            }

            return ds;
        }

        //遍历修改证券表格
        public DataTable Adjust_Table(DataTable ds)
        {

            //priceSec(ds);
            for(int i=0;i<ds.Rows.Count;i++)
            {
                ds.Rows[i][3] = Adjust_SecCode(ds.Rows[i][3].ToString());
            }

            ds=priceSec(ds);
            return ds;
            
        }


        //读入CSV文件数据
        public static DataTable readCSV(string filepath, string filename)
        {
            try
            {
                DataSet dsCSVData = new DataSet();

                OleDbConnection OleCon = new OleDbConnection();
                OleDbCommand OleCmd = new OleDbCommand();
                OleDbDataAdapter OleDa = new OleDbDataAdapter();

                OleCon.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source="
                    + filepath + ";Extended Properties='Text;FMT=Delimited(,);HDR=YES;IMEX=1';";
                OleCon.Open();

                DataTable dts1 = OleCon.GetSchema("Tables");
                DataTable dts2 = OleCon.GetSchema("Columns");
                OleCmd.Connection = OleCon;
                OleCmd.CommandText = "select * from [" + filename + "] where 1=1";
                OleDa.SelectCommand = OleCmd;
                OleDa.Fill(dsCSVData, "Csv");
                OleCon.Close();

                return dsCSVData.Tables[0];
            }
            catch (Exception)
            {
                return null;
            }
        }

        //输出到Excel表格
        public bool DataSetToExcel(DataTable dataTable, bool isShowExcle)
        {
            //DataTable dataTable = dataSet.Tables[0];
            int rowNumber = dataTable.Rows.Count;
            int columnNumber = dataTable.Columns.Count;

            if (rowNumber == 0)
            {
                MessageBox.Show("没有任何数据可以导入到Excel文件！");
                return false;
            }

            //建立Excel对象 
            Microsoft.Office.Interop.Excel.Application excel = new Microsoft.Office.Interop.Excel.Application();
            excel.Application.Workbooks.Add(true);
            excel.Visible = isShowExcle;//是否打开该Excel文件 

            //填充数据 
            for (int c = 0; c < rowNumber; c++)
            {
                for (int j = 0; j < columnNumber; j++)
                {
                    excel.Cells[c + 1, j + 1] = dataTable.Rows[c].ItemArray[j];
                }
            }
            return true;
        }


        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Stopwatch sw = new Stopwatch();
            sw.Start();

           DataTable read= readCSV(filepath, filename);
           DataTable result = Adjust_Table(read);
           DataSetToExcel(result, true);

           sw.Stop(); //计算结束
           MessageBox.Show("运行时间" + sw.ElapsedMilliseconds);

        }
    }
}
