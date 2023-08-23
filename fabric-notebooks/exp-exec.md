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

tx_node.execute("mkdir -p fig5")
```
:::

::: {.cell .code}
```python
for bufcap in [100, 10000]:
    for bandwidth in [10, 20, 50, 100, 250, 500, 750, 1000]: 
        for rtt in [5, 10, 25, 50, 75, 100, 150, 200]: 
            
            print("Now running: buffer %d, bandwidth %d, RTT %d" % (bufcap, bandwidth, rtt))


            # set up RTT
            router_node.execute("sudo tc qdisc replace dev " + router_ingress_name + " root netem delay " + str(rtt) + "ms")
            # set up rate limit, buffer limit
            router_node.execute("sudo tc qdisc replace dev " + router_egress_name + " root handle 1: htb default 3")
            router_node.execute("sudo tc class add dev " + router_egress_name + " parent 1: classid 1:3 htb rate " + str(bandwidth) + "Mbit")
            router_node.execute("sudo tc qdisc add dev " + router_egress_name + " parent 1:3 bfifo limit " + str(bufcap) + "kb")

            # quick validation
            tx_node.execute("ping -c 5 h3")
            rx_node.execute("iperf3 -s -1 -D")
            time.sleep(5)
            tx_node.execute("iperf3 -t 30 -i 30 -P 10 -c h3")
            time.sleep(10)

            for trial_idx in [1, 2, 3, 4, 5]:

                file_prefix = "fig5/%d_%d_%d_%d_" % (bufcap, bandwidth, rtt, trial_idx)

                # cubic experiment
                time.sleep(10)
                rx_node.execute("iperf3 -s -1 -D")
                tx_node.execute("iperf3 -c h3 -C cubic -t 60s -fk > fig5/" + file_prefix + "_cubic.txt", quiet=True)

                # bbr experiment
                time.sleep(10)
                rx_node.execute("iperf3 -s -1 -D")
                tx_node.execute("iperf3 -c h3 -C bbr -t 60s -fk > fig5/" + file_prefix + "_bbr.txt", quiet=True)
```
:::

