#!/bin/bash

ip_server=$1

for port in $2 $3 $4 $5
do
	curl --max-time 0.1 -s $ip_server:$port
done
ssh ayoub@$ip_server -p $6
#ssh test11@$ip_server -p $6
