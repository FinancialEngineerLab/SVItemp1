# -*- coding: utf-8 -*-

import lppl_calib_main
from pylab import *
import crash_lockin_plot
from tools.data_handler import data_utils
from tools.date_handler import date_count
from pyalgotrade.tushare import data_from_tushare
import tools.date_handler.date_offset as dtoffset
import matplotlib.pyplot as plt
from datetime import *
from tools.date_handler.date_offset import datetime_offset

inf = 2000.0
m_bound = [0.01, 0.99]
w_bound = [2,25]
tc_bound = [-0.05,0.1]
osci_bound = [2.5, inf]
damp_bound = [1, inf]
relative_err_bound = [0, 0.2]


def is_lppl_calib_result_within_bound(b, tc,m,c, w, start_date, end_date):
    ret = True
    length_period = date_count.count_business_day(start_date, end_date)
    end_low = datetime.strptime(dtoffset.datetime_offset(end_date,int(tc_bound[0]*length_period),'BD'),'%Y-%m-%d')
    end_high = datetime.strptime(dtoffset.datetime_offset(end_date,int(tc_bound[1]*length_period),'BD'),'%Y-%m-%d')
    tc_time = datetime.strptime(dtoffset.datetime_offset(start_date,int(tc),'BD'),'%Y-%m-%d')
    damp = m/w * abs(b/c)
    if not data_utils.is_within_bound(m_bound, m):
        ret = False
        return ret

    if not data_utils.is_within_bound(w_bound, w):
        ret = False
        return ret


    if tc_time>end_high or tc_time<end_low:
        ret = False
        return ret



    if not data_utils.is_within_bound(damp_bound, damp):
        ret = False
        return ret

    return ret


def is_lppl_relative_err_within_bound(sum_residuals):
   if data_utils.is_within_bound(relative_err_bound, sum_residuals):
        return True
   else:
        return False

def lppl_conf(offsetfrom,offsetto, end, sec_code, ktype, time_steps=2,use_ga=False):
    values, start_date_list= crash_lockin_plot.crash_lockin(offsetfrom, offsetto,end, sec_code, ktype, time_steps,use_ga=use_ga)
    nb_calib = len(values)
    count = 0

    if use_ga:
       for i in range(0,nb_calib):
        # check if the coeff is within bound
          start = datetime_offset(end,-1*offsetfrom+i*time_steps,'BD')
          ret = is_lppl_calib_result_within_bound(values[i][0].cof[1], values[i][0].cof[2], values[i][0].cof[3], values[i][0].cof[4], values[i][0].cof[5], start, end)
          if ret:
             count += 1
       return end,count,nb_calib
    else:
        for i in range(0,nb_calib):
          # check if the coeff is within bound
          start = datetime_offset(end,-1*offsetfrom+i*time_steps,'BD')
          ret = is_lppl_calib_result_within_bound(values[i].cof[1], values[i].cof[2], values[i].cof[3], values[i].cof[4], values[i].cof[5], start, end)
          if ret:
             count += 1
        return end,count,nb_calib

def run(start_date):
    for i in range(0,40):
        print lppl_conf(250,150,start_date,'hs300','D',time_steps=2)
        start_date = datetime_offset(start_date,6,'BD')
    return






if __name__ == '__main__':
    run('2015-06-19')
    #print lppl_conf(250,150,'2015-01-14','hs300','D',time_steps=2)


