#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Buffer" >> tput.csv

for bufcap in 10 100 1000 5000 10000 
do
    for trial in 1 2 3 4 5
    do 
        expstr="$bufcap"
        ## use grep keyword bitrate for Ubuntu22.04 but Bandwidth for earlier versions
        bbr_tput=$(cat "$bufcap"_"$trial"_bbr.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $7}')
        cubic_tput=$(cat "$bufcap"_"$trial"_cubic.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $7}')
        echo "$bbr_tput,$cubic_tput,$expstr" >> tput.csv
    done
done