from stratlib import  gf_llt
from unittest import TestCase
from pyalgotrade import bar
from pyalgotrade.barfeed.csvfeed import GenericBarFeed
from tools.performance_analyzer import performance_analyzer


class TestLLT(TestCase):

    def test_llt(self):
       frequency = bar.Frequency.DAY
       path = "..//data//000001SH.csv"
       barfeed = GenericBarFeed(frequency)
       barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
       barfeed.addBarsFromCSV('000001', path)
       strat = gf_llt.Guangfa_LLT(barfeed,'000001',0.03,3,2,2,0.08,info_show=False)
       performanceAnalyzer = performance_analyzer.performanceDataSet(strat)
       strat.run()

       output_trade_number = performanceAnalyzer.getCount()
       output_cum_return = round(float(performanceAnalyzer.getCumulReturns()[-1,1]),3)
       output_win_ratio = round(performanceAnalyzer.getWinningRatio(),3)
       self.assertEqual(output_trade_number, 204)
       self.assertEqual(output_cum_return, -0.522)
       self.assertEqual(output_win_ratio, 48.039)
