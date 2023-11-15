#!/bin/bash

log_msg()
{
 printf "\n==============================================\n" >> /var/log/DDOS_PORTSCAN.log
 printf "$dat\n +*+* $IP BANNED for ping flood +*+*\n" >> /var/log/DDOS_PORTSCAN.log
 printf "==============================================\n\n" >> /var/log/DDOS_PORTSCAN.log
}

iptablz()
{
	iptables -t mangle -C PREROUTING -s $IP -j DROP &> /dev/null
	if [ $? -eq 0 ]; then
		printf "$dat\n $IP already banned \n" >> /var/log/DDOS_PORTSCAN.log
		exit 0
	fi

	iptables -t mangle -I PREROUTING -s $IP -j DROP
	query=$(echo "iptables -t mangle -D PREROUTING -s $IP -j DROP")
	echo "$query" | at now + 1 minutes
	printf "$dat\n address $IP banned for POF" | mail -s "POF on your website" ayoubbrs@gmail.com
	log_msg
	exit 0
}

#screen -S tcpd -dm tcpdump -i enp0s3 -n icmp and icmp[icmptype]=icmp-echo -w icmp_echo.pcap
tcpdump -i enp0s3 -n icmp and icmp[icmptype]=8 -w icmp_echo.pcap > /dev/null 2>&1 & disown
sleep 2
pkill tcpdump
tcpdump -r icmp_echo.pcap &> text_modee 
rm icmp_echo.pcap
cat text_modee | awk '{print $3}' | sort | uniq -c | sort -nr > temp2.txt
rm text_modee

while read line
do
	ping_count=$(echo "$line" | awk -F' ' '{print $1}')
	IP=$(echo "$line" | awk -F' ' '{print $2}')
	rm temp2.txt

	if (( ping_count > 20 )); then
		dat=$(date)
		iptablz
	fi
done < temp2.txt

