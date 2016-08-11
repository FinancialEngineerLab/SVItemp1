# -*- coding: utf-8 -*-

from collections import OrderedDict
from functools import wraps

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.ticker import FuncFormatter

import _seaborn as sns
from tools.data_handler import dataseries_to_nparray, timeseries
from tools.date_handler import date_conversion
from tools.plot import plot_utils


def plotting_context(func):
    """Decorator to set plotting context during function call."""

    @wraps(func)
    def call_w_context(*args, **kwargs):
        set_context = kwargs.pop('set_context', True)
        if set_context:
            with context():
                return func(*args, **kwargs)
        else:
            return func(*args, **kwargs)

    return call_w_context


def context(context='notebook', font_scale=1.5, rc=None):
    """Create pyfolio default plotting style context.
    Under the hood, calls and returns seaborn.plotting_context() with
    some custom settings. Usually you would use in a with-context.
    Parameters
    ----------
    context : str, optional
        Name of seaborn context.
    font_scale : float, optional
        Scale font by factor font_scale.
    rc : dict, optional
        Config flags.
        By default, {'lines.linewidth': 1.5,
                     'axes.facecolor': '0.995',
                     'figure.facecolor': '0.97'}
        is being used and will be added to any
        rc passed in, unless explicitly overriden.
    Returns
    -------
    seaborn plotting context
    Example
    -------
    #>>> with pyfolio.plotting.context(font_scale=2):
    #>>>    pyfolio.create_full_tear_sheet()
    See also
    --------
    For more information, see seaborn.plotting_context().
"""
    if rc is None:
        rc = {}

    rc_default = {'lines.linewidth': 1.5,
                  'axes.facecolor': '0.995',
                  'figure.facecolor': '0.97'}

    # Add defaults if they do not exist
    for name, val in rc_default.items():
        rc.setdefault(name, val)

    return sns.plotting_context(context=context, font_scale=font_scale,
                                rc=rc)


def get_monthly_pd_series(returns, time_series=None):
    returns_pd_series = dataseries_to_nparray.change_data_series_to_pd_series(returns, time_series)
    monthly_ret_table = timeseries.aggregate_returns(returns_pd_series, 'monthly')
    return monthly_ret_table


def plot_monthly_returns_heatmap(returns, ax=None, **kwargs):
    """
    Plots a heatmap of returns by month.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to seaborn plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    monthly_ret_table = timeseries.aggregate_returns(returns, 'monthly')

    monthly_ret_table = monthly_ret_table.unstack()
    monthly_ret_table = np.round(monthly_ret_table, 3)

    sns.heatmap(
        monthly_ret_table.fillna(0) *
        100.0,
        annot=True,
        annot_kws={
            "size": 9},
        alpha=1.0,
        center=0.0,
        cbar=False,
        cmap=matplotlib.cm.RdYlGn,
        ax=ax, **kwargs)
    ax.set_ylabel('Year')
    ax.set_xlabel('Month')
    ax.set_title("Monthly Returns (%)")
    return ax


def plot_annual_returns(returns, ax=None, **kwargs):
    """
    Plots a bar graph of returns by year.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    x_axis_formatter = FuncFormatter(plot_utils.percentage)
    ax.xaxis.set_major_formatter(FuncFormatter(x_axis_formatter))
    ax.tick_params(axis='x', which='major', labelsize=10)

    ann_ret_df = pd.DataFrame(
        timeseries.aggregate_returns(
            returns,
            'yearly'))

    ax.axvline(
        100 *
        ann_ret_df.values.mean(),
        color='steelblue',
        linestyle='--',
        lw=4,
        alpha=0.7)
    (100 * ann_ret_df.sort_index(ascending=False)
     ).plot(ax=ax, kind='barh', alpha=0.70, **kwargs)
    ax.axvline(0.0, color='black', linestyle='-', lw=3)

    ax.set_ylabel('Year')
    ax.set_xlabel('Returns')
    ax.set_title("Annual Returns")
    ax.legend(['mean'])
    return ax


