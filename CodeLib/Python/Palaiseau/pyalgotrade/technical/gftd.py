# -*- coding: utf-8 -*-
# http://218.19.190.27/TD.pdf
import numpy as np

from pyalgotrade import technical
from pyalgotrade import dataseries


class GFTDEventWindow(technical.EventWindow):
    def __init__(self, period):
        technical.EventWindow.__init__(self, period)
        self.__nbLag = period   #模型买入启动或卖出启动形态形成时的价格比较滞后期数
        self.__currentUD = 0
        self.__prevUD = 0
        self.__cumulUD = None

    def onNewValue(self, dateTime, value):
         technical.EventWindow.onNewValue(self, dateTime, value)
         if value is not None and self.windowFull():
             self.__prevUD = self.__currentUD
             values = self.getValues()
             if value > values[-self.__nbLag]:
                 self.__currentUD = 1
             elif value < values[-self.__nbLag]:
                 self.__currentUD = -1

             if self.__prevUD == self.__currentUD:
                 if self.__cumulUD is None:
                     self.__cumulUD = self.__currentUD
                 else:
                     self.__cumulUD += self.__currentUD
             else:
                 self.__cumulUD = 0

    def getValue(self):
        return self.__cumulUD

class GFTD(technical.EventBasedFilter):
     def __init__(self, dataSeries, period, maxLen=dataseries.DEFAULT_MAX_LEN):
        technical.EventBasedFilter.__init__(self, dataSeries, GFTDEventWindow(period), maxLen)
