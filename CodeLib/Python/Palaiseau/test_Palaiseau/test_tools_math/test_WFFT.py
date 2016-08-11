from unittest import TestCase
from tools.math.FFT import WFFT

class TestHurstRS(TestCase):

    def test_WFFT(self):
       path = "..//data//000001SH.csv"
       csvfile = open(path, 'r')
       data = []
       i =0
       for line in csvfile:
         if list(line.strip().split(','))[4] !='Close' and i<=20:
            data.append((float)(list(line.strip().split(','))[4]))
            i=i+1

       self.assertEqual(round(WFFT.get_T(WFFT.get_S(WFFT.get_power(data))),3), 14.410)