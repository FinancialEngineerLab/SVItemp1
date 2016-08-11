using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using WAPIWrapperCSharp;
using UtilityLib;
using QuantLib;

namespace Strategy
{
    public static class PEAD
    {
        private static double dPEAD_YejiKuaibaoStrat_Quantile = 90;

        private static DataTable dtFullSUETable = new DataTable();
        private static string strPrevYear = null;

        // NetProft: 归属母公司股东的净利润
        public static double getSUE(double dCurrentYearNetProfit, double dPrevYearNetProfit, double dCurrentYearNetAssetValue)
        {
            return (dCurrentYearNetProfit - dPrevYearNetProfit) / dCurrentYearNetAssetValue * 100;
        }

        public static DateTime[] getYejiKuaiBaoReportDate(string strYear)
        {
            string strReportDate = null;
            DateTime[] dtReportDate = new DateTime[2];
            strReportDate = strYear + "/11/30";
            dtReportDate[0] = DateTime.ParseExact(strReportDate, "yyyy/MM/dd", System.Globalization.CultureInfo.CurrentCulture);
            dtReportDate[1] = DateTime.Now;
            return dtReportDate;
        }

        public static DataTable StockSelected_YejiKuaibaoStrat(string[] strStockCode, string strYear)
        {
            double[] dPrevYearSUE = null;
            DateTime[] strReportDate = null;
            double dThreshSUE = 0.0;

            // calc prev year SUE quantile
            dPrevYearSUE = UtilityArray.getColFromTable(dtFullSUETable, 2);
            dThreshSUE = UtilityMath.getPercentile(dPrevYearSUE, dPEAD_YejiKuaibaoStrat_Quantile);

            strReportDate = getYejiKuaiBaoReportDate(strYear);

            // 依次获取净利润、报告日、净资产
            List<UtilityYejiKuaibao> lsYejiKuaibao = UtilityWindData.getYejiKuaibaoNetProfit(strStockCode, strReportDate[0], strReportDate[1]);
            lsYejiKuaibao = UtilityWindData.getYejiKuaibaoDate(lsYejiKuaibao, strReportDate[0], strReportDate[1]);
            lsYejiKuaibao = UtilityWindData.getYejiKuaibaoNetAssetValue(lsYejiKuaibao, strReportDate[0], strReportDate[1]);

            // Create DataTable
            string strSUE1 = strReportDate[0].Year + "SUE";
            string strSUE2 = strReportDate[0].AddYears(-1).Year + "SUE";
            string strNetProfit1 = strReportDate[0].Year + "NetProfit";
            string strNetProfit2 = strReportDate[0].AddYears(-1).Year + "NetProfit";
            string strNetAssetValue = strReportDate[0].Year + "NetAssetValue";

            DataTable dtSUETable = new DataTable("业绩快报策略");
            DataColumn dc = null;
            dc = dtSUETable.Columns.Add("报告日", Type.GetType("System.DateTime"));
            dc = dtSUETable.Columns.Add("平仓日", Type.GetType("System.DateTime"));
            dc = dtSUETable.Columns.Add("股票代码", Type.GetType("System.String"));
            dc = dtSUETable.Columns.Add("股票名称", Type.GetType("System.String"));
            dc = dtSUETable.Columns.Add("交易状态", Type.GetType("System.String"));
            dc = dtSUETable.Columns.Add("分位数", Type.GetType("System.Double"));
            dc = dtSUETable.Columns.Add(strSUE1, Type.GetType("System.Double"));
            //dc = dtSUETable.Columns.Add(strNetProfit1, Type.GetType("System.Double"));
            dc = dtSUETable.Columns.Add(strReportDate[0].Year + "净利润", Type.GetType("System.Double"));
            dc = dtSUETable.Columns.Add(strReportDate[0].Year + "净资产", Type.GetType("System.Double"));
            dc = dtSUETable.Columns.Add(strSUE2, Type.GetType("System.Double"));
            dc = dtSUETable.Columns.Add(strReportDate[0].AddYears(-1).Year + "净利润", Type.GetType("System.Double"));

            dtFullSUETable.PrimaryKey = new DataColumn[] { dtFullSUETable.Columns["StockCode"] };
            
            for (int i = 0; i < lsYejiKuaibao.Count; i++)
            {
                DataRow drTemp = dtFullSUETable.Rows.Find(lsYejiKuaibao[i].strStockCode);
                lsYejiKuaibao[i].SUE = getSUE(lsYejiKuaibao[i].dNetProfit, (Convert.ToDouble(drTemp[strNetProfit2])), lsYejiKuaibao[i].dNetAssetValue);
                if (lsYejiKuaibao[i].SUE > dThreshSUE)
                {
                    DataRow dr = dtSUETable.NewRow();
                    dr["股票代码"] = drTemp["StockCode"];
                    dr["股票名称"] = drTemp["StockName"];
                    dr["分位数"] = dThreshSUE.ToString("0.0000");
                    dr[strSUE1] = lsYejiKuaibao[i].SUE.ToString("0.000");
                    dr[strReportDate[0].Year + "净利润"] = lsYejiKuaibao[i].dNetProfit.ToString("0.000");
                    dr["报告日"] = lsYejiKuaibao[i].dtReportDate;
                    //平仓日为报告日后20个交易日
                    dr["平仓日"] = UtilityCalendar.getNextBusinessDay(lsYejiKuaibao[i].dtReportDate, 20);
                    dr["交易状态"] = UtilityWindData.getTradingStatus(lsYejiKuaibao[i].strStockCode)[0];
                    dr[strReportDate[0].Year + "净资产"] = lsYejiKuaibao[i].dNetAssetValue.ToString("0.000");
                    dr[strSUE2] = (Convert.ToDouble(drTemp[strSUE2])).ToString("0.000");
                    dr[strReportDate[0].AddYears(-1).Year + "净利润"] = (Convert.ToDouble(drTemp[strNetProfit2])).ToString("0.000");
                    dtSUETable.Rows.Add(dr);
                }
            }
            return dtSUETable;
        }

        public static DataTable result_YejiKuaibaoStrat(string strYear, double dPercentile_)
        {
            DataTable dsResult = new DataTable();
            dPEAD_YejiKuaibaoStrat_Quantile = dPercentile_;
            // get prev year SUE data
            strPrevYear = (int.Parse(strYear) - 1).ToString();
            dtFullSUETable = UtilityMySQLData.getFullSUEListFromDB(strPrevYear);

            GlobalWind.windEnsureStart();
            string[] strStockCode = UtilityArray.getColFromTableStr(dtFullSUETable, 0);
            dsResult = StockSelected_YejiKuaibaoStrat(strStockCode, strYear);

            return dsResult;
        }

    }
}
