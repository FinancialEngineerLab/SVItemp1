# -*- coding: utf-8 -*-

# Source: https://github.com/quantopian/pyfolio/blob/master/pyfolio/timeseries.py

from tools.data_handler import config_reader, dataseries_to_nparray
from tools.date_handler import date_conversion, interesting_periods
from tools.msg_handler.deprecate import deprecated
from collections import OrderedDict
import scipy.stats as stats
import pandas as pd
import numpy as np
import tools
import datetime
import copy
from tools import qrisk



DEPRECATION_WARNING = ("Risk functions in pyfolio.timeseries are deprecated "
                       "and will be removed in a future release. Please "
                       "install the qrisk package instead.")


def cum_returns(returns, starting_value=None, forceTimeIndexInStringFormat = True):
    """
    Compute cumulative returns from simple returns.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    starting_value : float, optional
       The starting returns (default 1).
    Returns
    -------
    pandas.Series
        Series of cumulative returns.
    Notes
    -----
    For increased numerical accuracy, convert input to log returns
    where it is possible to sum instead of multiplying.
    """

    # df_price.pct_change() adds a nan in first position, we can use
    # that to have cum_returns start at the origin so that
    # df_cum.iloc[0] == starting_value
    # Note that we can't add that ourselves as we don't know which dt
    # to use.

    if pd.isnull(returns.iloc[0]):
        returns.iloc[0] = 0.

    # a stupid conversion here otherwise it wont work
    # ret = dataseries_to_nparray.change_pd_series_to_np_array(returns)
    #df_cum = np.exp(np.log(1 + ret).cumsum())
    # 为了避免引用传递的问题，此处做了繁琐的修改 - 赋值，循环 （也许有更好的方法）
    # 计辉 2016/3/4
    i = 1
    date_series =copy.deepcopy(returns.index)
    data_series=copy.deepcopy(returns.values)
    if type(date_series[0]) is tuple and forceTimeIndexInStringFormat:
        temp = date_conversion.change_tuple_format_to_string(date_series)
        date_series =temp
    data_series[0] = np.exp(np.log(1+ data_series[0]))
    while i< len(data_series):
        data_series[i] = data_series[i-1] *np.exp(np.log(1+ data_series[i]))
        i+=1
    df_cum =pd.Series(data=data_series,index=date_series)
    if starting_value is None:
        df_cum = df_cum - 1
    else:
        df_cum = df_cum * starting_value


    return df_cum

def aggregate_returns(df_daily_rets, convert_to):
    """
    Aggregates returns by week, month, or year.
    Parameters
    ----------
    df_daily_rets : pd.Series
       Daily/minutely returns of the strategy, noncumulative.
        - See full explanation in tears.create_full_tear_sheet (returns).
    convert_to : str
        Can be 'daily','weekly', 'monthly', or 'yearly'.
    Returns
    -------
    pd.Series
        Aggregated returns.
    """

    def cumulate_returns(x):
        return cum_returns(x)[-1]

    config_path = tools.get_config_file_path()
    convert_to = convert_to.lower()
    freq = config_reader.getConfig('frequency', convert_to, config_path)
    if freq == 'DAILY':
        return df_daily_rets.groupby([lambda x: x.year, lambda x: x.month, lambda x: x.day]).apply(cumulate_returns)
    elif freq == 'WEEKLY':
        return df_daily_rets.groupby(
            [lambda x: x.year,
             lambda x: x.isocalendar()[1]]).apply(cumulate_returns)
    elif freq == 'MONTHLY':
        return df_daily_rets.groupby(
              [lambda x: x.year, lambda x: x.month]).apply(cumulate_returns)
    elif freq == 'YEARLY':
        return df_daily_rets.groupby(
            [lambda x: x.year]).apply(cumulate_returns)
    else:
        ValueError(
            'convert_to must be daily, weekly, monthly or yearly'
        )


def get_max_drawdown_underwater(underwater):
    """Determines peak, valley, and recovery dates given an 'underwater'
    DataFrame.
    An underwater DataFrame is a DataFrame that has precomputed
    rolling drawdown.
    Parameters
    ----------
    underwater : pd.Series
       Underwater returns (rolling drawdown) of a strategy.
    Returns
    -------
    peak : datetime
        The maximum drawdown's peak.
    valley : datetime
        The maximum drawdown's valley.
    recovery : datetime
        The maximum drawdown's recovery.
    """

    valley = np.argmax(underwater)  # end of the period
    # Find first 0
    peak = underwater[:valley][underwater[:valley] == 0].index[-1]
    # Find last 0
    try:
        recovery = underwater[valley:][underwater[valley:] == 0].index[0]
    except IndexError:
        recovery = np.nan  # drawdown not recovered
    return peak, valley, recovery

