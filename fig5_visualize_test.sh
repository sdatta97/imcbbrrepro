#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Buffer,Bandwidth,rtt" >> tput_new.csv
for bufcap in 100 
do
    for bandwidth in 1000 
    do
        for rtt in 200 
        do
            for trial in 1 2 3 4 5
            do
                expstr="$bufcap,$bandwidth,$rtt"
                bbr_tput=$(rg Kbits/sec "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr.txt -A 0 -m 1| awk '{print $7}') 
                cubic_tput=$(rg Kbits/sec "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic.txt -A 0 -m 1| awk '{print $7}') 
                echo "$bbr_tput,$cubic_tput,$expstr" >> tput_new.csv   
            done      
        done
    done   
done