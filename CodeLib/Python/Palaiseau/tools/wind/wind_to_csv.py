from WindPy import *
import csv


def wind_to_csv(sec_code, start_date, end_date, path, BarSize=None):
    w.start()
    if BarSize is None:
        wd = w.wsi(sec_code, "open,high,low,close", start_date + " 09:30:00", end_date + " 15:01:00", "BarSize=5")
    elif BarSize == 'daily':
        wd = w.wsd(sec_code, "open,high,low,close", start_date, end_date,'Fill = Previous') # daily data
    else:
        wd = w.wsi(sec_code, "open,high,low,close", start_date + " 09:30:00", end_date + " 15:01:00",
                   "BarSize=" + BarSize)
    csvfile = file(path, 'wb')
    writer = csv.writer(csvfile)
    data = []

    for i in range(0, len(wd.Times)):
        if wd.Data[1][i]!=wd.Data[2][i]:
            data.append((wd.Times[i], wd.Data[0][i], wd.Data[1][i], wd.Data[2][i], wd.Data[3][i]))
    writer.writerows(data)
    csvfile.close()


if __name__ == "__main__":
    sec_code = '000905.SH'
    end_date = '2016-07-25'
    start_date = '2009-01-01'
    path = 'D:\\000300SH daily 2010-2016.csv '
    wind_to_csv(sec_code, start_date, end_date, path, BarSize='daily')
