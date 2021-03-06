# -*- coding: utf-8 -*-

import pandas as pd
from pyalgotrade import bar
from pyalgotrade.tushare import data_from_tushare
from pyalgotrade.tushare import dataframe_barfeed
from tools.performance_analyzer import performance_analyzer
from tools.data_handler import datarange
from trendfollow_quantopian import TrendFollow
from bollinger_bandit import  Bollinger_Bandit
from gf_llt import Guangfa_LLT
from gftd_cta import GuangFa_TD,GuangFa_TD_GAI
from pyalgotrade.barfeed.csvfeed import GenericBarFeed
from svmLag import SVMLag
from guoxin_vol import Guoxin_Vol
import random

def trendfollow_strat_optimization(strat,frequency,instrument,market,fromDate,toDate,source,reg_length,slope_min_pos,slope_min_neg,max_drawdown):

    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)

    testInfo = pd.DataFrame(columns={'test_id','reg_length','slope_min_pos','slope_min_neg','cumul_return',
                                         'Max_drawdown','win_ratio','trade_count'})
    test_id = 1
    for reg_length_param in reg_length:
         for slope_min_pos_param in slope_min_pos:
            for slope_min_neg_param in slope_min_neg:
                testParamsSet = [reg_length_param, 3, slope_min_pos_param, slope_min_neg_param,max_drawdown,150,False]
                if source == 'tushare':
                    barfeed = dataframe_barfeed.Feed(frequency)
                    barfeed.addBarsFromDataFrame(instrument, data_df)
                else:
                    barfeed = GenericBarFeed(frequency)
                    barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
                    barfeed.addBarsFromCSV(instrument, filepath)
                strat1 = strat(barfeed , instrument, *testParamsSet)
                performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                strat1.run()
                if performanceAnalyzer.getCount()!=0:
                    temp = pd.Series([test_id,reg_length_param,slope_min_pos_param,slope_min_neg_param,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                         index=['test_id','reg_length','slope_min_pos','slope_min_neg','cumul_return','Max_drawdown','win_ratio','trade_count'])
                    test_id += 1
                    testInfo=testInfo.append(temp,ignore_index=True)
                    print temp


    print  testInfo
    testInfo.to_csv('D://Workarea//Palaiseau//ZZ500 .csv')

def GuangFa_TD_strat_optimization(strat,frequency,instrument,market,fromDate,toDate,source,n1,n2,n3):

    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)

    testInfo = pd.DataFrame(columns={'test_id','n1','n2','n3','cumul_return',
                                         'Max_drawdown','win_ratio','trade_count'})
    test_id = 5
    for i in n1:
         for j in n2:
            for k in n3:
                if source == 'tushare':
                    barfeed = dataframe_barfeed.Feed(frequency)
                    barfeed.addBarsFromDataFrame(instrument, data_df)
                else:
                    barfeed = GenericBarFeed(frequency)
                    barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
                    barfeed.addBarsFromCSV(instrument, filepath)
                strat1 = strat(barfeed , instrument, i,j,k,False)
                performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                strat1.run()
                if performanceAnalyzer.getCount()!=0:
                    temp = pd.Series([test_id,i,j,k,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                         index=['test_id','n1','n2','n3','cumul_return','Max_drawdown','win_ratio','trade_count'])
                    test_id += 1
                    testInfo=testInfo.append(temp,ignore_index=True)
                    print  temp


    print  testInfo
    testInfo.to_csv('D://Workarea//Palaiseau//ZZ500 2015.csv')

def GuangFa_TD_Gai_strat_optimization(strat,frequency,instrument,market,fromDate,toDate,source,n1,n2_s,n3_s,n2_b,n3_b):

    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)

    testInfo = pd.DataFrame(columns={'test_id','n1','n2_s','n3_s','n2_b','n3_b','cumul_return',
                                         'Max_drawdown','win_ratio','trade_count'})
    test_id = 1
    for i in n1:
         for j in n2_s:
            for k in n3_s:
              for m in n2_b:
               for n in n3_b:
                if source == 'tushare':
                    barfeed = dataframe_barfeed.Feed(frequency)
                    barfeed.addBarsFromDataFrame(instrument, data_df)
                else:
                    barfeed = GenericBarFeed(frequency)
                    barfeed.setDateTimeFormat('%Y/%m/%d')
                    barfeed.addBarsFromCSV(instrument, filepath)
                strat1 = strat(barfeed , instrument, i,j,k,m,n,False)
                performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                strat1.run()
                if performanceAnalyzer.getCount()!=0:
                    temp = pd.Series([test_id,i,j,k,m,n,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                         index=['test_id','n1','n2_s','n3_s','n2_b','n3_b','cumul_return','Max_drawdown','win_ratio','trade_count'])
                    test_id += 1
                    testInfo=testInfo.append(temp,ignore_index=True)
                    print  temp


    print  testInfo
    testInfo.to_csv('D://Workarea//RB gai 8.csv')


def llt_strat_optimization(strat,frequency,instrument,market,fromDate,toDate,source,alpha,slope_min_pos,slope_min_neg,per):

    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY or frequency ==bar.Frequency.HOUR:
        path = "..//histdata//day//"

    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate,ktype='60')

    testInfo = pd.DataFrame(columns={'test_id','alpha','slope_long','slope_short','cumul_return',
                                         'Max_drawdown','win_ratio','trade_count','per'})
    test_id = 1
    for a in alpha:
      for p in per:
       for slope_min_pos_param in slope_min_pos:
            for slope_min_neg_param in slope_min_neg:
                testParamsSet = [a, 3,slope_min_pos_param, slope_min_neg_param,p,False]
                if source == 'tushare':
                    barfeed = dataframe_barfeed.Feed(frequency)
                    barfeed.addBarsFromDataFrame(instrument, data_df)
                else:
                    barfeed = GenericBarFeed(frequency)
                    barfeed.setDateTimeFormat('%Y/%m/%d')
                    barfeed.addBarsFromCSV(instrument, filepath)
                strat1 = strat(barfeed , instrument, *testParamsSet)
                performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                strat1.run()
                if performanceAnalyzer.getCount()!=0:
                    temp = pd.Series([test_id,a,slope_min_pos_param,slope_min_neg_param,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount(),p],
                                         index=['test_id','alpha','slope_long','slope_short','cumul_return','Max_drawdown','win_ratio','trade_count','per'])
                    test_id += 1
                    testInfo=testInfo.append(temp,ignore_index=True)
                    print temp

    print  testInfo
    testInfo.to_csv('D://llt_hs300.csv')

