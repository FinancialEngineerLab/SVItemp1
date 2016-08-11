# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rc
rc('mathtext', default='regular')
import seaborn as sns
sns.set_style('white')
from tools.wind import get_data
from pylab import mpl
mpl.rcParams['font.sans-serif'] = ['SimHei'] #指定默认字体
mpl.rcParams['axes.unicode_minus'] = False #解决保存图像是负号'-'显示为方块的问题
import time


def get_s_factor(sec_code, start_date, end_date):
    bar_data = get_data.get_hist_price_from_wind(sec_code, start_date, end_date, price_type='close,volume', bar_size='5')
    bar_data['return'] = bar_data['close'].pct_change()
    # 成交量除以一万，方便画图
    bar_data['smartS'] = np.abs(bar_data['return'])/np.sqrt(bar_data['volume'])*10000
    bar_data['volume'] /= 100000
    bar_data = bar_data.tail(30)
    bar_data['barNo'] = np.arange(1, len(bar_data)+1)
    bar_data['volTimesPrice'] = bar_data['close'] * bar_data['volume']
    bar_data.index = np.arange(len(bar_data))

    return bar_data

def plot_s_factor(bar_data):
    fig = plt.figure(figsize=(14,10))
    fig.set_tight_layout(True)
    # --------------图1： 某一时间段内成交量和 S 因子的分钟线展示--------------
    ax1 = fig.add_subplot(2,1,1)
    ax1.bar(bar_data.index, bar_data['volume'], align = 'center', width = 0.4)
    ax1.set_xlabel(u'样本分钟线序号', fontsize = 16)
    ax1.set_ylabel(u'成交量(万)', fontsize = 16)
    ax1.set_title(u'蓝色柱子(左轴)为成交量， 红色圆点(右轴)为 S 因子', fontsize = 16)
    plt.xticks(bar_data.index.values, bar_data['barNo'].values)
    ax1.set_xlim(left = -1, right = len(bar_data))
    ax2 = ax1.twinx()
    ax2.set_ylabel(u'S因子(乘100000)', fontsize = 16)
    ax2.plot(bar_data.index, bar_data['smartS'], 'o', color ='r')
    ax2.set_ylim(bottom = -0.5*max(bar_data['smartS']))
    ax1.grid()

    # --------------  图2： 聪明钱的选择过程  --------------
    bar_data = bar_data.sort_values('smartS', ascending = False)
    bar_data.index = np.arange(len(bar_data))
    bar_data ['accumVolPct'] = bar_data['volume'].cumsum()*1.0/bar_data['volume'].sum()
    ax1 = fig.add_subplot(2,1,2)

    bar_data_1 = bar_data[bar_data['accumVolPct']<0.2]
    bar_data_2 = bar_data[bar_data['accumVolPct']>0.2]
    ax1.bar(bar_data_1.index, bar_data_1['volume'], color = 'r', align = 'center', width = 0.4)
    ax1.bar(bar_data_2.index, bar_data_2['volume'], align = 'center', width = 0.4)
    ax2 = ax1.twinx()
    ax2.plot(bar_data.index, bar_data['accumVolPct'], '-o', color = 'g')
    ax1.set_ylabel(u'成交量(万)', fontsize = 16)
    ax2.set_ylabel(u'成交累计占比', fontsize = 16)
    ax1.set_title(u'蓝色柱子(左轴)为成交量， 绿色曲线(右轴)为累计成交量占比', fontsize = 16)
    plt.xticks(bar_data.index.values, bar_data['barNo'].values)
    ax1.set_xlabel(u'样本分钟线序号', fontsize=16)
    ax1.set_xlim(left=-1, right=len(bar_data))
    ax1.grid()
    plt.show()


def get_q_factor(sec_code, start_date, end_date):
    bar_data = get_s_factor(sec_code, start_date, end_date)
    vwap_all = bar_data['volTimesPrice'].sum() / bar_data['volume'].sum()

    bar_data['accumVol'] = bar_data['accumVol'].cumsum()
    smart_vol = bar_data['accumVol'].values[-1] * 0.2
    bar_data_smart_money = bar_data[bar_data['accumVol']<= smart_vol]
    vwap_smart_money = bar_data_smart_money['volTimesPrice'].sum()/bar_data_smart_money['volume'].sum()

    return vwap_smart_money/vwap_all


def get_q_factor_list(sec_code_list, start_date, end_date):
    start_time = time.time()
    q_factor = []
    for sec_code in sec_code_list:
        q_factor_single_sec = get_q_factor(sec_code, start_date, end_date)
        q_factor.append(q_factor_single_sec)
    finish_time = time.time()
    print ''
    print str(finish_time-start_time) + ' seconds elapsed in total.'
    return q_factor


def get_monthly_q_factor_list(sec_code_list, start_date, end_date):
    return



if __name__ == "__main__":
    sec_code = '000905.SH'
    start_date = '2016-07-25'
    end_date = '2016-07-25'
    bar_data = get_s_factor(sec_code, start_date, end_date)
    plot_s_factor(bar_data)