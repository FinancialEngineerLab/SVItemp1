using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using UtilityLib;
using System.Configuration;
using System.Collections.Specialized;

namespace UtilityLib
{
    public class UtilityArray
    {
        public static double[] getColFromTable(DataTable dtSUETable, int iCol)
        {
            double[] dResult = null;
            dResult = new double[dtSUETable.Rows.Count];
            for (int i = 0; i < dResult.Length; i++)
            {
                dResult[i] = double.Parse(dtSUETable.Rows[i][iCol].ToString());

            }
            return dResult;
        }

        public static string[] getColFromTableStr(DataTable dtSUETable, int iCol)
        {
            string[] dResult = null;
            dResult = new string[dtSUETable.Rows.Count];
            for (int i = 0; i < dResult.Length; i++)
            {
                dResult[i] = dtSUETable.Rows[i][iCol].ToString();
            }
            return dResult;
        }

        public static DateTime[] getColFromTableDt(DataTable dtSUETable, int iCol)
        {
            DateTime[] dtResult = null;
            dtResult = new DateTime[dtSUETable.Rows.Count];
            for (int i = 0; i < dtResult.Length; i++)
            {
                dtResult[i] = Convert.ToDateTime(dtSUETable.Rows[i][iCol].ToString());
            }
            return dtResult;
        }

        public static string getCodeConnectByComma(string[] strInput)
        {
            string strStockCodeAll = "";
            for (int i = 0; i < strInput.Length; i++)
            {
                if (i != strInput.Length - 1)
                    strStockCodeAll = strStockCodeAll + strInput[i].ToString() + ",";
                else
                    strStockCodeAll = strStockCodeAll + strInput[i].ToString();
            }
            return strStockCodeAll;
        }

        public static double[,] getColFromDoubleMatrix(double[,] dMatrix, int iCols)
        {
            double[,] dResult = new double[dMatrix.GetLength(0), 1];

            for (int i = 0; i < dMatrix.GetLength(0); i++)
            {
                dResult[i, 0] = dMatrix[i, iCols];
            }
            
            return dResult;
        }

        public static string getCodeConnectByAccent(NameValueCollection nvcCode)
        {
            string strWindCode = null;
            for (int i = 0; i < nvcCode.Count - 1; i++)
            {
                if (i != nvcCode.Count - 2)
                {
                    strWindCode = strWindCode + "`" + nvcCode[i] + "`,";
                }
                else
                {
                    strWindCode = strWindCode + "`" + nvcCode[i] + "`";
                }
            }
            return strWindCode;
        }

        public static double[] getDoubleArraySorted(double[] dtArray)
        {
            double[] dtTemp = dtArray;
            for (int i = 0; i < dtArray.Length; i++)
            {
                for (int j = 0; j < dtArray.Length; j++)
                {
                    if (dtTemp[i] < dtTemp[j])
                    {
                        double temp = dtTemp[i];
                        dtTemp[i] = dtTemp[j];
                        dtTemp[j] = temp;
                    }
                }
            }
            return dtTemp;
        }

        public static string[] mergeArray(string[] strFirst, string[] strSecond)
        {
            string[] result = new string[strFirst.Length + strSecond.Length];
            strFirst.CopyTo(result, 0);
            strSecond.CopyTo(result, strFirst.Length);
            return result;
        }

        // 生成DataTable存储所有数据，便于查看
        public static DataTable getWeeklyTable(NameValueCollection nvcCode, DateTime[] dtTrade, double[,] objData)
        {
            List<int> lTradeDays = UtilityWindData.getWeekTradeDays(dtTrade[0], dtTrade[dtTrade.Length - 1]);

            DataTable dtWeekly = new DataTable();
            dtWeekly.Columns.Add("date", Type.GetType("System.DateTime"));
            for (int i = 0; i < nvcCode.Count - 1; i++)
            {
                dtWeekly.Columns.Add(nvcCode.AllKeys[i], Type.GetType("System.Double"));
            }

            int k = 0;
            for (int i = 0; i < dtTrade.Length; i++)
            {
                DataRow drData = dtWeekly.NewRow();
                drData["date"] = dtTrade[i];

                for (int j = 0; j < nvcCode.Count - 1; j++)
                {
                    drData[nvcCode.AllKeys[j]] = objData[k, j] / (lTradeDays[k] * 100000000.00);
                }
                if (i < dtTrade.Length - 1 && (dtTrade[i]).AddDays(1) != dtTrade[i + 1])
                {
                    k++;
                }

                dtWeekly.Rows.Add(drData);
            }
            return dtWeekly;
        }

        public static DataTable getIndustryTable(NameValueCollection nvcCode, double[,] objData)
        {
            DataTable dtIndustry = new DataTable();
            dtIndustry.Columns.Add("行业名称", Type.GetType("System.String"));
            dtIndustry.Columns.Add("涨跌幅", Type.GetType("System.Double"));

            for (int i = 0; i < objData.Length; i++)
            {
                DataRow drNew = dtIndustry.NewRow();
                drNew["行业名称"] = nvcCode.Keys[i].ToString();
                drNew["涨跌幅"] = objData[0,i];
                dtIndustry.Rows.Add(drNew);
            }

            return dtIndustry;
        }
    }
}
