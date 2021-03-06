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
from pyalgotrade.technical import svm
from pyalgotrade.tushare import data_from_tushare
from tools.performance_analyzer import performance_analyzer


class SVMLag(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, period = 50, probaThresh = 0.5, lagVector =[9,7,8,3],info_show=True):
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__info_show = info_show
        self.__longPos = None
        self.__shortPos = None
        self.__close = feed[instrument].getCloseDataSeries()
        self.__svm = svm.SVM(dataSeries=self.__close, period=period, lagVector=lagVector)
        self.__svmPredictProba = self.__svm.getSVMPredictProba()
        self.__svmPredict = self.__svm.getSVMPredict()
        self.__probaThresh = probaThresh

    def getDateTimeSeries(self):
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
            assert False

    def onEnterCanceled(self, position):
        # self.__position = None
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)


    def onBars(self, bars):
        # If a position was not opened, check if we should enter a long position.

        if self.__svm is None:
            return

        # close long position
        if self.__longPos is not None:
             if self.exitLongSignal(bars):
                 self.__longPos.exitMarket()
                 if self.__info_show:
                     self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
        # close short position
        elif self.__shortPos is not None:
             if self.exitShortSignal(bars):
                 self.__shortPos.exitMarket()
                 if self.__info_show:
                     if self.__info_show:
                         self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
        # open long position
        else:
             if self.enterLongSignal(bars):
                 shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice()) # 5成仓位
                 self.__longPos = self.enterLong(self.__instrument, shares)
                 if self.__info_show:
                     self.info("LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() ))
        # open short position
             elif self.enterShortSignal(bars):
                   shares = int(self.getBroker().getEquity()*0.5  / bars[self.__instrument].getPrice()) # 5成仓位
                   self.__shortPos = self.enterShort(self.__instrument, shares)
                   if self.__info_show:
                       self.info("SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))

    def exitLongSignal(self, bars):
        return self.__svmPredict[-1] == -1 and self.__svmPredictProba[-1]> self.__probaThresh

    def enterLongSignal(self, bars):
        return self.__svmPredict[-1] == 1 and self.__svmPredictProba[-1]> self.__probaThresh

    def enterShortSignal(self, bars):
        return self.__svmPredict[-1] == -1 and self.__svmPredictProba[-1]> self.__probaThresh

    def exitShortSignal(self, bars):
        return self.__svmPredict[-1] == 1 and self.__svmPredictProba[-1]> self.__probaThresh




if __name__ == "__main__":
    strat = SVMLag
    instrument = '000905'
    market = 'SH 16.1-16.7'
    fromDate = '2014-07-01 09:35'
    toDate ='2016-06-03 15:00'
    frequency = bar.Frequency.MINUTE_FIVE
    paras = [46, 0.7]  #period, probaThresh
    plot = True
    source = 'csv'

    #############################################path set ############################33
    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    #############################################don't change ############################33
    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        #barfeed = dataframe_barfeed.Feed(frequency)
        #barfeed =TuShareLiveFeed(['zh500'],Frequency.MINUTE_FIVE, 10000, 0)       #10000代表数据最大个数，1代表提取前2天的数据，0代表提取昨天数据，实时回测必须于九点半前开启
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)
    else:
        barfeed = GenericBarFeed(frequency)
        barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
        barfeed.addBarsFromCSV(instrument, filepath)
    ############################################Run the strategy#########################
    strat1 = strat(barfeed, instrument, *paras)
    performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
    if plot:
        plt = plotter.StrategyPlotter(strat1, True, True, True)
    strat1.run()
    performanceAnalyzer.printPerformaceInfo()
    performanceAnalyzer.getReturnsTearSheet(live_start_date='2016-01-01')

    if plot:
        plt.plot()
