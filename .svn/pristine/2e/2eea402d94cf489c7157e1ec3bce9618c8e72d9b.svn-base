# -*- coding: utf-8 -*-
# ref: https://www.quantopian.com/posts/trend-follow-algo

if __name__ == '__main__':
    import sys
    sys.path.append("..")
    from pyalgotrade import bar
    from pyalgotrade import plotter
# 以上模块仅测试用
import numpy as np

from pyalgotrade import strategy
from pyalgotrade.broker.backtesting import TradePercentage
from pyalgotrade.broker.fillstrategy import DefaultStrategy
from pyalgotrade.technical import linreg, stats
from pyalgotrade.tushare import data_from_tushare
from tools.performance_analyzer import performance_analyzer

class Example_Strat(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument):
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__prices = feed[instrument].getPriceDataSeries()
        self.__longPos = None
        self.__shortPos = None

    def getDateTimeSeries(self,instrument=None):
        return self.__feed[self.__instrument].getPriceDataSeries().getDateTimes()

    def onEnterOk(self, position):
        self.addInfo(position.getEntryOrder())

    def onExitOk(self, position):
        strategy.BacktestingStrategy.onExitOk(self,position)
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)

    def onEnterCanceled(self, position):
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)

    def onBars(self, bars):
        if len(self.__prices)==10:
            shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice()) # 5成仓位
            self.__longPos = self.enterLong(self.__instrument, shares)
        elif len(self.__prices)==20:
            self.__longPos.exitMarket()
        elif len(self.__prices)==200:
            shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice()) # 5成仓位
            self.__longPos = self.enterLong(self.__instrument, shares)
        elif len(self.__prices)==400:
            self.__longPos.exitMarket()




if __name__ == "__main__":
    strat = Example_Strat
    instrument = '000001'
    market = 'SH'
    frequency = bar.Frequency.DAY
    plot = True
    source = 'csv'

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    barfeed = GenericBarFeed(frequency)
    barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
    barfeed.addBarsFromCSV(instrument, '..//data//000001SH.csv')
    strat1 = strat(barfeed, instrument)
    performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
    if plot:
        plt = plotter.StrategyPlotter(strat1, True, True, True)
    strat1.run()
    performanceAnalyzer.printPerformaceInfo()
    performanceAnalyzer.getReturnsTearSheet(live_start_date=None)




