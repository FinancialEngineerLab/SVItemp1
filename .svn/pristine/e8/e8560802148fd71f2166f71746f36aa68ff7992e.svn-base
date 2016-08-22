# -*- coding: utf-8 -*-
import numpy as np
from pyalgotrade import technical
from pyalgotrade import dataseries

def ERS(smin=2,smax=240,step=1):
    logers = []
    interval=[]
    for n in range(smin,smax+1,step):
      ersn = 0
      for i in range(1,n):
          ersn = ersn +((n-0.5)/n)*np.power(n*np.pi/2,-0.5)*np.sqrt((n-i)/i)
      logers.append(np.log10(ersn))
      interval.append(np.log10(n))
    return (np.polyfit(interval,logers,1))[0]


def RS(x,interval):
    n = int(len(x)/interval)           #区间个数
    t = len(x)-interval*n
    m = np.zeros(n)
    r = np.zeros(n)
    s = np.zeros(n)
    xx = np.zeros(n*interval)
    ret = 0
    for i in range(0,n):
        m[i]=sum(x[t+interval*i:t+interval*(i+1)])/interval       #计算各个区间的平均值
    for i in range(0,n):
        xx[i*interval]=x[t+i*interval]-m[i]                       #计算离差
        for j in range(1,interval):
            xx[i*interval+j]=xx[i*interval+j-1]+x[t+i*interval+j]-m[i]

    for i in range(0,n):
        r[i] = np.max(xx[i*interval:(i+1)*interval])-np.min(xx[i*interval:(i+1)*interval])   #计算极差
        s[i] = np.std(x[t+i*interval:t+(i+1)*interval])                                     #计算标准差
        ret = ret+(r[i]/s[i])/n                                                             #计算R/S
    return  np.log10(ret)


def hurst(price,smin,smax,step):
    r = np.zeros(len(price))
    x = np.zeros(len(price))
    r[0] = 0
    x[0] = 0
    logrs = []
    loginterval = []
    for i in range(1,len(price)):
        r[i]=np.log10(price[i]/price[i-1])                                               #计算对数收益
    m = np.polyfit(r[:-1],r[1:],1)                                                    #自回归分析
    b=m[0]
    a=m[1]
    for i in range(1,len(price)):
        x[i]=r[i]-(a+b*r[i-1])                                                #计算残差
    for i in range(smin,smax+1,step):
        loginterval.append(np.log10(i))                                       #log（n）序列
        logrs.append(RS(x,i))                                                  #log（R/S)序列
    return (np.polyfit(loginterval,logrs,1))[0]

class HurstExponentEventWindow(technical.EventWindow):
    def __init__(self, period, minLags, maxLags,step):
        technical.EventWindow.__init__(self, period)
        self.__minLags = minLags
        self.__maxLags = maxLags
        self.__step = step

    def onNewValue(self, dateTime, value):
        technical.EventWindow.onNewValue(self, dateTime, value)

    def getValue(self):
        ret = None
        if self.windowFull():
            ret = hurst(self.getValues(),self.__minLags, self.__maxLags,self.__step)
        return ret


class HurstExponent(technical.EventBasedFilter):
    """Hurst exponent filter.

    :param dataSeries: The DataSeries instance being filtered.
    :type dataSeries: :class:`pyalgotrade.dataseries.DataSeries`.
    :param period: The number of values to use to calculate the hurst exponent.
    :type period: int.
    :param minLags: The minimum number of lags to use. Must be >= 2.
    :type minLags: int.
    :param maxLags: The maximum number of lags to use. Must be > minLags.
    :type maxLags: int.
    :param maxLen: The maximum number of values to hold.
        Once a bounded length is full, when new items are added, a corresponding number of items are discarded
        from the opposite end.
    :type maxLen: int.
    """

    def __init__(self, dataSeries, period, minLags=2, maxLags=20, step=1,maxLen=dataseries.DEFAULT_MAX_LEN):
        assert period > 0, "period must be > 0"
        assert minLags >= 2, "minLags must be >= 2"
        assert maxLags > minLags, "maxLags must be > minLags"

        technical.EventBasedFilter.__init__(
            self,
            dataSeries,
            HurstExponentEventWindow(period, minLags, maxLags,step),
            maxLen
        )
