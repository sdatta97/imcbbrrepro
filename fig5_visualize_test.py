import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
df1 = pd.read_csv("tput_cubic.csv")
throughput = df1.to_numpy()
x = np.linspace(0,60,60,endpoint=False)
y = throughput[:-2].copy()
fig = plt.figure()
axs = plt.axes()
plt.plot(x,y, label="tput")
##axs.set_xlim([0,5])
axs.set_ylabel("Throughput (kbps)")
axs.set_xlabel("Time (s)")
plt.legend()
plt.show()