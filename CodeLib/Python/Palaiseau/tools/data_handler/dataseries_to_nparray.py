# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
from tools.date_handler import date_conversion

def change_data_series_to_np_array(data, time_series = None):
    i = 0
    result = []
    date_time = data.getDateTimes()  # 返回dateTime格式
    while i<len(data):
        if time_series is None:
            if date_time[1] is None:
                result.append([i, data.__getitem__(i)])   # 如果没有自带时间序列
            else:
                result.append([date_time[i], data.__getitem__(i)]) #只找到该方法,挨个取出,若试用str格式, strftime('%Y-%m-%d')
        else:
            if type(time_series) == np.ndarray:
                result.append([time_series[i][0], data.__getitem__(i)]) # 时间为 datetime 64格式
            else:
                result.append([time_series[i], data.__getitem__(i)])
        i += 1
    return np.array(result).reshape((len(result), 2))


def change_data_series_to_pd_series(data, time_series = None, use_new_version = True):
    if use_new_version:
        ret = pd.Series(data.getValues(), index = time_series)
    else:
        ret_np_array = change_data_series_to_np_array(data, time_series)
        ret = pd.Series(ret_np_array[:,1], index = ret_np_array[:,0] )
    return ret

def change_pd_series_to_np_array(data):
    result = []
    i = 0
    while i < len(data):
        result.append(data.iloc[i])
        i += 1
    return np.array(result)

def change_np_array_to_pd_series(data):
    ret = pd.Series(data[:,1],index=data[:,0])
    return  ret