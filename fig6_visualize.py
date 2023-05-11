import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 

# reading the CSV file
val_arr = np.array(pd.read_csv('bbr_10mb.csv'))
latency_bbr_10mb = np.ones((2,8,8))
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
        latency_bbr_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        latency_bbr_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = -int(val_arr[i].split('-'))
        i = i+2
print(counter)
print(latency_bbr_10mb)

val_arr = np.array(pd.read_csv('bbr_100mb.csv'))
latency_bbr_100mb = np.ones((2,8,8))
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
        latency_bbr_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        print(-val_arr[i])
        latency_bbr_100mb [bufcap_idx, bandwidth_idx, rtt_idx] = -val_arr[i]
        i = i+2
print(counter)
print(latency_bbr_100mb)

val_arr = np.array(pd.read_csv('cubic_10mb.csv'))
latency_cubic_10mb = np.ones((2,8,8))
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
        latency_cubic_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        print(-val_arr[i])
        latency_cubic_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = -val_arr[i]
        i = i+2
print(counter)
print(latency_cubic_10mb)

val_arr = np.array(pd.read_csv('cubic_100mb.csv'))
latency_cubic_100mb = np.ones((2,8,8))
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
        latency_cubic_10mb [bufcap_idx, bandwidth_idx, rtt_idx] = 0
        i = i+1
    else:
        print(-val_arr[i])
        latency_cubic_100mb [bufcap_idx, bandwidth_idx, rtt_idx] = -val_arr[i]
        i = i+2
print(counter)
print(latency_cubic_100mb)

latdec_100kb = np.ones((8,8))
latdec_10mb = np.ones((8,8))
for bandwidth_idx in range(8):
    for rtt_idx in range(8):
        latdec_100kb[bandwidth_idx,rtt_idx] = np.divide((latency_bbr_100mb[0,bandwidth_idx,rtt_idx] - latency_cubic_100mb[0,bandwidth_idx,rtt_idx]), latency_cubic_100mb[0,bandwidth_idx,rtt_idx])
        latdec_10mb[bandwidth_idx,rtt_idx]  = np.divide((latency_bbr_100mb[1,bandwidth_idx,rtt_idx] - latency_cubic_100mb[1,bandwidth_idx,rtt_idx]), latency_cubic_100mb[1,bandwidth_idx,rtt_idx])
print(latdec_100kb)
fig, ax = plt.subplots()
im = ax.imshow(latdec_100kb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(latdec_100kb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()

print(latdec_10mb)
fig, ax = plt.subplots()
im = ax.imshow(latdec_10mb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(latdec_10mb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()