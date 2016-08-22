# -*- coding: utf-8 -*-
import numpy as np
from WindPy import  *
import matplotlib.pyplot as plt
import  csv

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
        ret = ret+(r[i]/s[i])/n                                                              #计算R/S
    return  np.log10(ret)

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



if __name__ == "__main__":
  #w.start()
  #wd = w.wsd('000001.SH', "close", "2001-04-03","2010-11-11", "Period=D")
  #wd = w.wsi('000905.SH', "close", "2015-10-03"+" 09:30:00", "2016-03-22"+" 15:01:00", "BarSize=5")
  csvfile = open('D:\\Workarea\\Palaiseau\\test_Palaiseau\\data\\000001SH.csv', 'r')
  data = []
  for line in csvfile:
       if list(line.strip().split(','))[4] !='Close':
         data.append((float)(list(line.strip().split(','))[4]))
  data = np.array(data)
  print  data
  hurst_win=200
  h = []
  smin =2
  smax =120
  step =1
  print  ERS(2,204,2)
  print  hurst(data,2,8,1)

