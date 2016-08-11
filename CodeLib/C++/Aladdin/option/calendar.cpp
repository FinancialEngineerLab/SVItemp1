#include "calendar.h"


bool Calendar::isWeekend(Weekday w)
{
	return w == Saturday || w == Sunday;
}

bool Calendar::isBusinessDay(Date date)
{
	Weekday w = date.weekday();
	Day d = date.dayOfMonth();
	Month m = date.month();
	Year y = date.year();

	if (isWeekend(w)
		// New Year's Day
		|| (d == 1 && m == January)
		|| (y == 2005 && d == 3 && m == January)
		|| (y == 2006 && (d == 2 || d == 3) && m == January)
		|| (y == 2007 && d <= 3 && m == January)
		|| (y == 2007 && d == 31 && m == December)
		|| (y == 2009 && d == 2 && m == January)
		|| (y == 2011 && d == 3 && m == January)
		|| (y == 2012 && (d == 2 || d == 3) && m == January)
		|| (y == 2013 && d <= 3 && m == January)
		|| (y == 2014 && d == 1 && m == January)
		|| (y == 2015 && d <= 3 && m == January)
		// Chinese New Year
		|| (y == 2004 && d >= 19 && d <= 28 && m == January)
		|| (y == 2005 && d >=  7 && d <= 15 && m == February)
		|| (y == 2006 && ((d >= 26 && m == January) ||
		(d <= 3 && m == February)))
		|| (y == 2007 && d >= 17 && d <= 25 && m == February)
		|| (y == 2008 && d >= 6 && d <= 12 && m == February)
		|| (y == 2009 && d >= 26 && d <= 30 && m == January)
		|| (y == 2010 && d >= 15 && d <= 19 && m == January)
		|| (y == 2011 && d >= 2 && d <= 8 && m == February)
		|| (y == 2012 && d >= 23 && d <= 28 && m == January)
		|| (y == 2013 && d >= 11 && d <= 15 && m == February)
		|| (y == 2014 && d >= 31 && m == January)
		|| (y == 2014 && d <= 6 && m == February)
		|| (y == 2015 && d >= 18 && d <= 24 && m == February)
		// Ching Ming Festival
		|| (y <= 2008 && d == 4 && m == April)
		|| (y == 2009 && d == 6 && m == April)
		|| (y == 2010 && d == 5 && m == April)
		|| (y == 2011 && d >=3 && d <= 5 && m == April)
		|| (y == 2012 && d >= 2 && d <= 4 && m == April)
		|| (y == 2013 && d >= 4 && d <= 5 && m == April)
		|| (y == 2014 && d == 7 && m == April)
		|| (y == 2015 && d >= 5 && d <= 6 && m == April)
		// Labor Day
		|| (y <= 2007 && d >= 1 && d <= 7 && m == May)
		|| (y == 2008 && d >= 1 && d <= 2 && m == May)
		|| (y == 2009 && d == 1 && m == May)
		|| (y == 2010 && d == 3 && m == May)
		|| (y == 2011 && d == 2 && m == May)
		|| (y == 2012 && ((d == 30 && m == April) ||
		(d == 1 && m == May)))
		|| (y == 2013 && ((d >= 29 && m == April) ||
		(d == 1 && m == May)))
		|| (y == 2014 && d >= 1 && d <=3 && m == May)
		|| (y == 2015 && d == 1 && m == May)
		// Duanwu Festival
		|| (y <= 2008 && d == 9 && m == June)
		|| (y == 2009 && (d == 28 || d == 29) && m == May)
		|| (y == 2010 && d >= 14 && d <= 16 && m == June)
		|| (y == 2011 && d >= 4 && d <= 6 && m == June)
		|| (y == 2012 && d >= 22 && d <= 24 && m == June)
		|| (y == 2013 && d >= 10 && d <= 12 && m == June)
		|| (y == 2014 && d == 2 && m == June)
		|| (y == 2015 && d == 22 && m == June)
		// Mid-Autumn Festival
		|| (y <= 2008 && d == 15 && m == September)
		|| (y == 2010 && d >= 22 && d <= 24 && m == September)
		|| (y == 2011 && d >= 10 && d <= 12 && m == September)
		|| (y == 2012 && d == 30 && m == September)
		|| (y == 2013 && d >= 19 && d <= 20 && m == September)
		|| (y == 2014 && d == 8 && m == September)
		|| (y == 2015 && d == 27 && m == September)
		// National Day
		|| (y <= 2007 && d >= 1 && d <= 7 && m == October)
		|| (y == 2008 && ((d >= 29 && m == September) ||
		(d <= 3 && m == October)))
		|| (y == 2009 && d >= 1 && d <= 8 && m == October)
		|| (y == 2010 && d >= 1 && d <= 7 && m == October)
		|| (y == 2011 && d >= 1 && d <= 7 && m == October)
		|| (y == 2012 && d >= 1 && d <= 7 && m == October)
		|| (y == 2013 && d >= 1 && d <= 7 && m == October)
		|| (y == 2014 && d >= 1 && d <= 7 && m == October)
		|| (y == 2015 && d >= 1 && d <= 7 && m == October)
		// Victory Day
		|| (y == 2015 && d >= 3 && d <= 4 && m == October)
		)
		return false;
	return true;
}

