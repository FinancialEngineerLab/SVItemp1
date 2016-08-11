using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WAPIWrapperCSharp;
using System.Configuration;
using System.Collections.Specialized;
using UtilityLib;
using System.IO;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Web;

namespace UtilityLib
{
    public class UtilityExcel
    {
        public static void saveDataGridViewtoCSV(DataGridView dgv)
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "CSV files (*.csv)|*.csv";
            saveFileDialog.FilterIndex = 0;
            saveFileDialog.RestoreDirectory = true;
            saveFileDialog.CreatePrompt = true;
            saveFileDialog.FileName = null;

            // Open Save Window
            if (saveFileDialog.ShowDialog() == DialogResult.Cancel)
            {
                return;
            }

            // Return file string
            string fileNameString = saveFileDialog.FileName;

            //验证strFileName是否为空或值无效    
            if (fileNameString.Trim() == "")
            {
                return;
            }

            //定义表格内数据的行数和列数    
            int rowscount = dgv.Rows.Count;
            int colscount = dgv.Columns.Count;

            //行列数必须大于0   
            if (rowscount <= 0 || colscount <= 0)
            {
                throw new Exception("saveDataGridViewtoCSV: 没有数据可供保存!");
            }
            //行数不可以大于65536    
            if (rowscount > 65536)
            {
                throw new Exception("saveDataGridViewtoCSV: 数据记录数太多(最多不能超过65536条)，不能保存! ");
            }

            //列数不可以大于255    
            if (colscount > 255)
            {
                throw new Exception("saveDataGridViewtoCSV: 数据记录行数太多，不能保存! ");
            }

