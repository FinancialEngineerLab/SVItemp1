using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using UtilityLib;

namespace UtilityLib
{
    public class UtilityMySQLData
    {
        // Stockcode/StockName/20**NetProfit/20**SUE
        public static DataTable getFullSUEListFromDB(string strYearNumber)
       {
           DataSet dsResult = new DataSet();
           string strDBType = "MySQL";
           DBConnect sqlConn = new DBConnect(strDBType);
           string strQuery = "select StockCode, StockName,"+ strYearNumber + "SUE," + strYearNumber + "NetProfit from SUE";
           dsResult = sqlConn.Select(strQuery);
           if (dsResult.Tables.Count > 0)
           {
               return dsResult.Tables[0];
           }
           else
           {
               throw new Exception("getFullSUEList: 数据库中没有找到SUE数据");
           }
       }

        public static DataTable getIndustryCashflowFromDB(DataTable dtDataTable, string strDate)
        {
            dtDataTable.Columns.Add("资金流向", Type.GetType("System.Double"));
            dtDataTable.PrimaryKey = new DataColumn[] { dtDataTable.Columns["行业名称"]};

            DBConnect dbConn = new DBConnect("MySQL");
            DataTable dtIndustryCashflow = (dbConn.Select("SELECT * FROM IndustryFlow where date = '" + strDate + "';")).Tables[0];

            if (dtIndustryCashflow.Rows.Count == 0)
            {                
                return null;
            }

            for (int i = 1; i < dtIndustryCashflow.Columns.Count; i++)
            {
                string strName = dtIndustryCashflow.Columns[i].ColumnName;
                DataRow drTemp = dtDataTable.Rows.Find(strName);
                drTemp["资金流向"] = dtIndustryCashflow.Rows[0][i];
            }
            return dtDataTable;
        }

        public static DataTable getFundIndustryAllocationFromDB(string strStartDate, string strEndDate, string strIndustryCode)
        {
            DataSet dsResult = new DataSet();
            string strDBType = "MySQL";
            DBConnect sqlConn = new DBConnect(strDBType);
            string strQuery = "select " + strIndustryCode + " from FundIndustryAllocation where Date>='" + strStartDate + "' and Date<='" + strEndDate + "'";

            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getFundIndustryAllocationFromDB: 数据库中没有找到行业配置数据");
            }
        }

