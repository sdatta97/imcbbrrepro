import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 
import seaborn as sns

dat = pd.read_csv('latency.csv')
dat = dat.groupby(by=["Buffer","Bandwidth","delay"]).mean().reset_index()
dat = dat.assign(dec =  100*(dat.CUBIC_latency - dat.BBR_latency)/dat.CUBIC_latency)

dat_sm_hm = dat[dat.Buffer==100].pivot("Bandwidth", "delay", "dec")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".1f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("Latency decrease for BBR vs CUBIC, 100KB buffer")
plt.show()

dat_sm_hm = dat[dat.Buffer==10000].pivot("Bandwidth", "delay", "dec")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".1f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("Latency decrease for BBR vs CUBIC, 10MB buffer")
plt.show()