"""
Topology to reproduce \"When to use and when not to use BBR\"
"""

#
# NOTE: This code was machine converted. An actual human would not
#       write code like this!
#

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal object,
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Pick your OS.
imageList = [
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD', 'UBUNTU 18.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD', 'UBUNTU 20.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD', 'UBUNTU 22.04')]

pc.defineParameter("osImage", "Select OS image",
                   portal.ParameterType.IMAGE,
                   imageList[0], imageList,
                   longDescription="Use Ubuntu 18.04 to replicate the base result, 22.04 for the extended result.")

params = pc.bindParameters()

# Node h1
node_h1 = request.RawPC('h1')
node_h1.disk_image = params.osImage
iface0 = node_h1.addInterface('link1_h1', pg.IPv4Address('10.10.1.1','255.255.255.0'))
node_h1.installRootKeys(True, True)

# Node h2
node_h2 = request.RawPC('h2')
node_h2.disk_image = params.osImage
iface1 = node_h2.addInterface('link2_h2', pg.IPv4Address('10.10.2.1','255.255.255.0'))
node_h2.installRootKeys(True, True)

# Node tbf
node_tbf = request.RawPC('tbf')
node_tbf.disk_image = params.osImage
iface2 = node_tbf.addInterface('link1_tbf', pg.IPv4Address('10.10.1.10','255.255.255.0'))
iface3 = node_tbf.addInterface('link2_tbf', pg.IPv4Address('10.10.2.10','255.255.255.0'))
iface4 = node_tbf.addInterface('link3_tbf', pg.IPv4Address('10.10.3.10','255.255.255.0'))
node_tbf.installRootKeys(True, True)


# Node h3
node_h3 = request.RawPC('h3')
node_h1.disk_image = params.osImage
iface5 = node_h3.addInterface('link3_h3', pg.IPv4Address('10.10.3.1','255.255.255.0'))
node_h3.installRootKeys(True, True)


# Link link1
link1 = request.Link('link1')
iface0.bandwidth = 5000000
link1.addInterface(iface0)
iface2.bandwidth = 5000000
link1.addInterface(iface2)
link1.best_effort = True
link1.vlan_tagging = True
link1.link_multiplexing = True

# Link link2
link2 = request.Link('link2')
iface1.bandwidth = 5000000
link2.addInterface(iface1)
iface3.bandwidth = 5000000
link2.addInterface(iface3)
link2.best_effort = True
link2.vlan_tagging = True
link2.link_multiplexing = True


# Link link3
link3 = request.Link('link3')
iface4.bandwidth = 5000000
link3.addInterface(iface4)
iface5.bandwidth = 5000000
link3.addInterface(iface5)
link3.best_effort = True
link3.link_multiplexing = True
link3.vlan_tagging = True


# Print the generated rspec
pc.printRequestRSpec(request)
