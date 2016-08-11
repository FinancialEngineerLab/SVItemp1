import numpy as np
from pyalgotrade import technical
from pyalgotrade import dataseries
from tools.math.SVM import svm_main



class SVMEventWindow(technical.EventWindow):
    def __init__(self, period, lagVector):
        assert(period > 0)
        technical.EventWindow.__init__(self, period)
        self.__lagVector = lagVector

    def getValue(self):
        pass

    def getPredictionAndProba(self):
        prediction, proba = None, None
        if self.windowFull():
            svm_model = svm_main.SVMStockMkt(autoPrepare=1, dataSource = self.getValues(), dataSourceColNames=['close'], lagVector=self.__lagVector)
            prediction, proba = svm_model.train()
        return prediction, proba

class SVM(technical.EventBasedFilter):
    """SVM filter.

    :param dataSeries: The DataSeries instance being filtered.
    :type dataSeries: :class:`pyalgotrade.dataseries.DataSeries`.
    :param period: The number of values to use to calculate the EMA. Must be an integer greater than 1.
    :type period: int.
    :param maxLen: The maximum number of values to hold.
        Once a bounded length is full, when new items are added, a corresponding number of items are discarded from the opposite end.
    :type maxLen: int.
    """

    def __init__(self, dataSeries, period, lagVector = [1,2,3,10], maxLen=dataseries.DEFAULT_MAX_LEN):
        technical.EventBasedFilter.__init__(self, dataSeries, SVMEventWindow(period, lagVector), maxLen)
        self.__svmPredict = dataseries.SequenceDataSeries(maxLen)
        self.__svmPredictProba = dataseries.SequenceDataSeries(maxLen)
        dataSeries.getNewValueEvent().subscribe(self.__onNewValue)

    def __onNewValue(self, dataseries, dateTime, value):
        a, b = self.getEventWindow().getPredictionAndProba()
        self.__svmPredict.append(a)
        self.__svmPredictProba.append(b)

    def getSVMPredict(self):
        return self.__svmPredict

    def getSVMPredictProba(self):
        return self.__svmPredictProba