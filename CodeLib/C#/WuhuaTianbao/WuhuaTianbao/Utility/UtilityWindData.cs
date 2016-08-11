using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WAPIWrapperCSharp;
using System.Configuration;
using System.Collections.Specialized;
using UtilityLib;
using System.IO;
using System.Data;
using WuhuaTianbao;


namespace UtilityLib
{  
    public class UtilityWindData
    {
        //得到规范的价格格式
        public static string getWindPriceType(string strPriceType)
        {
            string strLowerCasePriceType = strPriceType.ToLower();
            if(strLowerCasePriceType.Equals("open") || strLowerCasePriceType.Equals("high") || strLowerCasePriceType.Equals("low") ||
                strLowerCasePriceType.Equals("close") || strLowerCasePriceType.Equals("pe_ttm") || strLowerCasePriceType.Equals("pb_lf") ||
                strLowerCasePriceType.Equals("mf_amt"))
            {
                return strLowerCasePriceType;
            }
            else
            {
                throw new Exception("getWindPriceType: Wind price data type not accepted");
                
            }
        }

        public static string getStockName(string strCode)
        {
            WindData wd = GlobalWind.w.wsd(strCode, "sec_name", DateTime.Now.Date, DateTime.Now.Date, "");
            return ((string[,])(wd.getDataByFunc("wsd")))[0, 0];
        }

        //从wind中提取指定代码的历史价格数组
        public static double[] getWindHistoryPrice(string strCode, string strStartTime, string strEndTime, string strPriceType)
        {
            string strCleanPriceType = null;   //提取的价格类型(满足万得格式）
            int iDataLen = 0;                  //数据数量
            double[] dHistoryPrice = null;    //历史价格数组
            double[,] temp = null;           //临时存储数据用

            strCleanPriceType = getWindPriceType(strPriceType);
            WindData wd = GlobalWind.w.wsd(strCode, strCleanPriceType, strStartTime, strEndTime, "Fill=Previous,PriceAdj=F");
            iDataLen = wd.timeList.Length;
            dHistoryPrice = new double[iDataLen];
            temp = ((double[,])wd.getDataByFunc("wsd"));
            for (int i = 0; i < iDataLen; i++)
            {
                dHistoryPrice[i] = temp[i, 0];
            }
            return dHistoryPrice;
        }


        public static double[] getWindPctChg(List<string> lsWindCode)
        {
            string strWindCode = UtilityArray.getCodeConnectByComma(lsWindCode.ToArray());

            WindData wd = GlobalWind.w.wsq(strWindCode, "rt_pct_chg", "");

            return (double[])wd.data;
        }

        public static double[,] getMultiSecuritiesHistoryPrice(string strCode, string strStartTime, string strEndTime, string strPriceType)
        {
            string strCleanPriceType = null;
            double[,] dResult = null;

            strCleanPriceType = getWindPriceType(strPriceType);
            WindData wd = GlobalWind.w.wsd(strCode, strCleanPriceType, strStartTime, strEndTime, "Fill=Previous,PriceAdj=F");
            dResult = ((double[,])wd.getDataByFunc("wsd"));

            return dResult;
        }

        public static string[] getWindSectorConstituent(string strSectorCode, DateTime dtTestDate)
        {
            WindData wd = GlobalWind.w.wset("sectorconstituent", "date=" + dtTestDate.ToShortDateString() + ";windcode=" + strSectorCode);
            object[,] objConstituent = (object[,])wd.getDataByFunc("wset");
            List<string> lsConstituentCode = new List<string>();

            for (int i = 0; i < wd.GetDataLength() / 3; i++)
            {
                lsConstituentCode.Add(objConstituent[i, 1].ToString());
            }
                
            return lsConstituentCode.ToArray();
        }

        public static double getWindIndustryNetCapitalInflow(string strSectionCode, DateTime dtRetrieveDate)
        {
            string[] strMemberArray = getWindSectorConstituent(strSectionCode, DateTime.Now.AddDays(-1));
            string strMemberCode = UtilityArray.getCodeConnectByComma(strMemberArray);

            WindData wd = getWindHistoryPrice(strMemberCode, dtRetrieveDate, dtRetrieveDate, "mf_amt");
            double[,] dResult = (double[,])wd.getDataByFunc("wsd");
            
            double dCashFlow = 0;
            for (int j = 0; j < dResult.Length; j++)
            {
                if (!double.IsNaN(dResult[0, j]))
                {
                    dCashFlow += dResult[0, j] / 10000;
                }
            }
            return dCashFlow;
        }

        public static double getWindIndustryCashflow()
        {
            GlobalWind.windEnsureStart();

            NameValueCollection NCsection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string[] strIndustryGroupMember = ConfigHelper.GetAppConfigWholeArray("ShenWanIndustryNameToCode");
            string[] strIndustryGroupMemberName = ConfigHelper.GetAppKeyWholeArray("ShenWanIndustryNameToCode");

            DateTime dtRetrieveDate =  DateTime.Now.AddDays(-1).Date;
            List<double> lsCashFlow = new List<double>();
            for (int i = 0; i < strIndustryGroupMember.Length; i++)
            {
                string[] strMemberArray = getWindSectorConstituent(strIndustryGroupMember[i], DateTime.Now.AddDays(-1));
                string strMemberCode = UtilityArray.getCodeConnectByComma(strMemberArray);
                WindData wd = getWindHistoryPrice(strMemberCode, dtRetrieveDate, dtRetrieveDate, "mf_amt");
                double[,] dResult = (double[,])wd.getDataByFunc("wsd");
                double dCashFlow = 0;
                
                for (int j = 0; j < dResult.Length; j++)
                {
                    if (!double.IsNaN(dResult[0, j]))
                    {
                        dCashFlow += dResult[0, j] / 10000;
                    }     
                }
                lsCashFlow.Add(dCashFlow);
            }
                
            return 0;
        }

        //从wind中提取指定代码的历史价格数组
        public static WindData getWindDataByType(string strCode, int iPrevStart, int iPrevEnd, string strPriceType)
        {
             string strCleanPriceType = null;   //提取的价格类型(满足万得格式）

            string strStartTime = UtilityTime.getPrevTradeDay(DateTime.Now, iPrevStart).ToShortDateString();
            string strEndTime = UtilityTime.getPrevTradeDay(DateTime.Now, iPrevEnd).ToShortDateString();

            strCleanPriceType = getWindPriceType(strPriceType);
            WindData wd = GlobalWind.w.wsd(strCode, strCleanPriceType, strStartTime, strEndTime, "Fill=Previous");

            return wd;
        }

