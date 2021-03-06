from unittest import TestCase
from pyalgotrade import bar
from tools.performance_analyzer import performance_analyzer
from test_Palaiseau.test_tools_performance_analyzer import  example_start
from pyalgotrade.barfeed.csvfeed import GenericBarFeed

class TestPerformanceAnalyzer(TestCase):

    def test_peformance_analyzer(self):
        instrument = '000001'
        frequency = bar.Frequency.DAY
        barfeed = GenericBarFeed(frequency)
        barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
        barfeed.addBarsFromCSV(instrument, '..//data//000001SH.csv')
        strat1 = example_start.Example_Strat(barfeed, instrument)
        performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
        strat1.run()
        output_trade_number = performanceAnalyzer.getCount()
        output_cum_return = round(float(performanceAnalyzer.getCumulReturns()[-1,1]),3)
        output_win_ratio = round(performanceAnalyzer.getWinningRatio(),3)
        output_Annual_return = round(performanceAnalyzer.getAnnualReturn(),3)
        output_Sharpe_ratio = round(performanceAnalyzer.getSharpeRatio(),3)
        output_Max_drawdown = round(performanceAnalyzer.getMaxDrawdown(),3)
        output_calmar_ratio = round(performanceAnalyzer.getCalmarRatio(),3)
        self.assertEqual(output_trade_number, 2)
        self.assertEqual(output_cum_return,-0.020)
        self.assertEqual(output_win_ratio, 0.000)
        self.assertEqual(output_Annual_return, -0.002)
        self.assertEqual(output_Sharpe_ratio, -1.441)
        self.assertEqual(output_Max_drawdown, 0.113)
        self.assertEqual(output_calmar_ratio,-0.019)

