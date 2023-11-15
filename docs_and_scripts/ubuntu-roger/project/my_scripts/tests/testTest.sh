#!/bin/bash

#tcpdump -nn -i enp0s3 -w capture.pcap > /dev/null 2>&1 & disown
#sleep 2
#pkill tcpdump

#tcpdump -nn -r capture.pcap &> text_mode1
#rm capture.pcap
#cat txt1 | awk -F' ' '!/ICMP/{print $3}' | awk -F'.' '{print $1"."$2"."$3"."$4}'

cat txt1 | awk -F' ' '!/ICMP/ && !/1992/{print $3}' | awk -F'.' '{print $1"."$2"."$3"."$4}' | awk '!/10.12.19.23/{print }'