def plot_monthly_returns_dist(returns, ax=None, **kwargs):
    """
    Plots a distribution of monthly returns.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    x_axis_formatter = FuncFormatter(plot_utils.percentage)
    ax.xaxis.set_major_formatter(FuncFormatter(x_axis_formatter))
    ax.tick_params(axis='x', which='major', labelsize=10)

    monthly_ret_table = timeseries.aggregate_returns(returns, 'monthly')

    ax.hist(
        100 * monthly_ret_table,
        color='orangered',
        alpha=0.80,
        bins=20,
        **kwargs)

    ax.axvline(
        100 * monthly_ret_table.mean(),
        color='gold',
        linestyle='--',
        lw=4,
        alpha=1.0)

    ax.axvline(0.0, color='black', linestyle='-', lw=3, alpha=0.75)
    ax.legend(['mean'])
    ax.set_ylabel('Number of months')
    ax.set_xlabel('Returns')
    ax.set_title("Distribution of Monthly Returns")
    return ax


def plot_period_return_dist(returns, ax=None, time_horizon='monthly', **kwargs):
    """
    Plots a distribution of monthly returns.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """
    if ax is None:
        ax = plt.gca()

    x_axis_formatter = FuncFormatter(plot_utils.percentage)
    ax.xaxis.set_major_formatter(FuncFormatter(x_axis_formatter))
    ax.tick_params(axis='x', which='major', labelsize=10)

    monthly_ret_table = timeseries.aggregate_returns(returns, time_horizon)

    ax.hist(
        100 * monthly_ret_table,
        color='orangered',
        alpha=0.80,
        bins=20,
        **kwargs)

    ax.axvline(
        100 * monthly_ret_table.mean(),
        color='gold',
        linestyle='--',
        lw=4,
        alpha=1.0)

    ax.axvline(0.0, color='black', linestyle='-', lw=3, alpha=0.75)
    ax.legend(['mean'])
    ax.set_ylabel('Number of periods')
    ax.set_xlabel('Returns')
    ax.set_title("Distribution of Returns")
    return ax


def plot_drawdown_periods(returns, top=10, ax=None, **kwargs):
    """
    Plots cumulative returns highlighting top drawdown periods.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    top : int, optional
        Amount of top drawdowns periods to plot (default 10).
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    y_axis_formatter = FuncFormatter(plot_utils.one_dec_places)
    ax.yaxis.set_major_formatter(FuncFormatter(y_axis_formatter))

    df_cum_rets = timeseries.cum_returns(returns, starting_value=1.0)
    df_drawdowns = timeseries.gen_drawdown_table(returns, top=top)
    df_cum_rets.plot(ax=ax, **kwargs)
    lim = ax.get_ylim()

    # 排除掉recoverDate = nan 和 net drawdown = 0的情况
    # 计辉 2016/3/6

    drop_list = []
    for i in range(0, len(df_drawdowns)):
        if str(df_drawdowns.values[i][4]) == 'nan' or df_drawdowns.values[i][0] == 0.0:
            drop_list.append(i)
    for j in drop_list:
        df_drawdowns = df_drawdowns.drop(j)

    colors = sns.cubehelix_palette(len(df_drawdowns))[::-1]

    j = 0
    for i, (peak, recovery) in df_drawdowns[
        ['peak date', 'recovery date']].iterrows():
        if pd.isnull(recovery):
            recovery = returns.index[-1]
        ax.fill_between((peak, recovery),
                        lim[0],
                        lim[1],
                        alpha=.4,
                        color=colors[j])
        j += 1

    ax.set_title('Top %i Drawdown Periods' % top)
    ax.set_ylabel('Cumulative returns')
    ax.legend(['Portfolio'], loc='upper left')
    ax.set_xlabel('')
    return ax


def plot_drawdown_underwater(returns, ax=None, **kwargs):
    """Plots how far underwaterr returns are over time, or plots current
    drawdown vs. date.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    y_axis_formatter = FuncFormatter(plot_utils.percentage)
    ax.yaxis.set_major_formatter(FuncFormatter(y_axis_formatter))

    df_cum_rets = timeseries.cum_returns(returns, starting_value=1.0)
    running_max = np.maximum.accumulate(df_cum_rets)
    underwater = -100 * ((running_max - df_cum_rets) / running_max)
    (underwater).plot(ax=ax, kind='area', color='coral', alpha=0.7, **kwargs)
    ax.set_ylabel('Drawdown')
    ax.set_title('Underwater Plot')
    ax.set_xlabel('')
    return ax


def plot_rolling_returns(returns,
                         factor_returns=None,
                         live_start_date=None,
                         cone_std=None,
                         legend_loc='best',
                         volatility_match=False,
                         cone_function=timeseries.forecast_cone_bootstrap,
                         ax=None, **kwargs):
    """
    Plots cumulative rolling returns versus some benchmarks'.
    Backtest returns are in green, and out-of-sample (live trading)
    returns are in red.
    Additionally, a non-parametric cone plot may be added to the
    out-of-sample returns region.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    factor_returns : pd.Series, optional
        Daily noncumulative returns of a risk factor.
         - This is in the same style as returns.
    live_start_date : datetime, optional
        The date when the strategy began live trading, after
        its backtest period. This date should be normalized.
    cone_std : float, or tuple, optional
        If float, The standard deviation to use for the cone plots.
        If tuple, Tuple of standard deviation values to use for the cone plots
         - See timeseries.forecast_cone_bounds for more details.
    legend_loc : matplotlib.loc, optional
        The location of the legend on the plot.
    volatility_match : bool, optional
        Whether to normalize the volatility of the returns to those of the
        benchmark returns. This helps compare strategies with different
        volatilities. Requires passing of benchmark_rets.
    cone_function : function, optional
        Function to use when generating forecast probability cone.
        The function signiture must follow the form:
        def cone(in_sample_returns (pd.Series),
                 days_to_project_forward (int),
                 cone_std= (float, or tuple),
                 starting_value= (int, or float))
        See timeseries.forecast_cone_bootstrap for an example.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
