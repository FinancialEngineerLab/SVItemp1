from WindPy import  *
import datetime
import csv
from tools.date_handler import date_offset

def wind_to_csv(instrument,start_date,end_date, path, BarSize = None):
    w.start()
    if BarSize is None:
        wd = w.wsi(instrument, "open,high,low,close", start_date+" 09:30:00", end_date+" 15:01:00", "BarSize=5")
    else:
        wd = w.wsi(instrument, "open,high,low,close", start_date+" 09:30:00", end_date+" 15:01:00", "BarSize="+BarSize)
    csvfile = file(path,'wb')
    writer= csv.writer(csvfile)
    data=[]

    for i in range(0,len(wd.Times)):
        if (wd.Times[i].hour!=9 or wd.Times[i].minute>30) and (wd.Times[i].hour!=15 or wd.Times[i].minute==0) :
           data.append((wd.Times[i],wd.Data[0][i],wd.Data[1][i],wd.Data[2][i],wd.Data[3][i]))
    writer.writerows(data)
    csvfile.close()

if __name__ == "__main__":
    instrument = 'IC00.CFE'
    date = '2015-10-14'
    start_date = '2015-05-10'
    path = 'D:\\IC00.csv'
    wind_to_csv(instrument, start_date, date, path)