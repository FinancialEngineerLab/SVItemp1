from pyalgotrade import technical
from pyalgotrade import dataseries
import numpy as np

class RPSEventWindow(technical.EventWindow):
    def __init__(self, period, ma_period, changeToReturn):
        assert(period > 0)
        technical.EventWindow.__init__(self, period)
        self.__value = None
        self.__ma_value = None
        self.__period = period
        self.__ma_period = ma_period
        self.__value_list_for_ma = []
        self.__changeToReturn = changeToReturn

    def onNewValue(self, dateTime, value):
        technical.EventWindow.onNewValue(self, dateTime, value)
        if self.windowFull():
             if self.__changeToReturn:
                current_return = np.log(value /self.getValues()[-2])
                high_return = np.max(np.diff(np.log(self.getValues())))
                low_return = np.min(np.diff(np.log(self.getValues())))
                current_rps = (current_return - low_return)/(high_return - low_return)
             else:
                current_rps = (value - np.min(self.getValues())) /(np.max(self.getValues()) - np.min(self.getValues()))
             if self.__ma_period is not None:
                self.__value_list_for_ma.append(current_rps)
                self.__value = np.mean(self.__value_list_for_ma[-self.__ma_period:]) if len(self.__value_list_for_ma) >= self.__ma_period else None
             else:
                self.__value = current_rps

    def getValue(self):
        return self.__value

class RPS(technical.EventBasedFilter):
    def __init__(self, dataSeries, period=250, ma_period = 10,changeToReturn=False, maxLen=dataseries.DEFAULT_MAX_LEN):
        technical.EventBasedFilter.__init__(self, dataSeries, RPSEventWindow(period,ma_period, changeToReturn), maxLen)





