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
from pyalgotrade.technical import gftd
from pyalgotrade.tushare import data_from_tushare
from tools.performance_analyzer import performance_analyzer
from tools.date_handler import future_clearing

class GuangFa_TD(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, n1, n2, n3, info_show=True,instrumentMainFutContract = None, instrumentSubFutContract = None,futContractClearingDate=None):
        """
        n1: 买入启动或者卖出启动形态形成时候的价格比较滞后期数
        n2: 买入启动或者卖出启动形态形成时候的价格关系单向连续个数
        n3: 模型计数阶段的最终信号发出所需计数值
        """
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__close = feed[instrument].getCloseDataSeries()
        self.__high = feed[instrument].getHighDataSeries()
        self.__low = feed[instrument].getLowDataSeries()
        self.__n1 = n1
        self.__n2 = n2
        self.__n3 = n3
        self.__gftd = gftd.GFTD(self.__close, self.__n1)
        self.__longStart = False
        self.__shortStart = False
        self.__longCount = 0
        self.__shortCount = 0
        self.__longLastCount = 0
        self.__shortLastCount = 0

        self.__longPos = None
        self.__shortPos = None
        self.__info_show = info_show

        self.__useFutForClearing = (instrumentMainFutContract is not None)
        self.__instrumentMainFutContract = instrumentMainFutContract
        self.__instrumentSubFutContract =  instrumentSubFutContract
        self.__futContractClearingDate = futContractClearingDate
        self.__shortYicang = False
        self.__longYicang = False
        if self.__useFutForClearing:
            self.__code = self.__instrumentMainFutContract
        else:
            self.__code = self.__instrument

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

    def updateLongShortStartFlag(self):
        # long/ short start
        if self.__gftd[-1] == self.__n2:
            self.__shortStart = True
            self.__shortCount = 0
        if self.__gftd[-1] == - self.__n2:
            self.__longStart = True
            self.__longCount = 0

    def updateLongShortCount(self):
        self.__longLastCount = self.__longLastCount +1
        self.__shortLastCount = self.__shortLastCount +1
        if self.__shortStart:
            if self.__close[-1]<= self.__low[-3] and self.__low[-1] < self.__low[-2]:
                if self.__shortCount==0:
                    self.__shortCount = 1
                elif self.__close[-1] < self.__close[-1-self.__shortLastCount]:
                    self.__shortCount = self.__shortCount+1
                self.__shortLastCount = 0
        if self.__longStart:
            if self.__close[-1]>= self.__high[-3] and self.__high[-1] > self.__high[-2]:
                if self.__longCount==0:
                    self.__longCount = 1
                elif self.__close[-1] > self.__close[-1-self.__longLastCount]:
                    self.__longCount = self.__longCount+1
                self.__longLastCount = 0



    def onBars(self, bars):
        # wait for enough bars to be available to calc td
        if self.__gftd[-1] is None:
            return
        if (bars[self.__instrument].getDateTime().hour ==11 and bars[self.__instrument].getDateTime().minute>30) or(bars[self.__instrument].getDateTime().hour ==15 and bars[self.__instrument].getDateTime().minute>0):
            print "当前交易时间已经结束"
            self.__feed.stop()
            return
        self.updateLongShortStartFlag()
        self.updateLongShortCount()

        if self.__longCount >= self.__n3:
             if self.__shortPos is not None:
                 self.__shortPos.exitMarket()
                 if self.__info_show:
                    self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
             elif self.__longPos is None:
                 shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice())
                 self.__longPos = self.enterLong(self.__instrument, shares)
                 if self.__info_show:
                    self.info("LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
        elif self.__shortCount >= self.__n3:
             if self.__longPos is not None:
                 self.__longPos.exitMarket()
                 if self.__info_show:
                    self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
             elif self.__shortPos is None:
                 shares = int(self.getBroker().getEquity() *0.5 / bars[self.__instrument].getPrice())
                 self.__shortPos = self.enterShort(self.__instrument, shares)
                 if self.__info_show:
                    self.info("SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))



class GuangFa_TD_GAI(strategy.BacktestingStrategy):
    def __init__(self, feed, instrument, n1, n2_s, n3_s,n2_b,n3_b, info_show=True,is_stop_loss=False,count_show=False,use_info=False,instrumentMainFutContract = None, instrumentSubFutContract = None,futContractClearingDate=None,
                 tradeVol = 0.5):
        """
        n1: 买入启动或者卖出启动形态形成时候的价格比较滞后期数
        n2: 买入启动或者卖出启动形态形成时候的价格关系单向连续个数
        n3: 模型计数阶段的最终信号发出所需计数值
        """
        strategy.BacktestingStrategy.__init__(self, feed)
        self.__feed = feed
        self.__instrument = instrument
        self.getBroker().setFillStrategy(DefaultStrategy(None))
        self.getBroker().setCommission(TradePercentage(0.001))
        self.__position = None
        self.__close = feed[instrument].getCloseDataSeries()
        self.__high = feed[instrument].getHighDataSeries()
        self.__low = feed[instrument].getLowDataSeries()
        self.__n1 = n1
        self.__n2_s = n2_s
        self.__n3_s = n3_s
        self.__n2_b = n2_b
        self.__n3_b = n3_b
        self.__gftd = gftd.GFTD(self.__close, self.__n1)
        self.__longStart = False
        self.__shortStart = False
        self.__longCount = 0
        self.__shortCount = 0
        self.__longLastCount = 0
        self.__shortLastCount = 0
        self.__useSelfInfo =use_info
        self.__countShow = count_show
        self.__tradeVol = tradeVol #  默认半仓

        self.__longPos = None
        self.__shortPos = None
        self.__info_show = info_show
        self.__max = 0
        self.__min = 100000
        self.__is_stop_loss = is_stop_loss
        self.__useFutForClearing = (instrumentMainFutContract is not None)
        self.__instrumentMainFutContract = instrumentMainFutContract
        self.__instrumentSubFutContract =  instrumentSubFutContract
        self.__futContractClearingDate = futContractClearingDate
        self.__shortYicang = False
        self.__longYicang = False
        if self.__useFutForClearing:
            self.__code = self.__instrumentMainFutContract
        else:
            self.__code = self.__instrument

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

    def updateLongShortStartFlag(self,time):
        # long/ short start
        if self.__gftd[-1] == self.__n2_s:
            self.__shortStart = True
            if self.__countShow:
              print str(time)+' Short Start'
            self.__shortCount = 0
            self.__max = 0
        if self.__gftd[-1] == - self.__n2_b:
            self.__longStart = True
            if self.__countShow:
               print str(time)+' Long Start'
            self.__longCount = 0
            self.__min = 100000

    def updateLongShortCount(self,time):
        self.__longLastCount +=1
        self.__shortLastCount +=1
        if self.__shortStart:
            if self.__max <= self.__high[-1]:
                self.__max = self.__high[-1]
            if self.__close[-1]<= self.__low[-3] and self.__low[-1] < self.__low[-2]:
                if self.__shortCount==0:
                    self.__shortCount = 1
                    if self.__countShow:
                       print str(time)+' Short count: '+str(self.__shortCount)
                elif self.__close[-1] < self.__close[-1-self.__shortLastCount]:
                    self.__shortCount += 1
                    if self.__countShow:
                       print str(time)+' Short count: '+str(self.__shortCount)
                self.__shortLastCount = 0
        if self.__longStart:
            if self.__min >= self.__low[-1]:
                self.__min = self.__low[-1]
            if self.__close[-1]>= self.__high[-3] and self.__high[-1] > self.__high[-2]:
                if self.__longCount==0:
                    self.__longCount = 1
                    if self.__countShow:
                       print str(time)+' Long count: '+str(self.__longCount)
                elif self.__close[-1] > self.__close[-1-self.__longLastCount]:
                    self.__longCount += 1
                    if self.__countShow:
                      print str(time)+' Long count: '+str(self.__longCount)
                self.__longLastCount = 0



    def onBars(self, bars):
        # wait for enough bars to be available to calc td
        if self.__gftd[-1] is None:
            return
        if (bars[self.__instrument].getDateTime().hour ==11 and bars[self.__instrument].getDateTime().minute>30) or(bars[self.__instrument].getDateTime().hour ==15 and bars[self.__instrument].getDateTime().minute>0):
            print "当前交易时间已经结束"
            self.__feed.stop()
            return
        self.updateLongShortStartFlag(bars[self.__instrument].getDateTime())
        self.updateLongShortCount(bars[self.__instrument].getDateTime())
        if self.sell_stop_loss() and self.__shortPos is not None :
            self.__shortPos.exitMarket()
            if self.__info_show:
                     if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" %"SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
            return
        if self.buy_stop_loss() and self.__longPos is not None :
                 self.__longPos.exitMarket()
                 if self.__info_show:
                     if not self.__useSelfInfo:
                         print "\033[0;31m%s\033[0m" %"LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
                 return




        if self.__longCount >= self.__n3_b :
             if self.__shortPos is not None :
                 self.__shortPos.exitMarket()
                 if self.__info_show:
                     if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" %"SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("SHORT close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
             elif self.__longPos is None:
                 shares = int(self.getBroker().getEquity() *self.__tradeVol / bars[self.__instrument].getPrice())
                 self.__longPos = self.enterLong(self.__instrument, shares)
                 if self.__info_show:
                     if not self.__useSelfInfo:
                        print "\033[0;31m%s\033[0m" %"LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() )
                     else:
                         self.info("LONG open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime() ))
        elif self.__shortCount >= self.__n3_s :
             if self.__longPos is not None:
                 self.__longPos.exitMarket()
                 if self.__info_show:
                     if not self.__useSelfInfo:
                         print "\033[0;31m%s\033[0m" %"LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                     else:
                         self.info("LONG close at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))
             elif self.__shortPos is None:
                 shares = int(self.getBroker().getEquity() *self.__tradeVol/ bars[self.__instrument].getPrice())
                 self.__shortPos = self.enterShort(self.__instrument, shares)
                 if self.__info_show:
                       if not self.__useSelfInfo:
                           print "\033[0;31m%s\033[0m" %"SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime())
                       else:
                           self.info("SHORT open at $%.2f at %s" % (bars[self.__instrument].getPrice(),bars[self.__instrument].getDateTime()))

    def sell_stop_loss(self):
        return self.__is_stop_loss and (self.__close[-1]>=self.__max)

    def buy_stop_loss(self):
        return self.__is_stop_loss and (self.__close[-1]<=self.__min)






if __name__ == "__main__":
    strat = GuangFa_TD_GAI
    instrument = '000905'
    market = 'SH daily 16.1-16.7'
    fromDate = '2014-07-01 09:35'
    toDate ='2016-06-03 15:00'
    frequency = bar.Frequency.DAY
    #paras = [5,3,8,2,5,True,False]   #千一的参数

    paras = [8,7,2,7,2,True,False, False, False, None, None, None, 0.99]
    plot = True
    source = 'csv'
    futClearingDate = future_clearing.get_ic_contract_clearing_date()

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
        #barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
        barfeed.setDateTimeFormat('%Y/%m/%d')
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

