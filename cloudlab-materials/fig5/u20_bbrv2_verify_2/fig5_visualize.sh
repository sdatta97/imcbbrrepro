#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Buffer,Bandwidth,rtt" >> tput.csv
echo "BBR_retransmissions,CUBIC_retransmissions,Buffer,Bandwidth,rtt" >> retr.csv
for bufcap in 100 
do
    for bandwidth in 1000 
    do
        for rtt in 200 
        do
            for trial in 1 2 3 4 5
            do
                expstr="$bufcap,$bandwidth,$rtt"
                bbr_tput=$(rg receiver "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr.txt -A 0 -m 1| awk '{print $7}') 
                cubic_tput=$(rg receiver "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic.txt -A 0 -m 1| awk '{print $7}') 
                echo "$bbr_tput,$cubic_tput,$expstr" >> tput.csv  
                bbr_retr=$(rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_bbr.txt -A 0 -m 1| awk '{print $9}') 
                cubic_retr=$(rg sender "$bufcap"_"$bandwidth"_"$rtt"_"$trial"_cubic.txt -A 0 -m 1| awk '{print $9}')   
                echo "$bbr_retr,$cubic_retr,$expstr" >> retr.csv    
            done      
        done
    done   
done