def forecast_cone_bootstrap(is_returns, num_days, cone_std=(1., 1.5, 2.),
                            starting_value=1, num_samples=1000,
                            random_seed=None):
    """
    Determines the upper and lower bounds of an n standard deviation
    cone of forecasted cumulative returns. Future cumulative mean and
    standard devation are computed by repeatedly sampling from the
    in-sample daily returns (i.e. bootstrap). This cone is non-parametric,
    meaning it does not assume that returns are normally distributed.
    Parameters
    ----------
    is_returns : pd.Series
        In-sample daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    num_days : int
        Number of days to project the probability cone forward.
    cone_std : int, float, or list of int/float
        Number of standard devations to use in the boundaries of
        the cone. If multiple values are passed, cone bounds will
        be generated for each value.
    starting_value : int or float
        Starting value of the out of sample period.
    num_samples : int
        Number of samples to draw from the in-sample daily returns.
        Each sample will be an array with length num_days.
        A higher number of samples will generate a more accurate
        bootstrap cone.
    random_seed : int
        Seed for the pseudorandom number generator used by the pandas
        sample method.
    Returns
    -------
    pd.DataFrame
        Contains upper and lower cone boundaries. Column names are
        strings corresponding to the number of standard devations
        above (positive) or below (negative) the projected mean
        cumulative returns.
    """

    samples = np.empty((num_samples, num_days))
    seed = np.random.RandomState(seed=random_seed)
    for i in range(num_samples):
        samples[i, :] = is_returns.sample(num_days, replace=True,
                                          random_state=seed)

    cum_samples = np.cumprod(1 + samples, axis=1) * starting_value

    cum_mean = cum_samples.mean(axis=0)
    cum_std = cum_samples.std(axis=0)

    if isinstance(cone_std, (float, int)):
        cone_std = [cone_std]

    cone_bounds = pd.DataFrame(columns=pd.Float64Index([]))
    for num_std in cone_std:
        cone_bounds.loc[:, float(num_std)] = cum_mean + cum_std * num_std
        cone_bounds.loc[:, float(-num_std)] = cum_mean - cum_std * num_std

    return cone_bounds


def get_top_drawdowns(returns, top=10):
    """
    Finds top drawdowns, sorted by drawdown amount.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    top : int, optional
        The amount of top drawdowns to find (default 10).
    Returns
    -------
    drawdowns : list
        List of drawdown peaks, valleys, and recoveries. See get_max_drawdown.
    """

    returns = returns.copy()
    df_cum = cum_returns(returns, 1.0)
    running_max = np.maximum.accumulate(df_cum)
    underwater = running_max - df_cum

    drawdowns = []
    for t in range(top):
        peak, valley, recovery = get_max_drawdown_underwater(underwater)
        # Slice out draw-down period
        if not pd.isnull(recovery):
            underwater.drop(underwater[peak: recovery].index[1:-1],
                            inplace=True)
        else:
            # drawdown has not ended yet
            underwater = underwater.loc[:peak]

        drawdowns.append((peak, valley, recovery))
        if (len(returns) == 0) or (len(underwater) == 0):
            break

    return drawdowns

