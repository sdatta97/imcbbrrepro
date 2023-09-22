#!/bin/bash
##code runs on router (tbf)
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
                sudo tc qdisc replace dev $(ip route get 10.10.1.1 | grep -oP "(?<=dev )[^ ]+") root netem limit 100000 delay "$rtt"ms
                ## Delete any existing queues
                sudo tc qdisc del dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root
                ## Create an htb qdisc
                sudo tc qdisc replace dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") root handle 1: htb default 3
                ## Limit the queue traffic to the bandwidth
                sudo tc class add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1: classid 1:3 htb rate "$bandwidth"Mbit
                ## Set up queue limit
                sudo tc qdisc add dev $(ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+") parent 1:3 bfifo limit "$bufcap"kb
                sleep 10
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -w 100M -C cubic -n 10mb -fk -V > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_10.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -w 100M -C bbr -n 10mb -fk -V > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr_10.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -w 100M -C cubic -n 100mb -fk -V > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_100.txt"
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -w 100M -C bbr -n 100mb -fk -V > ./fig6/"$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr_100.txt"
            done
        done
    done
done
