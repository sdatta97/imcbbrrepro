#!/bin/bash

DST=$1

touch router-tc.txt

rm -f router-tc.txt 

<<com
cleanup ()
{
	# get timestamp
	ts=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  |  grep "unacked" |  awk '{print $1}')

	# get send queue
	send_q=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  | grep "unacked" | awk '{print $5}')

	# get sender
	sender=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  | grep "unacked" | awk '{print $6}')

	# retransmissions - current, total
	retr=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"  |  grep -oP '\bunacked:.*\brcv_space'  | awk -F '[:/ ]' '{print $4","$5}' | tr -d ' ')


	# get cwnd, ssthresh
	cwn=$(cat sender-ss.txt |   sed -e ':a; /<->$/ { N; s/<->\n//; ba; }' | grep "ESTAB"    |  grep "unacked" | grep -oP '\bcwnd:.*(\s|$)\bbytes_acked' | awk -F '[: ]' '{print $2","$4}')

	# concatenate into one CSV
	paste -d ',' <(printf %s "$ts") <(printf %s "$send_q") <(printf %s "$sender") <(printf %s "$retr") <(printf %s "$cwn") > sender-ss.csv

	exit 0
}

trap cleanup SIGINT SIGTERM
com
while [ 1 ]; do 
	 watch -n 0.1 tc -s qdisc show dev $(ip route get $DST | grep -oP "(?<=dev )[^ ]+") | tee -a router-tc.txt 
done