#!/bin/bash
##code runs on router (tbf)
# sysctl -w net.core.rmem_default=2147483647
# sysctl -w net.core.wmem_default=2147483647
# sysctl -w net.core.rmem_max=2147483647
# sysctl -w net.core.wmem_max=2147483647
sudo ssh -o StrictHostKeyChecking=no -T root@h3 "mkdir -p fig5"
sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig5"
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            ## ssh into router
            ## ssh -o StrictHostKeyChecking=no -T root@tbf<< EOF
            ## Delete any existing queues
            sudo tc qdisc del dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root  
            echo "Del h1 success"
            ## Create an htb qdisc
            sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3  
            echo "Replace h1 success"
            ## Limit the queue traffic to the bandwidth
            sudo tc class add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            echo "Add b/w h1 success"
            ## Set up queue limit
            sudo tc qdisc add dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            echo "Add bufcap h1 success"
            ## Delete any existing queues
            ##sudo tc qdisc del dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root
            ## Create an htb qdisc
            ##sudo tc qdisc replace dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
            ## Limit the queue traffic to the bandwidth
            ##sudo tc class add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            ## Set up queue limit
            ##sudo tc qdisc add dev $(ip route get 10.10.2.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            ## Delete any existing queues
            sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
            echo "Del h3 success"
            ## Create an htb qdisc
            sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
            echo "Replace h3 success"
            ## Limit the queue traffic to the bandwidth
            sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
            echo "Replace h3 success"
            ## Set up queue limit
            sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kbit
            echo "Add h3 success"
            ## Set up network delay 
            sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root netem delay "$rtt"
            echo "Add delay at h3 success"
## EOF
            ##ssh into h3
            ## << EOF
            ## screen -S "$bufcap\_$bandwidth\_$rtt\_$delay"
            sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
            echo "iperf3 server success"
            sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c -fk h3 -C cubic -t 10s | tee ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$delay"_cubic.txt"
            echo "iperf3 client success"
            sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
            sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c -fk h3 -C bbr -t 10s | tee ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$delay"_bbr.txt"
## EOF
        done
    done
done