#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Buffer,Bandwidth,delay" >> tput.csv
echo "Buffer,Bandwidth,delay,CC,Goodput" >> cubic.csv
echo "Buffer,Bandwidth,delay,CC,Goodput" >> bbr.csv
echo "Buffer,Bandwidth,delay,CC,Retransmissions" >> cubic_retr.csv
echo "Buffer,Bandwidth,delay,CC,Retransmissions" >> bbr_retr.csv

for bufcap in 100 10000 
do
    for bandwidth in 10 20 50 100 250 500 750 1000 
    do
        for delay in 2.5 5 12.5 25 37.5 50 75 100 
        ## for rtt in 5 10 25 50 75 100 150 200 
        do
            for trial in 1 2 3 4 5
            do
                expstr="$bufcap,$bandwidth,$delay"
                bbr_tput=$(rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_bbr.txt -A 0 | awk '{print $7}') 
                cubic_tput=$(rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_cubic.txt -A 0 | awk '{print $7}') 
                echo "$bbr_tput,$cubic_tput,$expstr" >> tput.csv
                ## rg sender "$bufcap"_"$bandwidth"_"$delay"_cubic.txt -A 0 | awk -v fname="$bufcap"_"$bandwidth"_"$delay"_cubic.txt '{print fname"," $7}'  >> cubic.csv
                rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_cubic.txt -A 0 | awk -v fname="$expstr" '{print fname",cubic," $7}'  >> cubic.csv      
                rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_bbr.txt -A 0 | awk -v fname="$expstr" '{print fname",bbr," $7}'  >> bbr.csv      
                rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_cubic.txt -A 0 | awk -v fname="$expstr" '{print fname",cubic," $9}'  >> cubic_retr.csv      
                rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_bbr.txt -A 0 | awk -v fname="$expstr" '{print fname",bbr," $9}'  >> bbr_retr.csv      
                ## rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_bbr.txt -A 0 | awk '{print $7}'  >> bbr.csv 
                ## rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_cubic.txt -A 0 | awk '{print $9}'  >> cubic_retr.csv      
                ## rg sender "$bufcap"_"$bandwidth"_"$delay"_"$trial"_bbr.txt -A 0 | awk '{print $9}'  >> bbr_retr.csv  
            done      
        done
    done   
done