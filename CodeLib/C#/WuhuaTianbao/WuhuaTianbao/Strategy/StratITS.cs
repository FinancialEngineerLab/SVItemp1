using System.Linq;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using System.Net;
using System.IO;
using System.Text.RegularExpressions;
using UtilityLib;
using System.Globalization;

namespace WuhuaTianbao
{
    class StratITS
    {
        // 将提前的HTML代码转换为表格
        public static DataTable getDailyFutureVol(string strHTML)
        {
            DataTable dtDailyFutureVol = new DataTable("每日结算会员成交持仓排名");
            DataColumn dc = new DataColumn();
            dc = dtDailyFutureVol.Columns.Add("会员简称", Type.GetType("System.String"));
            dc = dtDailyFutureVol.Columns.Add("成交量", typeof(int));
            dc = dtDailyFutureVol.Columns.Add("比上交易日增减", typeof(int));
            dc = dtDailyFutureVol.Columns.Add("买单会员简称", Type.GetType("System.String"));
            dc = dtDailyFutureVol.Columns.Add("持买单量", typeof(int));
            dc = dtDailyFutureVol.Columns.Add("买单比上交易日增减", typeof(int));
            dc = dtDailyFutureVol.Columns.Add("卖单会员简称", Type.GetType("System.String"));
            dc = dtDailyFutureVol.Columns.Add("持卖单量", typeof(int));
            dc = dtDailyFutureVol.Columns.Add("卖单比上交易日增减", typeof(int));

            List<string> strNameList = new List<string>();
            List<string> strVolList = new List<string>();
            List<string> strVarList = new List<string>();
            foreach (Match mch in Regex.Matches(strHTML, @"[\u4e00-\u9fa5]{4}"))
            {
                string strCompName = mch.Value.Trim();
                strNameList.Add(strCompName);
            }
            foreach (Match mch in Regex.Matches(strHTML, @"<\bvolume>-?[0-9]\d*"))
            {
                string strCompName = mch.Value.Trim();
                strVolList.Add(strCompName.Substring(8));
            }
            foreach (Match mch in Regex.Matches(strHTML, @"<\bvarVolume>-?[0-9]\d*"))
            {
                string strCompName = mch.Value.Trim();
                strVarList.Add(strCompName.Substring(11));
            }

            int iSumTradeVol = 0;
            int iSumVarVol = 0;
            int iSumBuyVol = 0;
            int iSumBuyVar = 0;
            int iSumSellVol = 0;
            int iSumSellVar = 0;

            for (int i = 0; i < strNameList.Count() / 3; i++)
            {
                DataRow dr = dtDailyFutureVol.NewRow();
                dr["会员简称"] = strNameList[i * 3].ToString();
                dr["买单会员简称"] = strNameList[i * 3 + 1].ToString();
                dr["卖单会员简称"] = strNameList[i * 3 + 2].ToString();
                dr["成交量"] = int.Parse(strVolList[i * 3].ToString());
                dr["持买单量"] = int.Parse(strVolList[i * 3 + 1].ToString());
                dr["持卖单量"] = int.Parse(strVolList[i * 3 + 2].ToString());
                dr["比上交易日增减"] = int.Parse(strVarList[i * 3].ToString());
                dr["买单比上交易日增减"] = int.Parse(strVarList[i * 3 + 1].ToString());
                dr["卖单比上交易日增减"] = int.Parse(strVarList[i * 3 + 2].ToString());

                iSumTradeVol += int.Parse(strVolList[i * 3].ToString());
                iSumBuyVol += int.Parse(strVolList[i * 3 + 1].ToString());
                iSumSellVol += int.Parse(strVolList[i * 3 + 2].ToString());
                iSumVarVol += int.Parse(strVarList[i * 3].ToString()); ;
                iSumBuyVar += int.Parse(strVarList[i * 3 + 1].ToString()); ;
                iSumSellVar += int.Parse(strVarList[i * 3 + 2].ToString());

                dtDailyFutureVol.Rows.Add(dr);
            }

            DataRow dsum = dtDailyFutureVol.NewRow();
            dsum["成交量"] = iSumTradeVol;
            dsum["比上交易日增减"] = iSumVarVol;
            dsum["持买单量"] = iSumBuyVol;
            dsum["持卖单量"] = iSumSellVol;
            dsum["买单比上交易日增减"] = iSumBuyVar;
            dsum["卖单比上交易日增减"] = iSumSellVar;
            dtDailyFutureVol.Rows.Add(dsum);

            return dtDailyFutureVol;
        }