def gen_drawdown_table(returns, top=10):
    """
    Places top drawdowns in a table.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    top : int, optional
        The amount of top drawdowns to find (default 10).
    Returns
    -------
    df_drawdowns : pd.DataFrame
        Information about top drawdowns.
    """
    df_cum = cum_returns(returns, 1.0)

    drawdown_periods = get_top_drawdowns(returns, top=top)
    df_drawdowns = pd.DataFrame(index=list(range(top)),
                                columns=['net drawdown in %',
                                         'peak date',
                                         'valley date',
                                         'recovery date',
                                         'duration'])

    for i, (peak, valley, recovery) in enumerate(drawdown_periods):
        if pd.isnull(recovery):
            df_drawdowns.loc[i, 'duration'] = np.nan
        else:
            df_drawdowns.loc[i, 'duration'] = len(pd.date_range(peak,
                                                                recovery,
                                                                freq='B'))
        df_drawdowns.loc[i, 'peak date'] = (peak.to_pydatetime()
                                            .strftime('%Y-%m-%d'))
        df_drawdowns.loc[i, 'valley date'] = (valley.to_pydatetime()
                                              .strftime('%Y-%m-%d'))
        if isinstance(recovery, float):
            df_drawdowns.loc[i, 'recovery date'] = recovery
        else:
            df_drawdowns.loc[i, 'recovery date'] = (recovery.to_pydatetime()
                                                    .strftime('%Y-%m-%d'))
        df_drawdowns.loc[i, 'net drawdown in %'] = (
            (df_cum.loc[peak] - df_cum.loc[valley]) / df_cum.loc[peak]) * 100

    df_drawdowns['peak date'] = pd.to_datetime(
        df_drawdowns['peak date'],
        unit='D')
    df_drawdowns['valley date'] = pd.to_datetime(
        df_drawdowns['valley date'],
        unit='D')
    df_drawdowns['recovery date'] = pd.to_datetime(
        df_drawdowns['recovery date'],
        unit='D')

    return df_drawdowns





###################################################################
# Updated on 2016-08-07

@deprecated(msg=DEPRECATION_WARNING)
def max_drawdown(returns):
    """
    Determines the maximum drawdown of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    Returns
    -------
    float
        Maximum drawdown.
    Note
    -----
    See https://en.wikipedia.org/wiki/Drawdown_(economics) for more details.
    """

    return qrisk.max_drawdown(returns)


@deprecated(msg=DEPRECATION_WARNING)
def annual_return(returns, period='daily'):
    """Determines the mean annual growth rate of returns.
    Parameters
    ----------
    returns : pd.Series
        Periodic returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing. Can be 'monthly', 'weekly', or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    float
        Annual Return as CAGR (Compounded Annual Growth Rate).
    """

    return qrisk.annual_return(returns, period=period)


@deprecated(msg=DEPRECATION_WARNING)
def annual_volatility(returns, period='daily'):
    """
    Determines the annual volatility of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Periodic returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing volatility. Can be 'monthly' or 'weekly' or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    float
        Annual volatility.
    """

    return qrisk.annual_volatility(returns, period=period)


@deprecated(msg=DEPRECATION_WARNING)
def calmar_ratio(returns, period='daily'):
    """
    Determines the Calmar ratio, or drawdown ratio, of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing. Can be 'monthly', 'weekly', or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    float
        Calmar ratio (drawdown ratio) as float. Returns np.nan if there is no
        calmar ratio.
    Note
    -----
    See https://en.wikipedia.org/wiki/Calmar_ratio for more details.
    """

    return qrisk.calmar_ratio(returns, period=period)


@deprecated(msg=DEPRECATION_WARNING)
def omega_ratio(returns, annual_return_threshhold=0.0):
    """Determines the Omega ratio of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    annual_return_threshold : float, optional
        Minimum acceptable return of the investor. Annual threshold over which
        returns are considered positive or negative. It is converted to a
        value appropriate for the period of the returns for this ratio.
        E.g. An annual minimum acceptable return of 100 translates to a daily
        minimum acceptable return of 0.01848.
            (1 + 100) ** (1. / 252) - 1 = 0.01848
        Daily returns must exceed this value to be considered positive. The
        daily return yields the desired annual return when compounded over
        the average number of business days in a year.
            (1 + 0.01848) ** 252 - 1 = 99.93
        - Defaults to 0.0
    Returns
    -------
    float
        Omega ratio.
    Note
    -----
    See https://en.wikipedia.org/wiki/Omega_ratio for more details.
    """

    return qrisk.omega_ratio(returns, required_return=annual_return_threshhold)


@deprecated(msg=DEPRECATION_WARNING)
def sortino_ratio(returns, required_return=0, period='daily'):
    """
    Determines the Sortino ratio of a strategy.
    Parameters
    ----------
    returns : pd.Series or pd.DataFrame
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    required_return: float / series
        minimum acceptable return
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing. Can be 'monthly', 'weekly', or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    depends on input type
    series ==> float
    DataFrame ==> np.array
        Annualized Sortino ratio.
    """

    return qrisk.sortino_ratio(returns, required_return=required_return)


