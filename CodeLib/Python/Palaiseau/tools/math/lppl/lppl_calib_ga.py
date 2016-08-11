# -*- coding: utf-8 -*-

import genetic_algo_population
from pylab import *
import numpy
import tools.date_handler.date_offset as dtoffset
from datetime import datetime
# from WindPy import *

# t, a, b, tc, m, c, w, phi
inf = 2000.0


def set_default_calib_limits(data_series, limit_type=0):
    if limit_type == 0:
        limits = ([8.4, 8.8], [-1, -0.1], [data_series[0].size, data_series[0].size * 2], [0.1, 0.9], [-1, 1], [12, 18],
                  [0, 2])
    elif limit_type == 1:
        limits = ([data_series[0].size, data_series[0].size * 1.2], [0.1, 0.9], [6, 15])
    return limits


def lppl_calib_ga(data_series, start, limits=None, size=20, eliminate=0.3, mate=1.5, probmutate=0.05, vsize=4,
                  mutatetimes=2, best_solution=3, frequency=None, random_seed_population=None,
                  random_seed_individual=None, calib_type=0):
    if limits is None:
        limits = set_default_calib_limits(data_series, limit_type=calib_type)

    calib = genetic_algo_population.Population(limits, size, eliminate, mate, probmutate, vsize,
                                               data_series, random_seed_population,
                                               random_seed_individual)  # size, eliminate, mate, probmutate, vsize

    # print out information at each step
    for i in range(mutatetimes):
        calib.Fitness()
        calib.Eliminate()
        values = calib.BestSolutions(best_solution)
        for j in values:
            print j.PrintIndividual()
        calib.Mate()
        calib.Mutate()

    calib.Fitness()
    values = calib.BestSolutions(best_solution)

    print "\nvar dump"
    try:
        print values[0].cof + " "
    except:
        print "nothing"
    for x in values:
        print x.PrintIndividual()
        print "Estimate Bubble Bursting Date is: " + getBubbleBurstDate(start, x, frequency=frequency)
        print "Estimate Index will reach: " + str(x.getExpFutureIndex()) + "\n"

    return values


def getCleanDataForLPPL(df_data_from_tushare, price_type='close'):
    time = numpy.linspace(0, len(df_data_from_tushare) - 1, len(df_data_from_tushare))
    priceData = numpy.log(df_data_from_tushare[price_type]).sort_index()
    df_data = [time, priceData]

    return df_data


def getBubbleBurstDate(start_date, value, frequency=0):
    if len(start_date) == 19:
        start = datetime.strptime(start_date, "%Y-%m-%d %H:%M:%S")
    else:
        start = datetime.strptime(start_date, "%Y-%m-%d")

    critical_time = value.cof[2]

    if frequency is not None:
        burstdate = dtoffset.datetime_offset(start.date().isoformat(), int(round(critical_time / (240 / frequency))),
                                             "BD")
    else:
        burstdate = dtoffset.datetime_offset(start.date().isoformat(), int(round(critical_time, 0)), "BD")

    return str(burstdate)
