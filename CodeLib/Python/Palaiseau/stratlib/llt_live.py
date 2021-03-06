# -*- coding: utf-8 -*-
import tools
from tools.wind import wind_to_csv
from pyalgotrade.tushare.barfeed import  TuShareLiveFeed
from pyalgotrade.bar import Frequency
from stratlib import gf_llt
import datetime
from tools.date_handler import date_offset
import os
import sys
from tools.data_handler import config_reader


def live_llt_run(is_index,instrument,start_date,end_date,path,alpha,period,slope_long,slope_short,per,use_wind):
    wind_to_csv.wind_to_csv(instrument,start_date,end_date,path,'60')
    if  is_index:
       config_path = tools.get_config_file_path()
       if use_wind:
           code = instrument
       else:
           code = config_reader.getConfig('index',instrument,config_path)
       barfeed =TuShareLiveFeed([code],Frequency.HOUR, path,10000, 0)                           #10000,0为固定参数 不需要修改
       strat =gf_llt.Guangfa_LLT(barfeed,code,alpha,period,slope_long,slope_short,per)
    else:
       barfeed =TuShareLiveFeed([instrument[0:6]],Frequency.HOUR,path, 10000, 0)
       strat = gf_llt.Guangfa_LLT(barfeed,instrument[0:6],alpha,period,slope_long,slope_short,per)
    strat.run()


if __name__ == "__main__":
    path = os.path.abspath(os.path.dirname(sys.argv[0]))
    path = path[0:len(path)-9]
    path += '\\histdata\\min\\5min_data_today_llt.csv'
    date =str(datetime.datetime.now())[0:10]
    use_wind=False
    [alpha, period,slope_long,slope_short ,percentage ]=[0.03,3,2,2,0.08]

    live_llt_run(True,'000016.SH',date_offset.datetime_offset(date,-100,'BD'),date_offset.datetime_offset(date,0,'BD'),path,
                         alpha,period,slope_long,slope_short,percentage,use_wind)
