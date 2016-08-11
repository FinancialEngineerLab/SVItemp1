using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;

namespace UtilityLib
{
    public static class UtilityZhaoYangData
    {
        // 返回朝阳永续数据： 一致预期PE,PB,ROE,净利同比
        public static List<double[]> getZhaoYangDataPE_PB_ROE_Other(string strcode_, int iStartYear,int iEndYear,int iType,string strDB)
        {
            DBConnect dbSQLServer = new DBConnect("SQLServer");
            SqlDataReader myReader = null;
            List<double[]> ldata = new List<double[]>();
            string strQuery = null;

            dbSQLServer.getSqlConnection().Open();
            
          
            for (int j = iStartYear; j <= iEndYear; j++)
            {
                DateTime dtStartTime = DateTime.Parse(j.ToString() + "-05-01");
                DateTime dtEndTime = DateTime.Parse((j + 1).ToString() + "-04-30");
                double[] dtemp = null;
                strQuery = "select c5,cPB,c12,c7,CON_DATE from " + strDB + " where STOCK_CODE='" + strcode_.ToString().Substring(0, 6)+"' AND RPT_DATE=" + j.ToString() + " AND STOCK_TYPE=" + iType.ToString()+" ORDER BY CON_DATE";
                myReader = dbSQLServer.Read(strQuery);
                while (myReader.Read())
                {
                    dtemp = new double[4];
                    if (DateTime.Compare(DateTime.Parse(myReader[4].ToString()), dtStartTime) >=0 && DateTime.Compare(DateTime.Parse(myReader[4].ToString()), dtEndTime) <=0)
                    {
                        dtemp[0] = (double)myReader[0];    
                        dtemp[1] = (double)myReader[1];
                        dtemp[2] = (double)myReader[2];
                        dtemp[3] = (double)myReader[3];
                        ldata.Add(dtemp);
                    }

                }
                myReader.Close();

            }
            return ldata;
        }

        // 返回朝阳永续数据： 近4周一致预期变化
        public static DataTable getZhaoYangDataExpectValueChange(string[] strCode, DateTime dtReportDate, DateTime[] dtReleaseDate)
        {
            DataTable dtResult = new DataTable("一致预期变化");
            dtResult.Columns.Add("股票代码", Type.GetType("System.String"));
            dtResult.Columns.Add("股票简称", Type.GetType("System.String"));
            dtResult.Columns.Add("一致预期变化", Type.GetType("System.Double"));

            DBConnect dbSQLConn = new DBConnect("SQLServer");
            string strQuery = null;

            for (int i = 0; i < strCode.Length; i++)
            {
                strQuery = "SELECT CON_DATE,C81,RPT_DATE,STOCK_NAME FROM CON_FORECAST_STK WHERE STOCK_CODE='" + strCode[i].Substring(0, 6) +
                    "' AND CON_DATE>='" + dtReleaseDate[i].AddDays(-2).ToShortDateString() + "' AND CON_DATE<'" + dtReleaseDate[i].ToShortDateString() +
                    "' AND RPT_DATE='" + dtReportDate.Year.ToString() + "' ORDER BY CON_DATE";
                DataTable dtTemp = dbSQLConn.Select(strQuery).Tables[0];

                // 解决缺值的特殊情况
                if (dtTemp.Rows.Count == 0)
                {
                    strQuery = "SELECT CON_DATE,C81,RPT_DATE,STOCK_NAME FROM CON_FORECAST_STK WHERE STOCK_CODE='" + strCode[i].Substring(0, 6) +
                    "' AND CON_DATE>='" + dtReleaseDate[i].AddDays(-3).ToShortDateString() + "' AND CON_DATE<'" + dtReleaseDate[i].ToShortDateString() +
                    "' AND RPT_DATE='" + dtReportDate.Year.ToString() + "' ORDER BY CON_DATE";
                    dtTemp = dbSQLConn.Select(strQuery).Tables[0];
                }

                DataRow dr = dtResult.NewRow();
                dr["股票代码"] = strCode[i];
                if (dtTemp.Rows.Count == 0)
                {
                    dr["一致预期变化"] = -999;
                    dr["股票简称"] = null;
                }
                else
                {
                    dr["一致预期变化"] = dtTemp.Rows[0][1];
                    dr["股票简称"] = dtTemp.Rows[0][3];
                }                                
                dtResult.Rows.Add(dr);
            }

            return dtResult;
        }

