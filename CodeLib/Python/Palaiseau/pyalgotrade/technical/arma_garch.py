import pandas as pd
from pyalgotrade import technical
from pyalgotrade import dataseries
from tools.math.stat import arma


class ARMAGARCHEventWindow(technical.EventWindow):
    def __init__(self, period):
        assert(period > 0)
        technical.EventWindow.__init__(self, period)
        self.__predict = None
        self.__dateTime = []

    def onNewValue(self, dateTime, value):
         technical.EventWindow.onNewValue(self, dateTime, value)
         self.__dateTime.append(dateTime)
         if value is not None and self.windowFull():
             dataSeries_pd = pd.DataFrame(self.getValues(), index = self.__dateTime[-self.getWindowSize():], columns=['close'])
             model = arma.statHelper(dataSeries=dataSeries_pd, needLogDiff=True)
             model.fit_arma_garch_model()
             self.__predict = model.meanOfOnePeriodPrediction_arma_garch_model()

    def getValue(self):
        return self.__predict


class ARMAGARCH(technical.EventBasedFilter):
     def __init__(self, dataSeries, period, maxLen=dataseries.DEFAULT_MAX_LEN):
        technical.EventBasedFilter.__init__(self, dataSeries, ARMAGARCHEventWindow(period), maxLen)
