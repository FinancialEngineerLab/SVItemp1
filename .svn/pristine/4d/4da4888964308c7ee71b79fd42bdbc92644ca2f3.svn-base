from tools.tushare import get_data
from tools.plot import plot_pyfolio
import matplotlib.pyplot as plt
from tools.data_handler import timeseries


if __name__ == "__main__":
    sec_code = 'hs300'
    start = '2015-01-01'
    end = '2015-06-01'
    ktype = 'D'
    price_type = 'close'
    pd_return_data = get_data.get_hist_returns_from_tushare(sec_code,start, end, ktype,price_type)

    # quantiles
    quantiles = pd_return_data.quantile(q=[0.15,0.85])
    print 'Quantiles of returns'
    print quantiles

    # plot the returns
    ax_return_dist = plt.subplot(2,1,1)
    ax_return_quantiles = plt.subplot(2,1,2)
    pd_return_data_monthly =  timeseries.aggregate_returns(pd_return_data,'monthly')
    pd_return_data_yearly =  timeseries.aggregate_returns(pd_return_data,'yearly')
    plot_pyfolio.plot_period_return_dist(pd_return_data, time_horizon='daily', ax = ax_return_dist)
    plot_pyfolio.plot_return_quantiles(pd_return_data, pd_return_data_monthly, pd_return_data_yearly, ax =ax_return_quantiles )
    plt.show()