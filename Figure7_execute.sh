#!/bin/bash
##code runs on router (tbf)
# sysctl -w net.core.rmem_default=2147483647
# sysctl -w net.core.wmem_default=2147483647
# sysctl -w net.core.rmem_max=2147483647
# sysctl -w net.core.wmem_max=2147483647

sudo ssh -o StrictHostKeyChecking=no -T root@h3 "mkdir -p fig7"
sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig7"
## bandwidth = 100;
## bufcap = 10000;
## rtt = 25;
for loss_pc in 0 1 2 3 6 12 18 27 36 45 50
do
    ## Delete any existing queues
    sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
    ## Create an htb qdisc
    sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
    ## Limit the queue traffic to the bandwidth
    sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
    ## Set up queue limit
    sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit 10Mb
    ## Delete any existing queues
    sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
    ## Create an htb qdisc
    sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
    ## Limit the queue traffic to the bandwidth
    sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
    ## Set up queue limit
    sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit 10Mb
    ## Set up network delay 
    sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root netem delay 25ms
    sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root netem loss $loss_pc%

    sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
    sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C cubic -n 100mb -fk | tee ./fig7/"$loss_pc"_cubic.txt"
    sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
    sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C bbr -n 100mb -fk | tee ./fig7/"$loss_pc"_bbr.txt"
    sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
    sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C reno -n 100mb -fk | tee ./fig7/"$loss_pc"_reno.txt"
done