# coding=utf-8
import calendar
import datetime
import time
from datetime import timedelta

from dateutil import rrule


# 日期推算函数
def minute_offset(start_time, offset, count):
    t = time.strptime(start_time, "%Y-%m-%d %H:%M")
    year, month, day, h, m = t[0:5]
    min_all = offset * count
    min_all *= -1
    day_count = int(min_all / 240)
    if not day_count == 0:
        start_time = datetime_offset(str(year) + '-' + str(month) + '-' + str(day), -1 * day_count, 'BD')
    minute_off = min_all % 240
    rest_minute = get_rest_min_of_day(h, m)
    if rest_minute < minute_off:
        start_time = datetime_offset(start_time, 1, 'BD')
        rest_minute += 240
    minute = rest_minute - minute_off
    if minute <= 120:
        h = 9 + int((minute + 30) / 60)
        m = minute + 30 - (h - 9) * 60
    else:
        h = 13 + int((minute - 120) / 60)
        m = minute % 60
    year = int(start_time[0:4])
    month = int(start_time[5:7])
    day = int(start_time[8:10])
    return str(datetime.datetime(year, month, day, h, m))


def get_rest_min_of_day(hour, minute):
    if hour <= 8 or (hour == 9 and minute < 30):
        print "该时间段不在交易时间，自动修正到上一个交易时间"
        return 0
    elif hour == 12 or (hour == 11 and minute > 30):
        print "该时间段不在交易时间，自动修正到上一个交易时间"
        hour = 11
        minute = 30
    elif hour > 15 or (hour == 15 and minute > 0):
        hour = 15
        minute = 0
        print "该时间段不在交易时间，自动修正到上一个交易时间"
    if hour < 12:
        return (hour - 9) * 60 + (minute - 30)
    else:
        return (hour - 9) * 60 + (minute - 30) - 90


def datetime_offset(start_time, offset, offset_type):
    """
    :param start_time: string, date
    :param offset: int number
    :param offset_type: string BD business day, D day, M month, Y year:
    :return:
    """

    t = time.strptime(start_time, "%Y-%m-%d")
    y, m, d = t[0:3]
    if offset_type == 'M':
        (y, m, t) = get_year_and_month(y, m, offset)
        return str(y) + '-' + str(m) + '-' + str(add_zero(d))
    elif offset_type == 'Y':
        y = y + offset
        return str(y) + '-' + str(m) + '-' + str(d)
    elif offset_type == 'D':
        return str(datetime.date(y, m, d) + timedelta(days=offset))
    elif offset_type == 'BD':
        if offset < 0:
            r = rrule.rrule(rrule.DAILY,
                            byweekday=[rrule.MO, rrule.TU, rrule.WE, rrule.TH, rrule.FR],
                            # count=-2 * offset + 20,
                            dtstart=datetime.date(2004, 12, 31),
                            until=datetime.date(y, m, d))

            rs = rrule.rruleset()
            rs.rrule(r)
            for ex_date in holidays:
                rs.exdate(ex_date)
            if rs[rs.count() - 1] != datetime.datetime(y, m, d):
                return str(rs[rs.count() + offset])[0:10]
            else:
                return str(rs[rs.count() + offset - 1])[0:10]
        elif offset > 0:
            r = rrule.rrule(rrule.DAILY,
                            byweekday=[rrule.MO, rrule.TU, rrule.WE, rrule.TH, rrule.FR],
                            dtstart=datetime.date(y, m, d), count=2 * offset + 20)
            rs = rrule.rruleset()
            rs.rrule(r)
            for ex_date in holidays:
                rs.exdate(ex_date)
            if rs[0] != datetime.datetime(y, m, d):
                return str(rs[offset - 1])[0:10]
            else:
                return str(rs[offset])[0:10]
        elif offset == 0:
            r = rrule.rrule(rrule.DAILY,
                            byweekday=[rrule.MO, rrule.TU, rrule.WE, rrule.TH, rrule.FR],
                            dtstart=datetime.date(y, m, d), count=2 * offset + 20)
            rs = rrule.rruleset()
            rs.rrule(r)
            flag = 0
            for ex_date in holidays:
                if ex_date == rs[0]:
                    flag = 1
            if flag == 1:
                return datetime_offset(datetime_to_string(string_to_date_time(start_time) - datetime.timedelta(-1)), 0,
                                       offset_type)
            else:
                return start_time

        else:
            return start_time


