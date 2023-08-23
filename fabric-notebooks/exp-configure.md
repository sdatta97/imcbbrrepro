::: {.cell .markdown}
### Extra configuration for this experiment
:::

::: {.cell .code}
```python
# set socket read and write buffer on all endpoints to larger value
for node in slice.get_nodes():
    node.execute("sudo sysctl -w net.core.rmem_default=2147483647")
    node.execute("sudo sysctl -w net.core.wmem_default=2147483647")
    node.execute("sudo sysctl -w net.core.rmem_max=2147483647")
    node.execute("sudo sysctl -w net.core.wmem_max=2147483647")
```
:::


::: {.cell .code}
```python
slice.get_node(name="h1").execute("sudo modprobe tcp_bbr")
```
:::

