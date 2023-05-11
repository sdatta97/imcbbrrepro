#!/bin/bash
rm -rf *.csv
touch bbr_goodput.csv
touch cubic_goodput.csv
touch bbr_retr.csv
touch cubic_retr.csv
for loss_pc in 0 1 2 3 6 12 18 27 36 45 50
do
    cat "$loss_pc"_bbr.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $7}' >> bbr_goodput.csv
    cat "$loss_pc"_cubic.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $7}' >> cubic_goodput.csv
    cat "$loss_pc"_reno.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $7}' >> reno_goodput.csv
    cat "$loss_pc"_bbr.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $9}' >> bbr_retr.csv
    cat "$loss_pc"_cubic.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $9}' >> cubic_retr.csv 
    cat "$loss_pc"_reno.txt | grep "Bitrate" -A 1 | grep -v "Bitrate" | tail -n 1 | awk '{print $9}' >> reno_retr.csv
done