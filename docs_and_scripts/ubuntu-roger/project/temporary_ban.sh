#!/bin/bash

IP=$1
iptables -t filter -I INPUT -s $IP -j DROP

echo "iptables -t filter -D INPUT -s $IP -j DROP" | at now + 1 minutes
