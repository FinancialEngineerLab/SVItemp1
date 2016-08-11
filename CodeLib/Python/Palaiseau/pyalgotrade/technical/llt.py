import numpy as np
from pyalgotrade import technical
from pyalgotrade import dataseries

class LLTEventWindow(technical.EventWindow):
    def __init__(self, alpha, period, returnLLT):
        assert(period > 0)
        technical.EventWindow.__init__(self, period)
        self.__alpha = alpha
        self.__value = None
        self.__slope = None
        self.__prevValue = None
        self.__prev2Value = None
        self.__prev3Value = None
        self.__prevSlope = None
        self.__prev2Slope = None
        self.__returnLLTOrSlope = returnLLT

    def onNewValue(self, dateTime, value):
        technical.EventWindow.onNewValue(self, dateTime, value)
        if len(self.getValues()) > 2:
            prevValue = self.getValues()[-1]
            prev2Value = self.getValues()[-2]
            prev3Value = self.getValues()[-3]
            assert(prevValue is not None and prev2Value is not None and prev3Value is not None)

            if self.windowFull():
                if self.__value is None:
                    self.__prevValue = prevValue
                    self.__prev2Value = prev2Value
                    self.__prevSlope = 0.0
                    self.__prev2Slope = 0.0
                else:
                    self.__prev2Value = self.__prevValue
                    self.__prevValue = self.__value
                    self.__prev2Slope = self.__prevSlope
                    self.__prevSlope = self.__slope

                self.__value = (self.__alpha - self.__alpha**2/4.0)*value \
                               + self.__alpha**2 /2.0 * prevValue - (self.__alpha - self.__alpha**2*3.0/4.0) * prev2Value \
                               + 2*(1- self.__alpha)* self.__prevValue - (1-self.__alpha)**2 * self.__prev2Value

                self.__slope = (self.__alpha - self.__alpha**2/4.0)* (value - prevValue) \
                               + self.__alpha**2 /2.0 * (prevValue - prev2Value) - (self.__alpha - self.__alpha**2*3.0/4.0) * (prev2Value - prev2Value)\
                               + 2*(1- self.__alpha)* self.__prevSlope  - (1-self.__alpha)**2 * self.__prev2Slope

    def getValue(self):
        if self.__returnLLTOrSlope:
            return self.__value
        else:
            return self.__slope

class LLT(technical.EventBasedFilter):
    """LLT filter.

    :param dataSeries: The DataSeries instance being filtered.
    :type dataSeries: :class:`pyalgotrade.dataseries.DataSeries`.
    :param period: The number of values to use to calculate the SMA.
    :type period: int.
    :param maxLen: The maximum number of values to hold.
        Once a bounded length is full, when new items are added, a corresponding number of items are discarded from the opposite end.
    :type maxLen: int.
    """
    def __init__(self, dataSeries, alpha, period = 3, returnLLT = True, maxLen=dataseries.DEFAULT_MAX_LEN):
        technical.EventBasedFilter.__init__(self, dataSeries, LLTEventWindow(alpha, period, returnLLT), maxLen)
