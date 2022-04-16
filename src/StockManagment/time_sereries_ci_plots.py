import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

#TODO: convert to timeseries and plot
data_folder = "./data"
df_m = pd.read_csv("data/df_median.csv")
par = pd.read_json("parameters_model.json")
time_line = df_m["time"]
start_date='2021-01-01'
time_line_date_in_days = pd.to_datetime(start_date) + \
    pd.to_timedelta(time_line.values, unit='D')
df_m["date"] = time_line_date_in_days
df_m = df_m.set_index('date')
states = [
    # 'S',
    # 'E',
    'I_S',
    # 'I_A',
    'D',    
    # 'R', 
    # 'V', 
    'X_vac'
    #'K_stock',
    #'action'
]
N = par["N"][0]
stock_policy = ['K_stock', 'action']
df_m_states = N * df_m[states]
df_m_stock_policy = N * df_m[stock_policy]
df_m_states.plot(subplots = True)
df_m_stock_policy.plot(subplots = True)
plt.show()