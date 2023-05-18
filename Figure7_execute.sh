#!/bin/bash
##code runs on router (tbf)
# sysctl -w net.core.rmem_default=2147483647
# sysctl -w net.core.wmem_default=2147483647
# sysctl -w net.core.rmem_max=2147483647
# sysctl -w net.core.wmem_max=2147483647

sudo ssh -o StrictHostKeyChecking=no -T root@h3 "mkdir -p fig7"
sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig7"
for loss_pc in 0 1 2 3 6 12 18 27 36 45 50
do
    for trial in 1 2 3 4 5
    do
        ## Delete any existing queues
        sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
        ## Set up network delay 
        sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root netem delay 25ms
        ## add loss in same line
        ## Add loss to network
        ## sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root netem loss $loss_pc%
        ## Create an htb qdisc
        ## sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
        ## Limit the queue traffic to the bandwidth
        ## sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
        ## Set up queue limit
        ## sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit 10Mb
        ## Delete any existing queues
        sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
        ## Create an htb qdisc
        sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
        ## Limit the queue traffic to the bandwidth
        sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
        sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 handle 3: root netem loss $loss_pc%
        ## Set up queue limit
        sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit 10Mb
        sleep 10
        ## sudo ssh -o StrictHostKeyChecking=no -T root@h3 "ping -c 1 h1"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "ping -c 10 h3"
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C cubic -t 60s -fk > ./fig7/"$loss_pc"_"$trial"_cubic.txt"
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C bbr -t 60s -fk > ./fig7/"$loss_pc"_"$trial"_bbr.txt"
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C reno -t 60s -fk > ./fig7/"$loss_pc"_"$trial"_reno.txt"
    done
done