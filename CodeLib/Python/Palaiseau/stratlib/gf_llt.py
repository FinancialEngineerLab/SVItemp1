# -*- coding: utf-8 -*-

if __name__ == '__main__':
    import sys
    sys.path.append("..")
    from pyalgotrade import bar
    from pyalgotrade import plotter
# 以上模块仅测试用

from pyalgotrade import strategy
from pyalgotrade.broker.backtesting import TradePercentage
from pyalgotrade.broker.fillstrategy import DefaultStrategy
from pyalgotrade.technical import llt
from pyalgotrade.tushare import data_from_tushare, dataframe_barfeed
from tools.performance_analyzer import performance_analyzer
from tools.math import poly_calib


class Guangfa_LLT(strategy.BacktestingStrategy):
        def __init__(self, feed, instrument, alpha, period = 3, slopeLongThresh = 0.0001, slopeShortThresh = 0.0001, per=0.1,info_show = True, use_self_info = False,tradeVol = 0.5 ):
            strategy.BacktestingStrategy.__init__(self, feed)
            self.__feed = feed
            self.__instrument = instrument
            self.getBroker().setFillStrategy(DefaultStrategy(None))
            self.getBroker().setCommission(TradePercentage(0.001))
            self.__position = None
            self.__prices = feed[instrument].getPriceDataSeries()
            self.__longPos = None
            self.__shortPos = None
            self.__LLT = llt.LLT(self.__prices, alpha, period, returnLLT=True)
            self.__slope = llt.LLT(self.__prices, alpha, period, returnLLT=False)
            self.__slopeLongThresh = slopeLongThresh
            self.__slopeShortThresh = slopeShortThresh
            self.__info_show = info_show
            self.__per = per
            self.__useSelfInfo = use_self_info
            self.__tradeVol = tradeVol #  默认半仓

        def getDateTimeSeries(self):
            return self.__feed[self.__instrument].getPriceDataSeries().getDateTimes()

        def getLLT(self):
            return self.__LLT

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
            # wait for enough bars to be available to calc regression lines
            if self.__LLT[-1] is None or self.__LLT[-3] is None:
                return
            if (bars[self.__instrument].getDateTime().hour ==11 and bars[self.__instrument].getDateTime().minute>30) or(bars[self.__instrument].getDateTime().hour ==15 and bars[self.__instrument].getDateTime().minute>0):
                print "当前交易时间已经结束"
                self.__feed.stop()
                return
            try:
                slope = poly_calib.get_slope_from_points(self.__LLT)
                print bars[self.__instrument].getDateTime(), slope
            except:
                return
            if (self.__LLT[-1]-self.__prices[-1])/self.__LLT[-1]>=self.__per:
                slope=1000000
            elif (self.__LLT[-1]-self.__prices[-1])/self.__LLT[-1]<=-1*self.__per:
                slope = -1000000
            #print slope,self.__slopeLongThresh,bars[self.__instrument].getDateTime()
            #print bars[self.__instrument].getDateTime(), slope
             # close long position
            if self.__longPos is not None:
                 if self.exitLongSignal(slope):
                     self.__longPos.exitMarket()
                     if self.__info_show:
                        if not self.__useSelfInfo:
                          print "\033[0;31m%s\033[0m" %"LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                        else:
                          self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
            # close short position
            elif self.__shortPos is not None:
                 if self.exitShortSignal(slope):
                     self.__shortPos.exitMarket()
                     if self.__info_show:
                        if not self.__useSelfInfo:
                           print "\033[0;31m%s\033[0m" %"SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                        else:
                           self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
            # open long position
            else:
                 if self.enterLongSignal(slope):
                     shares = int(self.getBroker().getEquity() *self.__tradeVol / bars[self.__instrument].getPrice()) # 5成仓位
                     self.__longPos = self.enterLong(self.__instrument, shares)
                     if self.__info_show:
                        if not self.__useSelfInfo:
                           print "\033[0;31m%s\033[0m" %"LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() )
                        else:
                           self.info("LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() ))
            # open short position
                 elif self.enterShortSignal(slope):
                       shares = int(self.getBroker().getEquity()*self.__tradeVol  / bars[self.__instrument].getPrice()) # 5成仓位
                       self.__shortPos = self.enterShort(self.__instrument, shares)
                       if self.__info_show:
                          if not self.__useSelfInfo:
                             print "\033[0;31m%s\033[0m" %"SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                          else:
                             self.info("SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))


        def exitLongSignal(self, slope):
            return slope < self.__slopeLongThresh/2 and not self.__longPos.exitActive()

        def exitShortSignal(self,slope):
            return slope > - self.__slopeShortThresh/2 and not self.__shortPos.exitActive()

        def enterLongSignal(self, slope):
            return slope > self.__slopeLongThresh

        def enterShortSignal(self, slope):
            return slope < - self.__slopeShortThresh



if __name__ == "__main__":
    strat = Guangfa_LLT
    instrument = '000300'
    market = 'SH daily 16.1-16.7'
    fromDate = '2014-01-01 09:35'
    toDate ='2015-12-31 15:00'
    frequency = bar.Frequency.DAY
    paras = [0.45,3,0,0,0.14, True, False, 0.99]  #alpha, period, slopeLong, slopeShort, percentage
    plot = True
    source = 'tushar'

    #############################################path set ###############################
    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    #############################################don't change ############################
    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)
        barfeed = dataframe_barfeed.Feed(frequency)
        barfeed.addBarsFromDataFrame(instrument, data_df)
    else:
        barfeed = GenericBarFeed(frequency)
        if frequency == bar.Frequency.DAY:
            barfeed.setDateTimeFormat('%Y/%m/%d')
        else:
            barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
        barfeed.addBarsFromCSV(instrument, filepath)
    ############################################Run the strategy#########################
    strat = strat(barfeed, instrument,*paras)
    performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
    if plot:
        plt = plotter.StrategyPlotter(strat, True, True, True)
        plt.getInstrumentSubplot(instrument).addDataSeries("LLT", strat.getLLT())
    strat.run()
    performanceAnalyzer.printPerformaceInfo()
    performanceAnalyzer.getReturnsTearSheet(live_start_date='2016-01-01')

    if plot:
        plt.plot()