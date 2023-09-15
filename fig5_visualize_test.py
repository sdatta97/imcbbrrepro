import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
df1 = pd.read_csv("tput_new.csv")
df = df1.groupby(by=["Buffer","Bandwidth","rtt"]).mean().reset_index()
throughput = df.to_numpy()
throughput = throughput[:-2].copy()
fig = plt.figure()
axs = plt.axes()
plt.plot(np.arange(60),throughput, label="tput")
##axs.set_xlim([5,8])
axs.set_xlabel("Time (s)")
plt.legend()
plt.show()