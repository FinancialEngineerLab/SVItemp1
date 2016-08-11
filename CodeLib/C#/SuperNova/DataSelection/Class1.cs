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
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Data.SqlClient;
using System.Globalization;

namespace SuperNova
{
    public class DBOperation
    {
        public void connectToOracleDB(OleDbConnection OleCon)
        {
            try
            {
                OleCon.Close();
                OleCon.ConnectionString = " Provider=OraOLEDB.Oracle.1;Password=xsq;" +
                     " ;Persist Security Info=True;User ID=xsq" +
                     " ;Data Source=trade";
                OleCon.Open();
            }
            catch (Exception)
            {
                MessageBox.Show("数据库连接失败!");
            }
        }

        public void filterOutData(OleDbConnection OleCon, string sSQL, DataSet dsOutputData)
        {
            try
            {

                OleDbCommand OleCmd = new OleDbCommand(sSQL);
                OleDbDataAdapter OleDa = new OleDbDataAdapter(sSQL, OleCon);

                OleCon.Close();
                //OleDa.SelectCommand = OleCmd;
                dsOutputData.Tables.Clear();
                OleDa.Fill(dsOutputData);

                // 通过判断不含停牌多头市值来判断产品是否结束
                // 对结束的产品从DataSet中删除
                //if (dsOutputData.Tables[0].Columns[2].ColumnName == "不含停牌多头市值")
                //{
                //    for (int i = dsOutputData.Tables[0].Rows.Count - 1; i >= 0; i--)
                //    {
                //        if (dsOutputData.Tables[0].Rows[i]["不含停牌多头市值"].ToString() == "0")
                //        {
                //            dsOutputData.Tables[0].Rows.RemoveAt(i);
                //        }
                //    }
                //}
                

                OleDa.Dispose();
            }
            catch (Exception)
            {
                MessageBox.Show("数据库调取数据失败!");
                OleCon.Close();

            }
        }   

    }


    public class DataTableOperation
    {
        // iCriteriaColIndex !=-1时， 此函数 = sumif 函数
        public double getColumnSum(DataTable dt, int iColIndex, int iCriteriaColIndex = -1)
        {
            double ret = 0;
            foreach (DataRow row in dt.Rows)
            {
                if (iCriteriaColIndex == -1)
                    ret += double.Parse(row[iColIndex].ToString());
                else
                {
                    if(row[iCriteriaColIndex].ToString() == "True")
                        ret += double.Parse(row[iColIndex].ToString());
                }
            }
            return ret;
        }


        public bool checkDataExport(DataTable dtInput)
        {
            if (dtInput.Rows.Count == 0)
            {
                MessageBox.Show("DataGridView空间中无数据");
                return false;
            }
            return true;

        }

