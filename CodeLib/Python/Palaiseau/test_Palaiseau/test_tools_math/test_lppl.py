from tools.math.lppl.lppl_calib_ga import lppl_calib_ga
import testcases.common
import numpy as np
import pandas as pd
import datetime


class TestCase(testcases.common.TestCase):
    def testBacktestingLpplCalibGA(self):
        '''sec_code = 'hs300'
        start = '2014-01-01'
        end = '2015-06-01'
        ktype = 'D'
        df_data_from_tushare = data_from_tushare.get_kdata_from_tushare(sec_code, start, end, ktype, price_type=None)
        df_data = getCleanDataForLPPL(df_data_from_tushare)'''
        start = '2014-01-01'
        path = "..//data//000300SH.csv"
        csvfile = open(path, 'r')
        price_data = []
        date_data = []
        i = 0
        for line in csvfile:
            if list(line.strip().split(','))[4] != 'Close' and i < 50:
                price_data.append((float)(list(line.strip().split(','))[4]))
                date_data.append(unicode(
                    str(datetime.datetime.strptime((str(list(line.strip().split(','))[0]))[:-5], '%Y/%m/%d'))[0:10]))
                i += 1
        price_data = np.array(price_data)
        price_data = np.log(price_data)
        time = np.linspace(0, 49, 50)
        df_data = pd.Series(data=price_data, index=date_data, name='close')
        df_data.index.name = 'date'
        df_data = [time, df_data]
        fitness_avg = 0
        for i in range(20):
            values = lppl_calib_ga(df_data, start)
            fitness_avg += values[0].fit / 20
        assert (0.000165 >= fitness_avg >= 0.000150)
