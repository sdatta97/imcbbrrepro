::: {.cell .markdown}
### Analyze experiment results
:::

::: {.cell .code}
```python
import pandas as pd
from io import StringIO
import seaborn as sns # may need to pip install seaborn
import matplotlib.pyplot as plt
```
:::

::: {.cell .code}
```python
tput = tx_node.execute("cd " + data_dir + "; grep 'Kbits/sec.*sender' *.txt | awk -F'[_ .]' '{print $1\",\"$2\",\"$3\",\"$4\",\"$5\",\"$21}' ")
```
:::


::: {.cell .code}
```python
df_tput = pd.read_csv(StringIO(tput[0]), names = ['bufcap','bandwidth','rtt','trial','cc','goodput_'])
df_tput = df_tput.pivot_table(columns='cc', index=['bufcap','bandwidth','rtt'], values=['goodput_'], aggfunc='mean').reset_index() 
df_tput.columns = [''.join(col).strip() for col in df_tput.columns.values]
df_tput = df_tput.assign(goodput_gain = 100*(df_tput['goodput_' + exp_factors['cc'][1]]-df_tput['goodput_' + exp_factors['cc'][0]])/df_tput['goodput_' + exp_factors['cc'][0]])
```
:::


::: {.cell .code}
```python
dat_hm = df_tput[df_tput.bufcap==100].pivot(columns=["bandwidth"], index=["rtt"], values="goodput_gain")
sns.set(font_scale=0.8)
ax = sns.heatmap(dat_hm, annot=True, fmt=".1f", cmap="RdBu_r", center=0, vmin=-100, vmax=100)
ax.invert_yaxis()
ax.set_title("Goodput gain for " + exp_factors['cc'][1].upper() + " vs " + exp_factors['cc'][0].upper() + ", 100KB buffer")
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in Mbps)")
plt.show()
```
:::

::: {.cell .code}
```python
dat_hm = df_tput[df_tput.bufcap==10000].pivot(columns=["bandwidth"], index=["rtt"], values="goodput_gain")
sns.set(font_scale=0.8)
ax = sns.heatmap(dat_hm, annot=True, fmt=".1f", cmap="RdBu_r", center=0, vmin=-100, vmax=100)
ax.invert_yaxis()
ax.set_title("Goodput gain for " + cc_variants[1].upper() + " vs " + cc_variants[0].upper() + ", 10MB buffer")
plt.xlabel("RTT (in ms)")
plt.ylabel("Bandwidth (in Mbps)")
plt.show()
```
:::