        public void exportToExcel(DataTable dtInput, string strExportPath)
        {
            if (!checkDataExport(dtInput))
            {
                return;
            };

            Excel.Application objApp = new Excel.Application();
            Excel.Workbooks objBooks = objApp.Workbooks;
            Excel.Workbook objBook = objBooks.Add(Missing.Value);
            Excel.Worksheet objSheet = null;

            int iRow = 0;

            try
            {
                objSheet = (Excel.Worksheet)objBook.Worksheets.Add(Missing.Value, Missing.Value, Missing.Value, Missing.Value);
                ((Excel.Worksheet)objBook.Sheets[1]).Select(Missing.Value);

                foreach (DataRow dr in dtInput.Rows)
                {
                    iRow++;
                    for (int iCol = 0; iCol < dtInput.Columns.Count; iCol++)
                    {
                        objSheet.Cells[iRow + 1, iCol + 1] = dr[iCol].ToString();
                    }
                }
                objBook.Close(true, strExportPath, Missing.Value);
                objBooks.Close();
            }
            catch (Exception)
            {
                MessageBox.Show("导出失败!", "Export to Excel", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
            }

        }

        public void exportToAccess(DataTable dtInput, string strExportPath)
        {
            if (!checkDataExport(dtInput))
            {
                return;
            };

            //变量申明
            string strCon = null;
            string strTableName = null;
            string strCreateTable = null;
            string strDeleteTable = null;
            string strInsert = null;
            int iStartCol = 5;

            bool bFlag = false;

            DataTable dtTableName;

            //申明连接字符串
            strCon = @"Provider = Microsoft.Jet.OLEDB.4.0; Data Source =" + strExportPath;
            using (OleDbConnection conn = new OleDbConnection(strCon))
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }


                //申明创建表格字符串
                strTableName = DateTime.Now.ToLongDateString().ToString();
                strCreateTable = @"CREATE TABLE " + strTableName + "(股票名称 varchar(20), 股票代码 varchar(10), 总持仓 Float, 总市值  Float, 当日涨幅 Float, ";
                for (int iCols = iStartCol; iCols < dtInput.Columns.Count; iCols++)
                {
                    strCreateTable += dtInput.Columns[iCols].ColumnName + " Float";
                    if (iCols != dtInput.Columns.Count - 1)
                    {
                        strCreateTable += ", ";
                    }
                }
                strCreateTable += ")";

                //判断表格是否已经存在
                dtTableName = conn.GetSchema("Tables");

                for (int iRows = 0; iRows < dtTableName.Rows.Count; iRows++)
                {
                    if (dtTableName.Rows[iRows]["TABLE_NAME"].ToString() == strTableName)
                    {
                        bFlag = true;
                    }
                }

                //如果存在删除表格
                if (bFlag == true)
                {
                    strDeleteTable = @"DROP TABLE " + DateTime.Now.ToLongDateString().ToString();
                    OleDbCommand cmdDelete = new OleDbCommand(strDeleteTable, conn);
                    cmdDelete.ExecuteNonQuery();
                }

                //创建表格
                OleDbCommand cmdCreateTable = new OleDbCommand(strCreateTable, conn);
                cmdCreateTable.ExecuteNonQuery();

                using (OleDbTransaction trans = conn.BeginTransaction())
                {
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.Transaction = trans;

                    try
                    {
                        for (int iRows = 0; iRows < dtInput.Rows.Count; iRows++)
                        {
                            strInsert = @"INSERT INTO " + strTableName + " VALUES (";
                            for (int iCols = 0; iCols < dtInput.Columns.Count; iCols++)
                            {
                                if (iCols == 0 || iCols == 1)
                                {
                                    strInsert += "'" + dtInput.Rows[iRows][iCols].ToString() + "'";
                                }
                                else
                                {
                                    strInsert += dtInput.Rows[iRows][iCols].ToString();
                                }
                                if (iCols != dtInput.Columns.Count - 1)
                                {
                                    strInsert += " ,";
                                }
                            }
                            strInsert += ")";
                            cmd.CommandText = strInsert;
                            cmd.ExecuteNonQuery();
                        }
                        trans.Commit();
                        MessageBox.Show("导出成功!", "Export to Access", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
                    }
                    catch (Exception)
                    {
                        trans.Rollback();
                        MessageBox.Show("导出失败!", "Export to Access", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
                    }
                    finally
                    {
                        trans.Dispose();
                        cmdCreateTable.Dispose();
                        cmd.Dispose();
                        conn.Close();
                    }
                }
            }
        }

        public double weightedAverage(DataTable dtInput, int iValueCol, int iChangeCol)
        {
            double dTotalWeightedAvg = 0;
            double dTotalVal = 0;
            double dTotalChange = 0;

            for (int iRows = 1; iRows < dtInput.Rows.Count; iRows++)
            {
                dTotalVal += Double.Parse(dtInput.Rows[iRows][iValueCol].ToString());
                dTotalChange += Double.Parse(dtInput.Rows[iRows][iValueCol].ToString()) * Double.Parse(dtInput.Rows[iRows][iChangeCol].ToString());
            }

            dTotalWeightedAvg = dTotalChange / dTotalVal;

            return dTotalWeightedAvg;
        }

    }

    public class StringOperation
    {
        public string convertToWindCode(string strOriginalCode)
        {
            string strWindCode = null;
            int iLength = 6;

            if (strOriginalCode.Length <= iLength)
            {
                return strOriginalCode;
            }
            else
            {
                strWindCode = strOriginalCode.Substring(0, iLength) + ".";
                if (strOriginalCode.Substring(iLength, 2) == "SS")
                {
                    strWindCode += "SH";
                }
                else
                {
                    strWindCode += strOriginalCode.Substring(iLength, 2);
                }
                return strWindCode;
            }
        }

        public string[] readStockList(string strTxtFilePath)
        {
            string[] strStockList = null;
            StreamReader srReader = null;
            int i = 0;
            try
            {
                srReader = new StreamReader(strTxtFilePath);

                for (string line = srReader.ReadLine(); line != null; line = srReader.ReadLine())
                {
                    if(strStockList == null)
                        Array.Resize<string>(ref strStockList, 1);
                    else
                        Array.Resize<string>(ref strStockList, (strStockList.Length + 1));
                    strStockList[i] = line;
                    i++;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("读取沪深300成分列表失败!", "Read Stock List", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);

            }
            finally
            {
                if (srReader != null) srReader.Close();
            }
            return strStockList;
        }

        public bool isInStockList(string strStock, string[] strStockList)
        {
            bool bIsInStockList = false;
            for (int i = 0; i < strStockList.Length; i++)
            {
                if (strStockList[i] == strStock)
                {
                    bIsInStockList = true;
                }
            }

            return bIsInStockList;
        }

        public double getFundNAV(string strFundName, DataTable dtNAVData)
        {
            double dFundNAV = 0.0;
            foreach (DataRow row in dtNAVData.Rows)
            {
                if(row[0].ToString() == strFundName)
                    dFundNAV = double.Parse(row[1].ToString());
            }
            return dFundNAV;
        }

    }

    

   


}
      