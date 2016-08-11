from stratlib import  gftd_cta
from unittest import TestCase
from pyalgotrade import bar
from pyalgotrade.barfeed.csvfeed import GenericBarFeed
from tools.performance_analyzer import performance_analyzer


class TestGFTD(TestCase):

    def test_GF_TD(self):
       frequency = bar.Frequency.MINUTE_FIVE
       paras = [4,4,4,False]
       path = "..//data//000905SH.csv"
       barfeed = GenericBarFeed(frequency)
       barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
       barfeed.addBarsFromCSV('000905', path)
       strat = gftd_cta.GuangFa_TD(barfeed,'000905',*paras)
       performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
       strat.run()

       output_trade_number = performanceAnalyzer.getCount()
       output_cum_return = round(float(performanceAnalyzer.getCumulReturns()[-1,1]),3)
       output_win_ratio = round(performanceAnalyzer.getWinningRatio(),3)
       self.assertEqual(output_trade_number, 32)
       self.assertEqual(output_cum_return, 0.002)
       self.assertEqual(output_win_ratio, 40.625)

