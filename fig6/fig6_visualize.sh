#!/bin/bash
rm -rf *.csv
echo "BBR_latency,CUBIC_latency,Buffer,Bandwidth,rtt" >> latency.csv

for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            for trial in 1 2 3 4 5
            do
                expstr="$bufcap,$bandwidth,$rtt"
                bbr_latency=$(rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr_100.txt -A 0 | awk '{print $3}' | cut -d "-" -f 2)
                cubic_latency=$(rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic_100.txt -A 0 | awk '{print $3}' | cut -d "-" -f 2)
                echo "$bbr_latency,$cubic_latency,$expstr" >> latency.csv
            done      
        done
    done   
done