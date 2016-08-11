import time
import tushare as ts
import pandas as pd
import string
from datetime import datetime
import ctypes

# 18 stocks
watch_list_quanshang =['000166','000750','000776','000783','002500','002673','002736','600030','600109','600369',
                             '600837','600958','600999','601211','601688','601788','601901']


def get_real_time_return_from_tushare(sec_codes):
    col_names = ['time','name', 'code','return']
    df = pd.DataFrame(columns = col_names)
    for sec_code in sec_codes:
        try:
            df_single_quote = ts.get_realtime_quotes(sec_code)
            time = df_single_quote.iat[0,-2]
            name = df_single_quote.iat[0,0]
            code = df_single_quote.iat[0,-1]
            preclose = df_single_quote.iat[0,1]
            current_price = df_single_quote.iat[0,3]
            stock_return = string.atof(current_price)/string.atof(preclose)-1
            df_single_quote_filtered = pd.Series([time, name, code, stock_return],index = col_names)
            df = df.append(df_single_quote_filtered, ignore_index=True)
        except Exception, e:
            print 'Unhandled exception'
            print e
    return df



if __name__ == "__main__":

    secondsToWait = 20
    while 1:
        current_time = datetime.now()
        if 9.5 < current_time.hour < 11.5 or 13 < current_time.hour < 15.5:
            df_quote = get_real_time_return_from_tushare(watch_list_quanshang)
            stock_highlight = df_quote[df_quote['return'] > 0.01]
            if stock_highlight.count > 3:
                print 'warning!'
            time.sleep(secondsToWait)
        else:
            break