        public static DataTable getWindHistoryData(string[] strCode, string strStartTime, string strEndTime, string strPriceType)
        {
            string strCleanPriceType = null;   //提取的价格类型(满足万得格式）            
            string strCleanCode = null;
            DataTable dtResult = new DataTable();

            strCleanCode = UtilityArray.getCodeConnectByComma(strCode);
            strCleanPriceType = getWindPriceType(strPriceType);
            WindData wd = GlobalWind.w.wsd(strCleanCode, strCleanPriceType, strStartTime, strEndTime, "Fill=Previous");
            double[,] dResult = (double[,])wd.getDataByFunc("wsd");

            dtResult.Columns.Add("Date", Type.GetType("System.DateTime"));
            for (int i = 0; i < strCode.Length; i++)
            {
                dtResult.Columns.Add(strCode[i], Type.GetType("System.Double"));
            }

            for (int i = 0; i < wd.timeList.Length; i++)
            {
                DataRow dr = dtResult.NewRow();
                dr[0] = wd.timeList[i];
                for (int j = 0; j < strCode.Length; j++)
                {
                    dr[j + 1] = dResult[i, j];
                }
                dtResult.Rows.Add(dr);
            }
            return dtResult;
        }

        public static WindData getWindHistoryPrice(string strWindCode, DateTime dtBegin, DateTime dtEnd, string strPriceType)
        {
            string strCleanPriceType = getWindPriceType(strPriceType);
            WindData wd = GlobalWind.w.wsd(strWindCode, strCleanPriceType, dtBegin, dtEnd, "Fill=Previous");          
            return wd;
        }

        //提取作图所需的所有价格数据
        public static double[,] getWindSingleStockHistoryPrice(string strCode, DateTime dtStart, DateTime dtEnd)
        {
            // Retrieve all price data from Wind
            WindData wd = GlobalWind.w.wsd(strCode, "open,high,low,close,volume", dtStart.ToShortDateString(), dtEnd.ToShortDateString(), "Fill=Previous");

            // Change into double[, ] for easy
            double[,] dResult = (double[,])wd.getDataByFunc("wsd");

            return dResult;
        }

        //提取对应时间序列
        public static DateTime[] getWindHistoryDate (string strCode, DateTime dtStart, DateTime dtEnd)
        {
            // Retrieve all price data from Wind
            WindData wd = GlobalWind.w.wsd(strCode, "close", dtStart.ToShortDateString(), dtEnd.ToShortDateString(), "Fill=Previous");

            // Change into DateTime[ ] for easy
            DateTime[] dtResult = wd.timeList;

            return dtResult;
        }

        #region
        //list返回五个结果，list[0],list[1]为成交量，成交金额的历史均值 double
        //list[2]为double[,]型，第一列为成交量的历史周频数据，第二列为成交金额的历史周频数据
        //list[3],list[4]为double[]型，是成交量及成交金额的历史偏差
        #endregion
        public static List<Object> getWindVolumeAndAmt(string strIndustryCode) 
        {
            int iSize = 0;                   //周频数据量
            int[] iTDweek = null;     //历史每周的交易日（不包括无交易的周）
            WindData wd = null;
            double[,] dVolumeAndAmt = null;  //存储成交量，金额的数组(成交量为第一列，金额为第二列）
            double iWeightSize = 0;           //加权数据量大小
            double dAverageV = 0;    //成交量的历史均值
            double dAverageA = 0;     //成交金额的历史均值
            double[] dBiasVolume = null; //成交量历史均值的偏离
            double[] dBiasAmt = null;  //成交金额历史均值的偏离
            List<Object> lResult = new List<Object>();
            iTDweek = UtilityTime.getTDWeekDays();
            iSize = iTDweek.Length;
            dBiasAmt = new double[iSize];
            dBiasVolume = new double[iSize];
            wd = GlobalWind.w.wsd(strIndustryCode, "volume,amt", "2005-1-10", "2016-1-15", "Period=W;Fill=Previous");
            dVolumeAndAmt = (double[,])wd.getDataByFunc("wsd");
             //历史周频日均
            for (int j = 0; j < iSize; j++)
            {
                dVolumeAndAmt[j, 0] = dVolumeAndAmt[j, 0] / iTDweek[j];
                dVolumeAndAmt[j, 1] = dVolumeAndAmt[j, 1] / iTDweek[j];
            }
            for (int j = 0; j < iSize; j++)
            {

                dAverageV = dAverageV + dVolumeAndAmt[j, 0] * (((double)iTDweek[j]) / 5.0);
                dAverageA = dAverageA + dVolumeAndAmt[j, 1] * (((double)iTDweek[j]) / 5.0);
                iWeightSize = iWeightSize + (((double)iTDweek[j]) / 5.0);
            }
            dAverageA = dAverageA / iWeightSize;
            dAverageV = dAverageV / iWeightSize;
            for (int j = 0; j < iSize; j++)
            {
                dBiasVolume[j] = (dVolumeAndAmt[j, 0] - dAverageV) / dAverageV;
                dBiasAmt[j] = (dVolumeAndAmt[j, 1] - dAverageA) / dAverageA;
            }
            lResult.Add(dAverageV);
            lResult.Add(dAverageA);
            lResult.Add(dVolumeAndAmt);
            lResult.Add(dBiasVolume);
            lResult.Add(dBiasAmt);

            return lResult;
        }

        public static List<Object> getWindVolumeAndAmt(string strIndustryCode, DateTime dtBegin, DateTime dtEnd)
        {
            int iSize = 0;                   //周频数据量
            int[] iTDweek = null;     //历史每周的交易日（不包括无交易的周）
            WindData wd = null;
            double[,] dVolumeAndAmt = null;  //存储成交量，金额的数组(成交量为第一列，金额为第二列）
            double iWeightSize = 0;           //加权数据量大小
            double dAverageV = 0;    //成交量的历史均值
            double dAverageA = 0;     //成交金额的历史均值
            double[] dBiasVolume = null; //成交量历史均值的偏离
            double[] dBiasAmt = null;  //成交金额历史均值的偏离
            List<Object> lResult = new List<Object>();
            iTDweek = UtilityTime.getTDWeekDays();
            iSize = iTDweek.Length;
            dBiasAmt = new double[iSize];
            dBiasVolume = new double[iSize];
            wd = GlobalWind.w.wsd(strIndustryCode, "volume,amt", dtBegin.AddDays(-10), dtEnd, "Period=W;Fill=Previous");
            dVolumeAndAmt = (double[,])wd.getDataByFunc("wsd");
             //历史周频日均
            for (int j = 0; j < iSize; j++)
            {
                dVolumeAndAmt[j, 0] = dVolumeAndAmt[j, 0] / iTDweek[j];
                dVolumeAndAmt[j, 1] = dVolumeAndAmt[j, 1] / iTDweek[j];
            }
            for (int j = 0; j < iSize; j++)
            {

                dAverageV = dAverageV + dVolumeAndAmt[j, 0] * (((double)iTDweek[j]) / 5.0);
                dAverageA = dAverageA + dVolumeAndAmt[j, 1] * (((double)iTDweek[j]) / 5.0);
                iWeightSize = iWeightSize + (((double)iTDweek[j]) / 5.0);
            }
            dAverageA = dAverageA / iWeightSize;
            dAverageV = dAverageV / iWeightSize;
            for (int j = 0; j < iSize; j++)
            {
                dBiasVolume[j] = (dVolumeAndAmt[j, 0] - dAverageV) / dAverageV;
                dBiasAmt[j] = (dVolumeAndAmt[j, 1] - dAverageA) / dAverageA;
            }
            lResult.Add(dAverageV);
            lResult.Add(dAverageA);
            lResult.Add(dVolumeAndAmt);
            lResult.Add(dBiasVolume);
            lResult.Add(dBiasAmt);

            return lResult;
        }

