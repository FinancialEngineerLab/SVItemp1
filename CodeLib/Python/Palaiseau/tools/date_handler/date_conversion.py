import datetime
import pandas as pd

def change_tuple_format_to_datetime(date_series):
    temp = []
    for j in range(0,len(date_series)):
        temp.append(datetime.datetime(date_series[j][0],date_series[j][1],date_series[j][2]))
    return temp

def get_utc_timestamp(dt):
    """
    returns the Timestamp/DatetimeIndex
    with either localized or converted to UTC.
    Parameters
    ----------
    dt : Timestamp/DatetimeIndex
        the date(s) to be converted
    Returns
    -------
    same type as input
        date(s) converted to UTC
    """
    dt = pd.to_datetime(dt)
    try:
        dt = dt.tz_localize('UTC')
    except TypeError:
        dt = dt.tz_convert('UTC')
    return dt
