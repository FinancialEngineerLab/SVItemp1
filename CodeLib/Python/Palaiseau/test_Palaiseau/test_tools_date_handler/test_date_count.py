# coding=utf-8
from unittest import TestCase
from tools.date_handler import date_count
import datetime
class TestDateCount(TestCase):

    def test_datetime_count(self):
        self.assertEqual(date_count.days_traded(datetime.datetime(2015,1,1),datetime.datetime(2015,1,20)),20)
        self.assertEqual(date_count.years_traded(datetime.datetime(2015,1,1),datetime.datetime(2015,12,31)),1)
        self.assertEqual(date_count.count_business_day('2016-04-01','2016-04-05'),2)
        self.assertEqual(date_count.count_business_day('2016-04-01','2016-04-03'),1)
        self.assertEqual(date_count.count_business_day('2016-04-02','2016-04-03'),0)