# 得到某年某月的天数
def get_days_of_month(year, month):
    """
    get days of month
    """
    return calendar.monthrange(year, month)[1]


# 加0符合规范
def add_zero(n):
    """
    add 0 before 0-9
    return 01-09
    """
    nabs = abs(int(n))
    if nabs < 10:
        return "0" + str(nabs)
    else:
        return nabs


def get_weekday_of_date(current_date, input_string_format=True):
    if input_string_format:
        d_ = string_to_date_time(current_date)
    else:
        d_ = current_date
    return d_.weekday()


# 返回月底日
def get_month_end_date(current_date, use_BD=True):
    d_ = string_to_date_time(current_date)
    last_day = calendar.monthrange(d_.year, d_.month)[1]
    month_end_dt = datetime.datetime(d_.year, d_.month, last_day)
    month_end = datetime_to_string(month_end_dt)
    if use_BD:
        if get_weekday_of_date(month_end) >= 5 or month_end in holidays:
            month_end = datetime_offset(month_end, -1, 'BD')
    return month_end


def get_month_end_date_list(start_date, end_date, use_BD=True):
    month_end_date_list = []
    i = 0
    month_date = datetime_offset(start_date, i, offset_type='M')
    while month_date < datetime_offset(end_date, 1, offset_type='M'):  # 终止日后推一个月:
        month_end = get_month_end_date(month_date, use_BD)
        month_end_date_list.append(month_end)
        i += 1
        month_date = datetime_offset(start_date, i, offset_type='M')
    return month_end_date_list


# 推算月份
def get_year_and_month(year, mon, n=0):
    """
    get the year,month,days from today
    befor or after n months
    """
    this_year = int(year)
    this_mon = int(mon)
    total_mon = this_mon + n
    if n >= 0:
        if total_mon <= 12:
            days = str(get_days_of_month(this_year, total_mon))
            total_mon = add_zero(total_mon)
            return year, total_mon, days
        else:
            i = total_mon / 12
            j = total_mon % 12
            if j == 0:
                i -= 1
                j = 12
            this_year += i
            days = str(get_days_of_month(this_year, j))
            j = add_zero(j)
            return str(this_year), str(j), days
    else:
        if (total_mon > 0) and (total_mon < 12):
            days = str(get_days_of_month(this_year, total_mon))
            total_mon = add_zero(total_mon)
            return year, total_mon, days
        else:
            i = total_mon / 12
            j = total_mon % 12
            if j == 0:
                i -= 1
                j = 12
            this_year += i
            days = str(get_days_of_month(this_year, j))
            j = add_zero(j)
            return str(this_year), str(j), days


# 把字符串转成datetime
def string_to_date_time(date):
    # def parse_date(date):
    # Sample: 2005-12-30
    # This custom parsing works faster than:
    # datetime.datetime.strptime(date, "%Y-%m-%d")
    year = int(date[0:4])
    month = int(date[5:7])
    day = int(date[8:10])
    ret = datetime.datetime(year, month, day)
    return ret


# 把datetime转成字符串
def datetime_to_string(dt):
    return dt.strftime("%Y-%m-%d")


def get_datetime_diff_in_days(start_date, end_date):
    d1_ = string_to_date_time(start_date)
    d2_ = string_to_date_time(end_date)
    d1 = datetime.datetime(d1_.year, d1_.month, d1_.day)
    d2 = datetime.datetime(d2_.year, d2_.month, d2_.day)
    return d2 - d1


