#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Reno_goodput,Loss_pc" >> tput.csv
echo "BBR_retransmissions,CUBIC_retransmissions,Reno_retransmissions,Loss_pc" >> retr.csv

for loss_pc in 0 1 2 3 6 12 18 27 36 45 50
do
    for trial in 1 2 3 4 5
    do 
        expstr="$loss_pc"
        bbr_tput=$(cat "$loss_pc"_"$trial"_bbr.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}')
        cubic_tput=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}')
        reno_tput=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}')
        echo "$bbr_tput,$cubic_tput,$reno_tput,$expstr" >> tput.csv
        bbr_retr=$(cat "$loss_pc"_"$trial"_bbr.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}') 
        cubic_retr=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}')
        reno_retr=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}')
        echo "$bbr_retr,$cubic_retr,$reno_retr,$expstr" >> retr.csv
    done
done