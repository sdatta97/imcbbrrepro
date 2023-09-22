#!/bin/bash
##code runs on router (tbf)
sudo ssh -o StrictHostKeyChecking=no -T root@h1 "mkdir -p fig5"
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            for trial_idx in 1 2 3 4 5
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
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C cubic -w 100M -t 60s -fk -V > ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$trial_idx"_cubic.txt"
                sleep 10
                sudo ssh -o StrictHostKeyChecking=no -T root@h3 "iperf3 -s -1 -D"
                sudo ssh -o StrictHostKeyChecking=no -T root@h1 "iperf3 -c h3 -C bbr2 -w 100M -t 60s -fk -V > ./fig5/"$bufcap"_"$bandwidth"_"$rtt"_"$trial_idx"_bbr.txt"
            done
        done
    done
done
