#!/bin/bash

print_msg()
{
		printf "\n============================================\n" >> /var/log/DDOS_PORTSCAN.log
		printf "$dat\n *+* $IP BANNED for Ports Scan *+*\n" >> /var/log/DDOS_PORTSCAN.log
		printf "============================================\n\n" >> /var/log/DDOS_PORTSCAN.log
}

iptablz()
{
     iptables -t mangle -C PREROUTING -s $IP -j DROP &> /dev/null

     if [ $? -eq 1 ]; then
	iptables -t mangle -I PREROUTING -s $IP -j DROP
	print_msg
	
	query=$(echo "iptables -t mangle -D PREROUTING -s $IP -j DROP")
	echo "$query" | at now + 10 minutes
	printf "$dat\n address $IP banned for Port Scanning" | mail -s "Port Scanning !" ayoubbrs@gmail.com
    else 
         printf "$dat\n $IP already banned\n" >> /var/log/DDOS_PORTSCAN.log
    fi

    exit 0 # disable for multiple IPs check
}

tcpdump -nn -i enp0s3 -w capture.pcap > /dev/null 2>&1 & disown
sleep 2
pkill tcpdump

tcpdump -nn -r capture.pcap &> text_mode1
rm capture.pcap
cat text_mode1 | awk -F' ' '!/ICMP/ && !/1992/{print $3}' | awk -F'.' '{print $1"."$2"."$3"."$4}' | awk '!/10.12.19.23/{print }' > text_mode2
rm text_mode1
cat text_mode2 | awk '{print $0}' | sort | uniq -c | sort -nr > tempp.txt
rm text_mode2

while read line
do
	count=$(echo "$line" | awk -F' ' '{print $1}')
	IP=$(echo "$line" | awk -F' ' '{print $2}')
	rm tempp.txt

	if (( count > 20 )); then
		dat=$(date)
		iptablz
	fi
done < tempp.txt