            //验证以fileNameString命名的文件是否存在，如果存在删除它  
            FileInfo file = new FileInfo(fileNameString);
            if (file.Exists)
            {
                try
                {
                    file.Delete();
                }
                catch (Exception)
                {
                    throw new Exception("saveDataGridViewtoCSV: 删除失败!");
                }
            }

            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                Stream myStream = saveFileDialog.OpenFile();
                StreamWriter sw = new StreamWriter(myStream, System.Text.Encoding.GetEncoding(-0));
                string strLine = "";
                try
                {
                    //Write in the headers of the columns.  
                    for (int i = 0; i < dgv.ColumnCount; i++)
                    {
                        if (i > 0)
                            strLine += ",";
                        strLine += dgv.Columns[i].HeaderText;
                    }
                    strLine.Remove(strLine.Length - 1);
                    sw.WriteLine(strLine);
                    strLine = "";
                    //Write in the content of the columns.  
                    for (int j = 0; j < dgv.Rows.Count; j++)
                    {
                        strLine = "";
                        for (int k = 0; k < dgv.Columns.Count; k++)
                        {
                            if (k > 0)
                                strLine += ",";
                            if (dgv.Rows[j].Cells[k].Value == null)
                                strLine += "";
                            else
                            {
                                string m = dgv.Rows[j].Cells[k].Value.ToString().Trim();
                                strLine += m.Replace(",", "，");
                            }
                        }
                        strLine.Remove(strLine.Length - 1);
                        sw.WriteLine(strLine);
                    }
                    sw.Close();
                    myStream.Close();
                    MessageBox.Show("saveDataGridViewtoCSV: Data has been exported to：" + saveFileDialog.FileName.ToString(), "Exporting Completed", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Exporting Error", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        public static void saveDataTabletoCSV(DataTable dgv, string strFileAddress = null, string strFileName = null)
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "CSV files (*.csv)|*.csv";
            saveFileDialog.FilterIndex = 0;
            saveFileDialog.RestoreDirectory = true;
            saveFileDialog.CreatePrompt = true;
            saveFileDialog.FileName = strFileName;
            if (strFileAddress != null)
            {
                saveFileDialog.InitialDirectory = strFileAddress;
            }
            else
            {
                saveFileDialog.InitialDirectory = Directory.GetCurrentDirectory();
            }

            // Open Save Window
            if (saveFileDialog.ShowDialog() == DialogResult.Cancel)
            {
                return;
            }

            // Return file string
            string fileNameString = saveFileDialog.FileName;

            //验证strFileName是否为空或值无效    
            if (fileNameString.Trim() == "")
            {
                return;
            }

            //定义表格内数据的行数和列数    
            int rowscount = dgv.Rows.Count;
            int colscount = dgv.Columns.Count;

            //行列数必须大于0   
            if (rowscount <= 0 || colscount <= 0)
            {
                throw new Exception("saveDataGridViewtoCSV: 没有数据可供保存!");
            }
            //行数不可以大于65536    
            if (rowscount > 65536)
            {
                throw new Exception("saveDataGridViewtoCSV: 数据记录数太多(最多不能超过65536条)，不能保存! ");
            }

            //列数不可以大于255    
            if (colscount > 255)
            {
                throw new Exception("saveDataGridViewtoCSV: 数据记录行数太多，不能保存! ");
            }

            //验证以fileNameString命名的文件是否存在，如果存在删除它  
            FileInfo file = new FileInfo(fileNameString);
            if (file.Exists)
            {
                try
                {
                    file.Delete();
                }
                catch (Exception)
                {
                    throw new Exception("saveDataGridViewtoCSV: 删除失败!");
                }
            }

            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                Stream myStream = saveFileDialog.OpenFile();
                StreamWriter sw = new StreamWriter(myStream, System.Text.Encoding.GetEncoding(-0));
                string strLine = "";
                try
                {
                    //Write in the headers of the columns.  
                    for (int i = 0; i < dgv.Columns.Count; i++)
                    {
                        if (i > 0)
                            strLine += ",";
                        strLine += dgv.Columns[i].ColumnName;
                    }
                    strLine.Remove(strLine.Length - 1);
                    sw.WriteLine(strLine);
                    strLine = "";
                    //Write in the content of the columns.  
                    for (int j = 0; j < dgv.Rows.Count; j++)
                    {
                        strLine = "";
                        for (int k = 0; k < dgv.Columns.Count; k++)
                        {
                            if (k > 0)
                                strLine += ",";
                            if (dgv.Rows[j][k] == null)
                                strLine += "";
                            else
                            {
                                string m = dgv.Rows[j][k].ToString().Trim();
                                strLine += m.Replace(",", "，");
                            }
                        }
                        strLine.Remove(strLine.Length - 1);
                        sw.WriteLine(strLine);
                    }
                    sw.Close();
                    myStream.Close();
                    MessageBox.Show("saveDataGridViewtoCSV: Data has been exported to：" + saveFileDialog.FileName.ToString(), "Exporting Completed", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Exporting Error", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        public static void saveDataGridViewtoExcel(DataGridView dgv)
        {
            SaveFileDialog dlg = new SaveFileDialog();
            dlg.DefaultExt = "xls";
            dlg.Filter = "EXCEL文件(*.XLS)|*.xls ";
            dlg.InitialDirectory = Directory.GetCurrentDirectory();
            // Open Save Window
            if (dlg.ShowDialog() == DialogResult.Cancel)
            {
                return;
            }
                
            // Return file string
            string fileNameString = dlg.FileName;

            //验证strFileName是否为空或值无效    
            if (fileNameString.Trim() == "")
            { 
                return; 
            }

            //定义表格内数据的行数和列数    
            int rowscount = dgv.Rows.Count;
            int colscount = dgv.Columns.Count;

            //行列数必须大于0   
            if (rowscount <= 0 || colscount <= 0)
            {
                throw new Exception("saveDataGridViewtoExcel: 没有数据可供保存!");
            }
            //行数不可以大于65536    
            if (rowscount > 65536)
            {
                throw new Exception("saveDataGridViewtoExcel: 数据记录数太多(最多不能超过65536条)，不能保存! ");
            }

            //列数不可以大于255    
            if (colscount > 255)
            {
                throw new Exception("saveDataGridViewtoExcel: 数据记录行数太多，不能保存! ");
            }   

            //验证以fileNameString命名的文件是否存在，如果存在删除它  
            FileInfo file = new FileInfo(fileNameString);
            if (file.Exists)
            {
                try
                {
                    file.Delete();
                }
                catch (Exception)
                {
                    throw new Exception("saveDataGridViewtoExcel: 删除失败!");
                }
            }

            Excel.Application objExcel = null;
            Excel.Workbook objWorkbook = null;
            Excel.Worksheet objsheet = null;   

            try  
            {   
                //申明对象    
                objExcel = new Microsoft.Office.Interop.Excel.Application();   
                objWorkbook = objExcel.Workbooks.Add(Missing.Value);   
                objsheet = (Excel.Worksheet)objWorkbook.ActiveSheet;   
                //设置EXCEL不可见    
                objExcel.Visible = false;   
  
                //向Excel中写入表格的表头    
                int displayColumnsCount = 1;   
                for (int i = 0; i <= dgv.ColumnCount - 1; i++)   
                {   
                    if (dgv.Columns[i].Visible == true)   
                    {   
                        objExcel.Cells[1, displayColumnsCount] = dgv.Columns[i].HeaderText.Trim();   
                        displayColumnsCount++;   
                    }   
                }   
                
                //向Excel中逐行逐列写入表格中的数据    
                for (int row = 0; row <= dgv.RowCount - 1; row++)   
                {   
                    //tempProgressBar.PerformStep();    
  
                    displayColumnsCount = 1;   
                    for (int col = 0; col < colscount; col++)   
                    {   
                        if (dgv.Columns[col].Visible == true)   
                        {   
                            try  
                            {   
                                objExcel.Cells[row + 2, displayColumnsCount] = dgv.Rows[row].Cells[col].Value.ToString().Trim();   
                                displayColumnsCount++;   
                            }   
                            catch (Exception)   
                            {
                                throw new Exception("saveDataGridViewtoExcel：写入过程发生错误！");
                            }   
  
                        }   
                    }   
                }   
                
                //保存文件    
                objWorkbook.SaveAs(fileNameString, 56, Missing.Value, Missing.Value, Missing.Value,   
                        Missing.Value, Excel.XlSaveAsAccessMode.xlShared, Missing.Value, Missing.Value, Missing.Value,   
                        Missing.Value, Missing.Value);   
            }   
            catch (Exception error)   
            {
                throw new Exception("saveDataGridViewtoExcel：" + error.Message);   
            }   
            finally  
            {   
                //关闭Excel应用    
                if (objWorkbook != null) objWorkbook.Close(Missing.Value, Missing.Value, Missing.Value);   
                if (objExcel.Workbooks != null) objExcel.Workbooks.Close();   
                if (objExcel != null) objExcel.Quit();   
  
                objsheet = null;   
                objWorkbook = null;   
                objExcel = null;   
            }   
            MessageBox.Show(fileNameString + "\n\n导出完毕! ", "提示 ", MessageBoxButtons.OK, MessageBoxIcon.Information);   
        }


    }
}
