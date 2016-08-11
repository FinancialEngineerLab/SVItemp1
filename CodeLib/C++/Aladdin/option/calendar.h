#pragma once
#include "date.h"
#include "Aladdin\xll\utility\ensure.h"


//Source: Quantlib calendar.cpp china.cpp 

 enum BusinessDayConvention {
    // ISDA
    Following,                   /*!< Choose the first business day after
                                        the given holiday. */
    ModifiedFollowing,           /*!< Choose the first business day after
                                        the given holiday unless it belongs
                                        to a different month, in which case
                                        choose the first business day before
                                        the holiday. */
    Preceding,                   /*!< Choose the first business
                                        day before the given holiday. */
    // NON ISDA
    ModifiedPreceding,           /*!< Choose the first business day before
                                        the given holiday unless it belongs
                                        to a different month, in which case
                                        choose the first business day after
                                        the holiday. */
    Unadjusted,                  /*!< Do not adjust. */
    HalfMonthModifiedFollowing   /*!< Choose the first business day after
                                        the given holiday unless that day
                                        crosses the mid-month (15th) or the
                                        end of month, in which case choose
                                        the first business day before the
                                        holiday. */
};




class Calendar : public Date {
private:
	
public:
	Calendar();
	Calendar(int iSerialNumber):Date(iSerialNumber){};
	bool isWeekend(Weekday);
	bool isBusinessDay(Date);
	bool isHoliday(Date d)  {return !isBusinessDay(d);};

	Date adjust(Date d, BusinessDayConvention bConvention);
	Date addTenor(Date d, int n, TimeUnit unit,BusinessDayConvention bConvention, bool endOfMonth);
	Date addTenor(Date d,Period p, BusinessDayConvention c,bool endOfMonth); 
};

























 //! Chinese calendar
    /*! Holidays:
        <ul>
        <li>Saturdays</li>
        <li>Sundays</li>
        <li>New Year's day, January 1st (possibly followed by one or
            two more holidays)</li>
        <li>Labour Day, first week in May</li>
        <li>National Day, one week from October 1st</li>
        </ul>

        Other holidays for which no rule is given (data available for
        2004-2015 only):
        <ul>
        <li>Chinese New Year</li>
        <li>Ching Ming Festival</li>
        <li>Tuen Ng Festival</li>
        <li>Mid-Autumn Festival</li>
        </ul>

        SSE data from <http://www.sse.com.cn/>
        IB data from <http://www.chinamoney.com.cn/>

        \ingroup calendars
    */


