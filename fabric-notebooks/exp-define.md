::: {.cell .markdown}
### Define configuration for this experiment
:::

::: {.cell .code}
```python
slice_name="re-when-to-use-bbr-" + fablib.get_bastion_username()

# use default_ubuntu_22 for 5.15 kernel, default_ubuntu_18 for 4.15 kernel, default_ubuntu_20 for BBRv2
image = 'default_ubuntu_22' 

node_conf = [
 {'name': "h1",  'cores': 4, 'ram': 16, 'disk': 500, 'image': image, 'packages': ['iperf3']}, 
 {'name': "h2",  'cores': 4, 'ram': 16, 'disk': 10, 'image': image, 'packages': ['iperf3']}, 
 {'name': "h3",  'cores': 4, 'ram': 16, 'disk': 10, 'image': image, 'packages': ['iperf3']}, 
 {'name': "tbf", 'cores': 4, 'ram': 16, 'disk': 10, 'image': image, 'packages': []} 
]
net_conf = [
 {"name": "link1", "subnet": "10.10.1.0/24", "nodes": [{"name": "tbf",   "addr": "10.10.1.10"}, {"name": "h1", "addr": "10.10.1.1"}]},
 {"name": "link2", "subnet": "10.10.2.0/24", "nodes": [{"name": "tbf",   "addr": "10.10.2.10"}, {"name": "h2", "addr": "10.10.2.1"}]},
 {"name": "link3", "subnet": "10.10.3.0/24", "nodes": [{"name": "tbf",   "addr": "10.10.3.10"}, {"name": "h3", "addr": "10.10.3.1"}]}
]
route_conf = [
 {"addr": "10.10.3.0/24", "gw": "10.10.1.10", "nodes": ["h1"]}, 
 {"addr": "10.10.3.0/24", "gw": "10.10.2.10", "nodes": ["h2"]},  
 {"addr": "10.10.1.0/24", "gw": "10.10.3.10", "nodes": ["h3"]},  
 {"addr": "10.10.2.0/24", "gw": "10.10.3.10", "nodes": ["h3"]}
]
exp_conf = {'cores': sum([ n['cores'] for n in node_conf]), 'nic': sum([len(n['nodes']) for n in net_conf]) }
```
:::