def bolliger_bandit_strat_optimization(strat, frequency, instrument, market, fromDate, toDate, source, bollingerlength,
                                       numStdDev, closelength, ccMAlength, malength, space ):
    if frequency == bar.Frequency.MINUTE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)

    testInfo = pd.DataFrame(columns={'test_id','boll_length','num_std','close_length','cc_malength',
                                         'ma_length','space', 'cumul_return','Max_drawdown','win_ratio','trade_count'})
    test_id = 1
    for boll_length_param in bollingerlength:
        for num_std_param in numStdDev:
            for close_length_param in closelength:
                for cc_malength_param in ccMAlength:
                    for malength_param in malength:
                        for space_param in space:
                            testParamsSet = [boll_length_param, num_std_param, close_length_param, cc_malength_param,malength_param,space_param]
                            if source == 'tushare':
                                barfeed = dataframe_barfeed.Feed(frequency)
                                barfeed.addBarsFromDataFrame(instrument, data_df)
                            else:
                                barfeed = GenericBarFeed(frequency)
                                barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
                                barfeed.addBarsFromCSV(instrument, filepath)
                            strat1 = strat(barfeed, instrument, *testParamsSet)
                            performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                            strat1.run()
                            if performanceAnalyzer.getCount()!=0:
                                temp = pd.Series([test_id,boll_length_param,num_std_param,close_length_param, cc_malength_param, malength_param, space_param,
                                                  performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                                     index=['test_id','boll_length','num_std','close_length','cc_malength','ma_length','space', 'cumul_return','Max_drawdown','win_ratio','trade_count'])
                                test_id += 1
                                testInfo = testInfo.append(temp,ignore_index=True)
    print  testInfo
    testInfo.to_csv('C:HS300_boll.csv')



def svm_strat_optimization(strat, frequency, instrument, market, fromDate, toDate, source, periodVector,  svmProbaThreshVector, lagVectorShort,
                           lagVectorLong ):
    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY:
        path = "..//histdata//day//"
    filepath = path + instrument + market + ".csv"

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate)


    testInfo = pd.DataFrame(columns={'test_id','period','svm_proba_thresh','lag_vector','cumul_return',
                                         'max_drawdown','win_ratio','trade_count'})
    test_id = 1
    for period in periodVector:
        for probaThresh in svmProbaThreshVector:
            for i in range(0,50):
                list_of_lagVector = random.sample(lagVectorShort, 2) + random.sample(lagVectorLong, 2)
                print list_of_lagVector
                testParamsSet = [period, probaThresh, list_of_lagVector]
                if source == 'tushare':
                    barfeed = dataframe_barfeed.Feed(frequency)
                    barfeed.addBarsFromDataFrame(instrument, data_df)
                else:
                    barfeed = GenericBarFeed(frequency)
                    barfeed.setDateTimeFormat('%Y/%m/%d %H:%M')
                    barfeed.addBarsFromCSV(instrument, filepath)
                strat1 = strat(barfeed , instrument, *testParamsSet)
                performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
                strat1.run()
                if performanceAnalyzer.getCount()!=0:
                    temp = pd.Series([test_id,period,probaThresh,list_of_lagVector,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                         index=['test_id','period','svm_proba_thresh','lag_vector','cumul_return','max_drawdown','win_ratio','trade_count'])
                    print temp
                    test_id += 1
                    testInfo=testInfo.append(temp,ignore_index=True)

    print  testInfo
    testInfo.to_csv('D://Workarea//Beiwaitan//CodeLib//Python//Palaiseau//svm.csv')


def guoxin_vol_strat_optimization(strat,frequency,instrument,market,fromDate,toDate,source,rps_period,rps_ma_period):

    if frequency == bar.Frequency.MINUTE_FIVE:
        path = "..//histdata//min//"
    elif frequency == bar.Frequency.DAY or frequency ==bar.Frequency.HOUR:
        path = "..//histdata//day//"

    filepath = path + instrument + market + ".csv"

    from pyalgotrade.barfeed.csvfeed import GenericBarFeed

    if source == 'tushare':
        data_df = data_from_tushare.get_kdata_from_tushare(instrument, fromDate, toDate,ktype='60')

    testInfo = pd.DataFrame(columns={'test_id','rps_period','rps_ma_period','cumul_return',
                                         'Max_drawdown','win_ratio','trade_count','per'})
    test_id = 1
    for period in rps_period:
      for ma_period in rps_ma_period:
            testParamsSet = [period, ma_period]
            if source == 'tushare':
                barfeed = dataframe_barfeed.Feed(frequency)
                barfeed.addBarsFromDataFrame(instrument, data_df)
            else:
                barfeed = GenericBarFeed(frequency)
                barfeed.setDateTimeFormat('%Y/%m/%d')
                barfeed.addBarsFromCSV(instrument, filepath)
            strat1 = strat(barfeed , instrument, *testParamsSet)
            performanceAnalyzer = performance_analyzer.performanceDataSet(strat1)
            strat1.run()
            if performanceAnalyzer.getCount()!=0:
                temp = pd.Series([test_id,period,ma_period,performanceAnalyzer.getCumulReturns()[-1,1],performanceAnalyzer.getMaxDrawdown(),performanceAnalyzer.getWinningRatio(),performanceAnalyzer.getCount()],
                                     index=['test_id','rps_period','rps_ma_period','cumul_return','Max_drawdown','win_ratio','trade_count'])
                test_id += 1
                testInfo=testInfo.append(temp,ignore_index=True)
                print temp

    print  testInfo
    testInfo.to_csv('D://voldiff_hs300.csv')

if __name__ == "__main__":
    testStratNum = 9
    if testStratNum == 1:
        trendfollow_strat_optimization(TrendFollow,bar.Frequency.MINUTE_FIVE, '000905','SH','2014-02-01','2016-02-05','tushar',
                                       range(25, 44, 1),
                                       datarange.floatrange(0, 4,5 ),
                                       datarange.floatrange(0, -4, 5),0.06)
    elif testStratNum == 2:
        bolliger_bandit_strat_optimization(Bollinger_Bandit, bar.Frequency.DAY, 'hs300','SH','2013-02-22','2016-02-21','tushare',
                                           range(15,45,5),# bollingerLength
                                           range(15,25,5),# numStd
                                           range(10,50,5),# closeLength
                                           range(10,40,5),# ccMALenght
                                           range(10,40,5),# maLength
                                           range(2,3,1))# space
    elif testStratNum ==3:
        llt_strat_optimization(Guangfa_LLT,bar.Frequency.DAY, '000300','SH daily 13.1-15.12','2016-01-26','2016-03-23','tushar',
                                       datarange.floatrange(0.2,0.25,2),
                                       datarange.floatrange(0, 20, 21),
                                       datarange.floatrange(0, 40,21),
                                       datarange.floatrange(0.06,0.14,5))
    elif testStratNum == 4:
        GuangFa_TD_strat_optimization(GuangFa_TD,bar.Frequency.MINUTE_FIVE, '000905','SH','2014-02-01','2016-02-05','tushar',
                                       range(2, 8, 1),
                                       range(2, 8, 1),
                                       range(2, 8, 1))
    elif testStratNum == 5:
        GuangFa_TD_Gai_strat_optimization(GuangFa_TD_GAI,bar.Frequency.DAY, '000905','SH daily 13.1-15.12','2014-02-01','2016-02-05','tushar',
                                       range(8, 9, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1))
    elif testStratNum == 6:
        trendfollow_strat_optimization(TrendFollow,bar.Frequency.MINUTE_FIVE, 'RB','','2014-02-01','2016-02-05','tushar',
                                       range(130, 140, 2),
                                       datarange.floatrange(0, 1,5 ),
                                       datarange.floatrange(0, -1, 5),1.01)
    elif testStratNum == 7:
        GuangFa_TD_Gai_strat_optimization(GuangFa_TD_GAI,bar.Frequency.MINUTE_FIVE, 'RB','','2014-02-01','2016-02-05','tushar',
                                       range(2, 4, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1),
                                       range(2, 10, 1))
    elif testStratNum == 8:
        svm_strat_optimization(SVMLag, bar.Frequency.MINUTE_FIVE, '000905','SH 16.1-16.7', '2014-02-01','2016-02-05','tushar',
                            range(46,47,1),
                            datarange.floatrange(0.65,0.7,2),
                            [1,2,3,4,5],[6,7,8,9,10])
    elif testStratNum == 9:
        guoxin_vol_strat_optimization(Guoxin_Vol,bar.Frequency.DAY, '000300','SH daily 09.1-15.12','2009-01-01','2015-12-31','tushar',
                                       range(200, 300, 5),
                                       range(1, 30, 1))

