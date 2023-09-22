#!/bin/bash
rm -rf *.csv
echo "BBR_goodput,CUBIC_goodput,Reno_goodput,BBR1dot1_goodput,BBR1dot5_goodput,Loss_pc" >> tput.csv
echo "BBR_retransmissions,CUBIC_retransmissions,Reno_retransmissions,BBR1dot1_retransmissions,BBR1dot5_retransmissions,Loss_pc" >> retr.csv

for loss_pc in 0 1 3 6 12 18 27 36 45 50
do
    for trial in 1 2
    do 
        expstr="$loss_pc"
        bbr_tput=$(cat "$loss_pc"_"$trial"_bbr.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        cubic_tput=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        reno_tput=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        bbr_tput_1dot1=$(cat "$loss_pc"_"$trial"_bbr1dot1.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        bbr_tput_1dot5=$(cat "$loss_pc"_"$trial"_bbr1dot5.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $7}')
        echo "$bbr_tput,$cubic_tput,$reno_tput,$bbr_tput_1dot1,$bbr_tput_1dot5,$expstr" >> tput.csv
        bbr_retr=$(cat "$loss_pc"_"$trial"_bbr.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}') 
        cubic_retr=$(cat "$loss_pc"_"$trial"_cubic.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}')
        reno_retr=$(cat "$loss_pc"_"$trial"_reno.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}')
        bbr_retr_1dot1=$(cat "$loss_pc"_"$trial"_bbr1dot1.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}') 
        bbr_retr_1dot5=$(cat "$loss_pc"_"$trial"_bbr1dot5.txt | grep "Transfer" -A 1 | grep -v "Transfer" | tail -n 1 | awk '{print $9}') 
        echo "$bbr_retr,$cubic_retr,$reno_retr,$bbr_retr_1dot1,$bbr_retr_1dot5,$expstr" >> retr.csv
    done
done