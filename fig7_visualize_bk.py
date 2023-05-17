import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt

# reading the CSV file
val_arr = np.array(pd.read_csv('bbr_goodput.csv'))
goodput_bbr = np.ones((11,1))
arr_length = val_arr.size
for i in range(arr_length):
    goodput_bbr [i] = val_arr[i]
## print(goodput_bbr)

# reading the CSV file
val_arr = np.array(pd.read_csv('cubic_goodput.csv'))
goodput_cubic = np.ones((11,1))
arr_length = val_arr.size
for i in range(arr_length):
    goodput_cubic [i] = val_arr[i]
## print(goodput_cubic)

val_arr = np.array(pd.read_csv('bbr_retr.csv'))
retr_bbr = np.ones((11,1))
arr_length = val_arr.size
for i in range(int(arr_length)):
    retr_bbr [i] = val_arr[i]
## print(retr_bbr)

# reading the CSV file
val_arr = np.array(pd.read_csv('cubic_retr.csv'))
retr_cubic = np.ones((11,1))
arr_length = val_arr.size
for i in range(int(arr_length)):
    retr_cubic [i] = val_arr[i]
## print(retr_cubic)

loss = ["0","1","2","3","6","12","18","27","36","45","50"] 
# Show all ticks and label them with the respective list entries
plt.plot(np.arange(11))
plt.xlabel("Loss (in %)")
plt.ylabel("Goodput (in mbps)")
plt.show()

loss = ["0","1","2","3","6","12","18","27","36","45","50"] 
fig, (ax1 ,ax2) = plt.subplots()
# Show all ticks and label them with the respective list entries
ax1.set_xticks(np.arange(11), labels=loss)
im = ax1.imshow(retr_bbr)
ax2.set_xticks(np.arange(11), labels=loss)
im = ax2.imshow(retr_cubic)
fig.tight_layout()
plt.xlabel("Loss (in %)")
plt.ylabel("Number of retransmissions")
plt.show()