        public static DataTable getPercentageChange(NameValueCollection NCSection, string dtBegin, string dtEnd)
        {
            string[] strCode = new string[NCSection.Count - 1];
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                strCode[i] = NCSection[i];
            }
            string strWindCode = UtilityArray.getCodeConnectByComma(strCode);

            WindData wd = GlobalWind.w.wsd(strWindCode, "pct_chg", dtBegin, dtEnd, "Fill=Previous");
            double[,] objChg = (double[,])wd.getDataByFunc("wsd");

            DataTable dtIndustry = UtilityArray.getIndustryTable(NCSection, objChg);
            
            return dtIndustry;
        }
        

        // 一次提取所有指数的成交量数据，减少提取次数，提高运行速度
        public static DataTable getVolumnWeekly(NameValueCollection NCSection, DateTime dtBegin, DateTime dtEnd)
        {
            string[] strCode = new string[NCSection.Count - 1];
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                strCode[i] = NCSection[i];
            }
            string strWindCode = UtilityArray.getCodeConnectByComma(strCode);

            WindData wd = GlobalWind.w.wsd(strWindCode, "volume", dtBegin, dtEnd, "Period=W;Fill=Previous");
            double[,] objVolumn = (double[,])wd.getDataByFunc("wsd");
            DateTime[] dtRecord = wd.timeList;

            DateTime[] dtTrade = getTradeDays(dtBegin, dtEnd);            

            DataTable dtWeekly = UtilityArray.getWeeklyTable(NCSection, dtTrade, objVolumn);

