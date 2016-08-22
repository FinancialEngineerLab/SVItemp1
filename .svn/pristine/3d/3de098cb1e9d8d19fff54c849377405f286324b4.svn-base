# -*- coding: utf-8 -*-

from tools.math.lppl.lppl_calib_ga import lppl_calib_ga as lppl_calib_ga
from tools.math.lppl.lppl_calib_ga import getCleanDataForLPPL as getCleanDataForLPPL
from tools.math.lppl.lppl_calib_exhaustion import lppl_calib_exhaustion as lppl_calib_exhaustion
from tools.math.lppl.lppl_plot import plotLPPLSimulationResult as plotLPPLSimulationResult
from pyalgotrade.tushare import data_from_tushare


def lppl_calib_main(data_series, start_date=None, limits=None, size=20, mate=1.5, probmutate=0.05, vsize=4,
                    mutatetimes=2, best_solution=3, frequency=None, random_seed_population=None,
                    random_seed_individual=None,
                    t_c=[0, 100, 1], m=[0.1, 0.9, 0.1], phi=[6, 13, 0.5], flag=0):
    """
    :param best_solution: 设置返回最优解的数目
    :param data_series: 收盘价数据
    :param start_date: 开始日期
    :param limits: 参数区间
    :param size: 模拟次数
    :param mate: mate变化幅度
    :param probmutate: 发生mutate概率
    :param vsize: vsize
    :param mutatetimes: mutate次数
    :param frequency: 分钟数据频率
    :param random_seed_population: random seed for population
    :param random_seed_individual: random seed for individual
    :param t_c: t_c Max Min Step
    :param m: m Max Min Step
    :param phi: Phi Max Min Step
    :param flag: 拟合方法 0： 7个参数GA算法拟合  1： 穷举法  2：3个参数GA算法拟合
    """

    result = None
    '''遗传算法'''
    if flag == 0 or flag == 1:
        result = lppl_calib_ga(data_series=data_series, start=start_date, limits=limits, size=size, mate=mate,
                               probmutate=probmutate, vsize=vsize, mutatetimes=mutatetimes, best_solution=best_solution,
                               frequency=frequency,
                               random_seed_population=random_seed_population,
                               random_seed_individual=random_seed_individual, calib_type=flag)

    '''穷举法计算LPPL拟合结果，速度很慢，应尽量避免使用'''
    if flag == 2:
        result = lppl_calib_exhaustion(data_series=data_series, t_c=t_c, m=m, phi=phi)

    if result is not None:
        plotLPPLSimulationResult(df_data_from_tushare, result, start)

    return result


if __name__ == "__main__":
    """日线数据，取自tushare"""
    sec_code = 'hs300'
    start = '2014-01-01'
    end = '2015-06-01'
    ktype = 'D'
    price_type = 'close'
    df_data_from_tushare = data_from_tushare.get_kdata_from_tushare(sec_code, start, end, ktype, price_type=None)
    df_data = getCleanDataForLPPL(df_data_from_tushare)
    values = lppl_calib_main(df_data, start, flag=1)

    """分钟数据，取自wind
    sec_code = '000300.SH'
    start = '2016-01-29 09:00:00'
    end = '2016-03-17 15:00:00'
    price_type = 'open,high,low,close'
    bar_size = '5'
    w.start()
    wd_data_from_wind = w.wsi(sec_code, price_type, start, end, "BarSize=" + bar_size)
    nar_rank = np.array(range(len(wd_data_from_wind.Data[3])))
    ser_data = Series(log(wd_data_from_wind.Data[3]), wd_data_from_wind.Times)
    df_data = list((nar_rank, ser_data))
    # value = calib_lppl(df_data, start, frequency=int(bar_size))
    # plotLPPLSimulationResultMin(wd_data_from_wind, value)"""
