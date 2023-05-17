import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 
import seaborn as sns

dat = pd.read_csv('tput.csv')
dat = dat.groupby(by=["Buffer","Bandwidth","delay"]).mean().reset_index()
dat = dat.assign(gain =  100*(dat.BBR_goodput - dat.CUBIC_goodput)/dat.CUBIC_goodput)

dat_sm_hm = dat[dat.Buffer==100].pivot("Bandwidth", "delay", "gain")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".1f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("Goodput gain for BBR vs CUBIC, 100KB buffer")
plt.show()

dat_sm_hm = dat[dat.Buffer==10000].pivot("Bandwidth", "delay", "gain")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".1f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("Goodput gain for BBR vs CUBIC, 10MB buffer")
plt.show()

dat = pd.read_csv('bbr_retr.csv')
dat = dat.groupby(by=["Buffer","Bandwidth","delay","CC"]).mean().reset_index()
dat = dat.assign(retr =  dat.Retransmissions)
dat_sm_hm = dat[dat.Buffer==100].pivot("Bandwidth", "delay", "retr")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".0f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("#Retransmissions for BBR, 100KB buffer")
plt.show()

dat = pd.read_csv('cubic_retr.csv')
dat = dat.groupby(by=["Buffer","Bandwidth","delay","CC"]).mean().reset_index()
dat = dat.assign(retr =  dat.Retransmissions)
dat_sm_hm = dat[dat.Buffer==100].pivot("Bandwidth", "delay", "retr")
sns.set(font_scale=0.7)
ax = sns.heatmap(dat_sm_hm, annot=True, fmt=".0f", cmap="viridis")
ax.invert_yaxis()
ax.set_title("#Retransmissions for CUBIC, 100KB buffer")
plt.show()