            return dtWeekly;
        }

        // 一次提取所有指数的成交量数据，减少提取次数，提高运行速度
        public static DataTable getAmountWeekly(NameValueCollection NCSection, DateTime dtBegin, DateTime dtEnd)
        {
            string[] strCode = new string[NCSection.Count - 1];
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                strCode[i] = NCSection[i];
            }
            string strWindCode = UtilityArray.getCodeConnectByComma(strCode);

            WindData wd = GlobalWind.w.wsd(strWindCode, "amt", dtBegin, dtEnd, "Period=W;Fill=Previous");
            double[,] objVolumn = (double[,])wd.getDataByFunc("wsd");
            DateTime[] dtRecord = wd.timeList;

            DateTime[] dtTrade = getTradeDays(dtBegin, dtEnd);

            DataTable dtWeekly = UtilityArray.getWeeklyTable(NCSection, dtTrade, objVolumn);

            return dtWeekly;
        }

        // 返回收尾时间区间内的交易日序列
        public static DateTime[] getTradeDays(DateTime dtBegin, DateTime dtEnd)
        {

            WindData wd = GlobalWind.w.tdays(dtBegin, dtEnd, "Period=D");
            object[] objTrade = (object[])(wd.data);
            DateTime[] dtTrade = new DateTime[objTrade.Length];

            for (int i = 0; i < objTrade.Length; i++)
            {
                dtTrade[i] = (System.DateTime)(objTrade[i]);
            }

            return dtTrade;
        }

        // 返回每周交易日天数序列
        public static List<int> getWeekTradeDays(DateTime dtBegin, DateTime dtEnd)
        {
            DateTime[] dtTrade = getTradeDays(dtBegin.AddDays(-10), dtEnd);
            List<int> lTradeDays = new List<int>();
            int n = 0;
            bool bStart = false;
            for (int i = 0; i < dtTrade.Length ; i++)
            {
                if (dtTrade[i] == dtBegin)
                {
                    bStart = true;
                }
                if (i == dtTrade.Length - 1 || (bStart == true && (dtTrade[i]).AddDays(1) != dtTrade[i + 1]))
                {
                    lTradeDays.Add(++n);
                    n = 0;
                }
                else if ((dtTrade[i]).AddDays(1) == dtTrade[i + 1])
                {
                    n++;
                }
                else
                {
                    n = 0;
                }
             }
            return lTradeDays;
        }

        // 提取业绩快报净利润（所有股票一次提取）
        public static List<UtilityYejiKuaibao> getYejiKuaibaoNetProfit(string[] strStockCode, DateTime strReportDateStart, DateTime strReportDateEnd) 
        {
            string strStockCodeAll = UtilityArray.getCodeConnectByComma(strStockCode);

            WindData wd = GlobalWind.w.wsd(strStockCodeAll, "performanceexpress_perfexnetprofittoshareholder", strReportDateStart, strReportDateEnd, "");
            try
            {
                double[,] dNetProfit = (double[,])(wd.getDataByFunc("wsd"));
                DateTime[] dtDate = (System.DateTime[])(wd.timeList);
                int iRows = dtDate.Length;
                int iCols = dNetProfit.Length / iRows;

                var res = new List<UtilityYejiKuaibao>();

                for (int j = 0; j < iCols; j++)
                {
                    for (int i = 0; i < iRows; i++)
                    {
                        if (!double.IsNaN(dNetProfit[i, j]))
                        {
                            res.Add
                                (
                                new UtilityYejiKuaibao
                                {
                                    strStockCode = strStockCode[j],
                                    dNetProfit = dNetProfit[i, j] / 100000000
                                }
                                );
                            break;
                        }
                    }
                }
                return res;
            }
            catch (InvalidCastException)
            {
                throw new Exception("getYejiKuaibaoNetProfit: 提取数据超限！");
            }
        }

        /* ----------------------------------------------- 提取业绩快报发布日 ----------------------------------------------- */
        public static DataTable getYJKBReleaseDate(string[] strStock, DateTime dtTestDate)
        {
            DataTable dtReportDate = new DataTable("业绩快报发布日");

            dtReportDate.Columns.Add("股票代码", Type.GetType("System.String"));
            dtReportDate.Columns.Add("快报公布日", Type.GetType("System.DateTime"));

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);
            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_date", dtTestDate, dtTestDate, "");

            Object[,] objRepoDate = ((Object[,])(wd.getDataByFunc("wsd")));

            int iRows = objRepoDate.Length;
            for (int i = 0; i < iRows; i++)
            {
                if (objRepoDate[0, i].ToString() != "")
                {
                    DataRow dr = dtReportDate.NewRow();
                    dr["股票代码"] = strStock[i];
                    dr["快报公布日"] = (System.DateTime)(objRepoDate[0, i]);
                    dtReportDate.Rows.Add(dr);
                }
            }

            return dtReportDate;
        }

        /* ----------------------------------------------- 提取业绩快报ROE ----------------------------------------------- */
        public static DataTable getYJKBReportROE(string[] strStock, DateTime dtTestDate)
        {
            DataTable drROE = new DataTable("业绩快报ROE");

            drROE.Columns.Add("股票代码", Type.GetType("System.String"));
            drROE.Columns.Add("ROE", Type.GetType("System.Double"));

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);
            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_perfexroediluted", dtTestDate, dtTestDate, "");

            double[,] dRepoROE = ((double[,])(wd.getDataByFunc("wsd")));

            int iRows = dRepoROE.Length;
            for (int i = 0; i < iRows; i++)
            {
                DataRow dr = drROE.NewRow();
                dr["股票代码"] = strStock[i];
                dr["ROE"] = dRepoROE[0, i];
                drROE.Rows.Add(dr);
            }
            return drROE;
        }

        // 计算环比增长
        public static DataTable getFinancialStatementDataQ2Q(string[] strStock, string strYear, int iQuarter, string strType, bool iYJKB)
        {
            string strWindDataType = null;
            string strWindForcastType = null;
            string strTableName = null;

            // 新建表格
            DataTable dtData = new DataTable();
            dtData.Columns.Add("股票代码", Type.GetType("System.String"));
            if (strType == "NetProfit")
            {
                dtData.TableName = "归属于母公司净利润环比";
                strWindDataType = "qfa_np_belongto_parcomsh";
                strWindForcastType = "PERFORMANCEEXPRESS_PERFEXNETPROFITTOSHAREHOLDER";
                strTableName = "净利润";
            }
            else if (strType == "OperationIncome")
            {
                dtData.TableName = "营业收入环比";
                strWindDataType = "qfa_oper_rev";
                strWindForcastType = "performanceexpress_perfexincome";
                strTableName = "营业收入";
            }

            // 获取报告时间
            DateTime[] dtReportDate = UtilityTime.getSeasonReportDate(strYear);

            // 所有股票代码
            string strStockAll = UtilityArray.getCodeConnectByComma(strStock);

            if (iQuarter == 4) // 计算第四季度净利润环比
            {               
                // 三季度
                WindData wd = GlobalWind.w.wsd(strStockAll, strWindDataType, dtReportDate[2], dtReportDate[2], "rptType=1");
                double[,] dSeason3 = (double[,])(wd.getDataByFunc("wsd"));
                double dFormer = 0.0;
                double dAfter = 0.0;

                if (iYJKB == true) // 假如使用业绩快报数据
                {
                    // 一季度
                    wd = GlobalWind.w.wsd(strStockAll, strWindDataType, dtReportDate[0], dtReportDate[0], "rptType=1");
                    double[,] dSeason1 = (double[,])(wd.getDataByFunc("wsd"));
                    // 二季度
                    wd = GlobalWind.w.wsd(strStockAll, strWindDataType, dtReportDate[1], dtReportDate[1], "rptType=1");
                    double[,] dSeason2 = (double[,])(wd.getDataByFunc("wsd"));

                    // 业绩快报-全年归属于母公司股东的净利润
                    wd = GlobalWind.w.wsd(strStockAll, strWindForcastType, dtReportDate[3], dtReportDate[3], "");
                    double[,] dSeason0 = (double[,])(wd.getDataByFunc("wsd"));

                    // 推算四季度
                    dtData.Columns.Add("三季度" + strTableName, Type.GetType("System.Double"));
                    dtData.Columns.Add("四季度" + strTableName + "（推算）", Type.GetType("System.Double"));
                    dtData.Columns.Add(strTableName + "环比涨幅", Type.GetType("System.Double"));
                    for (int i = 0; i < strStock.Length; i++)
                    {
                        DataRow dr = dtData.NewRow();
                        
                        dr["股票代码"] = strStock[i];
                        dFormer = dSeason3[0, i];
                        dAfter = dSeason0[0, i] - dSeason3[0, i] - dSeason2[0, i] - dSeason1[0, i];
                        dr["三季度" + strTableName] = dFormer;
                        dr["四季度" + strTableName + "（推算）"] = dAfter;
                        dr[strTableName + "环比涨幅"] = dAfter / dFormer - 1;

                        dtData.Rows.Add(dr);
                    }
                }
                else
                {
                    // 四季度
                    wd = GlobalWind.w.wsd(strStockAll, strWindDataType, dtReportDate[3], dtReportDate[3], "rptType=1");
                    double[,] dSeason4 = (double[,])(wd.getDataByFunc("wsd"));

                    dtData.Columns.Add("三季度" + strTableName, Type.GetType("System.Double"));
                    dtData.Columns.Add("四季度" + strTableName, Type.GetType("System.Double"));
                    dtData.Columns.Add(strTableName + "环比涨幅", Type.GetType("System.Double"));

                    for (int i = 0; i < strStock.Length; i++)
                    {
                        DataRow dr = dtData.NewRow();

                        dr["股票代码"] = strStock[i];
                        dFormer = dSeason3[0, i];
                        dAfter = dSeason4[0, i];
                        dr["三季度" + strTableName] = dFormer;
                        dr["四季度" + strTableName] = dAfter;
                        dr[strTableName + "环比涨幅"] = dFormer / dAfter - 1;

                        dtData.Rows.Add(dr);
                    }
                }
            }

            return dtData;
        }


        /* ----------------------------------------------- 提取业绩快报营业收入 ----------------------------------------------- */
        public static DataTable getYJKBReportIncome(string[] strStock, DateTime dtTestDate)
        {
            DataTable drIncome = new DataTable("业绩快报营业收入");

            drIncome.Columns.Add("股票代码", Type.GetType("System.String"));
            drIncome.Columns.Add("营业收入", Type.GetType("System.Double"));

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);
            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_perfexincome", dtTestDate, dtTestDate, "");

            double[,] dRepoIncome = ((double[,])(wd.getDataByFunc("wsd")));

            int iRows = dRepoIncome.Length;
            for (int i = 0; i < iRows; i++)
            {
                if (dRepoIncome[0, i].ToString() != "")
                {
                    DataRow dr = drIncome.NewRow();
                    dr["股票代码"] = strStock[i];
                    dr["营业收入"] = dRepoIncome[0, i];
                    drIncome.Rows.Add(dr);
                }
            }
            return drIncome;
        }

        /* ----------------------------------------------- 提取业绩快报归母净利润 ----------------------------------------------- */
        public static DataTable getYJKBReportNetProfit(string[] strStock, DateTime dtTestDate)
        {
            DataTable drNetProfit = new DataTable("业绩快报营业收入");

            drNetProfit.Columns.Add("股票代码", Type.GetType("System.String"));
            drNetProfit.Columns.Add("归母净利润", Type.GetType("System.Double"));

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);
            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_perfexnetprofittoshareholder", dtTestDate, dtTestDate, "");

            double[,] dRepoNetProfit = ((double[,])(wd.getDataByFunc("wsd")));

            int iRows = dRepoNetProfit.Length;
            for (int i = 0; i < iRows; i++)
            {
                if (dRepoNetProfit[0, i].ToString() != "")
                {
                    DataRow dr = drNetProfit.NewRow();
                    dr["股票代码"] = strStock[i];
                    dr["归母净利润"] = dRepoNetProfit[0, i];
                    drNetProfit.Rows.Add(dr);
                }
            }
            return drNetProfit;
        }

        /* --------------------------------- 提取归属于母公司股东的净利润 ------------------------------------------- */
        public static DataTable getNetProfitBelongtoShareholder(string[] strStock, DateTime dtTestDate)
        {
            DataTable dtNetProfitGrowthRate = new DataTable("归属母公司股东的净利润（TTM）");

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);

            WindData wd = GlobalWind.w.wsd(strStockCode, "np_belongto_parcomsh", dtTestDate, dtTestDate, "rptType=1");
            double[,] dNetProfitGrowthRate = (double[,])wd.getDataByFunc("wsd");

            dtNetProfitGrowthRate.Columns.Add("股票代码", Type.GetType("System.String"));
            dtNetProfitGrowthRate.Columns.Add("归母净利润", Type.GetType("System.Double"));

            int iRows = strStock.Length;
            for (int i = 0; i < iRows; i++)
            {
                DataRow dr = dtNetProfitGrowthRate.NewRow();
                dr["股票代码"] = strStock[i];
                dr["归母净利润"] = dNetProfitGrowthRate[0, i];
                dtNetProfitGrowthRate.Rows.Add(dr);
            }

            return dtNetProfitGrowthRate;
        }

        /* ----------------------------------------------- 提取营业收入 ----------------------------------------------- */
        public static DataTable getOperationRevenue(string[] strStock, DateTime dtTestDate)
        {
            DataTable dtOperationRevenue = new DataTable("营业收入");

            string strStockCode = UtilityArray.getCodeConnectByComma(strStock);

            WindData wd = GlobalWind.w.wsd(strStockCode, "oper_rev", dtTestDate, dtTestDate, "rptType=1");
            double[,] dOperationRevenue = (double[,])wd.getDataByFunc("wsd");

            dtOperationRevenue.Columns.Add("股票代码", Type.GetType("System.String"));
            dtOperationRevenue.Columns.Add("营业收入", Type.GetType("System.Double"));

            int iRows = strStock.Length;
            for (int i = 0; i < iRows; i++)
            {
                DataRow dr = dtOperationRevenue.NewRow();
                dr["股票代码"] = strStock[i];
                dr["营业收入"] = dOperationRevenue[0, i];
                dtOperationRevenue.Rows.Add(dr);
            }

            return dtOperationRevenue;
        }

        // 计算业绩快报ROE
        public static List<UtilityYejiKuaibao> getYejiKuaibaoROE(List<UtilityYejiKuaibao> lsYejiKuaibao, DateTime strReportDateStart, DateTime strReportDateEnd)
        {
            string[] strWindCode = new string[lsYejiKuaibao.Count];
            for (int i = 0; i < lsYejiKuaibao.Count; i++)
            {
                strWindCode[i] = lsYejiKuaibao[i].strStockCode;
            }
            string strStockCode = UtilityArray.getCodeConnectByComma(strWindCode);

            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_perfexroediluted", strReportDateStart, strReportDateEnd, "");

            double[,] dROE = (double[,])(wd.getDataByFunc("wsd"));

            int iCol = lsYejiKuaibao.Count;
            int iRow = dROE.Length / iCol;
            DateTime[] dtDate = (System.DateTime[])(wd.timeList);

            for (int j = 0; j < iCol; j++)
            {
                for (int i = 1; i < iRow; i++)
                {
                    // (lsYejiKuaibao[j].dtReportDate > DateTime.Now) 用以应对当天收市之后披露的业绩快报，Wind将报告期标示为明日的情况
                    if ((dtDate[i - 1] <= lsYejiKuaibao[j].dtReportDate && dtDate[i] >= lsYejiKuaibao[j].dtReportDate) || (lsYejiKuaibao[j].dtReportDate > DateTime.Now))
                    {
                        lsYejiKuaibao[j].ROE = (double)(dROE[i - 1, j]);
                        break;
                    }
                }
            }

            return lsYejiKuaibao;
        }

        // 计算业绩快报公布日
        public static List<UtilityYejiKuaibao> getYejiKuaibaoDate(List<UtilityYejiKuaibao> lsYejiKuaibao, DateTime strReportDateStart, DateTime strReportDateEnd)
        {
            string[] strWindCode = new string[lsYejiKuaibao.Count];
            for (int i = 0; i < lsYejiKuaibao.Count; i++)
            {
                strWindCode[i] = lsYejiKuaibao[i].strStockCode;
            }
            string strStockCode = UtilityArray.getCodeConnectByComma(strWindCode);

            WindData wd = GlobalWind.w.wsd(strStockCode, "performanceexpress_date", strReportDateStart, strReportDateEnd, "Fill=Previous");

            Object[,] objRepoDate = ((Object[,])(wd.getDataByFunc("wsd")));

            int iCol = lsYejiKuaibao.Count;
            int iRow = objRepoDate.Length / iCol;
            for (int i = 0; i < iRow; i++)
                for (int j = 0; j < iCol; j++)
                {
                    if (objRepoDate[i, j].ToString() != "")
                    {
                        lsYejiKuaibao[j].dtReportDate = (System.DateTime)(objRepoDate[i, j]);
                        
                    }
                }

            return lsYejiKuaibao;
        }

        // 计算业绩快报日公司净资产
        public static List<UtilityYejiKuaibao> getYejiKuaibaoNetAssetValue(List<UtilityYejiKuaibao> lsYejiKuaibao, DateTime strReportDateStart, DateTime strReportDateEnd)
        {
            string[] strWindCode = new string[lsYejiKuaibao.Count];
            for (int i = 0; i < lsYejiKuaibao.Count; i++)
            {
                strWindCode[i] = lsYejiKuaibao[i].strStockCode;
            }
            string strStockCode = UtilityArray.getCodeConnectByComma(strWindCode);

            WindData wd = GlobalWind.w.wsd(strStockCode, "mkt_cap", strReportDateStart, strReportDateEnd, "Fill=Previous");

            double[,] dNetAssetVal = (double[,])(wd.getDataByFunc("wsd"));

            int iCol = lsYejiKuaibao.Count;
            int iRow = dNetAssetVal.Length / iCol;
            DateTime[] dtDate = (System.DateTime[])(wd.timeList);

            for (int j = 0; j < iCol; j++)
            {
                for (int i = 1; i < iRow; i++)
                {
                    // (lsYejiKuaibao[j].dtReportDate > DateTime.Now) 用以应对当天收市之后披露的业绩快报，Wind将报告期标示为明日的情况
                    if ((dtDate[i - 1] <= lsYejiKuaibao[j].dtReportDate && dtDate[i] >= lsYejiKuaibao[j].dtReportDate) || (lsYejiKuaibao[j].dtReportDate > DateTime.Now))
                    {
                        // 提取净资产价值
                        lsYejiKuaibao[j].dNetAssetValue = (double)(dNetAssetVal[i - 1, j]) / 100000000;
                        break;
                    }
                }
            }

            return lsYejiKuaibao;
        }

        public static DataTable getWholeStockCode()
        {
            DataTable dtStockMap = new DataTable();
            dtStockMap.Columns.Add("股票代码", Type.GetType("System.String"));
            dtStockMap.Columns.Add("股票简称", Type.GetType("System.String"));

            string strDate = DateTime.Now.AddDays(-1).ToString("yyyyMMdd");

            WindData wd = GlobalWind.w.wset("SectorConstituent", "date=" + strDate + ";sector=全部A股(非ST)");
            int iLens = wd.GetDataLength() / 3;

            for (int i = 0; i < iLens; i++)
            {
                DataRow dr = dtStockMap.NewRow();
                dr["股票代码"] = ((object[,])(wd.getDataByFunc("wset")))[i, 1].ToString();
                dr["股票简称"] = ((object[,])(wd.getDataByFunc("wset")))[i, 2].ToString();
                dtStockMap.Rows.Add(dr);
            }

            return dtStockMap;
        }

        //public static DataTable getYejiKuaibaoReleaseDate(DataTable dtStockList)
        //{
        //    DataTable dtReleaseDate = dtStockList;
        //    string[] strCode = UtilityArray.getColFromTableStr(dtStockList, 0);
        //    string strCodeAll = UtilityArray.getCodeConnectByComma(strCode);

        //    WindData wd = GlobalWind.w.wsd("000498.SZ", "performanceexpress_perfexincome", "2015/12/11", "2016/01/13", "Fill=Previous");
        //    object[,] objReleaseDate = (object[,])(wd.getDataByFunc("wsd"));

        //    dtReleaseDate.Columns.Add("快报公布日", Type.GetType("System.DateTime"));

        //    for (int i = 0; i < strCode.Length; i++)
        //    {
        //        for (int j = 0; j < wd.timeList.Length; j++)
        //        {
        //            if (null != (objReleaseDate[j, i]))
        //            {
        //                dtReleaseDate.Rows[i]["快报公布日"] = (System.Double)(objReleaseDate[i, j]);
        //            }
        //        }
        //    }

        //    return dtStockList;
        //}

        public static double[] getIndustryLBWeeklyWeekly(string strIndustryCode)  //历史周频量比
        {
            List<Object> lVolumeData = UtilityWindData.getWindVolumeAndAmt(strIndustryCode);
            int iSize = ((double[])lVolumeData[4]).Length;
            double[,] temp = (double[,])lVolumeData[2];
            double[] dDataLB = new double[iSize - 4];
            for (int i = 0; i < iSize - 4; i++)
            {
                dDataLB[i] = temp[i + 4, 0] / (temp[i + 3, 0] + temp[i + 2, 0] + temp[i + 1, 0] + temp[i, 0]) * 4;
            }
            return dDataLB;
        }



        // 一次计算所有行业规定区间内量比
        public static DataTable getIndustryLBWeekly(string strSecName, DateTime dtBegin, DateTime dtEnd)  //历史周频量比
        {

            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(strSecName);
            string[] strIndustryGroupMember = ConfigHelper.GetAppConfigWholeArray(strSecName);
            string strWholeGroupCode = UtilityArray.getCodeConnectByComma(strIndustryGroupMember);

            WindData wd = GlobalWind.w.wsd(strWholeGroupCode, "volume", dtBegin.AddDays(-30), dtEnd, "Period=W;Fill=Previous");
            double[,] dVolume = (double[,])(wd.getDataByFunc("wsd"));
            DateTime[] dtTrade = getTradeDays(dtBegin, dtEnd);
            double[,] dFreeTurn = new double[dtTrade.Length, strIndustryGroupMember.Length];
            DataTable dtWeeklyLB = UtilityArray.getWeeklyTable(NCSection, dtTrade, dFreeTurn);

            List<int> iWeekTradeDays = getWeekTradeDays(dtBegin, dtEnd);

            for (int i = 0; i < strIndustryGroupMember.Length; i++)
            {
                int n = 0;
                int k = 0;
                for (int j = 0; j < dVolume.Length / strIndustryGroupMember.Length - 4; j++)
                {
                    for (int m = 0; m < iWeekTradeDays[k]; m++)
                    {
                        dtWeeklyLB.Rows[n++][i + 1] = dVolume[j + 4, i] / (dVolume[j + 3, i] + dVolume[j + 2, i] + dVolume[j + 1, i] + dVolume[j, i]) * 4;
                    }
                    k++;
                }
            }
            return dtWeeklyLB;
        }


        public static List<Object> getWindIndustryFreeTurnWeekly(string strIndustryCode)
        //list[0]为历史周频换手率 double[]，list[1]为历史平均换手率 double， list[2]为历史周频换手率与平均值的偏差 double[] 
        {
            int[] iTDweek = null;
            int iSize = 0;
            WindData wd = null;
            double[,] dData = null;
            List<Object> lResult = new List<Object>();
            string str = "SI" + strIndustryCode.Substring(0, 6) + "GroupMember";
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(str);
            int iIndustryNumber = int.Parse(NCSection["number"].ToString());
            string[] strIndustryGroupCode = new string[iIndustryNumber];
            iTDweek = UtilityTime.getTDWeekDays();
            iSize = iTDweek.Length;
            double[] dAverageData = new double[iSize];       //历史各周平均换手率
            double[] dWeekNumberOfGroup = new double[iSize];  //历史每周的行业指数中所包含股票的数目
            double dHistoryAverageData = 0; //历史平均换手率
            double iWeightSize = 0;
            double[] dBiasData = new double[iSize];//历史偏差百分比

            for (int i = 1; i <= iIndustryNumber; i++)
            {
                strIndustryGroupCode[i - 1] = NCSection[i.ToString()];
            }

            for (int i = 0; i < iIndustryNumber; i++)
            {
                wd = GlobalWind.w.wsd(strIndustryGroupCode[i], "free_turn", "2005-01-10", "2016-01-15", "Period=W;Fill=Previous");
                dData = (double[,])wd.getDataByFunc("wsd");
                for (int j = 0; j < iSize; j++)
                {

                    if (dData[j, 0] >= 0)
                    {
                        dAverageData[j] = dAverageData[j] + dData[j, 0] / iTDweek[j];
                        dWeekNumberOfGroup[j]++;
                    }
                }
            }
            for (int i = 0; i < iSize; i++)
            {
                dAverageData[i] = dAverageData[i] / dWeekNumberOfGroup[i];
            }
            for (int j = 0; j < iSize; j++)
            {

                dHistoryAverageData = dHistoryAverageData + dAverageData[j] * (((double)iTDweek[j]) / 5.0);
                iWeightSize = iWeightSize + (((double)iTDweek[j]) / 5.0);
            }
            dHistoryAverageData = dHistoryAverageData / iWeightSize;
            for (int j = 0; j < iSize; j++)
            {
                dBiasData[j] = (dAverageData[j] - dHistoryAverageData) / dHistoryAverageData;
            }
            lResult.Add(dAverageData);
            lResult.Add(dHistoryAverageData);
            lResult.Add(dBiasData);
            return lResult;
        }

        public static double getZZ800IndexOneDay(DataTable dtWeight, DateTime dtCurrent, string strIndexType)
        {
            double dZZ800IndexBasis = 0;
            double dZZ800Index = 0;
            double dZZ800Change = 0;

            string strBasisDate = dtWeight.Rows[0][0].ToString();
            string strEndDate = dtCurrent.ToShortDateString();
            string strPrevTradeDate = UtilityTime.getPrevTradeDay(dtCurrent, 1).ToShortDateString();

            string[] strCodeArray = UtilityArray.getColFromTableStr(dtWeight, 1);
            string strCodeFull = UtilityArray.getCodeConnectByComma(strCodeArray);

            // 月初（调仓日）价格
            double[,] dBasisPrice = getMultiSecuritiesHistoryPrice(strCodeFull, strBasisDate, strBasisDate, "close");
            // 当日价格
            double[,] dCurrentPrice = getMultiSecuritiesHistoryPrice(strCodeFull, strEndDate, strEndDate, "close");

            // 指数计算
            for (int i = 0; i < strCodeArray.Length; i++)
            {
                dZZ800Change += dCurrentPrice[0, i] / dBasisPrice[0, i] * Double.Parse(dtWeight.Rows[i][2].ToString());
            }

            dZZ800IndexBasis = Double.Parse((UtilityMySQLData.getZZ800IndexFromDB(strBasisDate, strBasisDate, strIndexType).Rows[0][1]).ToString());
            dZZ800Index = dZZ800IndexBasis * dZZ800Change;

            return dZZ800Index;
        }

        public static double[,] getZZ800EqualWeightIndex(DateTime dtStart, DateTime dtEnd, string strIndexType)
        {
            DateTime[] dtTrade = getTradeDays(dtStart, dtEnd);
            int iDays = dtTrade.Length;

            double[,] dResult = new double[iDays, 3];
           
            for (int i = 0; i < iDays; i++)
            {
                //提取股票成分
                DataTable dtZZ800FullUnderlying = UtilityMySQLData.getZZ800UnderlyingFromDB(dtStart.ToShortDateString(), "zz800BenchmarkFull");
                DataTable dtZZ800LargeUnderlying = UtilityMySQLData.getZZ800UnderlyingFromDB(dtStart.ToShortDateString(), "zz800BenchmarkLargeCap");
                DataTable dtZZ800SmallUnderlying = UtilityMySQLData.getZZ800UnderlyingFromDB(dtStart.ToShortDateString(), "zz800BenchmarkSmallCap");

                //计算指数
                dResult[i, 0] = getZZ800IndexOneDay(dtZZ800FullUnderlying, dtTrade[i], "zz800Full");
                dResult[i, 1] = getZZ800IndexOneDay(dtZZ800LargeUnderlying, dtTrade[i], "zz800Large");
                dResult[i, 2] = getZZ800IndexOneDay(dtZZ800SmallUnderlying, dtTrade[i], "zz800Small");              
            }
           
            return dResult;
        }

        public static DataTable getWindIndustryFreeTurnWeekly(string strSecName, DateTime dtBegin, DateTime dtEnd)
        {
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(strSecName);

            DateTime[] dtTrade = getTradeDays(dtBegin, dtEnd);
            double[,] dFreeTurn = new double[dtTrade.Length, NCSection.Count - 1];
            DataTable dtWeeklyFreeTurn = UtilityArray.getWeeklyTable(NCSection, dtTrade, dFreeTurn);
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                string strIndustryGroupName = "SI" + NCSection[i].ToString().Substring(0, 6) + "GroupMember";
                string[] strIndustryGroupMember = ConfigHelper.GetAppConfigWholeArray(strIndustryGroupName);
                string strWholeGroupCode = UtilityArray.getCodeConnectByComma(strIndustryGroupMember);

                WindData wd = GlobalWind.w.wsd(strWholeGroupCode, "free_turn", dtBegin, dtEnd, "Period=W;Fill=Previous");
                double[,] dFreeTurnPerGroup = (double[,])wd.getDataByFunc("wsd");
                
                List<int> iWeekTradeDays = getWeekTradeDays(dtBegin, dtEnd);
                int n = 0;
                for (int j = 0; j < iWeekTradeDays.Count; j++)
                {
                    for (int k = 0; k < iWeekTradeDays[j]; k++)
                    {
                        double dFreeTurnGroup = 0;
                        double dFreeTurnNum = 0;
                        for (int m = 0; m < strIndustryGroupMember.Length; m++)
                        {
                            if (dFreeTurnPerGroup[j , m] >= 0)
                            {
                                dFreeTurnGroup = dFreeTurnGroup + dFreeTurnPerGroup[j, m] / iWeekTradeDays[j];
                                dFreeTurnNum++;
                            }
                        }
                        dtWeeklyFreeTurn.Rows[n++][i + 1] = dFreeTurnGroup / dFreeTurnNum;
                    }
                }

            }
            return dtWeeklyFreeTurn;
        }

        public static List<Object> getWindEDBData(string strCodeList,string strStartDate, string strEndDate)
        {
            WindData wd = null;
            List<Object> lResult = new List<Object>();

            wd = GlobalWind.w.edb(strCodeList, strStartDate, strEndDate, "");
            lResult.Add((System.DateTime[])(wd.timeList));

            lResult.Add((double[,])(wd.getDataByFunc("edb")));

            return lResult;
        }

        public static List<Object> getWindCPIPPI(string strStartDate, string strEndDate)
        {
            
            List<Object> lResult = new List<Object>();
            string[] strCPI = new string[3]{"CPI当月同比","CPI食品当月同比","CPI非食品当月同比"};
            string[] strPPI = new string[2]{"PPI全部工业品当月同比","PPI全部工业品当月环比"};
            string[] strDataList = null ;
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strDataList = UtilityArray.mergeArray(strCPI, strPPI);
            strCodeList = ConfigHelper.GetAppConfigArray(strDataList, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate,strStartDate,strEndDate);

            return lResult;
        }

        public static List<Object> getWindFXMkt(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strFX = new string[2] { "美元兑人民币中间价", "美元兑人民币NDF12个月" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strFX, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        public static List<Object> getWindIRMkt(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[2] { "7天银行间回购加权利率", "SHIBOR3个月" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 央行公开市场操作
        public static List<Object> getWindCentralBankOMOs(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[1] { "资金净投放" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 美元指数
        public static List<Object> getWindDollarIndex(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[1] { "美元指数" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        public static List<Object> getWindNoteMkt(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[2] { "票据转贴月利率6个月","票据直贴月利率6个月长三角" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // EDB 数据通用获取函数(输入变量为提取数据名称---与上式区分）
        public static List<Object> getWindEDBData(string[] strCodeName, string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strCodeName, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 央行票据
        public static List<Object> getWindCentralBankBill(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[1] { "央票1年到期收益率" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 国债收益率
        public static List<Object> getWindTreasuryBond(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string[] strIR = new string[2] { "10年期国债到期收益率：中国", "10年期国债到期收益率：美国" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strIR, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 大宗商品价格
        public static List<Object> getWindBulkCommodities(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<object>();
            string[] strBC = new string[3] { "现货价:原油:美国西德克萨斯中级轻质原油(WTI)", "现货价:原油:英国布伦特Dtd", "期货结算价(活跃合约):铁矿石" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strBC, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 农产品价格
        public static List<Object> getWindFarmProduce(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<object>();
            string[] strFP = new string[5] {"期货结算价(活跃合约):黄玉米", "期货结算价(活跃合约):鸡蛋","50个城市平均价：猪肉：五花肉","50个城市平均价：鸡肉：白条鸡","猪粮比价：全国"};
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strFP, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 金属价格
        public static List<Object> getWindMetalPrice(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<object>();
            string[] strMP = new string[7] { "现货结算价:LME铜", "现货结算价:LME铅", "现货结算价:LME铝", 
                "现货结算价:LME锌", "期货结算价(活跃合约):焦煤", "期货结算价(活跃合约):螺纹钢", 
                "期货结算价(活跃合约):COMEX黄金" };
            string[] strCodeList = null;
            string strCodeConcatenate = null;

            strCodeList = ConfigHelper.GetAppConfigArray(strMP, "WindEDBData");
            strCodeConcatenate = UtilityArray.getCodeConnectByComma(strCodeList);
            lResult = getWindEDBData(strCodeConcatenate, strStartDate, strEndDate);
            return lResult;
        }

        // 获取停牌状态
        public static string[] getTradingStatus(string strCode)
        {
            List<string> strStatus = new List<string>();

            WindData wd = GlobalWind.w.wsq(strCode, "rt_susp_flag", "");

            //停牌标志是五位整数，前四位是月份和日期，最后一位含义如下：

            //0不停;
            //1停1h;
            //2停2h;
            //3停半天;
            //4停下午;
            //5停半小时;
            //6临时停牌;
            //9停牌一天

            // 获取交易状态，截取最后一位数字保存于iCode
            for (int i = 0; i < wd.GetCodeLength(); i++)
            {
                int iStatus = (int)((double[])(wd.data))[i];
                int iCode = iStatus % 10;

                switch (iCode)
                {
                    case 0: strStatus.Add("今日交易"); break;
                    case 1: strStatus.Add("停牌1小时"); break;
                    case 2: strStatus.Add("停牌2小时"); break;
                    case 3: strStatus.Add("停牌半天"); break;
                    case 4: strStatus.Add("下午停牌"); break;
                    case 5: strStatus.Add("停牌半小时"); break;
                    case 6: strStatus.Add("临时停牌"); break;
                    case 9: strStatus.Add("停牌一天"); break;
                }
            }
            
            return strStatus.ToArray();
        }

        public static List<Object> getWindRongZiRongQuanBalance(string strStartDate, string strEndDate)
        {
            List<Object> lResult = new List<Object>();
            string strIR = "融资融券余额";
            string strCode = null;

            strCode = ConfigHelper.GetAppConfig(strIR, "WindEDBData");
            WindData wd = GlobalWind.w.edb(strCode, strStartDate, strEndDate, "");
            lResult.Add((System.DateTime[])(wd.timeList));
            lResult.Add((double[])wd.data);

            return lResult;
        }


        //**************************************** Option Data ******************************************************//
        public static double[, ] getWindOptionBuyAndSellRTD(string strOptionCode)
        {
            // 买/卖-至五价格及挂单量
            
            WindData wd = GlobalWind.w.wsq(strOptionCode, "rt_bid1,rt_bid2,rt_bid3,rt_bid4,rt_bid5,rt_ask1,rt_ask2,rt_ask3,rt_ask4,rt_ask5,rt_bsize1,rt_bsize2,rt_bsize3,rt_bsize4,rt_bsize5,rt_asize1,rt_asize2,rt_asize3,rt_asize4,rt_asize5", "");

            double[, ] dPrice = (double[, ])wd.getDataByFunc("wsq");

            return dPrice;
        }

        public static double[,] getExercisePrice(string strOptionCode)
        {
            WindData wd = GlobalWind.w.wsd(strOptionCode, "exe_price", DateTime.Now, DateTime.Now, "");
            double[,] dExePrice = (double[,])wd.getDataByFunc("wsd");
            return dExePrice;
        }

        public static object[, ] getOptionInfo(string strOptionCode)
        {
            WindData wd = GlobalWind.w.wsd(strOptionCode, "exe_price,lasttradingdate", DateTime.Now, DateTime.Now, "");
            object[, ] objOptInfo = (object[, ])(wd.getDataByFunc("wsd"));
            return objOptInfo;
        }
        public static double getLatestPrice(string strCode)
        {
            WindData wd = GlobalWind.w.wsq(strCode, "rt_last", "");
            double dLatestPrice = ((double[,])(wd.getDataByFunc("wsd")))[0, 0];
            return dLatestPrice;
        }
        public static DateTime getFutureLastTradingDate(string strFutCode)
        {
            WindData wd = GlobalWind.w.wsd(strFutCode, "lasttrade_date", DateTime.Now, DateTime.Now, "");
            DateTime dtLastTradingDate = (System.DateTime)(((object[,])(wd.getDataByFunc("wsd")))[0, 0]);
            return dtLastTradingDate;
        }
        public static double getAskOnePrice(string strCode)
        {
            WindData wd = GlobalWind.w.wsq(strCode, "rt_ask1", "");
            double dLatestPrice = ((double[,])(wd.getDataByFunc("wsd")))[0, 0];
            return dLatestPrice;
        }
        public static double getLiveSpread(string strCode)
        {
            WindData wd = GlobalWind.w.wsq(strCode, "rt_spread", "");
            double dSpread = ((double[,])(wd.getDataByFunc("wsd")))[0, 0];
            return dSpread;
        }
    }

    public class UtilityYejiKuaibao
    {
        public string strStockCode { get; set; }

        public double dNetProfit { get; set; }

        public DateTime dtReportDate { get; set; }

        public double dNetAssetValue { get; set; }

        public double SUE { get; set; }

        public double ROE { get; set; }
    }

    




   

}