        // 返回朝阳永续数据： 一致预期净利同比
        public static DataTable getZhaoYangDataNetProfitYearly(string[] strCode, DateTime dtReportDate, DateTime[] dtReleaseDate)
        {
            DataTable dtResult = new DataTable("一致预期净利同比");
            dtResult.Columns.Add("股票代码", Type.GetType("System.String"));
            dtResult.Columns.Add("净利同比", Type.GetType("System.Double"));

            DBConnect dbSQLConn = new DBConnect("SQLServer");
            string strQuery = null;

            for (int i = 0; i < strCode.Length; i++)
            {
                strQuery = "SELECT CON_DATE,C7,RPT_DATE FROM CON_FORECAST_STK WHERE STOCK_CODE='" + strCode[i].Substring(0, 6) +
                    "' AND CON_DATE>='" + dtReleaseDate[i].AddDays(-2).ToShortDateString() + "' AND CON_DATE<='" + dtReleaseDate[i].ToShortDateString() +
                    "' AND RPT_DATE='" + dtReportDate.Year.ToString() + "' ORDER BY CON_DATE";
                DataTable dtTemp = dbSQLConn.Select(strQuery).Tables[0];

                DataRow dr = dtResult.NewRow();
                dr["股票代码"] = strCode[i];
                if (dtTemp.Rows.Count == 0)
                {
                    dr["净利同比"] = -999;
                }
                else
                {
                    dr["净利同比"] = dtTemp.Rows[0][1];
                }
                dtResult.Rows.Add(dr);
            }

            return dtResult;
        }

        // 返回朝阳永续数据： 主营收入同比(Zysrtb),净利润同比增长率(JlrTb)，毛利率（Mll)，净利率(Jll)，ROE
        // 没有行业数据，故返回行业成分股的中位数
        public static double[] getZhaoYangDataIndustryFundamentalData(string strIndustryCode,int iYear,int iSeason)//大小为5的double数组 依次返回营业收入增长率 净利润增长率 毛利率 净利率 ROE
        {
            double[] result = new double[5];
            List<double> lZysrTb = new List<double>();
            List<double> lJlrTb = new List<double>();
            List<double> lMll = new List<double>();
            List<double> lJll = new List<double>();
            List<double> lROE = new List<double>();
            DBConnect dbSQLServer = new DBConnect("SQLServer");
            SqlDataReader myReader = null;
            List<double[]> ldata = new List<double[]>();
            string strQuery = null;

            string str = "SI" + strIndustryCode.Substring(0, 6) + "GroupMember";
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(str);
            int iIndustryNumber = int.Parse(NCSection["number"].ToString());
            string[] strIndustryGroupCode = new string[iIndustryNumber];
            for (int i = 1; i <= iIndustryNumber; i++)
            {
                strIndustryGroupCode[i - 1] = NCSection[i.ToString()];
            }

            for (int i = 0; i < iIndustryNumber; i++)
            {
                strQuery = "select MLL,gain_16,JLR_TB,ZYSR_TB,DEBT_43,gain_1 from DER_FIN_MAIN  where STOCK_CODE='" + strIndustryGroupCode[i].Substring(0, 6) + "' AND  TIME_YEAR =" + iYear.ToString() + " AND TIME_YEAR_TYPE=" + iSeason.ToString();
                myReader = dbSQLServer.Read(strQuery);
                if (myReader.Read())
                {
                    lZysrTb.Add((double)myReader[3]);
                    lJlrTb.Add((double)myReader[2]);
                    lMll.Add((double)myReader[0]);
                    lJll.Add((double)myReader[1] / (double)myReader[5]);
                    lROE.Add((double)myReader[1] / (double)myReader[4]);
                }
                myReader.Close();
            }
            lZysrTb.Sort();
            lJlrTb.Sort();
            lMll.Sort();
            lJll.Sort();
            lROE.Sort();
            if (lZysrTb.Count % 2 == 0)
            {
                result[0] = (lZysrTb[lZysrTb.Count / 2] + lZysrTb[lZysrTb.Count / 2 - 1]) / 2;
                result[1] = (lJlrTb[lZysrTb.Count / 2] + lJlrTb[lZysrTb.Count / 2 - 1]) / 2;
                result[2] = (lMll[lZysrTb.Count / 2] + lMll[lZysrTb.Count / 2 - 1]) / 2;
                result[3] = (lJll[lZysrTb.Count / 2] + lJll[lZysrTb.Count / 2 - 1]) / 2;
                result[4] = (lROE[lZysrTb.Count / 2] + lROE[lZysrTb.Count / 2 - 1]) / 2;
            }
            else
            {
                result[0] = lZysrTb[lZysrTb.Count / 2];
                result[1] = lJlrTb[lZysrTb.Count / 2];
                result[2] = lMll[lZysrTb.Count / 2];
                result[3] = lJll[lZysrTb.Count / 2];
                result[4] = lROE[lZysrTb.Count / 2];
            }
            
            
            return result;
        }

        //依次返回2年复合增长率
        public static double getZhaoYangDataIndustryCompoundGrowthRate(string strIndustryCode, int iYear)
        {
            DBConnect dbSQLServer = new DBConnect("SQLServer");
            SqlDataReader myReader = null;
            double dResult = 0;
            string strQuery = null;
            strQuery = "select c3 from CON_FORECAST_SW  where  STOCK_TYPE  = 4 AND  STOCK_CODE='" + strIndustryCode.Substring(0, 6) + "' AND  RPT_DATE =" + iYear.ToString() +" AND CON_DATE = '"+DateTime.Now.AddDays(-1).ToShortDateString()+"'";
            myReader = dbSQLServer.Read(strQuery);
            if (!myReader.Read())
                throw new Exception("getZhaoYangDataIndustryCompoundGrowthRate: 未读取到数据");
            dResult = (double)myReader[0];
            myReader.Close();
            return dResult;
        }

