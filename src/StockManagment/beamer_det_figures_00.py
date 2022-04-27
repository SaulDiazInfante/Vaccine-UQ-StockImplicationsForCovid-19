from cProfile import label
from matplotlib import figure
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
#
plt.style.use('fivethirtyeight')
#
data_folder = "./data"
df = pd.read_csv("data/df_solution.csv")
par = pd.read_json("parameters_model.json")
time_line = df["time"]
start_date='2021-01-01'
time_line_date_in_days = pd.to_datetime(start_date) + \
    pd.to_timedelta(time_line.values, unit='D')
df["date"] = time_line_date_in_days
df = df.set_index('date')
#
states = [
    'S',
    'E',
    'I_S',
    #'I_A',
    'D',    
    #'R', 
    'V', 
    'X_vac',
 #   'K_stock',
 #   'action'
]
N = par["N"][0]
df_states = N * df[states]
#
figure_states, axes_states = plt.subplots(
    figsize=(14, 8.7),
    nrows=2,
    ncols=3
)
df_states.plot(
    subplots=True,
    layout=(2, 2),
    ax=axes_states, 
    sharex=True,
    label="deterministic",
    lw=1, 
    legend=False
    )

axes_states[0, 0].set_ylabel(r'$S$')
axes_states[0, 1].set_ylabel(r'$E$')
axes_states[0, 2].set_ylabel(r'$I_S$')
axes_states[1, 0].set_ylabel(r'$D$')
axes_states[1, 1].set_ylabel(r'$V$')
axes_states[1, 2].set_ylabel(r'$X_{vac}$')

plt.savefig("det_states.svg", dpi=300)
figure_states.tight_layout()
plt.show()
## Incidence figures
#
