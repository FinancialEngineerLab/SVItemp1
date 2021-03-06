from stratlib import  gftd_cta
from unittest import TestCase
from pyalgotrade import bar
from pyalgotrade.barfeed.csvfeed import GenericBarFeed
from tools.performance_analyzer import performance_analyzer


class TestGFTDGAI(TestCase):

    def test_GF_TD_GAI(self):
       frequency = bar.Frequency.MINUTE_FIVE
       paras = [4,4,2,4,2,False]
       path = "..//data//000905SH.csv"
       barfeed = GenericBarFeed(frequency)
       barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
       barfeed.addBarsFromCSV('000905', path)
       strat = gftd_cta.GuangFa_TD_GAI(barfeed,'000905',*paras)
       performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
       strat.run()

       output_trade_number = performanceAnalyzer.getCount()
       output_cum_return = round(float(performanceAnalyzer.getCumulReturns()[-1,1]),3)
       output_win_ratio = round(performanceAnalyzer.getWinningRatio(),3)
       self.assertEqual(output_trade_number, 54)
       self.assertEqual(output_cum_return, -0.09)
       self.assertEqual(output_win_ratio, 31.481)
