from stratlib import  hurst
from unittest import TestCase
from pyalgotrade import bar
from pyalgotrade.barfeed.csvfeed import GenericBarFeed
from tools.performance_analyzer import performance_analyzer


class TestHurst(TestCase):

    def test_Hurst(self):
       frequency = bar.Frequency.DAY
       path = "..//data//000001SH.csv"
       barfeed = GenericBarFeed(frequency)
       barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
       barfeed.addBarsFromCSV('000001', path)
       strat = hurst.HurstStrategy(barfeed,'000001',240)
       performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
       strat.run()

       output_trade_number = performanceAnalyzer.getCount()
       output_cum_return = round(float(performanceAnalyzer.getCumulReturns()[-1,1]),3)
       output_win_ratio = round(performanceAnalyzer.getWinningRatio(),3)
       self.assertEqual(output_trade_number, 20)
       self.assertEqual(output_cum_return, -0.222)
       self.assertEqual(output_win_ratio, 45.000)
