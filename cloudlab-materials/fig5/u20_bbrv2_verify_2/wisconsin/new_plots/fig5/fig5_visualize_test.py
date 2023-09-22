import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
df1 = pd.read_csv("tput_bbr.csv")
throughput = df1.to_numpy()
throughput = throughput[:-2].copy()
fig = plt.figure()
axs = plt.axes()
plt.plot(np.arange(60),throughput, label="tput")
##axs.set_xlim([5,8])
axs.set_ylabel("Throughput (kbps)")
axs.set_xlabel("Time (s)")
plt.legend()
plt.show()