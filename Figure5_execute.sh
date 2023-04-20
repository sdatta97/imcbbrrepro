#!/bin/bash
##code runs on h1
# sysctl -w net.core.rmem_default=2147483647
# sysctl -w net.core.wmem_default=2147483647
# sysctl -w net.core.rmem_max=2147483647
# sysctl -w net.core.wmem_max=2147483647
rtt_list = 5 10 25 50 75 100 150 200
bandwidth_list = 10 20 50 100 250 500 750 1000
bufcap_list = 100 10000

for bufcap in bufcap_list do
    for bandwidth in bandwidth_list do
        for rtt in rtt_list do
            ## ssh into router
            ssh -o StrictHostKeyChecking=no router << EOF
            ## Delete any existing queues
            sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
            ## Create an htb qdisc
            sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
            ## Limit the queue traffic to the bandwidth
            sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            ## Set up queue limit
            sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            ## Delete any existing queues
            sudo tc qdisc del dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root
            ## Create an htb qdisc
            sudo tc qdisc replace dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
            ## Limit the queue traffic to the bandwidth
            sudo tc class add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            ## Set up queue limit
            sudo tc qdisc add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            ## Delete any existing queues
            sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
            ## Create an htb qdisc
            sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
            ## Limit the queue traffic to the bandwidth
            sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            ## Set up queue limit
            sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            ## Set up network delay 
            sudo tc qdisc change dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root netem delay "$rtt"
EOF
            ##ssh into h3
            ssh -o StrictHostKeyChecking=no h3 << EOF
            mkdir -p fig5 
            screen -S "$bufcap\_$bandwidth\_$rtt\_$delay"
            iperf3 -s -1 -D
            iperf3 -c -fk h3 -C cubic -t 10s | tee ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$delay"_cubic.txt
            iperf3 -s -1 -D
            iperf3 -c -fk h3 -C bbr -t 10s | tee ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$delay"_bbr.txt
EOF
        done
    done
done