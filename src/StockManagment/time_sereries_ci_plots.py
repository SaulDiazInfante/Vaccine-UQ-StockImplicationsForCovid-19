import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

#TODO: convert to timeseries and plot
data_folderh = "./data"
df_mc = pd.read_csv("df_mean.csv")
par = pd.read_json("parameters_model.json")
time_line = par["time"]
start_date='2021-01-01'
time_line_date_in_days = pd.to_datetime(start_date) + \
    pd.to_timedelta(time_line.values, unit='D')
    