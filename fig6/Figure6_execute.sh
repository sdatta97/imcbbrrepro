#!/bin/bash
##code runs on router (tbf)
sysctl -w net.core.rmem_default=2147483647
sysctl -w net.core.wmem_default=2147483647
sysctl -w net.core.rmem_max=2147483647
sysctl -w net.core.wmem_max=2147483647

sudo ssh -o StrictHostKeyChecking=no -T root@h3 "mkdir -p fig6"
sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig6"
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            for trial in 1 2 3 4 5
            do 
                ## Delete any existing queues
                sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
                ## Set up network rtt 
                sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root netem delay "$rtt"ms
                ## Create an htb qdisc
                ## sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
                ## Limit the queue traffic to the bandwidth
                ## sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
                ## Set up queue limit
                ## sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
                ## Delete any existing queues
                sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
                ## Create an htb qdisc
                sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
                ## Limit the queue traffic to the bandwidth
                sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
                ## Set up queue limit
                sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
                ## sudo ssh -o StrictHostKeyChecking=no -T root@h3 "ping -c 1 h1"
                ## sudo ssh -o StrictHostKeyChecking=no -T root@h1 "ping -c 1 h3" 
                sleep 10
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C cubic -n 10mb -fk > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_10.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C bbr2 -n 10mb -fk > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr2_10.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C cubic -n 100mb -fk > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_100.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C bbr2 -n 100mb -fk > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr2_100.txt"
            done
        done
    done
done