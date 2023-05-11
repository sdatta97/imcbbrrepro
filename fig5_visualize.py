import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 

# reading the CSV file
val_arr = np.array(pd.read_csv('bbr.csv'))
goodput_bbr = np.ones((2,8,8))
arr_length = val_arr.size
counter = int(0)
i = 0
while i<arr_length:
    bufcap_idx = int(np.floor_divide((i+counter)/2, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder((i+counter)/2, 64),8))
    rtt_idx = int(np.remainder(np.remainder((i+counter)/2, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    if val_arr[i] == -1:
        counter = counter + 1
        goodput_bbr [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        print(val_arr[i])
        goodput_bbr [bufcap_idx, bandwidth_idx, rtt_idx] = val_arr[i]
        i = i+2
print(counter)
print(goodput_bbr)

# reading the CSV file
val_arr = np.array(pd.read_csv('cubic.csv'))
goodput_cubic = np.ones((2,8,8))
arr_length = val_arr.size
counter = int(0)
i = 0
while i<arr_length:
    bufcap_idx = int(np.floor_divide((i+counter)/2, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder((i+counter)/2, 64),8))
    rtt_idx = int(np.remainder(np.remainder((i+counter)/2, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    if val_arr[i] == -1:
        counter = counter + 1
        goodput_cubic [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        print(val_arr[i])
        goodput_cubic [bufcap_idx, bandwidth_idx, rtt_idx] = val_arr[i]
        i = i+2
print(counter)
print(goodput_cubic)
gpgain_10mb = np.ones((8,8))
gpgain_100mb = np.ones((8,8))
for bandwidth_idx in range(8):
    for rtt_idx in range(8):
        gpgain_10mb[bandwidth_idx,rtt_idx] = np.divide((goodput_bbr[0,bandwidth_idx,rtt_idx] - goodput_cubic[0,bandwidth_idx,rtt_idx]), goodput_cubic[0,bandwidth_idx,rtt_idx])
        gpgain_100mb[bandwidth_idx,rtt_idx]  = np.divide((goodput_bbr[1,bandwidth_idx,rtt_idx] - goodput_cubic[1,bandwidth_idx,rtt_idx]), goodput_cubic[1,bandwidth_idx,rtt_idx])
print(gpgain_10mb)
fig, ax = plt.subplots()
im = ax.imshow(gpgain_10mb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(gpgain_10mb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()

print(gpgain_100mb)
fig, ax = plt.subplots()
im = ax.imshow(gpgain_100mb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(gpgain_100mb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()