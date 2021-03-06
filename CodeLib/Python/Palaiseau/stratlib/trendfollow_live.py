# -*- coding: utf-8 -*-
import tools
from tools.wind import wind_to_csv
from pyalgotrade.tushare.barfeed import  TuShareLiveFeed
from pyalgotrade.bar import Frequency
from stratlib import trendfollow_quantopian
import datetime
from tools.date_handler import date_offset
import os
import sys
from tools.data_handler import config_reader


def live_trendfollow_run(is_index,instrument,start_date,end_date,path,lookback_periods, profit_take_std, slope_min_positive, slope_min_negative = None,maxdrawdown = 1.01,use_wind=False):
    wind_to_csv.wind_to_csv(instrument,start_date,end_date,path)
    if  is_index:
       config_path = tools.get_config_file_path()
       if use_wind:
           code = instrument
       else:
           code = config_reader.getConfig('index',instrument,config_path)
       barfeed =TuShareLiveFeed([code],Frequency.MINUTE_FIVE, path,10000, 0,use_wind)             #10000,0为固定参数 不需要修改
       strat = trendfollow_quantopian.TrendFollow(barfeed,code,lookback_periods,profit_take_std,slope_min_positive,slope_min_negative,maxdrawdown)
    else:
       barfeed =TuShareLiveFeed([instrument[0:6]],Frequency.MINUTE_FIVE,path, 10000, 0)
       strat = trendfollow_quantopian.TrendFollow(barfeed,instrument[0:6],lookback_periods,profit_take_std,slope_min_positive,slope_min_negative,maxdrawdown)
    strat.run()


if __name__ == "__main__":
    path = os.path.abspath(os.path.dirname(sys.argv[0]))
    path = path[0:len(path)-9]
    path += '\\histdata\\min\\5min_data_today.csv'
    date =str(datetime.datetime.now())[0:10]
    use_CTA = False
    use_wind =True
    stage = 0
    if use_CTA:
        [lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[37,3,1,-4,0.06]
    else:
        # out sample params in Q1 2016
         #[lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[37,3,1,-3,0.06]
        if stage ==0:           #15年回测数据
           [lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[37,3,0,0,0.06]
        elif stage == 1:        #2014.6.1到2014.6.15牛市回测数据
            [lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[40,3,0,-4,0.06]
        elif stage == 2:        #2015.6.16到2015.9.14熊市回测数据
            [lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[37,3,4,0,0.06]
        elif stage == 3:        #2015.9.15到2016.4.25震荡市回测数据
            [lookback_periods, profit_take_std,slope_min_positive,slope_min_negative ,maxdrawdown ]=[30,3,2,0,0.06]


    live_trendfollow_run(True,'000905.SH',date_offset.datetime_offset(date,-22,'BD'),date_offset.datetime_offset(date,0,'BD'),path,
                         lookback_periods,profit_take_std,slope_min_positive,slope_min_negative,maxdrawdown,use_wind)



