import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import adfuller
from tools.wind import get_data
import statsmodels.api as sm
import  statsmodels.tsa.stattools as sts
from statsmodels.stats import diagnostic
from arch import arch_model 
from arch.univariate import ZeroMean, GARCH, StudentsT, ConstantMean

# https://www.ricequant.com/community/topic/1319/
class statHelper:
    def __init__(self, dataSeries, needLogDiff = False, header ='close', printOutInfo = False):
        self.dataSeriesOriginal = dataSeries
        if needLogDiff:
            self.dataSeries = np.log(dataSeries[header]).diff().dropna()
        else:
            self.dataSeries = self.dataSeriesOriginal.values
        self.order = None
        self.printOutInfo = printOutInfo
        self.armaModel = None
        self.garchModel = None
        self.perdictionSimulNumber = 1000

    def stationaryTest(self):
        array = self.dataSeries.values.tolist()
        pvalue =  adfuller(array)[1]
        print ('Stationary DF test pvalue :',pvalue)

    def showData(self):
        print self.dataSeries

    def showDataOriginal(self):
        print self.dataSeriesOriginal

    def acfPlot(self):
        fig = plt.figure(figsize=(12, 8))
        ax1 = fig.add_subplot(211)
        fig = sm.graphics.tsa.plot_acf(self.dataSeries, lags=40, alpha=0.05, ax=ax1)
        ax2 = fig.add_subplot(212)
        fig = sm.graphics.tsa.plot_pacf(self.dataSeries, lags=40, alpha=0.05, ax=ax2)
        plt.show()

    def getARMAOrder(self, orderMethod = 'aic'):
        resid = sts.arma_order_select_ic(self.dataSeries, max_ar=4, max_ma=4,
                                 ic=['aic','bic','hqic'], trend='nc', fit_kw=dict(method='css'))
        if self.printOutInfo:
            print ('AIC-order :{}'.format(resid.aic_min_order))
            print ('BIC-order :{}'.format(resid.bic_min_order))
            print ('HQIC-order :{}'.format(resid.hqic_min_order))

        if orderMethod == 'aic':
            self.order = resid.aic_min_order
        elif orderMethod == 'bic':
            self.order = resid.bic_min_order
        else:
            self.order = resid.hqic_min_order

    def fitARMAModel(self):
        self.armaModel = sm.tsa.ARMA(self.dataSeries, self.order).fit(method='css-mle',disp=False)
        if self.printOutInfo:
            print self.armaModel.summary()
            print '-------------------------------------'
            print self.armaModel.params

    def residualARTest(self):
        if self.armaModel is not None:
            resid = self.armaModel.resid
            _, pvalue, _, bppvalue = diagnostic.acorr_ljungbox(resid, lags=None, boxpierce=True)
            if self.printOutInfo:
                print '-------------------------------------'
                print '---------Residual Ljungbox Test----------------'
                print pvalue,'\n',bppvalue

    def residualARCHTest(self):
        if self.armaModel is not None:
            resid = self.armaModel.resid
            fpvalue = diagnostic.het_arch(resid)[-1]
            if self.printOutInfo:
                print '-------------------------------------'
                print '---------Residual ARCH Test----------------'
                print 'Residual ARCH test pvalue :',fpvalue
                fig = plt.figure(figsize=(16, 6))
                ax1 = fig.add_subplot(111)
                fig = sm.graphics.tsa.plot_acf(resid.values ** 2, lags=40, ax=ax1)
                plt.show()

    def fitGARCHModel(self):
        garchModel = ConstantMean(self.dataSeries)
        garchModel.volatility = GARCH(1,0,1)
        garchModel.distribution = StudentsT()
        res = garchModel.fit(disp='off')
        self.garchModel = res
        if self.printOutInfo:
            print (res.summary())
            print (' ')
            print ('The estimated parameters: ')
            print ('----------------------------------------')
            print (res.params)

    def fit_arma_garch_model(self):
        try:
            self.getARMAOrder()
            self.fitARMAModel()
            self.fitGARCHModel()
        except Exception, e:
            print 'fit_arma_garch_model: failed to calibrate arma-garch model'
            print 'fit_arma_garch_model:  ',e

    def onePeriodPrediction_arma_garch_model(self):
        if self.armaModel is None or self.garchModel is None:
            raise Exception("onePeriodPrediction_arma_garch_model: arma or garch model has not been calibrated yet")

        res = self.garchModel
        arch = self.armaModel
        omega = res.params[1]
        alpha = res.params[2]
        beta = res.params[3]

        sigma_t = self.garchModel.conditional_volatility.ix[-1]
        sigma_forecast = np.sqrt(omega + alpha * res.resid.ix[-1] ** 2 + beta * res.conditional_volatility.ix[-1] ** 2)

        data_forecast = 0
        mu = arch.params[0]
        data_forecast += mu
        # ar order
        for i in range(1, self.order[0]+1):
            data_forecast += arch.params[i] * self.dataSeries[-i]

        # ma order
        data_forecast += sigma_forecast * np.random.standard_normal()
        for i in range(1, self.order[1]+1):
            data_forecast += arch.params[i+self.order[0]]* res.conditional_volatility.ix[-i]* np.random.standard_normal()

        return data_forecast

    def meanOfOnePeriodPrediction_arma_garch_model(self):
        sum = 0
        for i in range(1, self.perdictionSimulNumber):
            sum+= self.onePeriodPrediction_arma_garch_model()

        return sum/self.perdictionSimulNumber


if __name__=="__main__":
    secCode = '000905.SH'
    startDate = '2015-01-01'
    endDate = '2016-01-01'
    priceType ='close'
    indexData = get_data.get_hist_price_from_wind(secCode, startDate, endDate, priceType)
    arma_series = statHelper(indexData, needLogDiff=True, printOutInfo=False)
    #arma_series.stationaryTest()
    #arma_series.getARMAOrder()
    #arma_series.fitARMAModel()
    #arma_series.residualARTest()
    #arma_series.residualARCHTest()
    arma_series.fit_arma_garch_model()
    print arma_series.meanOfOnePeriodPrediction_arma_garch_model()