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
    retr_bbr [bandwidth_idx, rtt_idx] = val_arr[i]
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
    retr_cubic [bandwidth_idx, rtt_idx] = val_arr[i]
## print(retr_cubic)

gpgain_100kb = np.ones((8,8))
gpgain_10mb = np.ones((8,8))
for bandwidth_idx in range(8):
    for rtt_idx in range(8):
        gpgain_100kb[bandwidth_idx,rtt_idx] = np.divide((goodput_bbr[0,bandwidth_idx,rtt_idx] - goodput_cubic[0,bandwidth_idx,rtt_idx]), goodput_cubic[0,bandwidth_idx,rtt_idx])
        gpgain_10mb[bandwidth_idx,rtt_idx]  = np.divide((goodput_bbr[1,bandwidth_idx,rtt_idx] - goodput_cubic[1,bandwidth_idx,rtt_idx]), goodput_cubic[1,bandwidth_idx,rtt_idx])
print(gpgain_100kb)
fig, ax = plt.subplots()
im = ax.imshow(gpgain_100kb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(gpgain_100kb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()

print(gpgain_10mb)
fig, ax = plt.subplots()
im = ax.imshow(gpgain_10mb)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(gpgain_10mb[i, j],'.2f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()

print(retr_bbr)
fig, ax = plt.subplots()
im = ax.imshow(retr_bbr)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(retr_bbr[i, j],'.0f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()

print(retr_cubic)
fig, ax = plt.subplots()
im = ax.imshow(retr_cubic)
for i in range(8):
    for j in range(8):
        text = ax.text(j, i, format(retr_cubic[i, j],'.0f'), ha="center", va="center", color="w")
fig.tight_layout()
plt.show()
