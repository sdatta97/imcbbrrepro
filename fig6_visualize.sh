#!/bin/bash
rm -rf *.csv
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_cubic_10.txt -A 0 | awk '{print $3}' >> cubic_10mb.csv
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_bbr_10.txt -A 0 | awk '{print $3}' >> bbr_10mb.csv         
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_cubic_100.txt -A 0 | awk '{print $3}' >> cubic_100mb.csv
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_bbr_100.txt -A 0 | awk '{print $3}' >> bbr_100mb.csv      
        done
    done
done