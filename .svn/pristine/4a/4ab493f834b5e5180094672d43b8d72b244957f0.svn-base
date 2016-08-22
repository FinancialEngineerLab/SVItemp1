from pyalgotrade.tushare import data_from_tushare
import pandas
from tools.data_handler import data_utils


def get_hist_returns_from_tushare(sec_code, start, end, ktype, price_type='close', return_type = 'log_return', output_type = 'pandas'):
    df_price_data = data_from_tushare.get_kdata_from_tushare(sec_code, start, end, ktype, price_type = price_type)
    df_price_data_sorted = df_price_data.sort_index()
    return_list = data_utils.get_hist_returns(df_price_data_sorted,return_type)
    if output_type == 'pandas':
        pd_return_data = pandas.Series(data = return_list, index = df_price_data_sorted.index[1:])
        pd_return_data.index = pandas.to_datetime(pd_return_data.index)
        return pd_return_data
    else:
        return return_list

if __name__ == "__main__":
    sec_code = '510050.SH'
    start = '2015-01-01'
    end = '2015-02-01'
    price_type = 'close'
    pd_return_data = get_hist_returns_from_tushare(sec_code,start, end, price_type)
