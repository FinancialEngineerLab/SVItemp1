import tushare as ts

df = ts.get_tick_data('601318',date='2015-07-07')
print df
df = df.sort_values(by = 'volume')
print  df.head(2436)
