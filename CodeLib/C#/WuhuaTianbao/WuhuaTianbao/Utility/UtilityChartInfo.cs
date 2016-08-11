using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WuhuaTianbao
{
    /// <summary>
    /// 股票信息
    /// </summary>
    public class UtilityChartInfo
    {
        /// <summary>
        /// 时间
        /// </summary>
        public DateTime date { get; set; }

        /// <summary>
        /// 开盘价
        /// </summary>
        public double open { get; set; }
        /// <summary>
        /// 最高价
        /// </summary>
        public double high { get; set; }
        /// <summary>
        /// 最低价
        /// </summary>
        public double low { get; set; }
        /// <summary>
        /// 收盘价
        /// </summary>
        public double close { get; set; }
        ///// 收盘价
        /// </summary>
        public double close2 { get; set; }
        /// <summary>
        /// 成交量
        /// </summary>
        public double volume { get; set; }
    }

    public class UtilityRongziRongquanInfo
    {
        public string date { get; set; }

        public double amount { get; set; }

        public double difference { get; set; }
    }

    public class UtilityIndustryInfo
    {
        public string name { get; set; }

        public double pct_chg { get; set; }

        public double cashflow { get; set; }
    }

    public class UtiltiySHHKInfo
    {
        public string date { get; set; }

        public double SH { get; set; }

        public double HK { get; set; }
    }

    public class UtilityExcessReturn
    {
        public string date { get; set; }

        public double compareCapIndex { get; set; }

        public double benchmarkIndex { get; set; }

        public double ratio { get; set; }

        public double excessReturn30 { get; set; }

        public double excessReturn60 { get; set; }

        public double quantile30 { get; set; }

        public double quantile60 { get; set; }
    }

    public class Utiltity800Index
    {
        public string date { get; set; }

        public DateTime datetime { get; set; }

        public double zz800Full { get; set; }

        public double zz800Large { get; set; }

        public double zz800Small { get; set; }

        public double zz800Ratio { get; set; }

    }

    public class UtilityMarcoMkt
    {
        public string date { get; set; }

        public double group1 { get; set; }

        public double group2 { get; set; }
    }

    public class UtilityYJKB
    {
        public DateTime releaseDate { get; set; }

        public string strStockCode { get; set; }

        public string strStockName { get; set; }

        public double ROE { get; set; }

        public double netProfit { get; set; }

        public double netRevenue { get; set; }
    }

    public class UtilityDailyFutureTradeByCompany
    {
        public DateTime dtTradingDay { get; set; }

        public string strInstrumentId { get; set; }

        public int iDataTypeID { get; set; }

        public int iRank { get; set; }

        public string strShortName { get; set; }

        public int iVolume { get; set; }

        public int iVarVolume { get; set; }

        public int iPartyId { get; set; }

        public string strProductId { get; set; }
    }
}
