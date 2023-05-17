import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 

dat = pd.read_csv('tput.csv')
dat = dat.groupby(by=["Buffer"]).mean().reset_index()
bufcap_arr = np.multiply(1000,np.array([10,100,1000,5000,10000]))
val_arr_1 = np.divide(np.array(dat.BBR_goodput),1000)
plt.xscale("log")
plt.plot(bufcap_arr,val_arr_1, label="BBR")
val_arr_2 = np.divide(np.array(dat.CUBIC_goodput),1000)
plt.xscale("log")
plt.plot(bufcap_arr,val_arr_2, label="CUBIC")
val_arr_3 = np.add(val_arr_1,val_arr_2)
plt.xscale("log")
plt.plot(bufcap_arr,val_arr_3, label="Total")
plt.title("Goodput comparison against buffer capacity")
plt.xlabel("Buffer capacity (in bits)")
plt.ylabel("Goodput (in Mbps)")
plt.legend(["BBR", "CUBIC","Total"])
plt.show()