@deprecated(msg=DEPRECATION_WARNING)
def downside_risk(returns, required_return=0, period='daily'):
    """
    Determines the downside deviation below a threshold
    Parameters
    ----------
    returns : pd.Series or pd.DataFrame
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    required_return: float / series
        minimum acceptable return
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing. Can be 'monthly', 'weekly', or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    depends on input type
    series ==> float
    DataFrame ==> np.array
        Annualized downside deviation
    """

    return qrisk.downside_risk(returns,
                               required_return=required_return,
                               period=period)


@deprecated(msg=DEPRECATION_WARNING)
def sharpe_ratio(returns, risk_free=0, period='daily'):
    """
    Determines the Sharpe ratio of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    risk_free : int, float
        Constant risk-free return throughout the period.
    period : str, optional
        Defines the periodicity of the 'returns' data for purposes of
        annualizing. Can be 'monthly', 'weekly', or 'daily'.
        - Defaults to 'daily'.
    Returns
    -------
    float
        Sharpe ratio.
    np.nan
        If insufficient length of returns or if if adjusted returns are 0.
    Note
    -----
    See https://en.wikipedia.org/wiki/Sharpe_ratio for more details.
    """

    return qrisk.sharpe_ratio(returns, risk_free=risk_free, period=period)


@deprecated(msg=DEPRECATION_WARNING)
def information_ratio(returns, factor_returns):
    """
    Determines the Information ratio of a strategy.
    Parameters
    ----------
    returns : pd.Series or pd.DataFrame
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    factor_returns: float / series
        Benchmark return to compare returns against.
    Returns
    -------
    float
        The information ratio.
    Note
    -----
    See https://en.wikipedia.org/wiki/information_ratio for more details.
    """

    return qrisk.information_ratio(returns, factor_returns)

@deprecated(msg=DEPRECATION_WARNING)
def alpha_beta(returns, factor_returns):
    """Calculates both alpha and beta.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    factor_returns : pd.Series
         Daily noncumulative returns of the factor to which beta is
         computed. Usually a benchmark such as the market.
         - This is in the same style as returns.
    Returns
    -------
    float
        Alpha.
    float
        Beta.
    """

    return qrisk.alpha_beta(returns, factor_returns=factor_returns)


@deprecated(msg=DEPRECATION_WARNING)
def alpha(returns, factor_returns):
    """Calculates annualized alpha.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    factor_returns : pd.Series
         Daily noncumulative returns of the factor to which beta is
         computed. Usually a benchmark such as the market.
         - This is in the same style as returns.
    Returns
    -------
    float
        Alpha.
    """

    return qrisk.alpha(returns, factor_returns=factor_returns)


@deprecated(msg=DEPRECATION_WARNING)
def beta(returns, factor_returns):
    """Calculates beta.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    factor_returns : pd.Series
         Daily noncumulative returns of the factor to which beta is
         computed. Usually a benchmark such as the market.
         - This is in the same style as returns.
    Returns
    -------
    float
        Beta.
    """

    return qrisk.beta(returns, factor_returns)


@deprecated(msg=DEPRECATION_WARNING)
def stability_of_timeseries(returns):
    """Determines R-squared of a linear fit to the cumulative
    log returns. Computes an ordinary least squares linear fit,
    and returns R-squared.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
        - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    Returns
    -------
    float
        R-squared.
    """

    return qrisk.stability_of_timeseries(returns)


@deprecated(msg=DEPRECATION_WARNING)
def tail_ratio(returns):
    """Determines the ratio between the right (95%) and left tail (5%).
    For example, a ratio of 0.25 means that losses are four times
    as bad as profits.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in :func:`~pyfolio.timeseries.cum_returns`.
    Returns
    -------
    float
        tail ratio
    """

    return qrisk.tail_ratio(returns)

@deprecated(msg=DEPRECATION_WARNING)
def common_sense_ratio(returns):
    """Common sense ratio is the multiplication of the tail ratio and the
    Gain-to-Pain-Ratio -- sum(profits) / sum(losses).
    See http://bit.ly/1ORzGBk for more information on motivation of
    this metric.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    Returns
    -------
    float
        common sense ratio
    """
    return qrisk.tail_ratio(returns) * (1 + qrisk.annual_return(returns))



SIMPLE_STAT_FUNCS = [
    annual_return,
    annual_volatility,
    sharpe_ratio,
    calmar_ratio,
    stability_of_timeseries,
    max_drawdown,
    omega_ratio,
    sortino_ratio,
    stats.skew,
    stats.kurtosis,
    tail_ratio,
    common_sense_ratio,
]

