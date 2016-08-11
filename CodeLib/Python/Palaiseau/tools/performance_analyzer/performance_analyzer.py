# -*- coding: utf-8 -*-
import matplotlib.gridspec as gridspec
import matplotlib.pyplot as plt

from pyalgotrade import dataseries
from pyalgotrade.stratanalyzer import returns, sharpe, drawdown, trades
from tools import qrisk
from tools.data_handler import dataseries_to_nparray, timeseries
from tools.date_handler import date_conversion
from tools.plot import plot_pyfolio


# 返回pyalgo策略对象的数据集
# strategy 中需要添加 getInfo等函数
class performanceDataSet():
    def __init__(self, myStrategy):
        self.__myStrategy = myStrategy
        self.returnsAnalyzer = returns.Returns()
        self.sharpeRatioAnalyzer = sharpe.SharpeRatio()
        self.drawdownAnalyzer = drawdown.DrawDown()
        self.tradeAnalyzer = trades.Trades()

        myStrategy.attachAnalyzer(self.returnsAnalyzer)
        myStrategy.attachAnalyzer(self.sharpeRatioAnalyzer)
        myStrategy.attachAnalyzer(self.drawdownAnalyzer)
        myStrategy.attachAnalyzer(self.tradeAnalyzer)

    def getPerformanceDefaultData(self):
        __returns = self.getReturns()  # returns, array
        __cumulReturns = self.getCumulReturns()  # cumul returns, array
        __sharpeRatio = self.getSharpeRatio()
        __maxDrawDown = self.getMaxDrawdown()
        __tradeInfo = self.getInfo()
        return {"returns": __returns, "cumulativeReturns": __cumulReturns, "sharpeRatio": __sharpeRatio,
                "maxDrawdown": __maxDrawDown}

    def getInfo(self):
        return self.__myStrategy.getInfo()

    def getTimeSeries(self):
        return self.__myStrategy.getDateTimeSeries()

    def getCumulReturns(self):
        return dataseries_to_nparray.change_data_series_to_np_array(self.returnsAnalyzer.getCumulativeReturns(),
                                                                    time_series=self.getTimeSeries())

    def getReturns(self):
        return dataseries_to_nparray.change_data_series_to_np_array(self.returnsAnalyzer.getReturns(),
                                                                    time_series=self.getTimeSeries())

    def getAnnualReturn(self):
        return self.returnsAnalyzer.getAnnualReturn()

    def getCalmarRatio(self):
        if not self.getMaxDrawdown() == 0.0:
            return self.getAnnualReturn() / self.getMaxDrawdown()
        else:
            return -100000

    def getSharpeRatio(self):
        return self.sharpeRatioAnalyzer.getSharpeRatio(riskFreeRate=0.05)

    def getLongestDrawdownDuration(self):
        return self.drawdownAnalyzer.getLongestDrawDownDuration()

    def getMaxDrawdown(self):
        return self.drawdownAnalyzer.getMaxDrawDown()

    def getCount(self):
        return self.tradeAnalyzer.getCount()  # trades numbers, int

    def getProfitableCount(self):
        return self.tradeAnalyzer.getProfitableCount()

    def getUnprofitableCount(self):
        return self.tradeAnalyzer.getUnprofitableCount()

    def getEvenCount(self):
        return self.tradeAnalyzer.getEvenCount()  # zero-profit trades numbers, int

    def getAll(self):  # pandas format, 可使用to_json
        info = self.getInfo()
        info = info[['date', 'instrument', 'id']][info['action'] == 3]
        info['All'] = self.tradeAnalyzer.getAll()
        return info  # 每笔交易的盈利和损失, dataframe

    def getProfits(self):
        all_info = self.getAll()
        return all_info[all_info['All'] > 0]  # 每笔交易盈利, dataframe

    def getLosses(self):
        all_info = self.getAll()
        return all_info[all_info['All'] < 0]

    def getAllReturns(self):
        info = self.getInfo()
        returns = self.tradeAnalyzer.getAllReturns().tolist()
        len = returns.__len__()
        action = []
        CumulReturns = []
        All_CumulReturns = self.getCumulReturns()
        j = 0

        if not info.empty:
            if (info.index[-1] % 2) != 0:
                for i in range(0, len):
                    returns.insert(2 * i, 0)
                for i in range(0, 2 * len):
                    actionCode = self.mapToActionCode(info['action'][i])
                    action.append(actionCode)
                for i in range(0, All_CumulReturns.__len__()):
                    if j < 2 * len and All_CumulReturns[i][0] == info['date'][j]:
                        j += 1
                        CumulReturns.append(All_CumulReturns[i][1])
            else:
                for i in range(0, len + 1):
                    returns.insert(2 * i, 0)
                for i in range(0, 2 * len + 1):
                    actionCode = self.mapToActionCode(info['action'][i])
                    action.append(actionCode)
                for i in range(0, All_CumulReturns.__len__()):

                    if j < 2 * len + 1 and All_CumulReturns[i][0] == info['date'][j]:
                        j += 1
                        CumulReturns.append(All_CumulReturns[i][1])

        info['CumulReturns'] = CumulReturns
        info['AllReturn'] = returns
        info['action'] = action

        return info  # 每笔交易回报率, pandas

    def getPositiveReturns(self):
        allReturn = self.getAllReturns()
        return allReturn[allReturn["AllReturn"] > 0]  # 每笔交易盈利 dataFrame

    def getNegativeReturns(self):
        allReturn = self.getAllReturns()
        return allReturn[allReturn["AllReturn"] < 0]  # 每笔交易盈利 dataFrame

    def getCommisionsForAllTrades(self):
        return self.tradeAnalyzer.getCommissionsForAllTrades()  # return a numpy.array with commisions for each trade

    def getCommissionsForProfitableTrades(self):
        return self.tradeAnalyzer.getCommissionsForProfitableTrades()

    def getCommissionsForUnprofitableTrades(self):
        return self.tradeAnalyzer.getCommissionsForUnprofitableTrades()

    def getCommissionsForEvenTrades(self):
        return self.tradeAnalyzer.getCommissionsForEvenTrades()

    def getWinningRatio(self):
        if self.getCount() > 0:
            return float(self.getProfitableCount()) / self.getCount() * 100
        else:
            return 0

    def mapToActionCode(self, infoCode):
        if infoCode == 1:
            return '多开'
        elif infoCode == 2:
            return '空平'
        elif infoCode == 3:
            return '多平'
        elif infoCode == 4:
            return '空开'

    def printPerformaceInfo(self):
        print "Cumulative return: %.3f" % float(self.getCumulReturns()[-1, 1])
        print "Annual return: %.3f" % self.getAnnualReturn()
        print "Sharpe ratio: %.3f" % self.getSharpeRatio()
        print "Max drawdown: %.3f" % self.getMaxDrawdown()
        print "Longest drawdown duration: %s" % self.getLongestDrawdownDuration()
        print "Trade numbers: %.d" % self.getCount()
        print "the of percentage of Win: %.3f %%" % self.getWinningRatio()
        # 年化收益除以最大回撤
        print "Calmar ratio: %.3f" % self.getCalmarRatio()
        print "All returns: "
        print self.getAllReturns()

    # tear sheet plot
    def getDailyReturnsInPandasSeries(self, returns, force_index_to_dt=True):
        '''
        :param returns: higher frequency returns than daily returns(pandas series type)
        :param force_daily_freq:
        :return:
        '''
        ret = timeseries.aggregate_returns(returns, 'daily')
        if force_index_to_dt:
            if type(ret.index[0]) is tuple:
                ret.index = date_conversion.change_tuple_format_to_datetime(ret.index)
        return ret

    def getStrategyReturnsInPandasSeries(self, force_daily_freq=False):
        returns_pd_series = dataseries_to_nparray.change_data_series_to_pd_series(self.returnsAnalyzer.getReturns(),
                                                                                  time_series=self.getTimeSeries())
        if force_daily_freq:
            ret = self.getDailyReturnsInPandasSeries(returns_pd_series)
        else:
            ret = returns_pd_series

        return ret

    def plotMonthlyHeapMap(self, ax=None):
        returns_pd_series = self.getReturnsInPandasSeries()
        plot_pyfolio.plot_monthly_returns_heatmap(returns_pd_series, ax)
        return

    def plotMonthlyDist(self, ax=None):
        returns_pd_series = self.getReturnsInPandasSeries()
        plot_pyfolio.plot_montly_return_dist(returns_pd_series, ax)
        return

    def getBenchmarkReturn(self):
        prices = self.__myStrategy.getFeed().getDataSeries().getCloseDataSeries()
        benchmarkReturns = dataseries.SequenceDataSeries()
        benchmarkReturns.append(0.0)
        i = 1
        while i < len(prices):
            benchmarkReturns.append((prices[i] - prices[i - 1]) / prices[i - 1])
            i += 1
        return benchmarkReturns

    def getBenchmarkReturnInPandasSeries(self, force_daily_freq=False):
        benchmarkReturns = self.getBenchmarkReturn()
        benchmark_ret = dataseries_to_nparray.change_data_series_to_pd_series(benchmarkReturns,
                                                                              time_series=self.getTimeSeries())
        if force_daily_freq:
            ret = self.getDailyReturnsInPandasSeries(benchmark_ret)
        else:
            ret = benchmark_ret
        return ret

    def getReturnsTearSheet(self, benchmark_rets=None, live_start_date='2016-01-01', cone_std=(1.0, 1.5, 2.0),
                            bootstrap=False):
        """
        Generate a number of plots for analyzing a strategy's returns.
        - Fetches benchmarks, then creates the plots on a single figure.
        - Plots: rolling returns (with cone), rolling beta, rolling sharpe,
            rolling Fama-French risk factors, drawdowns, underwater plot, monthly
            and annual return plots, daily similarity plots,
            and return quantile box plot.
        - Will also print the start and end dates of the strategy,
            performance statistics, drawdown periods, and the return range.
        Parameters
        ----------
        """

        vertical_sections = 4
        returns_pd_series = self.getStrategyReturnsInPandasSeries(force_daily_freq=True)

        if benchmark_rets is None:
            benchmark_rets = self.getBenchmarkReturnInPandasSeries(force_daily_freq=True)
            # If the strategy's history is longer than the benchmark's, limit
            # strategy
            if returns_pd_series.index[0] < benchmark_rets.index[0]:
                returns_pd_series = returns_pd_series[returns_pd_series.index > benchmark_rets.index[0]]

        df_cum_rets = qrisk.cum_returns(returns_pd_series, starting_value=1)
        benchmark_rets.name = 'BenchmarkIndex'

        print("Entire data start date: " + str(df_cum_rets.index[0].strftime('%Y-%m-%d')))
        print("Entire data end date: " + str(df_cum_rets.index[-1].strftime('%Y-%m-%d')))
        print('\n')

        if live_start_date is not None:
            live_start_date = date_conversion.get_utc_timestamp(live_start_date)

        plot_pyfolio.show_perf_stats(returns_pd_series, benchmark_rets,
                                     bootstrap=bootstrap,
                                     live_start_date=live_start_date,
                                     split_factor_returns=True)

        vertical_sections = 12

        if live_start_date is not None:
            vertical_sections += 1
            # live_start_date = date_conversion.get_utc_timestamp(live_start_date)

        if bootstrap:
            vertical_sections += 1

        # fig = plt.figure(figsize=(14, vertical_sections * 6))
        # gs = gridspec.GridSpec(vertical_sections, 3, wspace=0.5, hspace=1)
        fig = plt.figure(figsize=(14, 4 * 6))
        gs = gridspec.GridSpec(4, 3, wspace=0.5, hspace=1)
        ax_rolling_returns = plt.subplot(gs[:2, :])
        ax_drawdown = plt.subplot(gs[2, :], sharex=ax_rolling_returns)
        ax_underwater = plt.subplot(gs[3, :], sharex=ax_rolling_returns)

        # fig2 = plt.figure(figsize=(14, vertical_sections * 6))
        # gs2 = gridspec.GridSpec(vertical_sections - 1, 3, wspace=0.5, hspace=1)
        fig2 = plt.figure(figsize=(14, 3 * 6))
        gs2 = gridspec.GridSpec(2, 3, wspace=0.5, hspace=1)    # there exists 2 block, and split the window into 2*3
        ax_monthly_heatmap = plt.subplot(gs2[0, 0])
        ax_annual_returns = plt.subplot(gs2[0, 1])
        ax_monthly_dist = plt.subplot(gs2[0, 2])
        ax_return_quantiles = plt.subplot(gs2[1, :])
        # cumul returns

        plot_pyfolio.plot_rolling_returns(returns_pd_series, factor_returns=benchmark_rets,
                                          live_start_date=live_start_date, cone_std=cone_std, ax=ax_rolling_returns)
        ax_rolling_returns.set_title('Cumulative Returns')

        # Drawdowns, frequency = daily
        plot_pyfolio.plot_drawdown_periods(returns_pd_series, top=5, ax=ax_drawdown)
        plot_pyfolio.plot_drawdown_underwater(returns_pd_series, ax=ax_underwater)
        plot_pyfolio.show_worst_drawdown_periods(returns_pd_series)

        # return range, frequency = weekly
        returns_pd_series_weekly = timeseries.aggregate_returns(returns_pd_series, 'weekly')
        print('\n')
        plot_pyfolio.show_return_range(returns_pd_series, returns_pd_series_weekly)

        # monthly/annual returns
        plot_pyfolio.plot_monthly_returns_heatmap(returns_pd_series, ax=ax_monthly_heatmap)
        plot_pyfolio.plot_annual_returns(returns_pd_series, ax=ax_annual_returns)
        plot_pyfolio.plot_monthly_returns_dist(returns_pd_series, ax=ax_monthly_dist)

        # quantile
        returns_pd_series_monthly = timeseries.aggregate_returns(returns_pd_series, 'monthly')
        plot_pyfolio.plot_return_quantiles(
            returns_pd_series,
            returns_pd_series_weekly,
            returns_pd_series_monthly,
            ax=ax_return_quantiles)

        for ax in fig.axes:
            plt.setp(ax.get_xticklabels(), visible=True)

        for ax in fig2.axes:
            plt.setp(ax.get_xticklabels(), visible=True)

        plt.show()

        return