        public static List<UtilityDailyFutureTradeByCompany> getFutureTradeByCompany(string strHTML)
        {
            List<UtilityDailyFutureTradeByCompany> lsInfoTable = new List<UtilityDailyFutureTradeByCompany>();
            foreach (Match mch in Regex.Matches(strHTML, @"(?is)<data.*?</data>"))
            {
                string strCompanyInfo = mch.Value.Trim();
                UtilityDailyFutureTradeByCompany UDFTB = new UtilityDailyFutureTradeByCompany();
                foreach (Match mchType in Regex.Matches(strCompanyInfo, @"<instrumentId>\w*"))
                {
                    string strInstrumentID = mchType.Value.Trim();
                    UDFTB.strInstrumentId = strInstrumentID.Substring(strInstrumentID.Length - 6);
                }
                foreach (Match mchDay in Regex.Matches(strCompanyInfo, @"<tradingDay>\w*"))
                {
                    string strTradingDay = mchDay.Value.Trim();
                    DateTime dtTradingDay = DateTime.ParseExact(strTradingDay.Substring(strTradingDay.Length - 8), "yyyyMMdd", System.Globalization.CultureInfo.CurrentCulture);
                    UDFTB.dtTradingDay = dtTradingDay;
                }
                foreach (Match mchTypeID in Regex.Matches(strCompanyInfo, @"<dataTypeId>\w*"))
                {
                    string strDataType = mchTypeID.Value.Trim();
                    UDFTB.iDataTypeID = int.Parse(strDataType.Substring(12));
                }
                foreach (Match mchRank in Regex.Matches(strCompanyInfo, @"<rank>\w*"))
                {
                    string strRank = mchRank.Value.Trim();
                    UDFTB.iRank = int.Parse(strRank.Substring(6));
                }
                foreach (Match mchName in Regex.Matches(strCompanyInfo, @"<shortname>[\u4e00-\u9fa5]{4}"))
                {
                    string strName = mchName.Value.Trim();
                    UDFTB.strShortName = strName.Substring(11);
                }
                foreach (Match mchVol in Regex.Matches(strCompanyInfo, @"<volume>\w*"))
                {
                    string strVol = mchVol.Value.Trim();
                    UDFTB.iVolume = int.Parse(strVol.Substring(8));
                }
                foreach (Match mchVar in Regex.Matches(strCompanyInfo, @"<varVolume>-?\w*"))
                {
                    string strVar = mchVar.Value.Trim();
                    UDFTB.iVarVolume = int.Parse(strVar.Substring(11));
                }
                foreach (Match mchParty in Regex.Matches(strCompanyInfo, @"<partyid>-?\w*"))
                {
                    string strParty = mchParty.Value.Trim();
                    UDFTB.iPartyId = int.Parse(strParty.Substring(9));
                }
                foreach (Match mchParty in Regex.Matches(strCompanyInfo, @"<productid>-?\w*"))
                {
                    string strProduct = mchParty.Value.Trim();
                    UDFTB.strProductId = strProduct.Substring(11);
                }
                lsInfoTable.Add(UDFTB);
            }
            return lsInfoTable;
        }

         //新建提取XML代码序列
        public static List<string> getXMLAddress(DateTime dtStartDate, DateTime dtEndDate, string strType)
        {
            List<string> lsXMLAddress = new List<string>();
            string strXML = "http://www.cffex.com.cn/fzjy/ccpm/";

            DateTime[] dtTradeDays = UtilityWindData.getTradeDays(dtStartDate, dtEndDate);
            
            for (int i = 0; i < dtTradeDays.Length; i++)
            {
                string strXMLFull = strXML + dtTradeDays[i].Year;
                if (dtTradeDays[i].Month < 10)
                {
                    strXMLFull += "0" + dtTradeDays[i].Month + "/";
                }
                else
                {
                    strXMLFull += dtTradeDays[i].Month + "/";
                }

                if (dtTradeDays[i].Day < 10)
                {
                    strXMLFull += "0" + dtTradeDays[i].Day + "/" + strType + ".xml";;
                }
                else
                {
                    strXMLFull += dtTradeDays[i].Day + "/" + strType + ".xml";
                }
                lsXMLAddress.Add(strXMLFull);
            }
            return lsXMLAddress;
        }

        public static void UpdateFutureData()
        {
            GlobalWind.windEnsureStart();
            DateTime dtEndDate = UtilityTime.getPrevTradeDay(DateTime.Now, 1);

            DateTime dtStartDate;
            DateTimeFormatInfo dtFormat = new System.Globalization.DateTimeFormatInfo();
            dtFormat.ShortDatePattern = "yyyy/MM/dd";
            dtStartDate = Convert.ToDateTime("2015/01/05", dtFormat);

            List<string> lsXMLAddress = getXMLAddress(dtStartDate, dtEndDate, "IF");
            for (int i = 0; i < lsXMLAddress.Count; i++)
            {
                string strHTML = UtilityWebBrowser.getHTMLcode(lsXMLAddress[i]);
                List<UtilityDailyFutureTradeByCompany> ls = getFutureTradeByCompany(strHTML);
                DataTable dsResult = getDailyFutureVol(strHTML);
                UtilityExcel.saveDataTabletoCSV(dsResult,@"D:\BeiwaitanCodeLib\C#\WuhuaTianbao",dtEndDate.ToString("yyyy-MM-dd"));
            }
        }
    }
}
