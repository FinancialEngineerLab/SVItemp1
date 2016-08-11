#include "period.h"

Period::Period(Frequency f) 
{
        switch (f) {
          case NoFrequency:
            // same as Period()
            units_ = Days;
            length_ = 0;
            break;
          case Once:
            units_ = Years;
            length_ = 0;
            break;
          case Annual:
            units_ = Years;
            length_ = 1;
            break;
          case Semiannual:
          case EveryFourthMonth:
          case Quarterly:
          case Bimonthly:
          case Monthly:
            units_ = Months;
            length_ = 12/f;
            break;
          case EveryFourthWeek:
          case Biweekly:
          case Weekly:
            units_ = Weeks;
            length_ = 52/f;
            break;
          case Daily:
            units_ = Days;
            length_ = 1;
            break;
          case OtherFrequency:
            ALADDIN_FAIL("unknown frequency");  // no point in showing 999...
          default:
            ALADDIN_FAIL("unknown frequency (" << int(f) << ")");
        }
}

Frequency Period::frequency() const {
    // unsigned version
	std::size_t length = std::abs(length_);

    if (length==0) {
        if (units_==Years) return Once;
        return NoFrequency;
    }

    switch (units_) {
        case Years:
        if (length == 1)
            return Annual;
        else
            return OtherFrequency;
        case Months:
        if (12%length == 0 && length <= 12)
            return Frequency(12/length);
        else
            return OtherFrequency;
        case Weeks:
        if (length==1)
            return Weekly;
        else if (length==2)
            return Biweekly;
        else if (length==4)
            return EveryFourthWeek;
        else
            return OtherFrequency;
        case Days:
        if (length==1)
            return Daily;
        else
            return OtherFrequency;
        default:
        ALADDIN_FAIL("unknown time unit (" << Integer(units_) << ")");
    }
}

 Period& Period::operator+=(const Period& p) 
 {
    if (length_==0) {
        length_ = p.length();
        units_ = p.units();
    } else if (units_==p.units()) {
        // no conversion needed
        length_ += p.length();
    } else {
        switch (units_) {

            case Years:
            switch (p.units()) 
			{
                case Months:
                units_ = Months;
                length_ = length_*12 + p.length();
                break;
                case Weeks:
                case Days:
                ALADDIN_ENSURE(p.length()==0,
                            "impossible addition between " << *this <<
                            " and " << p);
                break;
                default:
                ALADDIN_FAIL("unknown time unit (" << int(p.units()) << ")");
            }
            break;

            case Months:
            switch (p.units()) 
			{
                case Years:
                length_ += p.length()*12;
                break;
                case Weeks:
                case Days:
                ALADDIN_ENSURE(p.length()==0,
                            "impossible addition between " << *this <<
                            " and " << p);
                break;
                default:
                ALADDIN_FAIL("unknown time unit (" << int(p.units()) << ")");
            }
            break;

            case Weeks:
            switch (p.units()) 
			{
                case Days:
                units_ = Days;
                length_ = length_*7 + p.length();
                break;
                case Years:
                case Months:
                ALADDIN_ENSURE(p.length()==0,
                            "impossible addition between " << *this <<
                            " and " << p);
                break;
                default:
                ALADDIN_FAIL("unknown time unit (" << int(p.units()) << ")");
            }
            break;

            case Days:
            switch (p.units()) 
			{
                case Weeks:
                length_ += p.length()*7;
                break;
                case Years:
                case Months:
                ALADDIN_ENSURE(p.length()==0,
                            "impossible addition between " << *this <<
                            " and " << p);
                break;
                default:
                ALADDIN_FAIL("unknown time unit (" << int(p.units()) << ")");
            }
            break;

            default:
				ALADDIN_FAIL("unknown time unit (" << int(units_) << ")");
        }
    }

    //this->normalize();
    return *this;
}

Period& Period::operator-=(const Period& p) 
{
    return operator+=(-p);
}

Period operator-(const Period& p)
{
	return Period(-p.length(),p.units());
};