"""
    if ax is None:
        ax = plt.gca()

    ax.set_ylabel('Cumulative returns')
    ax.set_xlabel('')

    if volatility_match and factor_returns is None:
        raise ValueError('volatility_match requires passing of'
                         'factor_returns.')
    elif volatility_match and factor_returns is not None:
        bmark_vol = factor_returns.loc[returns.index].std()
        returns = (returns / returns.std()) * bmark_vol

    cum_rets = timeseries.cum_returns(returns, 1.0)

    y_axis_formatter = FuncFormatter(plot_utils.one_dec_places)
    ax.yaxis.set_major_formatter(FuncFormatter(y_axis_formatter))

    if factor_returns is not None:
        # Siqiao 2016/03/08
        # check for the time index format of factor_returns
        if type(factor_returns.index[0]) is tuple:
            factor_returns.index = date_conversion.change_tuple_format_to_string(factor_returns.index)
        cum_factor_returns = timeseries.cum_returns(
            factor_returns[cum_rets.index], 1.0)
        cum_factor_returns.plot(lw=2, color='gray',
                                label=factor_returns.name, alpha=0.60,
                                ax=ax, **kwargs)

    if live_start_date is not None:
        # live_start_date = date_conversion.get_utc_timestamp(live_start_date)
        is_cum_returns = cum_rets.loc[cum_rets.index < live_start_date]
        oos_cum_returns = cum_rets.loc[cum_rets.index >= live_start_date]
    else:
        is_cum_returns = cum_rets
        oos_cum_returns = pd.Series([])
    # is_cum_returns = pd.Series(is_cum_returns)
    is_cum_returns.plot(lw=3, color='forestgreen', alpha=0.6,
                        label='Backtest', ax=ax, **kwargs)

    if len(oos_cum_returns) > 0:
        oos_cum_returns.plot(lw=4, color='red', alpha=0.6,
                             label='Live', ax=ax, **kwargs)

        if cone_std is not None:
            if isinstance(cone_std, (float, int)):
                cone_std = [cone_std]
            # Siqiao 2016/03/08
            # check for the time index format of factor_returns
            # if  type(returns.index[0]) is tuple:
            #    returns.index = date_conversion.change_tuple_format_to_string(returns.index)
            is_returns = returns.loc[returns.index < live_start_date]
            cone_bounds = cone_function(
                is_returns,
                len(oos_cum_returns),
                cone_std=cone_std,
                starting_value=is_cum_returns[-1])

            cone_bounds = cone_bounds.set_index(oos_cum_returns.index)

            for std in cone_std:
                ax.fill_between(cone_bounds.index,
                                cone_bounds[float(std)],
                                cone_bounds[float(-std)],
                                color='steelblue', alpha=0.5)

    if legend_loc is not None:
        ax.legend(loc=legend_loc)
    ax.axhline(1.0, linestyle='--', color='black', lw=2)

    return ax


def plot_return_quantiles(returns, df_weekly, df_monthly, ax=None, **kwargs):
    """Creates a box plot of daily, weekly, and monthly return
    distributions.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    df_weekly : pd.Series
        Weekly returns of the strategy, noncumulative.
         - See timeseries.aggregate_returns.
    df_monthly : pd.Series
        Monthly returns of the strategy, noncumulative.
         - See timeseries.aggregate_returns.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    **kwargs, optional
        Passed to seaborn plotting function.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """

    if ax is None:
        ax = plt.gca()

    sns.boxplot(data=[returns, df_weekly, df_monthly],
                ax=ax, **kwargs)
    ax.set_xticklabels(['daily', 'weekly', 'monthly'])
    ax.set_title('Return quantiles')
    return ax


def show_return_range(returns, df_weekly):
    """
    Print monthly return and weekly return standard deviations.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    df_weekly : pd.Series
        Weekly returns of the strategy, noncumulative.
         - See timeseries.aggregate_returns.
    """

    two_sigma_daily = returns.mean() - 2 * returns.std()
    two_sigma_weekly = df_weekly.mean() - 2 * df_weekly.std()

    var_sigma = pd.Series([two_sigma_daily, two_sigma_weekly],
                          index=['2-sigma returns daily',
                                 '2-sigma returns weekly'])

    print(np.round(var_sigma, 3))


def show_worst_drawdown_periods(returns, top=5):
    """Prints information about the worst drawdown periods.
    Prints peak dates, valley dates, recovery dates, and net
    drawdowns.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    top : int, optional
        Amount of top drawdowns periods to plot (default 5).
    """

    print('\nWorst Drawdown Periods')
    drawdown_df = timeseries.gen_drawdown_table(returns, top=top)
    drawdown_df['net drawdown in %'] = list(
        map(plot_utils.round_two_dec_places, drawdown_df['net drawdown in %']))
    # print(drawdown_df.sort('net drawdown in %', ascending=False)) # Deprecated
    print(drawdown_df.sort_values(by='net drawdown in %', ascending=False))


def plot_perf_stats(returns, factor_returns, ax=None):
    """Create box plot of some performance metrics of the strategy.
    The width of the box whiskers is determined by a bootstrap.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    factor_returns : pd.DataFrame, optional
        data set containing the Fama-French risk factors. See
        utils.load_portfolio_risk_factors.
    ax : matplotlib.Axes, optional
        Axes upon which to plot.
    Returns
    -------
    ax : matplotlib.Axes
        The axes that were plotted on.
    """
    if ax is None:
        ax = plt.gca()

    bootstrap_values = timeseries.perf_stats_bootstrap(returns,
                                                       factor_returns,
                                                       return_stats=False)
    bootstrap_values = bootstrap_values.drop('kurtosis', axis='columns')

    sns.boxplot(data=bootstrap_values, orient='h', ax=ax)

    return ax


def show_perf_stats(returns, factor_returns, live_start_date=None,
                    bootstrap=False, split_factor_returns=False):
    """Prints some performance metrics of the strategy.
    - Shows amount of time the strategy has been run in backtest and
      out-of-sample (in live trading).
    - Shows Omega ratio, max drawdown, Calmar ratio, annual return,
      stability, Sharpe ratio, annual volatility, alpha, and beta.
    Parameters
    ----------
    returns : pd.Series
        Daily returns of the strategy, noncumulative.
         - See full explanation in tears.create_full_tear_sheet.
    live_start_date : datetime, optional
        The point in time when the strategy began live trading, after
        its backtest period.
    factor_returns : pd.Series
        Daily noncumulative returns of the benchmark.
         - This is in the same style as returns.
    bootstrap : boolean (optional)
        Whether to perform bootstrap analysis for the performance
        metrics.
         - For more information, see timeseries.perf_stats_bootstrap
    """

    if bootstrap:
        perf_func = timeseries.perf_stats_bootstrap
    else:
        perf_func = timeseries.perf_stats

    if live_start_date is not None:
        live_start_date = date_conversion.get_utc_timestamp(live_start_date)
        returns_backtest = returns[returns.index < live_start_date]
        returns_live = returns[returns.index > live_start_date]
        if split_factor_returns:  # Siqiao 2016/08/09 perf_func fails if factor_returns are not of the same size with returns
            factor_returns_live = factor_returns[
                factor_returns.index > live_start_date]  # add a var here => to work with returns live
            factor_returns_backtest = factor_returns[factor_returns.index < live_start_date]

            perf_stats_live = perf_func(
                returns_live,
                factor_returns=factor_returns_live)
        else:
            perf_stats_live = perf_func(
                returns_live,
                factor_returns=factor_returns)

        perf_stats_all = perf_func(
            returns,
            factor_returns=factor_returns)

        print('Out-of-Sample Months: ' +
              str(int(len(returns_live) / plot_utils.APPROX_BDAYS_PER_MONTH)))
    else:
        returns_backtest = returns

    print('Backtest Months: ' +
          str(int(len(returns_backtest) / plot_utils.APPROX_BDAYS_PER_MONTH)))

    if split_factor_returns and factor_returns_backtest is not None:
        perf_stats = perf_func(
            returns_backtest,
            factor_returns=factor_returns_backtest)
    else:
        perf_stats = perf_func(
            returns_backtest,
            factor_returns=factor_returns)

    if live_start_date is not None:
        perf_stats = pd.concat(OrderedDict([
            ('Backtest', perf_stats),
            ('Out of sample', perf_stats_live),
            ('All history', perf_stats_all),
        ]), axis=1)
    else:
        perf_stats = pd.DataFrame(perf_stats, columns=['Backtest'])

    plot_utils.print_table(perf_stats, name='Performance statistics',
                           fmt='{0:.2f}')