FACTOR_STAT_FUNCS = [
    information_ratio,
    alpha,
    beta,
]

def perf_stats(returns, factor_returns=None):
    """Calculates various performance metrics of a strategy, for use in
    plotting.show_perf_stats.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    factor_returns : pd.Series (optional)
        Daily noncumulative returns of the benchmark.
         - This is in the same style as returns.
        If None, do not compute alpha, beta, and information ratio.
    Returns
    -------
    pd.Series
        Performance metrics.
    """

    stats = pd.Series()

    for stat_func in SIMPLE_STAT_FUNCS:
        stats[stat_func.__name__] = stat_func(returns)

    if factor_returns is not None:
        for stat_func in FACTOR_STAT_FUNCS:
            stats[stat_func.__name__] = stat_func(returns,
                                                  factor_returns)

    return stats


def perf_stats_bootstrap(returns, factor_returns=None, return_stats=True):
    """Calculates various bootstrapped performance metrics of a strategy.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    factor_returns : pd.Series (optional)
        Daily noncumulative returns of the benchmark.
         - This is in the same style as returns.
        If None, do not compute alpha, beta, and information ratio.
    return_stats : boolean (optional)
        If True, returns a DataFrame of mean, median, 5 and 95 percentiles
        for each perf metric.
        If False, returns a DataFrame with the bootstrap samples for
        each perf metric.
    Returns
    -------
    pd.DataFrame
        if return_stats is True:
        - Distributional statistics of bootstrapped sampling
        distribution of performance metrics.
        if return_stats is False:
        - Bootstrap samples for each performance metric.
    """
    bootstrap_values = OrderedDict()

    for stat_func in SIMPLE_STAT_FUNCS:
        stat_name = stat_func.__name__
        bootstrap_values[stat_name] = calc_bootstrap(stat_func,
                                                     returns)

    if factor_returns is not None:
        for stat_func in FACTOR_STAT_FUNCS:
            stat_name = stat_func.__name__
            bootstrap_values[stat_name] = calc_bootstrap(
                stat_func,
                returns,
                factor_returns=factor_returns)

    bootstrap_values = pd.DataFrame(bootstrap_values)

    if return_stats:
        stats = bootstrap_values.apply(calc_distribution_stats)
        return stats.T[['mean', 'median', '5%', '95%']]
    else:
        return bootstrap_values


def calc_bootstrap(func, returns, *args, **kwargs):
    """Performs a bootstrap analysis on a user-defined function returning
    a summary statistic.
    Parameters
    ----------
    func : function
        Function that either takes a single array (commonly returns)
        or two arrays (commonly returns and factor returns) and
        returns a single value (commonly a summary
        statistic). Additional args and kwargs are passed as well.
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    factor_returns : pd.Series (optional)
        Daily noncumulative returns of the benchmark.
         - This is in the same style as returns.
    n_samples : int (optional)
        Number of bootstrap samples to draw. Default is 1000.
        Increasing this will lead to more stable / accurate estimates.
    Returns
    -------
    numpy.ndarray
        Bootstrapped sampling distribution of passed in func.
    """

    n_samples = kwargs.pop('n_samples', 1000)
    out = np.empty(n_samples)

    factor_returns = kwargs.pop('factor_returns', None)

    for i in range(n_samples):
        idx = np.random.randint(len(returns), size=len(returns))
        returns_i = returns.iloc[idx].reset_index(drop=True)
        if factor_returns is not None:
            factor_returns_i = factor_returns.iloc[idx].reset_index(drop=True)
            out[i] = func(returns_i, factor_returns_i,
                          *args, **kwargs)
        else:
            out[i] = func(returns_i,
                          *args, **kwargs)

    return out

def calc_distribution_stats(x):
    """Calculate various summary statistics of data.
    Parameters
    ----------
    x : numpy.ndarray or pandas.Series
        Array to compute summary statistics for.
    Returns
    -------
    pandas.Series
        Series containing mean, median, std, as well as 5, 25, 75 and
        95 percentiles of passed in values.
    """
    return pd.Series({'mean': np.mean(x),
                      'median': np.median(x),
                      'std': np.std(x),
                      '5%': np.percentile(x, 5),
                      '25%': np.percentile(x, 25),
                      '75%': np.percentile(x, 75),
                      '95%': np.percentile(x, 95),
                      'IQR': np.subtract.reduce(
                          np.percentile(x, [75, 25])),
                      })


