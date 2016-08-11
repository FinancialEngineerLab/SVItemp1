import sys
import py2exe
from distutils.core import setup
# import pytz
# import dateutil
# from pytz import common_timezones
# from pytz import timezone
# import datetime

# We need to import the glob module to search for all files.
import glob

sys.setrecursionlimit(5000)
# This allows to run it with a simple double click
sys.argv.append('py2exe')

py2exe_options = {
    "includes": ["tools", "tools.wind.wind_to_csv", "pyalgotrade", "stratlib.gftd_cta", "datetime",
                 "tools.date_handler", "os", "sys", "WindPy", "lxml", "lxml.*", "gzip", "matplotlib.backends",
                 "matplotlib.backends.backend_qt4agg", "matplotlib.backends.backend_tkagg",
                 "matplotlib.figure", "pylab", "numpy", "datetime.*",
                 ],
    "dll_excludes": ["MSVCP90.dll", 'tcl84.dll',
                     'tk84.dll'],
    "compressed": 1,
    "optimize": 2,
    "ascii": 0,
    "bundle_files": 3,
    "packages": ['pytz', 'matplotlib'],
}

# Save matplotlib-data to mpl-data ( It is located in thematplotlib\mpl-data
# folder and the compiled programs will look for it in \mpl-data
# note: using matplotlib.get_mpldata_info
data_files = [(r'mpl-data', glob.glob(r'C:\Anaconda2\Lib\site-packages\matplotlib\mpl-data\*.*')),
              # Because matplotlibrc does not have an extension, glob does not findit (at least I think that's why)
              # So add it manually here:
              (r'mpl-data', [r'C:\Anaconda2\Lib\site-packages\matplotlib\mpl-data\matplotlibrc']),
              (r'mpl-data\images', glob.glob(r'C:\Anaconda2\Lib\site-packages\matplotlib\mpl-data\images\*.*')),
              (r'mpl-data\fonts', glob.glob(r'C:\Anaconda2\Lib\site-packages\matplotlib\mpl-data\fonts\*.*'))]

setup(
    name='GF_TD_LIVE',
    version='1.0.0',
    windows=['GF_TD_LIVE.py'],
    zipfile=None,
    options={'py2exe': py2exe_options},
    data_files=data_files
)
