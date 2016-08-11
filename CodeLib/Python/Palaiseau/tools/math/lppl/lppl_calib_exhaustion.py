import numpy as np
import lppl_calib_formula
from lppl_calib_formula import params_calculate as params_calculate
from lppl_calib_formula import lppl as lppl
from lppl_calib_formula import func as func
import genetic_algo_individual


def lppl_calib_exhaustion(data_series, t_c=[0, 100, 1], m=[0.1, 0.9, 0.1], phi=[6, 13, 0.5]):
    best_fit = []
    fitness = 100000000

    t_c_max = t_c[1]
    t_c_min = t_c[0]
    t_c_step = t_c[2]

    m_min = m[0]
    m_max = m[1]
    m_step = m[2]


    phi_min = phi[0]
    phi_max = phi[1]
    phi_step = phi[2]

    lppl_calib_formula.DataSeries = data_series

    for t_c in range(int(data_series[0].size*(1 + t_c_min)), int((t_c_max + 1)*data_series[0].size), t_c_step):
        for m in np.arange(m_min, m_max, m_step):
            for phi in np.arange(phi_min, phi_max, phi_step):
                fit = params_calculate(t_c, m, phi, data_series)
                temp = func(fit)
                if temp < fitness:
                    fitness = temp
                    best_fit = params_calculate(t_c, m, phi, data_series)
    value = genetic_algo_individual.Individual(best_fit)
    value.fit = fitness
    print value.PrintIndividual()
    return value
