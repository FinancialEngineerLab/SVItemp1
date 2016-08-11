# coding=utf-8
import tushare
from tools.date_handler import date_offset


def get_kdata_from_tushare(sec_code, start, end, ktype='D', retry_count=3, pause=0, price_type=None):
    """
    :param sec_code:股票代码，即6位数字代码，或者指数代码（sh=上证指数 sz=深圳成指 hs300=沪深300指数 sz50=上证50 zxb=中小板 cyb=创业板）
    :param start: 开始日期，格式YYYY-MM-DD,默认'1994-01-01'
    :param end: 结束日期，格式YYYY-MM-DD，默认取当前日期
    :param autype: string,复权类型，qfq-前复权 hfq-后复权 None-不复权，默认为qfq
    :param ktype: 数据类型，D=日k线 W=周 M=月 5=5分钟 15=15分钟 30=30分钟 60=60分钟，默认为D
    :param retry_count:当网络异常后重试次数，默认为3
    :param pause: 重试时停顿秒数，默认为0
    :param price_type: 'open' 'high' 'low' 'close'
    :return: 股票的k线数据（只能最近三年）
    """
    time_length = date_offset.get_datetime_diff_in_days(start, end).days
    if time_length > 3 * 365:
        print "只能提取最近三年的数据"
        print "调整开始日期至" + date_offset.datetime_offset(end, -3, "Y")

    df_data = tushare.get_hist_data(sec_code, start=start, end=end, ktype=ktype, retry_count=retry_count, pause=pause)

    if price_type is not None:
        for headers in df_data.columns:
            if not headers == price_type:
                df_data.drop([headers], inplace=True, axis=1)

    return df_data


def save_tushare_kdata_to_csv(sec_code, start, end, ktype='D',
                              path='D:/Workarea/Beiwaitan/CodeLib/Python/Palaiseau/histdata/day/'):
    df = get_kdata_from_tushare(sec_code, start, end, ktype)
    df.to_csv(path + sec_code + '.csv')


if __name__ == "__main__":
    save_tushare_kdata_to_csv('000905', '2014-01-01', '2016-02-05')
