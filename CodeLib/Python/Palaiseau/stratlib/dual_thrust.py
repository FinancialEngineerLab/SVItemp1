# -*- coding: utf-8 -*-

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
from pyalgotrade.tushare import data_from_tushare
from tools.performance_analyzer import performance_analyzer


class Dual_Thrust(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, nx,kx, ns,ks,info_show=True):
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__info_show = info_show
        self.__longPos = None
        self.__shortPos = None

        self.__nx = nx  # 下轨天数
        self.__kx = kx  # 下轨系数
        self.__ns = ns  # 上轨天数
        self.__ks = ks  # 上轨系数

        self.__datetime = feed[instrument].getDateTimes()
        self.__open = feed[instrument].getOpenDataSeries()
        self.__high = feed[instrument].getHighDataSeries()
        self.__low = feed[instrument].getLowDataSeries()
        self.__close = feed[instrument].getCloseDataSeries()

        self.__openD = []
        self.__highD = []
        self.__lowD = []
        self.__closeD = []
        self.__upper_limit = []
        self.__lower_limit = []

        self.__shangguiD = None
        self.__xiaguiD = None

    def getDateTimeSeries(self):
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
        if self.__longPos == position:
            self.__longPos = None
        elif self.__shortPos == position:
            self.__shortPos = None
        else:
            assert(False)


    def onBars(self, bars):
        # If a position was not opened, check if we should enter a long position.
        self.dayInfo(bars[self.__instrument])

        if self.__shangguiD is None or self.__xiaguiD is None:
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

        #print bars[self.__instrument].getDateTime(), self.__shangguiD[-1], self.__xiaguiD[-1]


    def dayInfo(self, bar):

        if len(self.__datetime) < 2:
            self.__openD.append(bar.getOpen())
            self.__highD.append(self.__high[-1])
            self.__lowD.append(self.__low[-1])
            self.__closeD.append(self.__close[-1])
            return

        # if another day
        if self.__datetime[-1].date() != self.__datetime[-2].date():
            self.__openD.append(bar.getOpen())
            self.__highD.append(self.__high[-1])
            self.__lowD.append(self.__low[-1])
            self.__closeD.append(self.__close[-1])
            self.__upper_limit.append(round(round(self.__closeD[-2] * 1.1 * 1000) / 10) / 100)
            self.__lower_limit.append(round(round(self.__closeD[-2] * 0.9 * 1000) / 10) / 100)
            print self.__datetime[-1].date(), self.__datetime[-2].date(), self.__openD[-1]

            self.getShanggui()
            self.getXiagui()

        elif self.__datetime[-1].date() == self.__datetime[-2].date():
            if self.__high[-1] > self.__highD[-1]:
                self.__highD[-1] = self.__high[-1]
            if self.__low[-1] < self.__lowD[-1]:
                self.__lowD[-1] = self.__low[-1]
            self.__closeD[-1] = self.__close[-1]

    def getXiagui(self):
        if self.__openD is None or len(self.__openD) < self.__nx:
            return

        if self.__xiaguiD is None:
            self.__xiaguiD = []

        nhs = self.__highD[-self.__nx-1:-1]
        ncs = self.__closeD[-self.__nx-1:-1]
        nls = self.__lowD[-self.__nx-1:-1]
        nhh = max(nhs)
        nhc = max(ncs)
        nlc = min(ncs)
        nll = min(nls)
        ranges = max(nhh-nlc,nhc-nll)
        xiagui = self.__openD[-1] -self.__kx * ranges
        self.__xiaguiD.append(xiagui)

    def getShanggui(self):
        if self.__openD is None or len(self.__openD) < self.__ns:
            return

        if self.__shangguiD is None:
            self.__shangguiD = []

        nhs = self.__highD[-self.__ns-1:-1]
        ncs = self.__closeD[-self.__ns-1:-1]
        nls = self.__lowD[-self.__ns-1:-1]
        nhh = max(nhs)
        nhc = max(ncs)
        nlc = min(ncs)
        nll = min(nls)
        ranges = max(nhh-nlc,nhc-nll)
        shanggui = self.__openD[-1] + self.__ks * ranges
        self.__shangguiD.append(shanggui)

    def exitLongSignal(self, bars):
        return bars[self.__instrument].getPrice() < self.__xiaguiD[-1]

    def enterLongSignal(self, bars):
        return bars[self.__instrument].getPrice() > self.__shangguiD[-1]

    def enterShortSignal(self, bars):
        return bars[self.__instrument].getPrice() < self.__xiaguiD[-1]

    def exitShortSignal(self, bars):
        return bars[self.__instrument].getPrice() > self.__shangguiD[-1]



if __name__ == "__main__":
    strat = Dual_Thrust
    instrument = '000905'
    market = 'SH 2015'
    fromDate = '2014-07-01 09:35'
    toDate ='2016-06-03 15:00'
    frequency = bar.Frequency.MINUTE_FIVE
    paras = [2, 0.4, 3, 0.2, False]   #nx,kx, ns,ks

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
