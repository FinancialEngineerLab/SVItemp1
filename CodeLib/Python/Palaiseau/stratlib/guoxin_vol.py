# -*- coding: utf-8 -*-

if __name__ == '__main__':
    import sys

    sys.path.append("..")
    from pyalgotrade import bar
    from pyalgotrade import plotter
# 以上模块仅测试用

import numpy as np

from pyalgotrade import dataseries
from pyalgotrade import strategy
from pyalgotrade.broker.backtesting import TradePercentage
from pyalgotrade.broker.fillstrategy import DefaultStrategy
from pyalgotrade.technical import rps, vol_diff
from pyalgotrade.tushare import data_from_tushare, dataframe_barfeed
from tools.performance_analyzer import performance_analyzer


class Guoxin_Vol(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, period=100, ma_period=10, tradeVol=0.5, info_show=True, use_self_info=False):
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__close = feed[instrument].getCloseDataSeries()
        # self.__return = self.getReturnSeries(self.__close)
        self.__bars = feed[instrument]
        self.__longPos = None
        self.__shortPos = None
        assert (period >= 100)  # 确保vol_diff[-100:]在RPS开始计算之前已经存在
        self.__RPS = rps.RPS(self.__close, period, ma_period, changeToReturn=False)
        self.__voldiff = vol_diff.VOLDIFF(self.__bars)
        self.__info_show = info_show
        self.__useSelfInfo = use_self_info
        self.__tradeVol = tradeVol  # 默认半仓

    def getReturnSeries(self, priceDataSeries):
        returnSeries = dataseries.SequenceDataSeries(priceDataSeries.getLength() - 1)
        for i in range(returnSeries.getMaxLen()):
            returnSeries.appendWithDateTime(priceDataSeries[i + 1].getDateTimes(),
                                            (priceDataSeries.getValueAbsolute(i) - priceDataSeries.getValueAbsolute(
                                                i - 1)) / priceDataSeries.getValueAbsolute(i - 1))
        return returnSeries

    def getRPS(self):
        return self.__RPS

    def getPriceDataSeries(self):
        return self.__close

    def getDateTimeSeries(self):
        return self.__feed[self.__instrument].getPriceDataSeries().getDateTimes()

    def onEnterOk(self, position):
        self.addInfo(position.getEntryOrder())

    def onExitOk(self, position):
        strategy.BacktestingStrategy.onExitOk(self, position)
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert False

    def onEnterCanceled(self, position):
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert False

    def onBars(self, bars):
        # wait for enough bars to be available to calc regression lines
        if self.__RPS[-1] is None:
            return
        else:
            RPS = abs(int(self.__RPS[-1] * 100))
            ma_vol_diff = np.mean(self.__voldiff[-RPS:])

        if (bars[self.__instrument].getDateTime().hour == 11 and bars[self.__instrument].getDateTime().minute > 30) or (
                bars[self.__instrument].getDateTime().hour == 15 and bars[self.__instrument].getDateTime().minute > 0):
            print "当前交易时间已经结束"
            self.__feed.stop()
            return

        # print slope,self.__slopeLongThresh,bars[self.__instrument].getDateTime()
        # print bars[self.__instrument].getDateTime(), slope
        # close long position
        if self.__longPos is not None:
            if self.exitLongSignal(ma_vol_diff):
                self.__longPos.exitMarket()
                if self.__info_show:
                    if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" % "LONG close at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime())
                    else:
                        self.info("LONG close at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime()))
        # close short position
        elif self.__shortPos is not None:
            if self.exitShortSignal(ma_vol_diff):
                self.__shortPos.exitMarket()
                if self.__info_show:
                    if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" % "SHORT close at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime())
                    else:
                        self.info("SHORT close at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime()))
        # open long position
        else:
            if self.enterLongSignal(ma_vol_diff):
                shares = int(
                    self.getBroker().getEquity() * self.__tradeVol / bars[self.__instrument].getPrice())  # 5成仓位
                self.__longPos = self.enterLong(self.__instrument, shares)
                if self.__info_show:
                    if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" % "LONG open at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime())
                    else:
                        self.info("LONG open at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime()))
                        # open short position
            elif self.enterShortSignal(ma_vol_diff):
                shares = int(
                    self.getBroker().getEquity() * self.__tradeVol / bars[self.__instrument].getPrice())  # 5成仓位
                self.__shortPos = self.enterShort(self.__instrument, shares)
                if self.__info_show:
                    if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" % "SHORT open at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime())
                    else:
                        self.info("SHORT open at $%.2f at %s" % (
                        bars[self.__instrument].getPrice(), bars[self.__instrument].getDateTime()))

    def exitLongSignal(self, ma_vol_diff):
        return ma_vol_diff < 0 and not self.__longPos.exitActive()

    def exitShortSignal(self, ma_vol_diff):
        return ma_vol_diff > 0 and not self.__shortPos.exitActive()

    def enterLongSignal(self, ma_vol_diff):
        return ma_vol_diff > 0

    def enterShortSignal(self, ma_vol_diff):
        return ma_vol_diff < 0


if __name__ == "__main__":
    strat = Guoxin_Vol
    instrument = '000300'
    market = 'SH daily 09.1-16.7'
    fromDate = '2009-01-01 09:35'
    toDate = '2015-12-31 15:00'
    frequency = bar.Frequency.DAY
    paras = [250, 18, 0.99]  # period, ma_period
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
    strat = strat(barfeed, instrument, *paras)
    performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
    if plot:
        plt = plotter.StrategyPlotter(strat, True, True, True)
        plt.getInstrumentSubplot(instrument).addDataSeries("RPS", strat.getRPS(), useSecondayYAxisFlag=True)
    strat.run()
    performanceAnalyzer.printPerformaceInfo()
    performanceAnalyzer.getReturnsTearSheet(live_start_date='2016-01-01')

    if plot:
        plt.plot()
