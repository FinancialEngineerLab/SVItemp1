using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using UtilityLib;
using WAPIWrapperCSharp;

namespace Strategy
{
    public static class StratYejiKuaibao
    {
        // 魏刚版本的业绩快报，不同于PEAD
        public static DataTable getYejiKuaibaoResult(string strYear, double dROEThreshold, double dNetProfitThreshold, double dExpectProfitThreshold, 
            double dOperationIncomeThreshold, double dExpectUpwardsThreshold)
        {
            DataTable dtResult = new DataTable("业绩快报策略");

            // 存储现在的时刻和报告期
            DateTime[] dtReportPeriod = getYejiKuaibaoReportPeriod(strYear);

            GlobalWind.windEnsureStart();

            // 获取市场所有证券代码
            DataTable dtStockList = UtilityWindData.getWholeStockCode();
            string[] strStockCodeAll = UtilityArray.getColFromTableStr(dtStockList, 0);

            ////Test
            //string[] strStockCodeAll = { "000063.SZ", "002281.SZ", "002367.SZ", "002380.SZ", "300238.SZ", "300296.SZ", "300370.SZ", 
            //                               "300452.SZ", "300455", "300497.SZ", "600837.SH", "603678.SH" };

            /* ----------------------------------------------- Wind Data ----------------------------------------------- */
            DataTable dtReleaseDate = UtilityWindData.getYJKBReleaseDate(strStockCodeAll, dtReportPeriod[0]);
            string[] strStockReleased = UtilityArray.getColFromTableStr(dtReleaseDate, 0);

            DataTable dtReportROE = UtilityWindData.getYJKBReportROE(strStockReleased, dtReportPeriod[0]);

            // 2015.12
            DataTable dtNetProfitGrowthRate2 = UtilityWindData.getNetProfitBelongtoShareholder(strStockReleased, dtReportPeriod[0]);
            DataTable dtOperationRevenue2 = UtilityWindData.getOperationRevenue(strStockReleased, dtReportPeriod[0]);
            // 2014.12
            DataTable dtNetProfitGrowthRate1 = UtilityWindData.getNetProfitBelongtoShareholder(strStockReleased, dtReportPeriod[0].AddYears(-1));
            DataTable dtOperationRevenue1 = UtilityWindData.getOperationRevenue(strStockReleased, dtReportPeriod[0].AddYears(-1));


            /* ------------------------------------------ ZhaoYangYongXu Data ------------------------------------------ */
            // 4周分析师预期上调幅度
            DateTime[] dtRelaseTime = UtilityArray.getColFromTableDt(dtReleaseDate, 1);
            DataTable dtExpectIncrease = UtilityZhaoYangData.getZhaoYangDataExpectValueChange(strStockReleased, dtReportPeriod[0], dtRelaseTime);
            // 一致预期净利同比
            DataTable dtExpectNetProfitIncrease = UtilityZhaoYangData.getZhaoYangDataNetProfitYearly(strStockReleased, dtReportPeriod[0], dtRelaseTime);
            

            //同比增长率
            DataTable dtNetProfitTB = new DataTable("净利润同比增长率");
            dtNetProfitTB.Columns.Add("股票代码", Type.GetType("System.String"));
            dtNetProfitTB.Columns.Add("同比增长率", Type.GetType("System.Double"));

            DataTable dtOperationRevenueTB = new DataTable("营业收入同比增长率");
            dtOperationRevenueTB.Columns.Add("股票代码", Type.GetType("System.String"));
            dtOperationRevenueTB.Columns.Add("同比增长率", Type.GetType("System.Double"));

            for (int i = 0; i < dtNetProfitGrowthRate2.Rows.Count; i++)
            {
                DataRow dr1 = dtNetProfitTB.NewRow();
                dr1["股票代码"] = dtNetProfitGrowthRate2.Rows[i]["股票代码"];
                dr1["同比增长率"] = double.Parse(dtNetProfitGrowthRate2.Rows[i]["归母净利润"].ToString()) / double.Parse(dtNetProfitGrowthRate1.Rows[i]["归母净利润"].ToString()) - 1;
                dtNetProfitTB.Rows.Add(dr1);

                DataRow dr2 = dtOperationRevenueTB.NewRow();
                dr2["股票代码"] = dtOperationRevenue2.Rows[i]["股票代码"];
                dr2["同比增长率"] = double.Parse(dtOperationRevenue2.Rows[i]["营业收入"].ToString()) / double.Parse(dtOperationRevenue1.Rows[i]["营业收入"].ToString()) - 1;
                dtOperationRevenueTB.Rows.Add(dr2);
            }

            DataTable dtNetProfitHB = UtilityWindData.getFinancialStatementDataQ2Q(strStockReleased, strYear, 4, "NetProfit", true);
            DataTable dtOperationRevenueHB = UtilityWindData.getFinancialStatementDataQ2Q(strStockReleased, strYear, 4, "OperationIncome", true);

            // 超预期幅度
            DataTable dtOverExpectRange = new DataTable("超预期幅度");
            dtOverExpectRange.Columns.Add("股票代码", Type.GetType("System.String"));
            dtOverExpectRange.Columns.Add("超预期幅度", Type.GetType("System.Double"));

            for (int i = 0; i < dtNetProfitTB.Rows.Count; i++)
            {
                DataRow dr1 = dtOverExpectRange.NewRow();
                dr1["股票代码"] = dtNetProfitTB.Rows[i]["股票代码"];
                if (dtExpectNetProfitIncrease.Rows[i]["净利同比"].ToString() == "")
                {
                    dtExpectNetProfitIncrease.Rows[i]["净利同比"] = 0;
                    dr1["超预期幅度"] = 0 / double.Parse(dtNetProfitTB.Rows[i]["同比增长率"].ToString()) - 1;
                }
                else
                {
                    dr1["超预期幅度"] = double.Parse(dtNetProfitTB.Rows[i]["同比增长率"].ToString()) - double.Parse(dtExpectNetProfitIncrease.Rows[i]["净利同比"].ToString());
                }
                dtOverExpectRange.Rows.Add(dr1);
            }

            /* ---------------------------------------------- Create Table ---------------------------------------------- */
            DataColumn dc = null;
            dc = dtResult.Columns.Add("快报公布日", Type.GetType("System.DateTime"));
            dc = dtResult.Columns.Add("股票代码", Type.GetType("System.String"));
            dc = dtResult.Columns.Add("股票简称", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "净利润", Type.GetType("System.Double"));
            dc = dtResult.Columns.Add(strYear + "营业收入", Type.GetType("System.Double"));
            dc = dtResult.Columns.Add(strYear + "ROE", Type.GetType("System.Double"));
            dc = dtResult.Columns.Add(strYear + "预期上调幅度", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "超预期幅度", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "净利润同比", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "净利润环比", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "营业收入同比", Type.GetType("System.String"));
            dc = dtResult.Columns.Add(strYear + "营业收入环比", Type.GetType("System.String"));

            for (int i = 0; i < strStockReleased.Length; i++)
            {
                DataRow dr = dtResult.NewRow();
                dr["快报公布日"] = dtReleaseDate.Rows[i]["快报公布日"];
                dr["股票代码"] = strStockReleased[i];
                dr["股票简称"] = dtExpectIncrease.Rows[i]["股票简称"];
                dr[strYear + "净利润"] = dtNetProfitGrowthRate2.Rows[i]["归母净利润"];
                dr[strYear + "营业收入"] = dtOperationRevenue2.Rows[i]["营业收入"];
                if (double.Parse(dtReportROE.Rows[i]["ROE"].ToString()) <= (dROEThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "ROE"] = dtReportROE.Rows[i]["ROE"];
                if (dtExpectIncrease.Rows[i]["一致预期变化"].ToString() == "" || double.Parse(dtExpectIncrease.Rows[i]["一致预期变化"].ToString()) <= (dExpectUpwardsThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "预期上调幅度"] = double.Parse(dtExpectIncrease.Rows[i]["一致预期变化"].ToString()).ToString("0.00%");
                if (double.Parse(dtOverExpectRange.Rows[i]["超预期幅度"].ToString()) <= (dExpectProfitThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "超预期幅度"] = double.Parse(dtOverExpectRange.Rows[i]["超预期幅度"].ToString()).ToString("0.00%");
                if (double.Parse(dtNetProfitTB.Rows[i]["同比增长率"].ToString()) <= (dNetProfitThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "净利润同比"] = double.Parse(dtNetProfitTB.Rows[i]["同比增长率"].ToString()).ToString("0.00%");
                if (double.Parse(dtNetProfitHB.Rows[i]["净利润环比涨幅"].ToString()) <= (dNetProfitThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "净利润环比"] = double.Parse(dtNetProfitHB.Rows[i]["净利润环比涨幅"].ToString()).ToString("0.00%");
                if (double.Parse(dtOperationRevenueTB.Rows[i]["同比增长率"].ToString()) <= (dOperationIncomeThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "营业收入同比"] = double.Parse(dtOperationRevenueTB.Rows[i]["同比增长率"].ToString()).ToString("0.00%");
                if (double.Parse(dtOperationRevenueHB.Rows[i]["营业收入环比涨幅"].ToString()) <= (dExpectUpwardsThreshold / 100))
                {
                    continue;
                }
                dr[strYear + "营业收入环比"] = double.Parse(dtOperationRevenueHB.Rows[i]["营业收入环比涨幅"].ToString()).ToString("0.00%");

                dtResult.Rows.Add(dr);
            }
            return dtResult;
        }

        public static DateTime[] getYejiKuaibaoReportPeriod(string strYear)
        {
            DateTime[] dtReportDate = new DateTime[2];

            string strReportBegin = strYear + "/12/31";
            dtReportDate[0] = DateTime.ParseExact(strReportBegin, "yyyy/MM/dd", System.Globalization.CultureInfo.CurrentCulture);
            dtReportDate[1] = DateTime.Now;
            return dtReportDate;
        }
    }
}
