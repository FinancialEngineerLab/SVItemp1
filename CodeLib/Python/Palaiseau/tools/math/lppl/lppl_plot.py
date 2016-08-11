# -*- coding: utf-8 -*-

import matplotlib.dates as mdates
from pylab import *
from matplotlib.finance import candlestick_ohlc
import tools.date_handler.date_offset as dtoffset
import numpy
from datetime import datetime


def plotLPPLSimulationResult(df_data_from_tushare, values, start, type=0):
    """Index
    :param type: 拟合返回结果的种类， 0： 7个参数GA算法拟合； 1： 3个参数GA算法拟合
    :param start: 拟合开始的日期
    :param values: 拟合获得的结果
    :param df_data_from_tushare: 通过tushare获取开高低收数据
    """
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)

    ohlc = [[0 for col in range(5)] for row in range(df_data_from_tushare.index.size)]

    open = []
    [open.extend(i) for i in df_data_from_tushare.loc[:, ['open']].values.tolist()]
    open = map(float, open)
    high = []
    [high.extend(i) for i in df_data_from_tushare.loc[:, ['high']].values.tolist()]
    high = map(float, high)
    low = []
    [low.extend(i) for i in df_data_from_tushare.loc[:, ['low']].values.tolist()]
    low = map(float, low)
    close = []
    [close.extend(i) for i in df_data_from_tushare.loc[:, ['close']].values.tolist()]
    close = map(float, close)

    for i in range(df_data_from_tushare.index.size):
        ohlc[i][0] = datetime.strptime(df_data_from_tushare.index.values[i].encode("utf-8"), "%Y-%m-%d").toordinal()
        ohlc[i][1] = open[i]
        ohlc[i][2] = high[i]
        ohlc[i][3] = low[i]
        ohlc[i][4] = close[i]

    ax.set_ylabel(r'Index')
    ax.set_xlabel('Date')
    fmt = mdates.DateFormatter('%Y %b %d')
    ax.xaxis.set_major_formatter(fmt)
    ax.grid(True)
    ax.xaxis_date()
    ax.autoscale()
    # fig.autofmt_xdate()
    # fig.tight_layout()
    # ax.autoscale_view()
    plt.setp(plt.gca().get_xticklabels(), rotation=45, horizontalalignment='right')

    candlestick_ohlc(ax, ohlc, colorup='r', colordown='g')

    if type == 0 or type == 1:
        solution = 3
        for i in range(solution):
            timeseries = numpy.linspace(0, int(values[i].cof[2]) - 1, int(values[i].cof[2]))
            date_array1 = []
            for x in timeseries:
                date_array1.append(
                    datetime.strptime(dtoffset.datetime_offset(start, int(x), "BD").encode("utf-8"),
                                      "%Y-%m-%d").toordinal())
            plt.plot(date_array1, values[i].getExpFutureData(timeseries), label='Fit ' + str(i + 1))
    elif type == 2:
        timeseries = numpy.linspace(0, int(values.cof[2]) - 1, int(values.cof[2]))
        date_array1 = []
        for x in timeseries:
            date_array1.append(
                datetime.strptime(dtoffset.datetime_offset(start, int(x), "BD").encode("utf-8"),
                                  "%Y-%m-%d").toordinal())
        plt.plot(date_array1, values.getExpFutureData(timeseries), label='Fit 1')

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(handles, labels)
    show()


def plotLPPLSimulationResultMin(wd_data_from_wind, values, start):
    """index"""
    ohlc = [[0 for col in range(5)] for row in range(len(wd_data_from_wind.Data[0]))]
    open = wd_data_from_wind.Data[0]
    high = wd_data_from_wind.Data[1]
    low = wd_data_from_wind.Data[2]
    close = wd_data_from_wind.Data[3]

    for i in range(len(wd_data_from_wind.Data[0])):
        # ohlc[i][0] = i + 1
        ohlc[i][0] = wd_data_from_wind.Times[i].toordinal()
        ohlc[i][1] = open[i]
        ohlc[i][2] = high[i]
        ohlc[i][3] = low[i]
        ohlc[i][4] = close[i]

    ndays = np.unique(wd_data_from_wind.Times)
    xdays = []
    for i in wd_data_from_wind.Times:
        xdays.append(datetime.date(i).isoformat())
    data2 = ohlc

    # plot the data
    fig = plt.figure(figsize=(10, 5))
    ax = fig.add_axes([0.1, 0.2, 0.85, 0.7])
    # customization of the axis
    ax.spines['right'].set_color('none')
    ax.spines['top'].set_color('none')
    ax.xaxis.set_ticks_position('bottom')
    ax.yaxis.set_ticks_position('left')
    ax.tick_params(axis='both', direction='out', width=2, length=8,
                   labelsize=12, pad=8)
    ax.spines['left'].set_linewidth(2)
    ax.spines['bottom'].set_linewidth(2)
    # set the ticks of the x axis only when starting a new day
    # labels = datetime.date(wd_data_from_wind.Times).isoformat
    # fig.xticks(wd_data_from_wind.Times)
    # ax.set_xticks(ndays[1].isoformat)
    # ax.set_xticklabels(xdays, rotation=45, horizontalalignment='right')

    ax.set_ylabel('Index', size=20)

    candlestick_ohlc(ax, data2, width=0.5, colorup='g', colordown='r')

    """Fit 1"""
    timeseries = numpy.linspace(0, int(values[0].cof[2]) - 1, int(values[0].cof[2]))
    date_array1 = []
    for x in timeseries:
        date_array1.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(x), "BD").encode("utf-8"), "%Y-%m-%d").toordinal())

    plt.plot(date_array1, values[0].getExpFutureData(timeseries), label='Fit 1')
    # plt.plot(timeseries, values[0].getExpFutureData(timeseries), label='Fit 1')

    """Fit 2"""
    timeseries = numpy.linspace(0, int(values[1].cof[2]) - 1, int(values[1].cof[2]))
    date_array2 = []
    for x in timeseries:
        date_array2.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(x), "BD").encode("utf-8"), "%Y-%m-%d").toordinal())

    plt.plot(date_array2, values[1].getExpFutureData(timeseries), label='Fit 2')
    # plt.plot(timeseries, values[1].getExpFutureData(timeseries), label='Fit 2')

    """Fit 3"""
    timeseries = numpy.linspace(0, int(values[2].cof[2]) - 1, int(values[2].cof[2]))
    date_array3 = []
    for x in timeseries:
        date_array3.append(
            datetime.strptime(dtoffset.datetime_offset(start, int(x), "BD").encode("utf-8"), "%Y-%m-%d").toordinal())

    plt.plot(date_array3, values[2].getExpFutureData(timeseries), label='Fit 3')
    # plt.plot(timeseries, values[2].getExpFutureData(timeseries), label='Fit 3')

    plt.show()

    show()
