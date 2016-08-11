# -*- coding: utf-8 -*-

from pylab import *
from pyalgotrade.tushare import data_from_tushare
import tools.date_handler.date_offset as dtoffset
import matplotlib.pyplot as plt
from datetime import *
from tools.date_handler.date_offset import datetime_offset
from lppl_calib_ga import getCleanDataForLPPL as getCleanDataForLPPL
from lppl_calib_ga import lppl_calib_ga as lppl_calib_ga
from lppl_calib_exhaustion import lppl_calib_exhaustion
def crash_lockin(offsetfrom,offsetto, end, sec_code, ktype, time_steps=2,use_ga=True):

    start_datetime = datetime_offset(end,-1*offsetfrom,'BD')
    start_datetime = datetime.strptime(start_datetime, "%Y-%m-%d")
    values = []
    start_date_list = []
    nb_iteration = (offsetfrom-offsetto)/time_steps
    for i in range(nb_iteration):
        start_date = datetime_offset(str(start_datetime.date()), time_steps * i, 'BD')
        print start_date,end
        df_data_from_tushare_CLIP = data_from_tushare.get_kdata_from_tushare(sec_code, start_date, end, ktype,
                                                                             price_type=None)
        df_data = getCleanDataForLPPL(df_data_from_tushare_CLIP)
        if use_ga:
          values.append(lppl_calib_ga(df_data, start_datetime))
        else:
          values.append(lppl_calib_exhaustion(df_data, t_c=[0,0.2, 2],m=[0.1,2,0.2],phi=[1,50,2]))
        start_date_list.append(start_date)
    return values, start_date_list


def crash_lockin_plot(start_date_list, values):
    fit_series_1 = []
    fit_series_2 = []
    fit_series_3 = []

    for i in values:
        fit_series_1.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(i[0].cof[2]), "BD").encode("utf-8"), "%Y-%m-%d"))
        fit_series_2.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(i[1].cof[2]), "BD").encode("utf-8"), "%Y-%m-%d"))
        fit_series_3.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(i[2].cof[2]), "BD").encode("utf-8"), "%Y-%m-%d"))

    ax = subplot(1,1,1)
    ax.set_ylabel('Tc Date')
    ax.set_xlabel('End Date')

    plt.plot(start_date_list, fit_series_1, label='Fit 1')
    plt.plot(start_date_list, fit_series_2, label='Fit 2')
    plt.plot(start_date_list, fit_series_3, label='Fit 3')

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(handles, labels)
    show()


if __name__ == "__main__":
    sec_code = 'hs300'
    start = '2014-05-01'
    end = '2015-06-01'
    ktype = 'D'
    price_type = 'close'
    CLIP, start_date_list = crash_lockin(start, end, sec_code, ktype, nb_iteration=10)
    crash_lockin_plot(start_date_list, CLIP)