        //返回组合预期变动指数
        public static double getZhaoYangDataPEI(string strIndustryCode, int iYear)
        {
            double result = 0;
            DBConnect dbSQLServer = new DBConnect("SQLServer");
            SqlDataReader myReader = null;
            string strQuery = null;
            strQuery = "select PEI from CON_PER_SW  where  STOCK_TYPE  = 4 AND  STOCK_CODE='" + strIndustryCode.Substring(0, 6) + "' AND  RPT_DATE =" + iYear.ToString() +  " AND CON_DATE = '" + DateTime.Now.AddDays(-1).ToShortDateString() + "'";
            myReader = dbSQLServer.Read(strQuery);
            if (!myReader.Read())
                return 0;
            result = (double)myReader[0];
            myReader.Close();
            return result;
        }



        public static Dictionary<string, string> getPE_PB_ROE_Quantile_Data(string strIndustryCode, string strIndexCode)
        {
            DateTime dtToday = DateTime.Now;
            int iZhaoYangPEEndYear = 0;
            List<double[]> lIndustryData = null;            //历史行业一致预测数据
            List<double[]> lIndexData = null;            //历史指数一致预测数据
            double[] dHistoryIndustryPe = null;        //历史行业PE数据
            double[] dHistoryIndustryPb = null;      //历史行业PB数据
            double[] dHistoryIndexPe = null;          //历史行业相对指数PE数据
            double[] dHistoryIndexPb = null;           //历史行业相对指数PB数据
            Dictionary<string, string> dicResult = new Dictionary<string, string>();
            if (dtToday.Month > 6)
            {
                iZhaoYangPEEndYear = dtToday.Year;
            }
            else
            {
                iZhaoYangPEEndYear = dtToday.Year - 1;
            }
            lIndustryData = getZhaoYangDataPE_PB_ROE_Other(strIndustryCode, 2005, iZhaoYangPEEndYear, 4, "CON_FORECAST_SW");//4代表所取代码为行业代码（1为股票，2为指数，>=5为指数分行业）这里提取行业的预测数据
            dicResult["PE"] = lIndustryData[lIndustryData.Count - 1][0].ToString("0.000");
            dicResult["PB"] = lIndustryData[lIndustryData.Count - 1][1].ToString("0.000");
            dicResult["ROE"] = lIndustryData[lIndustryData.Count - 1][2].ToString("0.000");
            dicResult["净利同比"] = lIndustryData[lIndustryData.Count - 1][3].ToString("0.000");

            lIndexData = getZhaoYangDataPE_PB_ROE_Other(strIndexCode, 2005, iZhaoYangPEEndYear, 2, "CON_FORECAST_IDX");  //提取全市场的预测数据
            //dicResult["相对PE"] = ((lIndustryData[lIndustryData.Count - 1][0] - lIndexData[lIndexData.Count - 1][0]) / lIndexData[lIndexData.Count - 1][0]).ToString("0.00%");
            dicResult["相对PE"] = (lIndustryData[lIndustryData.Count - 1][0]  / lIndexData[lIndexData.Count - 1][0]).ToString("0.00%");
            //dicResult["相对PB"] = ((lIndustryData[lIndustryData.Count - 1][1] - lIndexData[lIndexData.Count - 1][1]) / lIndexData[lIndexData.Count - 1][1]).ToString("0.00%");
            dicResult["相对PB"] = (lIndustryData[lIndustryData.Count - 1][1]  / lIndexData[lIndexData.Count - 1][1]).ToString("0.00%");

            //提取历史数据，进行分位数计算
            dHistoryIndustryPe = new double[lIndustryData.Count];
            dHistoryIndustryPb = new double[lIndustryData.Count];
            dHistoryIndexPe = new double[lIndustryData.Count];
            dHistoryIndexPb = new double[lIndustryData.Count];
            for (int i = 0; i < lIndustryData.Count; i++)
            {

                dHistoryIndustryPe[i] = lIndustryData[i][0];
                dHistoryIndustryPb[i] = lIndustryData[i][1];
                dHistoryIndexPe[i] = lIndustryData[i][0] / lIndexData[i][0];
                dHistoryIndexPb[i] = lIndustryData[i][1] / lIndexData[i][1];
            }
            dicResult["PE分位数"] = UtilityMath.QF(dHistoryIndustryPe, dHistoryIndustryPe[dHistoryIndustryPe.Length - 1]).ToString("0.000");
            dicResult["PB分位数"] = UtilityMath.QF(dHistoryIndustryPb, dHistoryIndustryPb[dHistoryIndustryPb.Length - 1]).ToString("0.000");
            dicResult["相对PE分位数"] = UtilityMath.QF(dHistoryIndexPe, dHistoryIndexPe[dHistoryIndexPe.Length - 1]).ToString("0.000");
            dicResult["相对PB分位数"] = UtilityMath.QF(dHistoryIndexPb, dHistoryIndexPb[dHistoryIndexPb.Length - 1]).ToString("0.000");

           
            return dicResult;
        }

    }
}
