#pragma once
#include "Aladdin\xll\utility\ensure.h"

// Source: Quantlib period.h, period.cpp

enum TimeUnit { Days,
                Weeks,
                Months,
                Years,
				NormalDays, // non-business days
};

enum Frequency { NoFrequency = -1,     //!< null frequency
                    Once = 0,             //!< only once, e.g., a zero-coupon
                    Annual = 1,           //!< once a year
                    Semiannual = 2,       //!< twice a year
                    EveryFourthMonth = 3, //!< every fourth month
                    Quarterly = 4,        //!< every third month
                    Bimonthly = 6,        //!< every second month
                    Monthly = 12,         //!< once a month
                    EveryFourthWeek = 13, //!< every fourth week
                    Biweekly = 26,        //!< every second week
                    Weekly = 52,          //!< once a week
                    Daily = 365,          //!< once a day
                    OtherFrequency = 999  //!< some other unknown frequency
};


class Period {
public:
    Period()
    : length_(0), units_(Days) {}
    Period(int n, TimeUnit units)
    : length_(n), units_(units) {}
    explicit Period(Frequency f);
   
	int length() const { return length_; }
    TimeUnit units() const { return units_; }
    Frequency frequency() const;
    Period& operator+=(const Period&);
    Period& operator-=(const Period&);
    //Period& operator/=(int);
    void normalize();

private:
    int length_;
    TimeUnit units_;
};


inline Period operator-(const Period& p);