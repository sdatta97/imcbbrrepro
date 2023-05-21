#!/bin/bash
##code runs on router (tbf)
sudo sysctl -w net.core.rmem_default=2147483647
sudo sysctl -w net.core.wmem_default=2147483647
sudo sysctl -w net.core.rmem_max=2147483647
sudo sysctl -w net.core.wmem_max=2147483647

sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig8"
sudo ssh -o StrictHostKeyChecking=no -T root@h2 "mkdir -p fig8"
for bufcap in 10 100 1000 5000 10000 
do
    for trial in 1 2 3 4 5
    do 
        ## Delete any existing queues
        sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
        ## Set up network delay 
        sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root netem delay 20ms

        ## Create an htb qdisc
        ## sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
        ## Limit the queue traffic to the bandwidth
        ## sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
        ## Set up queue limit
        ## sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
        ## Delete any existing queues
        sudo tc qdisc del dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root 
        ## Set up network delay 
        sudo tc qdisc replace dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root netem delay 20ms 
        ## Create an htb qdisc
        ## sudo tc qdisc replace dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
        ## Limit the queue traffic to the bandwidth
        ## sudo tc class add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 100Mbit
        ## Set up queue limit
        ## sudo tc qdisc add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
        ## Delete any existing queues
        sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
        ## Create an htb qdisc
        sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
        ## Limit the queue traffic to the bandwidth
        sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate 1gbit
        ## Set up queue limit
        sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
        sleep 10
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "ping -c 1 h1"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "ping -c 1 h3"
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "ping -c 1 h2"
        sudo ssh -o StrictHostKeyChecking=no -T root@h2 "ping -c 1 h3" 
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
        sudo ssh -o StrictHostKeyChecking=no -T root@h1 "nohup iperf3 -c h3 -p 5201 -C cubic -t 60s -fk >./fig8/"$bufcap"_"$trial"_cubic.txt 2>/dev/null &"
        sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -p 5002 -1 -D"
        sudo ssh -o StrictHostKeyChecking=no -T root@h2 "iperf3 -c h3 -p 5002 -C bbr -t 60s -fk > ./fig8/"$bufcap"_"$trial"_bbr.txt"
    done
done