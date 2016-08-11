# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
from sklearn import preprocessing
from sklearn import cross_validation
from sklearn import svm
from sklearn import grid_search
import itertools
from tools.wind import get_data
from sklearn.metrics import f1_score


# ref: https://uqer.io/community/share/56e75253228e5b858cc25968

class SVMStockMkt:
    def __init__(self,
                 forward=1,
                 lag=1,
                 secCode = '000905.SH',
                 downUp = 1,
                 percent = 0.000,
                 startDate = '2015-01-01',
                 endDate = '2016-01-01',
                 autoPrepare = 1,
                 featuresIndex = 1,
                 test_size = 0.3,
                 kernel = 'linear',
                 dataSource = None,
                 dataSourceIndex = None,
                 dataSourceColNames = None,
                 lagVector = [1,2,3,10]):
        """
        forward   :前看天数，默认前看1天
        lag       :特征滞后天数，默认以前1天数据作为特征
        stock     :预测的指数,默认为上证综指
        downUp    :预测跌呢还是跌呢还是跌呢？跌填 0,涨填  1，默认测涨
        percent   :预测幅度，0.02意思就是涨（跌）2个点才标记为正样本
        autoPrepare :是否在类实例化的时候就自动准备好features label
        dataSource: 可以直接作为数据源，而不用再从wind或者其他地方调取
        """
        self.forward = forward
        self.lag = lag
        self.secCode = secCode
        self.percent = percent
        self.downUp = downUp
        self.startDate = startDate
        self.endDate = endDate
        self.features = []
        self.featureOriginal = []
        self.test_size = test_size
        self.indexData = pd.DataFrame()
        self.featuresIndex = featuresIndex
        self.labelStartIndex = 0
        self.featuresForPrediction = []
        self.kernel = kernel
        self.lagVector = sorted(lagVector)

        if dataSource is None:
            try:
                price_type = 'high,open,low,close'
                indexData = get_data.get_hist_price_from_wind(self.secCode, self.startDate, self.endDate, price_type)
                if indexData.empty:
                    print '获取数据为空'
                    return
                self.indexData = indexData
            except:
                print '无法获取数据'
                return
        else:
            if dataSourceColNames is None:
                raise Exception("dataSourceColNames is empty")

            indexData = pd.DataFrame(dataSource, columns = dataSourceColNames)
            if dataSourceIndex is not None:
                indexData.index = dataSourceIndex
            self.indexData = indexData

        if autoPrepare == 1:
            self.getFeature()
            self.getLabel()


    def getFeature(self, names = 0):
        featureOriginal = pd.DataFrame()
        data = self.indexData

        if self.featuresIndex == 1:  # use lag return matrix
            featureOriginal, featuresForPrediction = self.getMktLagReturnMatrix()
            self.labelStartIndex = min(self.lagVector)
        else:
            featureOriginal['high_low'] = (data['highestIndex'] - data['lowestIndex'])/data['lowestIndex']
            featureOriginal['high_close'] = (data['highestIndex'] - data['closeIndex'])/data['closeIndex']
            featureOriginal['close_low'] = (data['closeIndex'] - data['lowestIndex'])/data['lowestIndex']
            featureOriginal['close_open'] = (data['closeIndex'] - data['openIndex'])/data['openIndex']

        featureOriginal = featureOriginal.fillna(0)
        features = []

        for i in range(self.lag, len(featureOriginal) +1):
            temp = featureOriginal[i-self.lag:i]
            temp = list(itertools.chain.from_iterable(temp.values.tolist()))
            features.append(temp)
        self.features = features
        self.featureOriginal = featureOriginal
        self.featuresForPrediction = featuresForPrediction.values.tolist()
        return

    def getMktLagReturnMatrix(self, lagVector = [1,2,3,10]): # 返回一个矩阵，每列代表n-lag returns
        lagReturns = pd.DataFrame()
        lagVector = self.lagVector
        logChange = np.diff(np.log(self.indexData['close']))

        for i in range(0, len(lagVector)):
            lagColName = 'lag ' + str(lagVector[i])

            lagReturns = pd.concat([lagReturns,
                                    pd.DataFrame(logChange[:-lagVector[i]],
                                    index = self.indexData.index[lagVector[i]+1:],
                                    columns = [lagColName])], axis = 1)

        lagReturns = lagReturns.fillna(0)
        lagReturnsOutOfSample = lagReturns[-self.forward:]
        lagReturns = lagReturns[:-self.forward]
        return lagReturns, lagReturnsOutOfSample

    def getForwardReturn(self):
        fwdReturn = pd.DataFrame(columns = ['fwdReturn'],index = self.indexData.index[self.forward:])
        for i in range(0, len(fwdReturn.index)):
            fwdReturn.iloc[i,0] = np.log(self.indexData['close'][i+self.forward]) - np.log(self.indexData['close'][i])
        return fwdReturn

    def getLabel(self):
        # 数据为每个日期对应的未来的涨跌幅，所以要错开一个值
        label_df = pd.DataFrame(columns = ['realizedFwdReturn','symbol'],index = self.indexData.index[self.forward:])
        label_df['realizedFwdReturn'] = self.getForwardReturn()['fwdReturn'].shift(-1)

        if self.downUp==1:
            label_df['symbol'] = label_df['realizedFwdReturn'].apply(lambda x:1 if x>self.percent else -1 if x<-self.percent else 0)         ######symbol 就是我们要的label
        if self.downUp==-1:
            label_df['symbol'] = label_df['realizedFwdReturn'].apply(lambda x:1 if x<self.percent else 0)

        # 删除最后若干行 NaN
        label_df = label_df[:-self.forward]
        label_df = label_df[self.labelStartIndex:]
        self.label_df = label_df
        self.label =  label_df['symbol'].values.tolist()

        return self.label


    def train(self, kernel = 'rbf', method = 'lasso'):
        """
        kernal    :核函数，可选择  ‘linear’, ‘poly’, ‘rbf’, ‘sigmoid’, ‘precomputed’，默认为rbf
        """
        features = self.features
        label = self.label

        X_train,X_test, y_train, y_test = cross_validation.train_test_split(features, label, test_size = self.test_size, random_state = 0)

        if len(label) == len(features):
            scaler = preprocessing.StandardScaler().fit(X_train)
            X_train_scaler = scaler.transform(X_train)
            X_test_scaler = scaler.transform(X_test)
            clf = svm.SVC(kernel = kernel).fit(X_train_scaler, y_train)
            myscore = clf.score(X_test_scaler, y_test)
            y_pred = clf.predict(X_test_scaler)
            f1 = f1_score(y_test, y_pred)
            #print "准确率：%f, F1: %f"%( myscore,f1)
            #return myscore
            return clf.predict(self.featuresForPrediction)[0], myscore

        else:
            print "特征矩阵，标签行数不匹配"
            return


    def SVMFitAndPrediction(self):
        features = self.features
        label = self.label

        if self.kernel == 'rbf':
            clf = svm.SVC()
        elif self.kernel == 'linear':
            clf = svm.LinearSVC()
        clf.fit(features, label)

        return clf.predict(self.featuresForPrediction)

    def TrainWithOptimizedParams(self):
        features = self.features
        label = self.label

        parameters    = {'kernel':('linear', 'rbf'),'C':[1, 10, 100, 1000], 'gamma': np.logspace(-2, 1, 4)} #'kernel':('linear', 'rbf'),
        SVC_model     = svm.SVC()
        clf = grid_search.GridSearchCV(SVC_model, parameters)
        clf.fit(features, label)

        SVC_model     = svm.SVC(C=clf.best_params_["C"], gamma=clf.best_params_["gamma"]) #kernel=clf.best_params_["kernel"]
        SVC_model.fit(features, label)
        y_predSVC     = SVC_model.predict(self.featuresForPrediction)[0]
        return y_predSVC


if __name__=="__main__":
    svm_model = SVMStockMkt(startDate='2015-01-01', endDate='2015-04-01',autoPrepare=1)
    #svm_model.TrainWithOptimizedParams()
    print svm_model.train()
