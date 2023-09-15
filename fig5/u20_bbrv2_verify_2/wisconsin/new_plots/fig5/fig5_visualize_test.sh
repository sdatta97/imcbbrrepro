#!/bin/bash
rm -rf *.csv
echo "BBR_goodput" >> tput_bbr.csv
echo "CUBIC_goodput" >> tput_cubic.csv

for bufcap in 100 
do
    for bandwidth in 1000 
    do
        for rtt in 200 
        do
            for trial in 1
            do
                ##expstr="$bufcap,$bandwidth,$rtt"
                bbr_tput=$(rg Kbits/sec "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr.txt -A 0 | awk '{print $7}') 
                cubic_tput=$(rg Kbits/sec "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic.txt -A 0 | awk '{print $7}') 
                echo "$bbr_tput" >> tput_bbr.csv   
                echo "$cubic_tput" >> tput_cubic.csv   
            done      
        done
    done   
done