        // 返回每日沪股通和港股通净流入量（亿元人民币）
        public static DataTable getHuGangTongDataFromDB(string strStartDate, string strEndDate)
        {
            DataSet dsResult = new DataSet();
            string strDBType = "MySQL";
            DBConnect sqlConn = new DBConnect(strDBType);
            string strQuery = "select Date, SHUsed, HKUsed from SHHKStockTrade where Date>='" + strStartDate + "' and Date<='" + strEndDate + "'";
            dsResult = sqlConn.Select(strQuery);

            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getHuGangTongDataFromDB: 数据库中没有找到沪港通数据");
            }
        }


        // 返回两市每日融资融券余额
        public static DataTable getRongziRongquanDataFromDB(string strStartDate, string strEndDate)
        {
            DataSet dsResult = new DataSet();
            string strDBType = "MySQL";
            DBConnect sqlConn = new DBConnect(strDBType);
            string strQuery = "select * from RongziRongquan where Date>='" + strStartDate + "' and Date<='" + strEndDate + "'" + " ORDER BY Date ASC;";
            dsResult = sqlConn.Select(strQuery);

            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getRongziRongquanDataFromDB: 数据库中没有找到融资融券数据");
            }
        }

        // 将周频成交量、金额、换手率、量比加入字典
        public static Dictionary<string, string> getMySQLVolAmtAndOtherData(string strIndustryCode, string strIndustryName, Dictionary<string, string> dicInput)
        {
            Dictionary<string, string> dicResult = dicInput;
            // 周频成交量&金额
            DBConnect sqlConn = new DBConnect("MySQL");
            int n = (int)DateTime.Now.DayOfWeek;
            DateTime dt = DateTime.Now.AddDays(-n - 2);
            if (!UtilityTime.isTradeDay(dt)) // 解决上周五不是交易日的问题
            {
                dt = dt.AddDays(-7);
            }
            string strQuery = "SELECT " + strIndustryName + " FROM 周成交量 WHERE date = '" + dt.ToShortDateString() + "'";
            dicResult["周频成交量"] = ((double)((sqlConn.Select(strQuery)).Tables[0].Rows[0][0])).ToString("0.00");
            strQuery = "SELECT " + strIndustryName + " FROM 周成交额 WHERE date = '" + dt.ToShortDateString() + "'";
            dicResult["周频成交金额"] = ((double)((sqlConn.Select(strQuery)).Tables[0].Rows[0][0])).ToString("0.00");
            strQuery = "SELECT " + strIndustryName + " FROM 周频换手率 WHERE date = '" + dt.ToShortDateString() + "'";
            dicResult["周频换手率"] = ((double)((sqlConn.Select(strQuery)).Tables[0].Rows[0][0])).ToString("0.00");
            strQuery = "SELECT " + strIndustryName + " FROM 周频量比 WHERE date = '" + dt.ToShortDateString() + "'";
            dicResult["周频量比"] = ((double)((sqlConn.Select(strQuery)).Tables[0].Rows[0][0])).ToString("0.00");

            return dicResult;
        }


        // 中证800 标的
        public static DataTable getZZ800UnderlyingFromDB(string strDate, string strTableName)
        {
            DataSet dsResult = new DataSet();
            string strDBType = "MySQL";
            DBConnect sqlConn = new DBConnect(strDBType);
            DateTime[] dtMonthDate = new DateTime[2];

            dtMonthDate = UtilityTime.getStartAndEndMonthDate(strDate);
            string strQuery = "select Date, StockCode, Weight from " + strTableName + " where Date>='" + dtMonthDate[0].ToShortDateString() + "' and Date<='" + dtMonthDate[1].ToShortDateString() + "'";
            dsResult = sqlConn.Select(strQuery);

            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getZZ800UnderlyingFromDB: 数据库中没有找到中证800成分股标的");
            }
        }

        public static DataTable getIndustryFlowFromDB(string strStartDate, string strEndDate, string strType)
        {
            DBConnect sqlConn = new DBConnect("MySQL");
            string strQuery = "SELECT " + strType + " FROM IndustryFlow WHERE Date>='" + strStartDate + "' AND Date<='" + strEndDate + "'" + " ORDER BY Date ASC;";

            DataSet dsResult = sqlConn.Select(strQuery);
            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getZZ800IndexFromDB: 数据库中没有找到中证800等额指数");
            }
        }

        public static DataTable getZZ800IndexFromDB(string strDateStart, string strDateEnd, string strType)
        {
            DataSet dsResult = new DataSet();
            string strDBType = "MySQL";
            DBConnect sqlConn = new DBConnect(strDBType);
            string strQuery = "SELECT Date, " + strType + " FROM zz800EqualWeightIndex WHERE Date>='" + strDateStart + "' AND Date<='" + strDateEnd + "'";
            dsResult = sqlConn.Select(strQuery);

            if (dsResult.Tables.Count > 0)
            {
                return dsResult.Tables[0];
            }
            else
            {
                throw new Exception("getZZ800IndexFromDB: 数据库中没有找到中证800等额指数");
            }
        }

        public static void saveZZ800IndexIntoDB(DateTime[] dtTradeDateArray, double[,] dIndex)
        {
            int iDays = dtTradeDateArray.Length;

            DBConnect sqlConn = new DBConnect("MySQL");
            List<string> lsQuery = new List<string>();
            string strQuery = null;

            for (int i = 0; i < iDays; i++)
            {
                strQuery = "INSERT INTO zz800EqualWeightIndex VALUES ('" + dtTradeDateArray[i].ToString() + "'," + dIndex[i, 0].ToString() + ","
                        + dIndex[i, 1].ToString() + "," + dIndex[i, 2] + ");";
                lsQuery.Add(strQuery);
            }
            
            if (lsQuery.Count != 1)
            {
                sqlConn.BatchInsertDBMySql(lsQuery);
            }
            else
            {
                sqlConn.Insert(lsQuery[0]);
            }
        }

        public static void saveShenWanIndustryInflowIntoDB(string[] strSectionName, string[] strNetCapitalInflow, DateTime dtInputDate)
        {
            string strQuery = "INSERT INTO IndustryFlow (date,";
            string strName = UtilityArray.getCodeConnectByComma(strSectionName);
            string strNetInflow = UtilityArray.getCodeConnectByComma(strNetCapitalInflow);
            strQuery += strName + ") VALUES ('" + dtInputDate.ToShortDateString() + "'," + strNetInflow + ")";

            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(strQuery);
        }

        public static void saveRongziRongquanIntoDB(List<Object> lsRZRQ)
        {
            DBConnect sqlConn = new DBConnect("MySQL");
            List<string> lsQuery = new List<string>();
            string strQuery = null;

            for (int i = 0; i < ((DateTime[])lsRZRQ[0]).Length; i++)
            {
                strQuery = "INSERT INTO RongziRongquan VALUES ('" + ((DateTime[])lsRZRQ[0])[i].ToShortDateString() + "'," + (((double[,])lsRZRQ[1])[i, 0] / 10000).ToString() + ");";
                lsQuery.Add(strQuery);
            }

            if (lsQuery.Count != 1)
            {
                sqlConn.BatchInsertDBMySql(lsQuery);
            }
            else
            {
                sqlConn.Insert(lsQuery[0]);
            }
        }
    }
}
