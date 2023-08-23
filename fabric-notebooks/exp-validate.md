::: {.cell .markdown}
### Validate base network

Before we run any underlying experiment, we should check the "base" network - before adding any emulated delay or rate limiting - and make sure that it will not be a limiting factor in the experiment.

:::

::: {.cell .code}
```python
# check base delay
slice.get_node("h1").execute("ping -c 5 h3")
```
:::

::: {.cell .code}
```python
# check base capacity (by sending 10 parallel flows, look at their sum throughput)
import time
slice.get_node("h3").execute("iperf3 -s -1 -D")
time.sleep(5)
slice.get_node("h1").execute("iperf3 -t 30 -i 10 -P 10 -c h3")
```
:::

::: {.cell .code}
```python
# also check Linux kernel version on sender
slice.get_node("h1").execute("uname -a")
```
:::


