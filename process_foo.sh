#!/bin/bash
cat foo.txt | grep "qdisc" |  awk '{print $1, $30}' | tr -d b >> backlogs.csv