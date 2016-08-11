from tools.data_handler import timeseries
from unittest import TestCase
import pandas as pd
from nose_parameterized import parameterized
import numpy as np
import pandas.util.testing as pdt


class TestCumReturns(TestCase):
    dt = pd.date_range('2000-1-3', periods=3, freq='D')

    @parameterized.expand([
    (pd.Series([.1, -.05, .1], index=dt),
     pd.Series([1.1, 1.1 * .95, 1.1 * .95 * 1.1], index=dt), 1.),
    (pd.Series([np.nan, -.05, .1], index=dt),
     pd.Series([1., 1. * .95, 1. * .95 * 1.1], index=dt), 1.),
    ])
    def test_cum_returns(self, input, expected, start_value):
        output = timeseries.cum_returns(input, starting_value= start_value)
        pdt.assert_series_equal(output, expected)

class TestAggregateReturns(TestCase):
    simple_rets = pd.Series(
        [0.1] * 3 + [0] * 497,
        pd.date_range(
            '2000-1-3',
            periods=500,
            freq='D'))

    @parameterized.expand([
        (simple_rets, 'yearly', [0.3310000000000004, 0.0]),
        (simple_rets[:100], 'monthly', [0.3310000000000004, 0.0, 0.0, 0.0]),
        (simple_rets[:20], 'weekly', [0.3310000000000004, 0.0, 0.0])
    ])
    def test_aggregate_rets(self, returns, convert_to, expected):
        self.assertEqual(
            timeseries.aggregate_returns(
                returns,
                convert_to).values.tolist(),
            expected)


class TestDrawdown(TestCase):
    px_list_1 = np.array(
        [100, 120, 100, 80, 70, 110, 180, 150]) / 100.  # Simple
    px_list_2 = np.array(
        [100, 120, 100, 80, 70, 80, 90, 90]) / 100.  # Ends in drawdown
    dt = pd.date_range('2000-1-3', periods=8, freq='D')


    @parameterized.expand([
        (pd.Series(px_list_2,
                   index=dt),
         pd.Timestamp('2000-1-4'),
         pd.Timestamp('2000-1-7'),
         None,
         None),
        (pd.Series(px_list_1,
                   index=dt),
         pd.Timestamp('2000-1-4'),
         pd.Timestamp('2000-1-7'),
         pd.Timestamp('2000-1-9'),
         4)
    ])
    def test_gen_drawdown_table(self, px, expected_peak,
                                expected_valley, expected_recovery,
                                expected_duration):
        rets = px.pct_change().iloc[1:]

        drawdowns = timeseries.gen_drawdown_table(rets, top=1)
        self.assertTrue(
            pd.isnull(
                drawdowns.loc[
                    0,
                    'peak date'])) if expected_peak is None \
            else self.assertEqual(drawdowns.loc[0, 'peak date'],
                                  expected_peak)
        self.assertTrue(
            pd.isnull(
                drawdowns.loc[0, 'valley date'])) \
            if expected_valley is None else self.assertEqual(
                drawdowns.loc[0, 'valley date'],
                expected_valley)
        self.assertTrue(
            pd.isnull(
                drawdowns.loc[0, 'recovery date'])) \
            if expected_recovery is None else self.assertEqual(
                drawdowns.loc[0, 'recovery date'],
                expected_recovery)
        self.assertTrue(
            pd.isnull(drawdowns.loc[0, 'duration'])) \
            if expected_duration is None else self.assertEqual(
                drawdowns.loc[0, 'duration'], expected_duration)


    @parameterized.expand([
    (pd.Series(px_list_1,
               index=dt),
     1,
     [(pd.Timestamp('2000-01-03 00:00:00'),
       pd.Timestamp('2000-01-03 00:00:00'),
       pd.Timestamp('2000-01-03 00:00:00'))])
    ])
    def test_top_drawdowns(self, returns, top, expected):
        self.assertEqual(
            timeseries.get_top_drawdowns(
                returns,
                top=top),
            expected)
