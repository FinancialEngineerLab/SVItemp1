# coding=utf-8
from unittest import TestCase
from tools.date_handler import date_conversion
import datetime
class TestDateConversion(TestCase):

    def test_datetime_conversion(self):
        self.assertEqual(str(date_conversion.get_utc_timestamp(100000000000000000)),'1973-03-03 09:46:40+00:00')
        d=[]
        d.append([2015,1,2])
        self.assertEqual(date_conversion.change_tuple_format_to_string(d),[datetime.datetime(2015, 1, 2, 0, 0)])

