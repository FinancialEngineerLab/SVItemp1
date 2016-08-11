### Source: https://github.com/quantopian/pyfolio/blob/master/pyfolio/utils.py

import numpy as np
import pandas as pd

APPROX_BDAYS_PER_MONTH = 21
APPROX_BDAYS_PER_YEAR = 252


def one_dec_places(x, pos):
    """
    Adds 1/10th decimal to plot ticks.
    """

    return '%.1f' % x


def percentage(x, pos):
    """
    Adds percentage sign to plot ticks.
    """

    return '%.0f%%' % x


def round_two_dec_places(x):
    """
    Rounds a number to 1/100th decimal.
    """

    return np.round(x, 2)


def print_table(table, name=None, fmt=None):
    """Pretty print a pandas DataFrame.
    Uses HTML output if running inside Jupyter Notebook, otherwise
    formatted text output.
    Parameters
    ----------
    table : pandas.Series or pandas.DataFrame
        Table to pretty-print.
    name : str, optional
        Table name to display in upper left corner.
    fmt : str, optional
        Formatter to use for displaying table elements.
        E.g. '{0:.2f}%' for displaying 100 as '100.00%'.
        Restores original setting after displaying.
    """
    if isinstance(table, pd.Series):
        table = pd.DataFrame(table)

    if fmt is not None:
        prev_option = pd.get_option('display.float_format')
        pd.set_option('display.float_format', lambda x: fmt.format(x))

    if name is not None:
        table.columns.name = name

    # display(table)  # Cannot display the result table correctly
    print table

    if fmt is not None:
        pd.set_option('display.float_format', prev_option)
