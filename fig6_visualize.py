import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 

# reading the CSV file
val_arr = np.array(pd.read_csv('bbr_100mb.csv'))
latency_bbr_100kb = np.ones((8,8))
latency_bbr_10mb = np.ones((8,8))
RTT = ["5","10","25","50","75","100","150","200"]
Bandwidth = ["1000","750","500","250","100","50","20","10"]
arr_length = val_arr.size
for i in range(arr_length):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    if bufcap_idx == 0:
        latency_bbr_100kb [bandwidth_idx, rtt_idx] = val_arr[i]
    else:
        latency_bbr_10mb [bandwidth_idx, rtt_idx] = val_arr[i]
print(latency_bbr_100kb)
print(latency_bbr_10mb)

val_arr = np.array(pd.read_csv('cubic_100mb.csv'))
latency_cubic_100kb = np.ones((8,8))
latency_cubic_10mb = np.ones((8,8))
arr_length = val_arr.size
for i in range(arr_length):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    if bufcap_idx == 0:
        latency_cubic_100kb [bandwidth_idx, rtt_idx] = val_arr[i]
    else:
        latency_cubic_10mb [bandwidth_idx, rtt_idx] = val_arr[i]
print(latency_cubic_100kb)
print(latency_cubic_10mb)

latdec_100kb = np.ones((8,8))
latdec_10mb = np.ones((8,8))
for bandwidth_idx in range(8):
    for rtt_idx in range(8):
        latdec_100kb[bandwidth_idx,rtt_idx] = np.divide((latency_cubic_100kb[7-bandwidth_idx,rtt_idx] - latency_bbr_100kb[7-bandwidth_idx,rtt_idx]), latency_cubic_100kb[7-bandwidth_idx,rtt_idx])
        latdec_10mb[bandwidth_idx,rtt_idx]  = np.divide((latency_cubic_10mb[7-bandwidth_idx,rtt_idx] - latency_bbr_10mb[7-bandwidth_idx,rtt_idx]), latency_cubic_10mb[7-bandwidth_idx,rtt_idx])
print(latdec_100kb)
fig, ax = plt.subplots()
im = ax.imshow(latdec_100kb)
# Show all ticks and label them with the respective list entries
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(latdec_100kb[j, i],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.colorbar(im, label="Latency decrease", orientation="vertical")
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.show()

print(latdec_10mb)
fig, ax = plt.subplots()
# Show all ticks and label them with the respective list entries
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
im = ax.imshow(latdec_10mb)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(latdec_10mb[j, i],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.colorbar(im, label="Latency decrease", orientation="vertical")
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.show()