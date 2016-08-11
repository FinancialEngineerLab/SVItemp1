#pragma once
#include "period.h"
#include "Aladdin\xll\utility\ensure.h"

// Source: Quantlib Date.h Date.cpp

typedef int Day;
typedef int Year;

enum Month { January   = 1,
			February  = 2,
			March     = 3,
			April     = 4,
			May       = 5,
			June      = 6,
			July      = 7,
			August    = 8,
			September = 9,
			October   = 10,
			November  = 11,
			December  = 12,
			Jan = 1,
			Feb = 2,
			Mar = 3,
			Apr = 4,
			Jun = 6,
			Jul = 7,
			Aug = 8,
			Sep = 9,
			Oct = 10,
			Nov = 11,
			Dec = 12
};

enum Weekday { Sunday    = 1,
                Monday    = 2,
                Tuesday   = 3,
                Wednesday = 4,
                Thursday  = 5,
                Friday    = 6,
                Saturday  = 7,
                Sun = 1,
                Mon = 2,
                Tue = 3,
                Wed = 4,
                Thu = 5,
                Fri = 6,
                Sat = 7
};



// Date class
class Date {    
   
    // Default constructor returning a null date.
   public:
		Date();
		// Constructor taking a serial number as given by Applix or Excel.
		explicit Date(int serialNumber);
		// More traditional constructor.
		Date(Day d, Month m, Year y);
    
		// name inspectors 
		Weekday weekday() const {int w =  w = serialNumber_ % 7; return Weekday(w == 0 ? 7 : w);};
		Day dayOfMonth() const {return dayOfYear() - monthOffset(month(),isLeap(year()));};
    
		// One-based (Jan 1st = 1)
		Day dayOfYear() const {return serialNumber_ - yearOffset(year());};
		Month month() const;
		Year year() const;
		int serialNumber() const {return serialNumber_;};

		//! \name date algebra    
		//! increments date by the given number of days
		Date& operator+=(int days) ;
		//! increments date by the given period
		Date& operator+=(const Period&);
		//! decrement date by the given number of days
		Date& operator-=(int days);
		//! decrements date by the given period
		Date& operator-=(const Period&);
		//! 1-day pre-increment
		Date& operator++();
		//! 1-day post-increment
		Date operator++(int );
		//! 1-day pre-decrement
		Date& operator--();
		//! 1-day post-decrement
		Date operator--(int );
		//! returns a new date incremented by the given number of days
		Date operator+(int days) const {return Date(serialNumber_+days);};
		//! returns a new date incremented by the given period
		Date operator+(const Period& p) const { return advance(*this,p.length(),p.units());};
		//! returns a new date decremented by the given number of days
		Date operator-(int days) const {return Date(serialNumber_-days);};
		//! returns a new date decremented by the given period
		Date operator-(const Period& p) const{ return advance(*this,-p.length(),p.units());};
    

		//! \name static methods
		//@{
		//! today's date.
		static Date todaysDate();
		//! earliest allowed date
		static Date minDate();
		//! latest allowed date
		static Date maxDate();
		//! whether the given year is a leap one
		static bool isLeap(Year y);
		//! last day of the month to which the given date belongs
		static Date endOfMonth(const Date& d);
		//! whether a date is the last day of its month
		static bool isEndOfMonth(const Date& d);
		//! next given weekday following or equal to the given date
		/*! E.g., the Friday following Tuesday, January 15th, 2002
			was January 18th, 2002.

			see http://www.cpearson.com/excel/DateTimeWS.htm
		*/
		static Date nextWeekday(const Date& d,
								Weekday w);
		//! n-th given weekday in the given month and year
		/*! E.g., the 4th Thursday of March, 1998 was March 26th,
			1998.

			see http://www.cpearson.com/excel/DateTimeWS.htm
		*/
    
		static Date nthWeekday(int n,
								Weekday w,
								Month m,
								Year y); 
    
	private:
		int serialNumber_;
		static Date advance(const Date& d, int units, TimeUnit);
		static int monthLength(Month m, bool leapYear);
		static int monthOffset(Month m, bool leapYear);
		static int yearOffset(Year y);
		static int minimumSerialNumber();
		static int maximumSerialNumber();
		static void checkSerialNumber(int serialNumber);
};

inline bool operator==(const Date& d1, const Date& d2) {
	return (d1.serialNumber() == d2.serialNumber());
}

inline bool operator!=(const Date& d1, const Date& d2) {
	return (d1.serialNumber() != d2.serialNumber());
}