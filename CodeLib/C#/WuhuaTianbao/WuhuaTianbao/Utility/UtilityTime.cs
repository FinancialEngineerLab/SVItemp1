using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WAPIWrapperCSharp;
using UtilityLib;
using System.IO;
using System.Collections.Specialized;
using System.Configuration;

namespace UtilityLib
{
    public static class UtilityTime
    {
        public static bool isTradeDay(DateTime dtNow)
        {
            //GlobalWind.windEnsureStart();
            WindData wd = GlobalWind.w.tdays(dtNow, dtNow, "");
            if (wd.errorCode == 0)
            {
                return true;
            }
            
            return false;
        }

        public static DateTime getPrevTradeDay(DateTime dtNow, int iPrev)
        {
            //GlobalWind.windEnsureStart();
            WindData wd = GlobalWind.w.tdaysoffset(dtNow, -iPrev, "");
            GlobalWind.windEnsureNoErr(wd);
            return (System.DateTime)(((object[])(wd.data))[0]);
        }

        public static bool isTradeHour(DateTime dtNow)
        {
            if (!isTradeDay(dtNow)) // 非交易日
            {
                return false;
            }
            if ((dtNow > dtNow.Date.AddHours(9.5) && dtNow < dtNow.Date.AddHours(11.5)) || ((dtNow > dtNow.Date.AddHours(13)) && dtNow < dtNow.Date.AddHours(15)))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static bool isAfterTradeHour(DateTime dtNow)
        {
            if (isTradeDay(dtNow) && dtNow > dtNow.Date.AddHours(15))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static int[] getYearAndSeasonOfCWBB() //返回最近报表所出的年度和季度
        {
            DateTime temp = DateTime.Now;
            int[] result = new int[2];
            if (temp.Month <= 4 && temp.Month >= 1)
            {
                result[0] = temp.Year - 1;
                result[1] = 3;
            }
            else if (temp.Month <= 8 && temp.Month >= 5)
            {
                result[0] = temp.Year - 1;
                result[1] = 4;
            }
            else if (temp.Month <= 10 && temp.Month >= 9)
            {
                result[0] = temp.Year;
                result[1] = 2;
            }
            else
            {
                result[0] = temp.Year;
                result[1] = 3;
            }
            return result;
         }

        public static int[] getTDWeekDays()
        {
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("HistoryTradeDaysOfAWeek");
            int iWeekNumber = int.Parse(NCSection["AllWeeksNumber"].ToString());
            int[] iTDweek = new int[iWeekNumber];     //历史每周的交易日（不包括无交易的周）
            for (int i = 0; i < iWeekNumber; i++)
            {
                iTDweek[i] =int.Parse(NCSection[i.ToString()]);
            }


            return iTDweek;
        }


        public static DateTime[] getStartAndEndMonthDate(string strCurrentDate) // yyyy-mm-dd
        {
            DateTime[] ret = new DateTime[2];
            DateTime dtCurrentDate = DateTime.Parse(strCurrentDate);
            DateTime dtStartOfMonth = dtCurrentDate.AddMonths(-1).AddDays(-1);
            DateTime dtEndOfMonth = dtCurrentDate.AddDays(-1);

            ret[0] = dtStartOfMonth;
            ret[1] = dtEndOfMonth;
            return ret;

        }

        public static DateTime[] getSeasonReportDate(string strYear)
        {
            DateTime[] dtReportDate = new DateTime[4];

            string strReportBegin = strYear + "/12/31";
            dtReportDate[3] = DateTime.ParseExact(strReportBegin, "yyyy/MM/dd", System.Globalization.CultureInfo.CurrentCulture);
            dtReportDate[2] = dtReportDate[3].AddMonths(-3);
            dtReportDate[1] = dtReportDate[3].AddMonths(-6);
            dtReportDate[0] = dtReportDate[3].AddMonths(-9);

            return dtReportDate;
        }
    }
}
