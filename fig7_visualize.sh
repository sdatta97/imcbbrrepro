#!/bin/bash
rm -rf *.csv
echo "Goodput" >> bbr_goodput.csv
echo "Goodput" >> cubic_goodput.csv
echo "Retransmissions" >> bbr_retr.csv
echo "Retransmissions" >> cubic_retr.csv
for loss_pc in 0 1 2 3 6 12 18 27 36 45 50
do
    for trial in 1
    do 
        cat "$loss_pc"_"$trial"_bbr.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}' >> bbr_goodput.csv
        cat "$loss_pc"_"$trial"_cubic.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}' >> cubic_goodput.csv
        cat "$loss_pc"_"$trial"_reno.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $7}' >> reno_goodput.csv
        cat "$loss_pc"_"$trial"_bbr.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}' >> bbr_retr.csv
        cat "$loss_pc"_"$trial"_cubic.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}' >> cubic_retr.csv 
        cat "$loss_pc"_"$trial"_reno.txt | grep "Bandwidth" -A 1 | grep -v "Bandwidth" | tail -n 1 | awk '{print $9}' >> reno_retr.csv
    done
done