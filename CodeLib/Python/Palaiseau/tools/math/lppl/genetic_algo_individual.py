# -*- coding: utf-8 -*-
import numpy as np
from scipy.optimize import fmin_tnc
import random
from lppl_calib_formula import lppl as lppl
from lppl_calib_formula import func as func

global DataSeries


class Individual:
    """base class for individuals"""

    def __init__(self, InitValues, random_seed_individual=None):
        self.fit = 0
        self.cof = InitValues
        self.__seed_individual = random_seed_individual
        if self.__seed_individual is not None:
            random.seed(self.__seed_individual)
        else:
            random.seed()

    def fitness(self):
        try:
            cofs, nfeval, rc = fmin_tnc(func, self.cof, fprime=None, approx_grad=True,
                                        messages=0)  # 基于牛顿梯度下山的寻找函数最小值
            self.fit = func(cofs)
            self.cof = cofs

        except:
            # does not converge
            return False

    def mate(self, partner):  # 交配
        reply = []
        random.seed(self.__seed_individual)
        for i in range(0, len(self.cof)):  # 遍历所有的输入参数
            if random.randint(0, 1) == 1:  # 交配，0.5的概率自身的参数保留，0.5的概率留下partner的参数，即基因交换
                reply.append(self.cof[i])
            else:
                reply.append(partner.cof[i])

        return Individual(reply, random_seed_individual=self.__seed_individual)

    def mutate(self):  # 突变
        random.seed(self.__seed_individual)
        for i in range(0, len(self.cof) - 1):
            if random.randint(0, len(self.cof)) <= 2:
                # print "Mutate" + str(i)
                self.cof[i] += random.choice([-1, 1]) * .5 * i  # 突变

    def PrintIndividual(self):
        # t, a, b, tc, m, c, w, phi
        cofs = "A: " + str(round(self.cof[0], 3)) + " "
        cofs += "B: " + str(round(self.cof[1], 3)) + " "
        cofs += "Critical Time: " + str(round(self.cof[2], 3)) + " "
        cofs += "m: " + str(round(self.cof[3], 3)) + " "
        cofs += "c: " + str(round(self.cof[4], 3)) + " "
        cofs += "omega: " + str(round(self.cof[5], 3)) + " "
        cofs += "phi: " + str(round(self.cof[6], 3)) + " "

        return "Fitness: " + str(self.fit) + "\n" + cofs

    # return str(self.cof) + " fitness: " + str(self.fit)

    def getDataSeries(self):
        return DataSeries

    def getExpFutureData(self, DataSeries):
        return [np.exp(lppl(t, self.cof)) for t in DataSeries]

    def getExpFutureIndex(self):
        return np.exp(lppl(int(self.cof[2]), self.cof))
