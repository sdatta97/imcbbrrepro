::: {.cell .markdown}
### Extra configuration for this experiment
:::

::: {.cell .code}
```python
# if you need to install BBR3 kernel, make this True
is_bbr3 = True
pkg_list = ['linux-headers-6.4.0+_6.4.0-g6e321d1c986a-5_amd64.deb',
            'linux-libc-dev_6.4.0-g6e321d1c986a-5_amd64.deb',
            'linux-image-6.4.0+_6.4.0-g6e321d1c986a-5_amd64.deb']
if is_bbr3:
    for node in slice.get_nodes():
        for pkg in pkg_list:
            node.upload_file("../setup/" + pkg, "/home/ubuntu/" + pkg)
        node.execute("sudo dpkg -i " + " ".join(pkg_list) + "; sudo reboot")

        # if compiling from scratch.... which takes forever...
        # node.execute("sudo apt update; sudo apt -y install libelf-dev libssl-dev libncurses-dev flex bison pkg-config gcc binutils ca-certificates build-essential")
        # node.execute("git clone -o google-bbr -b v2alpha  https://github.com/google/bbr.git")
        # node.upload_file("../setup/.config", "/home/ubuntu/bbr/.config")
        # node.execute("cd bbr; sudo make -j $(nproc) ")
        # node.execute("cd bbr; sudo make modules -j $(nproc) ")
        # node.execute("cd bbr; sudo make modules_install -j $(nproc) ")
        # node.execute("cd bbr; sudo make install -j $(nproc) ")

    # wait for all nodes to come back up
    slice.wait_ssh(progress=True)
    for node in slice.get_nodes():
        node.execute("hostname; uname -a")
```
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