holidays = [
    # NEW YEAR
    datetime.datetime(2005, 1, 1),
    datetime.datetime(2006, 1, 1),
    datetime.datetime(2007, 1, 1),
    datetime.datetime(2008, 1, 1),
    datetime.datetime(2009, 1, 1),
    datetime.datetime(2010, 1, 1),
    datetime.datetime(2011, 1, 1),
    datetime.datetime(2012, 1, 1),
    datetime.datetime(2013, 1, 1),
    datetime.datetime(2014, 1, 1),
    datetime.datetime(2015, 1, 1),
    datetime.datetime(2016, 1, 1),
    datetime.datetime(2005, 1, 3),
    datetime.datetime(2006, 1, 2),
    datetime.datetime(2006, 1, 3),
    datetime.datetime(2007, 1, 2),
    datetime.datetime(2007, 1, 3),
    datetime.datetime(2007, 12, 31),
    datetime.datetime(2009, 1, 2),
    datetime.datetime(2011, 1, 3),
    datetime.datetime(2012, 1, 2),
    datetime.datetime(2012, 1, 3),
    datetime.datetime(2013, 1, 2),
    datetime.datetime(2013, 1, 3),
    datetime.datetime(2015, 1, 2),
    datetime.datetime(2015, 1, 3),
    datetime.datetime(2016, 1, 1),
    # CHINESE NEW YEAR
    datetime.datetime(2005, 2, 7),
    datetime.datetime(2005, 2, 8),
    datetime.datetime(2005, 2, 9),
    datetime.datetime(2005, 2, 10),
    datetime.datetime(2005, 2, 11),
    datetime.datetime(2005, 2, 12),
    datetime.datetime(2005, 2, 13),
    datetime.datetime(2005, 2, 14),
    datetime.datetime(2005, 2, 15),
    datetime.datetime(2006, 1, 26),
    datetime.datetime(2006, 1, 27),
    datetime.datetime(2006, 1, 28),
    datetime.datetime(2006, 1, 29),
    datetime.datetime(2006, 1, 30),
    datetime.datetime(2006, 1, 31),
    datetime.datetime(2006, 2, 1),
    datetime.datetime(2006, 2, 2),
    datetime.datetime(2006, 2, 3),
    datetime.datetime(2007, 2, 17),
    datetime.datetime(2007, 2, 18),
    datetime.datetime(2007, 2, 19),
    datetime.datetime(2007, 2, 20),
    datetime.datetime(2007, 2, 21),
    datetime.datetime(2007, 2, 22),
    datetime.datetime(2007, 2, 23),
    datetime.datetime(2007, 2, 24),
    datetime.datetime(2007, 2, 25),
    datetime.datetime(2008, 2, 6),
    datetime.datetime(2008, 2, 7),
    datetime.datetime(2008, 2, 8),
    datetime.datetime(2008, 2, 9),
    datetime.datetime(2008, 2, 10),
    datetime.datetime(2008, 2, 11),
    datetime.datetime(2008, 2, 12),
    datetime.datetime(2009, 1, 26),
    datetime.datetime(2009, 1, 27),
    datetime.datetime(2009, 1, 28),
    datetime.datetime(2009, 1, 29),
    datetime.datetime(2009, 1, 30),
    datetime.datetime(2010, 1, 15),
    datetime.datetime(2010, 1, 16),
    datetime.datetime(2010, 1, 17),
    datetime.datetime(2010, 1, 18),
    datetime.datetime(2010, 1, 19),
    datetime.datetime(2011, 2, 2),
    datetime.datetime(2011, 2, 3),
    datetime.datetime(2011, 2, 4),
    datetime.datetime(2011, 2, 5),
    datetime.datetime(2011, 2, 6),
    datetime.datetime(2011, 2, 7),
    datetime.datetime(2011, 2, 8),
    datetime.datetime(2012, 2, 23),
    datetime.datetime(2012, 2, 24),
    datetime.datetime(2012, 2, 25),
    datetime.datetime(2012, 2, 26),
    datetime.datetime(2012, 2, 27),
    datetime.datetime(2012, 2, 28),
    datetime.datetime(2013, 2, 11),
    datetime.datetime(2013, 2, 12),
    datetime.datetime(2013, 2, 13),
    datetime.datetime(2013, 2, 14),
    datetime.datetime(2013, 2, 15),
    datetime.datetime(2014, 1, 31),
    datetime.datetime(2014, 2, 1),
    datetime.datetime(2014, 2, 2),
    datetime.datetime(2014, 2, 3),
    datetime.datetime(2014, 2, 4),
    datetime.datetime(2014, 2, 5),
    datetime.datetime(2014, 2, 6),
    datetime.datetime(2015, 2, 18),
    datetime.datetime(2015, 2, 19),
    datetime.datetime(2015, 2, 20),
    datetime.datetime(2015, 2, 21),
    datetime.datetime(2015, 2, 22),
    datetime.datetime(2015, 2, 23),
    datetime.datetime(2015, 2, 24),
    datetime.datetime(2016, 2, 7),
    datetime.datetime(2016, 2, 8),
    datetime.datetime(2016, 2, 9),
    datetime.datetime(2016, 2, 10),
    datetime.datetime(2016, 2, 11),
    datetime.datetime(2016, 2, 12),
    datetime.datetime(2016, 2, 13),
    # CHING MING FESTIVAL
    datetime.datetime(2008, 4, 4),
    datetime.datetime(2009, 4, 6),
    datetime.datetime(2010, 4, 5),
    datetime.datetime(2011, 4, 3),
    datetime.datetime(2011, 4, 4),
    datetime.datetime(2011, 4, 5),
    datetime.datetime(2012, 4, 2),
    datetime.datetime(2012, 4, 3),
    datetime.datetime(2012, 4, 4),
    datetime.datetime(2013, 4, 4),
    datetime.datetime(2013, 4, 5),
    datetime.datetime(2014, 4, 7),
    datetime.datetime(2015, 4, 5),
    datetime.datetime(2015, 4, 6),
    datetime.datetime(2016, 4, 4),
    # LABOR DAY
    datetime.datetime(2005, 5, 1),
    datetime.datetime(2005, 5, 2),
    datetime.datetime(2005, 5, 3),
    datetime.datetime(2005, 5, 4),
    datetime.datetime(2005, 5, 5),
    datetime.datetime(2005, 5, 6),
    datetime.datetime(2005, 5, 7),
    datetime.datetime(2006, 5, 1),
    datetime.datetime(2006, 5, 2),
    datetime.datetime(2006, 5, 3),
    datetime.datetime(2006, 5, 4),
    datetime.datetime(2006, 5, 5),
    datetime.datetime(2006, 5, 6),
    datetime.datetime(2006, 5, 7),
    datetime.datetime(2007, 5, 1),
    datetime.datetime(2007, 5, 2),
    datetime.datetime(2007, 5, 3),
    datetime.datetime(2007, 5, 4),
    datetime.datetime(2007, 5, 5),
    datetime.datetime(2007, 5, 6),
    datetime.datetime(2007, 5, 7),
    datetime.datetime(2008, 5, 1),
    datetime.datetime(2008, 5, 2),
    datetime.datetime(2009, 5, 1),
    datetime.datetime(2010, 5, 3),
    datetime.datetime(2011, 5, 2),
    datetime.datetime(2012, 4, 30),
    datetime.datetime(2012, 5, 1),
    datetime.datetime(2013, 4, 29),
    datetime.datetime(2013, 4, 30),
    datetime.datetime(2013, 5, 1),
    datetime.datetime(2014, 5, 1),
    datetime.datetime(2014, 5, 2),
    datetime.datetime(2014, 5, 3),
    datetime.datetime(2015, 5, 1),
    datetime.datetime(2016, 5, 2),
    # TUEN NG FESTIVAL
    datetime.datetime(2008, 6, 9),
    datetime.datetime(2009, 5, 28),
    datetime.datetime(2009, 5, 29),
    datetime.datetime(2010, 6, 14),
    datetime.datetime(2010, 6, 15),
    datetime.datetime(2010, 6, 16),
    datetime.datetime(2011, 6, 4),
    datetime.datetime(2011, 6, 5),
    datetime.datetime(2011, 6, 6),
    datetime.datetime(2012, 6, 22),
    datetime.datetime(2012, 6, 23),
    datetime.datetime(2012, 6, 24),
    datetime.datetime(2013, 6, 10),
    datetime.datetime(2013, 6, 11),
    datetime.datetime(2013, 6, 12),
    datetime.datetime(2014, 6, 2),
    datetime.datetime(2015, 6, 22),
    datetime.datetime(2016, 6, 9),
    datetime.datetime(2016, 6, 10),
    datetime.datetime(2016, 6, 11),
    # MID-AUTUMN FESTIVAL
    datetime.datetime(2008, 9, 15),
    datetime.datetime(2010, 9, 22),
    datetime.datetime(2010, 9, 23),
    datetime.datetime(2010, 9, 24),
    datetime.datetime(2011, 9, 10),
    datetime.datetime(2011, 9, 11),
    datetime.datetime(2011, 9, 12),
    datetime.datetime(2012, 9, 30),
    datetime.datetime(2013, 9, 19),
    datetime.datetime(2013, 9, 20),
    datetime.datetime(2014, 9, 8),
    datetime.datetime(2015, 9, 27),
    datetime.datetime(2016, 9, 15),
    datetime.datetime(2016, 9, 16),
    datetime.datetime(2016, 9, 17),
    # NATIONAL DAY
    datetime.datetime(2005, 10, 1),
    datetime.datetime(2005, 10, 2),
    datetime.datetime(2005, 10, 3),
    datetime.datetime(2005, 10, 4),
    datetime.datetime(2005, 10, 5),
    datetime.datetime(2005, 10, 6),
    datetime.datetime(2005, 10, 7),
    datetime.datetime(2006, 10, 1),
    datetime.datetime(2006, 10, 2),
    datetime.datetime(2006, 10, 3),
    datetime.datetime(2006, 10, 4),
    datetime.datetime(2006, 10, 5),
    datetime.datetime(2006, 10, 6),
    datetime.datetime(2006, 10, 7),
    datetime.datetime(2007, 10, 1),
    datetime.datetime(2007, 10, 2),
    datetime.datetime(2007, 10, 3),
    datetime.datetime(2007, 10, 4),
    datetime.datetime(2007, 10, 5),
    datetime.datetime(2007, 10, 6),
    datetime.datetime(2007, 10, 7),
    datetime.datetime(2008, 9, 29),
    datetime.datetime(2008, 9, 30),
    datetime.datetime(2008, 10, 1),
    datetime.datetime(2008, 10, 2),
    datetime.datetime(2008, 10, 3),
    datetime.datetime(2009, 10, 1),
    datetime.datetime(2009, 10, 2),
    datetime.datetime(2009, 10, 3),
    datetime.datetime(2009, 10, 4),
    datetime.datetime(2009, 10, 5),
    datetime.datetime(2009, 10, 6),
    datetime.datetime(2009, 10, 7),
    datetime.datetime(2009, 10, 8),
    datetime.datetime(2010, 10, 1),
    datetime.datetime(2010, 10, 2),
    datetime.datetime(2010, 10, 3),
    datetime.datetime(2010, 10, 4),
    datetime.datetime(2010, 10, 5),
    datetime.datetime(2010, 10, 6),
    datetime.datetime(2010, 10, 7),
    datetime.datetime(2011, 10, 1),
    datetime.datetime(2011, 10, 2),
    datetime.datetime(2011, 10, 3),
    datetime.datetime(2011, 10, 4),
    datetime.datetime(2011, 10, 5),
    datetime.datetime(2011, 10, 6),
    datetime.datetime(2011, 10, 7),
    datetime.datetime(2012, 10, 1),
    datetime.datetime(2012, 10, 2),
    datetime.datetime(2012, 10, 3),
    datetime.datetime(2012, 10, 4),
    datetime.datetime(2012, 10, 5),
    datetime.datetime(2012, 10, 6),
    datetime.datetime(2012, 10, 7),
    datetime.datetime(2013, 10, 1),
    datetime.datetime(2013, 10, 2),
    datetime.datetime(2013, 10, 3),
    datetime.datetime(2013, 10, 4),
    datetime.datetime(2013, 10, 5),
    datetime.datetime(2013, 10, 6),
    datetime.datetime(2013, 10, 7),
    datetime.datetime(2014, 10, 1),
    datetime.datetime(2014, 10, 2),
    datetime.datetime(2014, 10, 3),
    datetime.datetime(2014, 10, 4),
    datetime.datetime(2014, 10, 5),
    datetime.datetime(2014, 10, 6),
    datetime.datetime(2014, 10, 7),
    datetime.datetime(2015, 10, 1),
    datetime.datetime(2015, 10, 2),
    datetime.datetime(2015, 10, 3),
    datetime.datetime(2015, 10, 4),
    datetime.datetime(2015, 10, 5),
    datetime.datetime(2015, 10, 6),
    datetime.datetime(2015, 10, 7),
    datetime.datetime(2016, 10, 1),
    datetime.datetime(2016, 10, 2),
    datetime.datetime(2016, 10, 3),
    datetime.datetime(2016, 10, 4),
    datetime.datetime(2016, 10, 5),
    datetime.datetime(2016, 10, 6),
    datetime.datetime(2016, 10, 7),
    # 70TH ANNIVERSARY OF THE VICTORY OF ANTI-JAPANESES WAR
    datetime.datetime(2015, 9, 3),
    datetime.datetime(2015, 9, 4),
]

if __name__ == "__main__":
    print minute_offset('2015-05-07 15:00', -100, 5)

    print get_month_end_date_list('2016-01-01', '2016-06-01')
