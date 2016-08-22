import numpy as np
def get_maxdrawdown(prices,reg_size,is_high):
    prices=prices[-1*reg_size:]
    if is_high:
        maxdrawdown = ( max(prices)-prices[-1])/max(prices)
    else:
        maxdrawdown = (prices[-1]-min(prices))/prices[-1]

    return maxdrawdown


def get_k_order_derivative(x,y,k):
    return np.polyfit(x,y,k)[0]

def get_price_data_series(prices,data_num):
    res = np.zeros(data_num)
    for i in range(0,data_num):
        res[i] = prices[-1*(data_num-i)]
    return res
