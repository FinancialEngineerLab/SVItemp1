from unittest import TestCase
from tools.math.hurst import hurst_RS
import numpy as np

class TestHurstRS(TestCase):

    def test_hurst_RS(self):
       path = "..//data//000001SH.csv"
       csvfile = open(path, 'r')
       data = []
       for line in csvfile:
         if list(line.strip().split(','))[4] !='Close':
           data.append((float)(list(line.strip().split(','))[4]))
       data = np.array(data)
       self.assertEqual(round(hurst_RS.ERS(2,204,1),6), 0.644605)
       self.assertEqual(round(hurst_RS.hurst(data,2,8,1),6),0.672835)



