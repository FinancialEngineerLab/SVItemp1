# coding=utf-8
from unittest import TestCase

from tools.date_handler import date_offset


class TestDateOffset(TestCase):
    def test_datetime_offset(self):
        self.assertEqual(date_offset.datetime_offset('2015-05-07', 10, 'BD'), '2015-05-21')  # 往后推10个交易日
        self.assertEqual(date_offset.datetime_offset('2015-05-21', -10, 'BD'), '2015-05-07')  # 往前推10个交易日
        self.assertEqual(date_offset.datetime_offset('2015-05-07', 10, 'D'), '2015-05-17')  # 往后推10天
        self.assertEqual(date_offset.datetime_offset('2015-05-17', -10, 'D'), '2015-05-07')  # 往前推10天
        self.assertEqual(date_offset.datetime_offset('2015-05-17', 10, 'M'), '2016-03-17')  # 往后推10个月
        self.assertEqual(date_offset.datetime_offset('2016-03-17', -10, 'M'), '2015-05-17')  # 往前推10个月
        self.assertEqual(date_offset.datetime_offset('2016-01-01', 0, 'M'), '2016-01-01')  # 往前推0个月
        self.assertEqual(date_offset.datetime_offset('2015-05-17', 10, 'Y'), '2025-5-17')  # 往后推10年
        self.assertEqual(date_offset.datetime_offset('2025-05-17', -10, 'Y'), '2015-5-17')  # 往前推10年

    def test_minute_offset(self):
        self.assertEqual(date_offset.minute_offset('2015-05-07 15:00', 10, 1), '2015-05-08 09:40:00')  # 往后推10个1分钟的交易时间
        self.assertEqual(date_offset.minute_offset('2015-05-07 15:00', -10, 1), '2015-05-07 14:50:00')  # 往前推10个1分钟的交易时间
        self.assertEqual(date_offset.minute_offset('2015-05-07 15:00', 100, 5),
                         '2015-05-12 09:50:00')  # 往后推100个5分钟的交易时间
        self.assertEqual(date_offset.minute_offset('2015-05-12 09:50', -100, 5),
                         '2015-05-08 09:30:00')  # 往前推100个5分钟的交易时间
        self.assertEqual(date_offset.minute_offset('2015-05-07 15:00', 0, 1), '2015-05-07 15:00:00')  # 往后推0个1分钟的交易时间

    def test_other_date_functions(self):
        self.assertEqual(date_offset.get_weekday_of_date('2016-07-28'), 3)
        self.assertEqual(date_offset.get_weekday_of_date('2016-07-30'), 5)
        self.assertEqual(date_offset.get_month_end_date('2016-07-30'), '2016-07-29')
        self.assertEqual(date_offset.get_month_end_date('2016-07-30', use_BD=False), '2016-07-31')
        self.assertEqual(date_offset.get_month_end_date('2016-07-30', use_BD=True), '2016-07-29')
        self.assertEqual(date_offset.get_month_end_date_list('2016-01-01', '2016-06-01', use_BD=True),
                         ['2016-01-29', '2016-02-29', '2016-03-31', '2016-04-29', '2016-05-31', '2016-06-30'])
        self.assertEqual(date_offset.get_month_end_date_list('2016-01-01', '2016-06-01', use_BD=False),
                         ['2016-01-31', '2016-02-29', '2016-03-31', '2016-04-30', '2016-05-31', '2016-06-30'])
