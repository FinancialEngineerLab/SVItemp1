from WindPy import  *
import pandas
from tools.data_handler import data_utils
import numpy


def get_hist_price_from_wind(sec_code, start_date, end_date, price_type='close', output_type = 'pandas',
                               bar_size = None):
    w.start()
    if bar_size is None:
        wd = w.wsd(sec_code, price_type, start_date, end_date,'Fill = Previous') # daily data
    else:
        wd = w.wsi(sec_code, price_type, start_date+" 09:30:00", end_date+" 15:01:00","BarSize="+bar_size)

    if output_type == 'pandas':
        index_time = pandas.to_datetime(wd.Times)
        wd_data_transpose = numpy.transpose(wd.Data)
        price_type_header = price_type.split(',')
        pd_price_data = pandas.DataFrame(wd_data_transpose, index = index_time, columns= price_type_header)
        pd_price_data.index.name = 'tradeDate'
        return pd_price_data
    else:
        raise Exception('Not Implemented Error')


def get_hist_returns_from_wind(sec_code, start, end, price_type='close', return_type = 'log_return', output_type = 'pandas'):
    df_price_data = get_hist_price_from_wind(sec_code, start, end, price_type = price_type)
    df_price_data_sorted = df_price_data.sort_index()
    return_list = data_utils.get_hist_returns(df_price_data_sorted,return_type)
    if output_type == 'pandas':
        pd_return_data = pandas.Series(data = return_list, index = df_price_data_sorted.index[1:])
        pd_return_data.index = pandas.to_datetime(pd_return_data.index)
        return pd_return_data
    else:
        return return_list


if __name__ == "__main__":
    sec_code = '000300.SH'
    start = '2014-01-15'
    end = '2015-12-31'
    price_type = 'open,high,low,close'
    pd_return_data = get_hist_price_from_wind(sec_code,start, end, price_type)

