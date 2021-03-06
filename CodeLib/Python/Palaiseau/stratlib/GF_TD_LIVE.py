# -*- coding: utf-8 -*-
import tools
from tools.wind import wind_to_csv
from pyalgotrade.tushare.barfeed import TuShareLiveFeed
from pyalgotrade.bar import Frequency
from stratlib import gftd_cta
import datetime
from tools.date_handler import date_offset
import os
import sys
from tools.data_handler import config_reader


def live_gftd_run(is_index, instrument, start_date, end_date, path, n1, n2_s, n3_s, n2_b, n3_b, use_wind=False,
                  is_stop_loss=False, show_count=False):
    wind_to_csv.wind_to_csv(instrument, start_date, end_date, path)
    if is_index:
        config_path = tools.get_config_file_path()
        if use_wind:
            code = instrument
        else:
            code = config_reader.getConfig('index', instrument, config_path)
        barfeed = TuShareLiveFeed([code], Frequency.MINUTE_FIVE, path, 10000, 0, use_wind)  # 10000,0为固定参数 不需要修改
        strat = gftd_cta.GuangFa_TD_GAI(barfeed, code, n1, n2_s, n3_s, n2_b, n3_b, True, is_stop_loss, show_count)
    else:
        barfeed = TuShareLiveFeed([instrument[0:6]], Frequency.MINUTE_FIVE, path, 10000, 0)
        strat = gftd_cta.GuangFa_TD_GAI(barfeed, instrument[0:6], n1, n2_s, n3_s, n2_b, n3_b, True, is_stop_loss,
                                        show_count)
    strat.run()


if __name__ == "__main__":
    path = os.path.abspath(os.path.dirname(sys.argv[0]))
    path = path[0:len(path) - 9]
    path += '\\histdata\\min\\5min_data_today.csv'
    date = str(datetime.datetime.now())[0:10]
    use_CTA = False
    use_wind = True
    is_stop_loss = False
    show_count = True
    if use_CTA:
        [n1, n2_s, n3_s, n2_b, n3_b] = [5, 3, 8, 2, 5]
    else:
        # out sample params in Q1 2016
        [n1, n2_s, n3_s, n2_b, n3_b] = [5, 3, 8, 2, 5]
        # out sample params in 2016.3.21--2016.4.26
        # [n1,n2_s,n3_s,n2_b,n3_b]=[3,9,2,5,5]
        # out sample params in 2016.1--2016.4
        # [n1,n2_s,n3_s,n2_b,n3_b] = [2,2,4,2,8]

    live_gftd_run(True, '000905.SH', date_offset.datetime_offset(date, -22, 'BD'),
                  date_offset.datetime_offset(date, 0, 'BD'), path,
                  n1, n2_s, n3_s, n2_b, n3_b, use_wind, is_stop_loss, show_count)
