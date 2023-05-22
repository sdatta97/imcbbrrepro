#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Reno_goodput,Loss_pc" >> tput.csv
echo "BBR_retransmissions,CUBIC_retransmissions,Reno_retransmissions,Loss_pc" >> retr.csv

for loss_pc in 0 1 3 6 12 18 27 36 45 50
do
    for trial in 1 2 3 4 5
    do 
        expstr="$loss_pc"
        bbr2_tput=$(cat "$loss_pc"_"$trial"_bbr2.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        cubic_tput=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        reno_tput=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        echo "$bbr2_tput,$cubic_tput,$reno_tput,$expstr" >> tput.csv
        bbr2_retr=$(cat "$loss_pc"_"$trial"_bbr2.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}') 
        cubic_retr=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}')
        reno_retr=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}')
        echo "$bbr2_retr,$cubic_retr,$reno_retr,$expstr" >> retr.csv
    done
done