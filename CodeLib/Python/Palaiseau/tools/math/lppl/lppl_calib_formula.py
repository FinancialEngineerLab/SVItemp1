# -*- coding: utf-8 -*-

import numpy as np

global DataSeries


def params_calculate(t_c, m, omega, data_series):
    t_lens = data_series[0].size

    f_t = [ft_formula(t_c, t, m) for t in range(t_lens)]
    g_t = [gt_formula(t_c, t, m, omega) for t in range(t_lens)]
    h_t = [ht_formula(t_c, t, m, omega) for t in range(t_lens)]

    y_t = np.array(data_series[1])
    x = np.array([1] * t_lens)
    x = np.transpose(np.vstack((x, np.array(f_t), np.array(g_t), np.array(h_t))))

    b = np.dot(np.dot(np.mat(np.dot(np.transpose(x), x)).I, np.transpose(x)), y_t)
    params = params_transform(t_c, m, omega, b)
    return params


def params_transform(t_c, m, omega, vector):
    a = vector[0, 0]
    b = vector[0, 1]
    c1 = vector[0, 2]
    c2 = vector[0, 3]
    c = np.sqrt(np.power(c1, 2) + np.power(c2, 2))
    phi = np.arcsin(c2 / c)
    params = (a, b, t_c, m, c, omega, phi)
    return params


def ft_formula(t_c, t, m):
    return np.power(t_c - t, m)


def gt_formula(t_c, t, m, omega):
    return np.power(t_c - t, m) * np.cos(omega * np.log(t_c - t))


def ht_formula(t_c, t, m, omega):
    return np.power(t_c - t, m) * np.sin(omega * np.log(t_c - t))


def lppl(t, x):
    a = x[0]
    b = x[1]
    tc = x[2]
    m = x[3]
    c = x[4]
    w = x[5]
    phi = x[6]
    return a + (np.power(tc - t, m)) * (b + (c * np.cos((w * np.log(tc - t)) + phi)))
    # return a + (b * np.power(tc - t, m)) * (1 + (c * np.cos((w * np.log(tc - t)) + phi)))


# DataSeries is in pandas series format
def func(x):
    delta = [lppl(t, x) for t in DataSeries[0]]  # 生成lppl时间序列
    delta = np.subtract(delta, DataSeries[1])  # 将生成的lppl时间序列减去对数指数序列
    delta = np.power(delta, 2)
    return np.average(delta)  # 返回拟合均方差