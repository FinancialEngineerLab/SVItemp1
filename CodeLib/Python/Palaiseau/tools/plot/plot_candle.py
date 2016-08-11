# coding=utf-8
from pylab import *
from decimal import Decimal
import matplotlib.dates as mdates
from matplotlib.finance import candlestick_ohlc


# 按列从txt中读入数据，数据格式为string
def txt_to_list(file_name, n_col):
    return [(line.split()[n_col]) for line in open(file_name)]


# 按列将string转换为date
def str_to_date(str_list):
    return [(datetime.datetime.strptime(dt_str, "%Y/%m/%d")) for dt_str in str_list]


# 按列将string转换为decimal
def str_to_decimal(str_list):
    return [Decimal(x) for x in str_list]


def get_ohlc_from_txt(filename):
    date = str_to_date(txt_to_list(filename, 0))

    idx_ohlc = [[0 for col in range(5)] for row in range(date.__len__())]
    idx_open = str_to_decimal(txt_to_list(filename, 2))
    idx_high = str_to_decimal(txt_to_list(filename, 3))
    idx_low = str_to_decimal(txt_to_list(filename, 4))
    idx_close = str_to_decimal(txt_to_list(filename, 5))

    for i in range(date.__len__()):
        idx_ohlc[i][0] = date[i].toordinal()
        idx_ohlc[i][1] = idx_open[i]
        idx_ohlc[i][2] = idx_high[i]
        idx_ohlc[i][3] = idx_low[i]
        idx_ohlc[i][4] = idx_close[i]

    return idx_ohlc


def plot_candle(filename, title_name):
    # x轴（右侧）最大最小值
    x_min = -1
    x_max = 2

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 1, 1)
    ax2 = ax1.twinx()

    date = str_to_date(txt_to_list(filename, 0))
    lppl_result = str_to_decimal(txt_to_list(filename, 1))

    idx_ohlc = get_ohlc_from_txt(filename)

    ax1.set_ylabel(r'Index')
    ax1.set_xlabel('Date')
    fmt = mdates.DateFormatter('%Y %b %d')
    ax1.xaxis.set_major_formatter(fmt)
    ax1.grid(True)
    ax1.xaxis_date()
    ax1.autoscale()

    candlestick_ohlc(ax1, idx_ohlc, colorup='r', colordown='g', width=1.6)

    ax2.plot(date, lppl_result, 'r', label=strLabel)

    ax2.set_ylim([x_min, x_max])
    ax1.set_ylabel('Index Price')
    ax2.set_ylabel('LPPL Confidence')
    ax1.set_xlabel("Date")

    plt.title(title_name, fontsize=20)

    show()

if __name__ == "__main__":
    # 读取文件名称
    filename = "C:\Users\yangyanzhe\Desktop\LPPL Simulation Result Accumulate\Steel_500_20.txt"
    # 指数名称
    strIndexName = u'上证综合指数'
    # 作图标题
    strTitle = u'南华螺纹钢指数 LPPL Confidence'
    strLabel = u'LPPL Confidence 50-100 RE=0.05'

    plot_candle(filename, strTitle)
