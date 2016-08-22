import numpy


def is_within_bound(bound_list, value):
    if bound_list[0] <= value <= bound_list[1]:
        return True
    else:
        return False


# price_data is in pd series form
def get_hist_returns(price_data, return_type, col = 0):
    length = len(price_data)
    returns = []
    for i in range(1, length):
        if return_type == 'log_return':
            returns.append(numpy.log(price_data.iloc[i, col]/price_data.iloc[i-1, col]))
        else:
            returns.append((price_data.iloc[i, col] - price_data.iloc[i-1, col])/price_data.iloc[i-1, col])
    return returns