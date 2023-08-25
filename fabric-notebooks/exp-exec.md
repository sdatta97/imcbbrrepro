::: {.cell .markdown}
### Execute experiment
:::

::: {.cell .code}
```python
# get name of router interface that is 'toward' h1 - apply delay here
# get name of router interface that is 'toward' h3 - apply rate limiting and buffer size limit here
router_node = slice.get_node(name='tbf')
router_ingress_iface = router_node.get_interface(network_name = "link1")
router_ingress_name = router_ingress_iface.get_device_name()
router_egress_iface  = router_node.get_interface(network_name = "link3")
router_egress_name = router_egress_iface.get_device_name()
```
:::

::: {.cell .code}
```python
tx_node = slice.get_node(name="h1")
rx_node = slice.get_node(name="h3")
```
:::


::: {.cell .code}
```python
# generate full factorial experiment
import itertools
exp_factors = { 
    'bufcap': [100, 10000],
    'bandwidth': [10, 20, 50, 100, 250, 500, 750, 1000],
    'rtt': [5, 10, 25, 50, 75, 100, 150, 200],
    'cc': ["cubic", "bbr"],
    'trial': [1,2,3,4,5]
}
factor_names = [k for k in exp_factors]
factor_lists = list(itertools.product(*exp_factors.values()))
exp_lists = [dict(zip(factor_names, factor_l)) for factor_l in factor_lists]
```
:::


::: {.cell .code}
```python
kernel = tx_node.execute("uname -r")[0].strip()
data_dir = kernel + "_" + exp_factors['cc'][0] + "_" + exp_factors['cc'][1]
tx_node.execute("mkdir -p " + data_dir)
```
:::



::: {.cell .code}
```python

for exp in exp_lists:

    # TODO: check if we already ran this experiment
    # (to allow stop/resume)

    file_out = data_dir + "/%d_%d_%d_%d_%s.txt" % (exp['bufcap'], exp['bandwidth'], exp['rtt'], exp['trial'], exp['cc'])

	tx_node.execute("sudo modprobe tcp_" + exp['cc'])

    router_node.execute("sudo tc qdisc del dev " + router_ingress_name + " root")
    router_node.execute("sudo tc qdisc del dev " + router_egress_name + " root")

    # set up RTT
    router_node.execute("sudo tc qdisc replace dev " + router_ingress_name + " root netem delay " + str(exp['rtt']) + "ms")
    # set up rate limit, buffer limit
    router_node.execute("sudo tc qdisc replace dev " + router_egress_name + " root handle 1: htb default 3")
    router_node.execute("sudo tc class add dev " + router_egress_name + " parent 1: classid 1:3 htb rate " + str(exp['bandwidth']) + "Mbit")
    router_node.execute("sudo tc qdisc add dev " + router_egress_name + " parent 1:3 bfifo limit " + str(exp['bufcap']) + "kb")

    time.sleep(10)
    rx_node.execute("iperf3 -s -1 -D")
    tx_node.execute("iperf3 -V -c h3 -C " + exp['cc'] + " -t 60s -fk -w 20M --logfile " + file_out, quiet=True)

```
:::

