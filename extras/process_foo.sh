#!/bin/bash
cat foo.txt | grep "htb" |  awk '{print $1}' >> timestamps.csv
cat foo.txt | grep "backlog" |  awk '{print $2}' | sed 's/.$//' >> backlogs.csv