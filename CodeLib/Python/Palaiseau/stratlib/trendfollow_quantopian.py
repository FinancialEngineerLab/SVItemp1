# -*- coding: utf-8 -*-
# ref: https://www.quantopian.com/posts/trend-follow-algo

if __name__ == '__main__':
    import sys
    sys.path.append("..")
    from pyalgotrade import bar
    from pyalgotrade import plotter
# 以上模块仅测试用
import numpy as np
import pandas as pd

from pyalgotrade import strategy
from pyalgotrade.broker.backtesting import TradePercentage
from pyalgotrade.broker.fillstrategy import DefaultStrategy
from pyalgotrade.technical import linreg, stats, reg
from pyalgotrade.tushare import data_from_tushare
from tools.performance_analyzer import performance_analyzer
from pyalgotrade.bar import Frequency

class TrendFollow(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, lookback_periods, profit_take_std, slope_min_positive, slope_min_negative = None,
                 maxdrawdown = 0.06, maxdrawdown_period = 150, info_show=True, instrumentMainFutContract = None, use_self_info = False):
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__prices = feed[instrument].getPriceDataSeries()
        self.__lookbackPeriods = lookback_periods
        self.__profitTakeStd = profit_take_std
        self.__slopeMin = slope_min_positive
        self.__slopeMinNegative = slope_min_negative
        self.__lookback_periods_array = np.asarray(range(lookback_periods))
        self.__longPos = None
        self.__shortPos = None
        self.__maxdrawdown = maxdrawdown
        self.__reg = linreg.Slope(self.__prices, self.__lookbackPeriods)
        self.__std = stats.StdDev(self.__prices, self.__lookbackPeriods)
        self.__slope = self.__reg.getSlope()
        self.__constant = self.__reg.getConstant()
        self.__info_show = info_show
        self.__maxdrawdown_high_indicator = stats.Maxdrawdown(self.__prices, maxdrawdown_period)
        self.__maxdrawdown_low_indicator = stats.Maxdrawdown(self.__prices, maxdrawdown_period, False)
        self.__useFutForClearing = (instrumentMainFutContract is not None)
        self.__useSelfInfo = use_self_info

    def getDateTimeSeries(self,instrument=None):
        #if instrument is None:
        #   __dateTime = pd.DataFrame()
        #   for element in self.__instrument:
        #       __dateTime = __dateTime.append(self.__feed[element].getPriceDataSeries().getDateTimes())
        #   __dateTime = __dateTime.drop_duplicates([0])
        #   return __dateTime.values #此时返回的为二维数组
        return self.__feed[self.__instrument].getPriceDataSeries().getDateTimes()

    def onEnterOk(self, position):
        self.addInfo(position.getEntryOrder())

    def onExitOk(self, position):
        # execInfo = position.getEntryOrder().getExecutionInfo()
        strategy.BacktestingStrategy.onExitOk(self,position)
        # self.info("BUY at $%.2f" % (execInfo.getPrice()))
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)

    def onEnterCanceled(self, position):
        # self.__position = None
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)

    def onBars(self, bars):
        # wait for enough bars to be available to calc regression lines
        if self.__reg[-1] is None:
            return
        if (bars[self.__instrument].getDateTime().hour ==11 and bars[self.__instrument].getDateTime().minute>30) or(bars[self.__instrument].getDateTime().hour ==15 and bars[self.__instrument].getDateTime().minute>0):
            print "当前交易时间已经结束"
            self.__feed.stop()
            return
        #print str(self.__prices[-1])+' '+str(bars[self.__instrument].getDateTime())
        # use normalized slope
        if bars[self.__instrument].getFrequency()==300:
           slope = self.__slope[-1] / self.__constant[-1] * 252 * 48
        elif bars[self.__instrument].getFrequency()==86400:
            slope = self.__slope[-1] / self.__constant[-1] * 252
        else:
            raise ValueError('Frequency Error')
        # currently how far away from reg line
        delta_neg_one = self.__prices[-1] - self.__reg.getRegValue(self.__lookback_periods_array[-1])
        delta_neg_two = self.__prices[-2] - self.__reg.getRegValue(self.__lookback_periods_array[-2])

        dd_long = self.__maxdrawdown_high_indicator[-1]
        dd_short = self.__maxdrawdown_low_indicator[-1]

        # close long position
        if self.__longPos is not None:
             if self.exitLongSignal(slope,delta_neg_one):
                 self.__longPos.exitMarket()
                 if self.__info_show:
                     if self.__useSelfInfo==False:
                         print "\033[0;31m%s\033[0m" %"LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
        # close short position
        elif self.__shortPos is not None:
             if self.exitShortSignal(slope,delta_neg_one):
                 self.__shortPos.exitMarket()
                 if self.__info_show:
                     if self.__useSelfInfo==False:
                        print "\033[0;31m%s\033[0m" %"SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
        # open long position
        else:
             if self.enterLongSignal(delta_neg_one,delta_neg_two,slope,dd_long):
                 shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice()) # 5成仓位
                 self.__longPos = self.enterLong(self.__instrument, shares)
                 if self.__info_show:
                     if self.__useSelfInfo==False:
                        print "\033[0;31m%s\033[0m" %"LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() )
                     else:
                         self.info("LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() ))
        # open short position
             elif self.enterShortSignal( delta_neg_one,delta_neg_two,slope,dd_short):
                   shares = int(self.getBroker().getEquity()*0.5  / bars[self.__instrument].getPrice()) # 5成仓位
                   self.__shortPos = self.enterShort(self.__instrument, shares)
                   if self.__info_show:
                       if self.__useSelfInfo==False:
                           print "\033[0;31m%s\033[0m" %"SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                       else:
                           self.info("SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))

    def exitLongSignal(self, slope,delta_neg_one):
        return (slope < 0 or delta_neg_one > self.__profitTakeStd * self.__std[-1]) and ( not self.__longPos.exitActive())

    def enterLongSignal(self,delta_neg_one,delta_neg_two,slope,dd_long):
        return (delta_neg_one > 0 > delta_neg_two) and (slope > self.__slopeMin) and (dd_long<self.__maxdrawdown)

    def enterShortSignal(self, delta_neg_one,delta_neg_two,slope,dd_short):
         if self.__slopeMinNegative is not None:
            return (delta_neg_one < 0 < delta_neg_two) and (slope < self.__slopeMinNegative) and (dd_short<self.__maxdrawdown)
         else:
            return (delta_neg_one < 0 < delta_neg_two) and (slope < - self.__slopeMin) and (dd_short<self.__maxdrawdown)

    def exitShortSignal(self,slope,delta_neg_one):
        return (slope > 0 or delta_neg_one < -self.__profitTakeStd * self.__std[-1]) and  (not self.__shortPos.exitActive())

if __name__ == "__main__":
    strat = TrendFollow
    instrument = '000905'
    market = 'SH 2015'
    fromDate = '2014-07-01 09:35'
    toDate ='2016-02-03 15:00'
    frequency = bar.Frequency.MINUTE_FIVE
    paras = [37,3,0,0,0.06]
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
        #barfeed.addBarsFromDataFrame(instrument, data_df)
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

