using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UtilityLib
{
    class UtilityCalendar
    {
        public static DateTime getNextBusinessDay(DateTime dtStartDate, int iDays)
        {
            DateTime dtEndDate = new DateTime();
            string strYear = null;
            string[] strChinaHoliday = null;
            List<DateTime> lsDateArray = new List<DateTime>();
            int iCount = iDays;
            DateTime dtTemp = dtStartDate;

            strYear = dtStartDate.Year.ToString();
            strChinaHoliday = ConfigHelper.GetAppConfigWholeArray("ChinaHoliday" + strYear);
            int iHoliday = strChinaHoliday.Length;
            bool bHoliday = false;

            while (iCount >= 0)
            {
                if (dtTemp.DayOfWeek != DayOfWeek.Saturday && dtTemp.DayOfWeek != DayOfWeek.Sunday)
                {
                    bHoliday = false;
                    for (int i = 0; i < iHoliday; i++)
                    {
                        if (dtTemp.ToString("yyyy/MM/dd") == strChinaHoliday[i])
                        {
                            bHoliday = true;
                        }
                    }
                    if (bHoliday == false)
                    {
                        lsDateArray.Add(dtTemp);
                        iCount -= 1;
                    }
                }
                dtTemp = dtTemp.AddDays(1);
            }

            dtEndDate = lsDateArray.Last();

            return dtEndDate;
        }
    }
}
