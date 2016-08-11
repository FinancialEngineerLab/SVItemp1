using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ExcelDna.Integration;
using ExcelDna.Logging;
using MySql.Data.MySqlClient;
using System.Data;
using UtilityLib;



namespace Aladdin2
{
    public class Al2Functions: IExcelAddIn
    {
        
        public static int iDisplayType = 0; // 0 - 直接在对应单元格中显示异常信息，1 - 在log中显示异常信息

       
        public void AutoOpen()
        {
            ExcelIntegration.RegisterUnhandledExceptionHandler(ErrorHandler);
        }

        private object ErrorHandler(object exceptionObject) 
        {
            if (iDisplayType == 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("AL2 Err: ");
                sb.Append(exceptionObject.ToString());

                return sb.ToString();
            }
            else
            {
                ExcelReference caller = (ExcelReference)XlCall.Excel(XlCall.xlfCaller);
                // Calling reftext here requires all functions to be marked IsMacroType=true, which is undesirable. 
                // A better plan would be to build the reference text oneself, using the RowFirst / ColumnFirst info 
                // Not sure where to find the SheetName then.... 
                string callingName = (string)XlCall.Excel(XlCall.xlfReftext, caller, true);

                LogDisplay.WriteLine(callingName + " Error: " + exceptionObject.ToString());

                // return #VALUE into the cell anyway. 
                return ExcelError.ExcelErrorValue; 
            }           
        }

        public void AutoClose()
        {
        }


        [ExcelFunction(IsMacroType = true, Description = "Return the version of Aladdin2", Category = "Aladdin2 functions")]
        public static object AL2Version()
        {
            string AL2_VERSION = null;
#if DEBUG
            AL2_VERSION =  "1.00 - Debug";
#else
            AL2_VERSION = "1.00 - Release";
#endif
            return AL2_VERSION;
        }
        


        [ExcelFunction(IsMacroType = true, Description = "Read data from MySQL database", Category = "Aladdin2 functions")]
        public static object[,] AL2ReadFromMySQL(object ServerPath, object PortNum, object DatabaseName, object UID, object Password,object QueryString)
        {
            string strConnectionString = null;
            MySqlConnection conMySql = null;
            DataTable dsOutputData = new DataTable();
            string strServer = ServerPath.ToString();
            string strPort = PortNum.ToString();
            string strDatabase = DatabaseName.ToString();
            string strUid = UID.ToString();
            string strPassword = Password.ToString();
            string strQuery = QueryString.ToString();
            object[,] result = null;

            strConnectionString = "SERVER=" + strServer + ";" + "PORT = " + strPort + ";" + "DATABASE=" + strDatabase + ";" + "User ID=" + strUid + ";" + "PASSWORD=" + strPassword + ";";
            conMySql = new MySqlConnection(strConnectionString);

            MySqlDataAdapter dataAdapter = new MySqlDataAdapter(strQuery, conMySql);
            dataAdapter.Fill(dsOutputData);

            if (dsOutputData.Rows.Count == 0)
            {
                throw new InvalidOperationException("数据提取为空!");
            }

            result = new object[dsOutputData.Rows.Count, dsOutputData.Columns.Count];
            for (int i = 0; i < dsOutputData.Rows.Count; i++)
            {
                for (int j = 0; j < dsOutputData.Columns.Count; j++)
                {
                    result[i, j] = dsOutputData.Rows[i][j].ToString();
                }
            }

            conMySql.Close();
            return result;
        }



        [ExcelFunction(IsMacroType = true, Description = "Insert data into MySQL database", Category = "Aladdin2 functions")]
        public static string AL2WriteToMySQL(object ServerPath, object PortNum, object DatabaseName, object UID, object Password, object TableName, object[,] InsertDataRange,object[] InsertDataHead)
        {
            string strConnectionString = null;
            MySqlConnection conMySql = null;
            DataTable dsFileldsName = new DataTable();
            string strServer = ServerPath.ToString();
            string strPort = PortNum.ToString();
            string strDatabase = DatabaseName.ToString();
            string strUid = UID.ToString();
            string strPassword = Password.ToString();
            string strShowFields = null;

            strConnectionString = "SERVER=" + strServer + ";" + "PORT = " + strPort + ";" + "DATABASE=" + strDatabase + ";" + "User ID=" + strUid + ";" + "PASSWORD=" + strPassword + ";";
            conMySql = new MySqlConnection(strConnectionString);
            conMySql.Open();

            strShowFields = "SHOW FULL FIELDS FROM `" + TableName.ToString() + "`";
            MySqlDataAdapter dataAdapter = new MySqlDataAdapter(strShowFields, conMySql);
            dataAdapter.Fill(dsFileldsName);

            UtilityString.isTableFits(InsertDataRange, InsertDataHead, dsFileldsName);

            for (int i = 0; i < InsertDataRange.GetLength(0); i++)
            {
                string strInsert = "INSERT INTO " + TableName.ToString() + " (";
                for (int j = 0; j < InsertDataHead.Length; j++)
                {
                    if (j != InsertDataHead.Length - 1)
                    {
                        strInsert = strInsert + InsertDataHead[j] + ",";
                    }
                    else
                    {
                        strInsert = strInsert + InsertDataHead[j];
                    }
                }
                strInsert = strInsert + ") VALUES (";
                for (int j = 0; j < InsertDataHead.Length; j++)
                {
                    if (j != InsertDataHead.Length - 1)
                    {
                        strInsert = strInsert + "'" + InsertDataRange[i, j] + "',";
                    }
                    else
                    {
                        strInsert = strInsert + "'" + InsertDataRange[i, j] + "'";
                    }
                }
                strInsert = strInsert + ");";
                
                MySqlCommand cmd = new MySqlCommand(strInsert, conMySql);
                cmd.ExecuteNonQuery();
            }

            conMySql.Close();
            return "ContribOK";
        }

        [ExcelFunction(IsMacroType = true, Description = "Multiplies two numbers", Category = "Aladdin2 functions")]
        public static double MultiplyThem(double x, double y)
        {
            //return x * y;
            throw new InvalidOperationException("Don't be evil!");
            
        }

        
    }
}
