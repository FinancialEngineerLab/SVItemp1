import math
from WindPy import  *
import matplotlib.pyplot as plt
from tools.data_handler import datarange
# formula 21
def get_power(p,t=datarange.floatrange(1.5,15,56)):
    power = []
    for i in range(0,len(t),1):
        real = 0
        imag =0
        for j  in range(1,len(p)+1,1):
            real = real+p[j-1]*math.cos(-1*j*(2*math.pi/t[i]))
            imag = imag+p[j-1]*math.sin(-1*j*(2*math.pi/t[i]))
        value = real*real +imag*imag
        power.append(value)
    assert len(power)==len(t)
    #plt.plot(t,power)
    #plt.show()
    return power
# formula 30
def get_S(power,t=datarange.floatrange(1.5,15,56)):
    assert len(power)==len(t)
    power_max = max(power)
    s = []

    for i in range(0,len(power),1):
        if power[i] ==power_max:
            value=0
        else:
            value =-10*math.log(0.01/(1-power[i]/power_max))/math.log(10)
            #value = -1*math.log(power[i]/power_max)
        s.append(value)
    assert len(s)==len(t)
    #plt.plot(t,s)
    #plt.show()
    return s
#fomula 31,32
def get_T(s,q=15,t=datarange.floatrange(1.5,15,56)):
    assert len(s)==len(t)
    all_s=0
    all_t=0
    for i in range(0,len(t)):
        all_s = all_s + max(q-s[i],0)
        all_t = all_t + max(q-s[i],0)*t[i]
    return all_t/all_s









if __name__ == '__main__':
    w.start()
    wd=w.wsd("000300.SH", "MA", "2012-08-18", "2015-11-18", "MA_N=10")
    dtime = wd.Times[14:700+14]
    data = wd.Data[0]
    result = []
    for i in range(0,700,1):
         result.append(get_T(get_S(get_power(data[i:i+15]))))
    plt.plot(dtime,result)
    plt.show()
