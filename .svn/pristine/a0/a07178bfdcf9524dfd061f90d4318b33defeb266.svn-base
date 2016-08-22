from pyalgotrade import technical
from pyalgotrade import dataseries
from pyalgotrade.dataseries import bards


class VOLDIFFEventWindow(technical.EventWindow):
    def __init__(self, period):
        assert(period >= 1)
        technical.EventWindow.__init__(self, period)
        self.__value = None

    def onNewValue(self, dateTime, value):
        technical.EventWindow.onNewValue(self, dateTime, value.getClose())
        if value is not None and self.windowFull():
            sigma_u =  (value.getHigh() - value.getOpen()) / value.getOpen()
            sigma_d =  (value.getOpen() - value.getLow()) / value.getOpen()
            self.__value = sigma_u - sigma_d

    def getValue(self):
        return self.__value


class VOLDIFF(technical.EventBasedFilter):
     def __init__(self, barDataSeries, period=1, maxLen=dataseries.DEFAULT_MAX_LEN):
        if not isinstance(barDataSeries, bards.BarDataSeries):
            raise Exception("barDataSeries must be a dataseries.bards.BarDataSeries instance")

        technical.EventBasedFilter.__init__(self, barDataSeries, VOLDIFFEventWindow(period), maxLen)