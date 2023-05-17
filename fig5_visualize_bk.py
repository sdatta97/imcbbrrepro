import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt 

# reading the CSV file
val_arr = np.array(pd.read_csv('bbr.csv'))
goodput_bbr = np.ones((2,8,8))
arr_length = val_arr.size
for i in range(arr_length):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    goodput_bbr [bufcap_idx, bandwidth_idx, rtt_idx] = val_arr[i]
print(goodput_bbr)

# reading the CSV file
val_arr = np.array(pd.read_csv('cubic.csv'))
goodput_cubic = np.ones((2,8,8))
arr_length = val_arr.size
for i in range(arr_length):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    goodput_cubic [bufcap_idx, bandwidth_idx, rtt_idx] = val_arr[i]
print(goodput_cubic)

val_arr = np.array(pd.read_csv('bbr_retr.csv'))
retr_bbr = np.ones((8,8))
arr_length = val_arr.size
for i in range(int(arr_length/2)):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    retr_bbr [7-bandwidth_idx, rtt_idx] = val_arr[i]
## print(retr_bbr)

# reading the CSV file
val_arr = np.array(pd.read_csv('cubic_retr.csv'))
retr_cubic = np.ones((8,8))
arr_length = val_arr.size
for i in range(int(arr_length/2)):
    bufcap_idx = int(np.floor_divide(i, 64))
    bandwidth_idx = int(np.floor_divide(np.remainder(i, 64),8))
    rtt_idx = int(np.remainder(np.remainder(i, 64),8))
    print(bufcap_idx , bandwidth_idx , rtt_idx)
    retr_cubic [7-bandwidth_idx, rtt_idx] = val_arr[i]
## print(retr_cubic)

gpgain_100kb = np.ones((8,8))
gpgain_10mb = np.ones((8,8))
for bandwidth_idx in range(8):
    for rtt_idx in range(8):
        gpgain_100kb[bandwidth_idx,rtt_idx] = np.divide((goodput_bbr[0,7-bandwidth_idx,rtt_idx] - goodput_cubic[0,7-bandwidth_idx,rtt_idx]), goodput_cubic[0,7-bandwidth_idx,rtt_idx])
        gpgain_10mb[bandwidth_idx,rtt_idx]  = np.divide((goodput_bbr[1,7-bandwidth_idx,rtt_idx] - goodput_cubic[1,7-bandwidth_idx,rtt_idx]), goodput_cubic[1,7-bandwidth_idx,rtt_idx])

RTT = ["5","10","25","50","75","100","150","200"]
Bandwidth = ["1000","750","500","250","100","50","20","10"]

print(gpgain_100kb)
fig, ax = plt.subplots()
# Show all ticks and label them with the respective list entries
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
im = ax.imshow(gpgain_100kb)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(gpgain_100kb[j, i],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.colorbar(im, label="Goodput gain", orientation="vertical")
plt.show()

print(gpgain_10mb)
fig, ax = plt.subplots()
im = ax.imshow(gpgain_10mb)
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(gpgain_10mb[j, i],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.colorbar(im, label="Goodput gain", orientation="vertical")
plt.show()

print(retr_bbr)
fig, ax = plt.subplots()
im = ax.imshow(retr_bbr)
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(retr_bbr[j, i],'.0f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.colorbar(im, label="Retransmissions", orientation="vertical")
plt.show()

print(retr_cubic)
fig, ax = plt.subplots()
im = ax.imshow(retr_cubic)
ax.set_xticks(np.arange(8), labels=RTT)
ax.set_yticks(np.arange(8), labels=Bandwidth)
for i in range(8):
    for j in range(8):
        text = ax.text(i, j, format(retr_cubic[j, i],'.0f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in mbps)")
plt.colorbar(im, label="Retransmissions", orientation="vertical")
plt.show()
