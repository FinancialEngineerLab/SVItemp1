import datetime

ic_future_clearing_date_list = [
    datetime.datetime.strptime('2015-5-15 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-6-19 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-7-17 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-8-21 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-9-18 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-10-16 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-11-20 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2015-12-18 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2016-1-15 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2016-2-19 14:50','%Y-%m-%d %H:%M'),
    datetime.datetime.strptime('2016-3-18 14:50','%Y-%m-%d %H:%M')
]


def get_ic_contract_clearing_date():
    clearing_date = []
    for i in ic_future_clearing_date_list:
        clearing_date.append(i)
    return clearing_date