Date Calendar::adjust(Date d,BusinessDayConvention bConvention)
{
	ALADDIN_ENSURE (d!=Date(),"null date");
	Date d1 = d;

	if (bConvention == Unadjusted)
		return d;
	
	if (bConvention == Following || bConvention == ModifiedFollowing 
		|| bConvention == HalfMonthModifiedFollowing) {
			while (isHoliday(d1))
				d1++;
			if (bConvention == ModifiedFollowing 
				|| bConvention == HalfMonthModifiedFollowing) {
					if (d1.month() != d.month()) {
						return adjust(d, Preceding);
					}
					if (bConvention == HalfMonthModifiedFollowing) {
						if (d.dayOfMonth() <= 15 && d1.dayOfMonth() > 15) {
							return adjust(d, Preceding);
						}
					}
			}
	} else if (bConvention == Preceding || bConvention == ModifiedPreceding) {
		while (isHoliday(d1))
			d1--;
		if (bConvention == ModifiedPreceding && d1.month() != d.month()) {
			return adjust(d,Following);
		}
	} else {
		ALADDIN_FAIL("unknown business-day convention");
	}
	return d1;
}


Date Calendar::addTenor(Date d, int n, TimeUnit unit,BusinessDayConvention bConvention, bool endOfMonth)
{
	ALADDIN_ENSURE(d!=Date(), "null date");
	if (n == 0) 
	{
		return adjust(d,bConvention);
	} else if (unit == Days || unit == NormalDays) 
			{
				Date d1 = d;
				if (n > 0) {
					while (n > 0) {
						d1++;
						if( unit == Days)
						{
							while (isHoliday(d1))
							d1++;
						}
						n--;
					}
				} else {
					while (n < 0) {
						d1--;
						if( unit == Days)
						{
							while(isHoliday(d1))
								d1--;
						}
						n++;
					}
				}
				return d1;
			} else if (unit == Weeks) 
					{
						Period p(n,unit);
						//Date d1 = d + n*unit;
						Date d1 = d + p;
						return adjust(d1,bConvention);
					} else 
							{
								Period p(n,unit);
								Date d1 = d + p;

								// we are sure the unit is Months or Years
								if (endOfMonth && isEndOfMonth(d))
									return Calendar::endOfMonth(d1);

								return adjust(d1, bConvention);
							}
}


Date Calendar::addTenor(Date d,Period p, BusinessDayConvention c,bool endOfMonth)
{
		return addTenor(d, p.length(), p.units(), c, endOfMonth);
}