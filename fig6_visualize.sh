#!/bin/bash
rm -rf *.csv
echo "Latency" >> cubic_10mb.csv
echo "Latency" >> bbr_10mb.csv
echo "Latency" >> cubic_100mb.csv
echo "Latency" >> bbr_100mb.csv
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            for trial in 1
            do 
                rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_10.txt -A 0 | awk '{print $3}' | cut -d "-" -f 2 >> cubic_10mb.csv
                rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr_10.txt -A 0 | awk '{print $3}' | cut -d "-" -f 2 >> bbr_10mb.csv         
                rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_100.txt -A 0 | awk '{print $3}' | cut -d "-" -f 2 >> cubic_100mb.csv
                rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr_100.txt -A 0 | awk '{print $3}'  | cut -d "-" -f 2 >> bbr_100mb.csv    
            done  
        done
    done
done