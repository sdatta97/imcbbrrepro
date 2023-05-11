#!/bin/bash
rm -rf *.csv
for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for rtt in 5 10 25 50 75 100 150 200 
        do
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_cubic.txt -A 0 | awk -v fname="$bufcap"_"$bandwidth"_"$rtt"_cubic.txt '{print fname"," $7}'  >> cubic.csv
            rg sender "$bufcap"_"$bandwidth"_"$rtt"_bbr.txt -A 0 | awk '{print 1, $7}'  >> bbr.csv        
        done
    done   
done