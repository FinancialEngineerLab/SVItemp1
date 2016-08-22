from dateutil import rrule
import time
import datetime
import date_offset

def days_traded(begin, end):
    delta = end - begin
    ret = delta.days + 1
    return ret


def years_traded(begin, end):
    return days_traded(begin, end) / 365.0


# date in format %Y-%m-%d
def count_business_day(start_date, end_date):
    start_strptime = time.strptime(start_date, "%Y-%m-%d")
    end_strptime = time.strptime(end_date, "%Y-%m-%d")

    start_y, start_m, start_d = start_strptime[0:3]
    end_y, end_m, end_d = end_strptime[0:3]

    r = rrule.rrule(rrule.DAILY,
                    byweekday=[rrule.MO, rrule.TU, rrule.WE, rrule.TH, rrule.FR],
                    dtstart=datetime.date(start_y, start_m, start_d),
                    until=datetime.date(end_y, end_m, end_d))

    rs = rrule.rruleset()
    rs.rrule(r)
    for ex_date in date_offset.holidays:
        rs.exdate(ex_date)

    return rs.count()


if __name__ == "__main__":
    start = '2015-01-01'
    end = '2015-06-01'
    count = count_business_day(start, end)
    print count