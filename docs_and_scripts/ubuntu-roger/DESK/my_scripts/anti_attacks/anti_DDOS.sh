#!/bin/bash

log_msg()
{
 printf "\n===========================================\n" >> /var/log/DDOS_PORTSCAN.log
 printf "$dat\n *+*+*+* $IP BANNED for DDOS *+*+*+*\n" >> /var/log/DDOS_PORTSCAN.log
 printf "===========================================\n\n" >> /var/log/DDOS_PORTSCAN.log
}

iptablz()
{
	iptables -t mangle -C PREROUTING -s $IP -j DROP &> /dev/null
	if [ $? -eq 0 ]; then
		printf "$dat\n $IP already banned\n" >> /var/log/DDOS_PORTSCAN.log
		exit 0
	fi

	iptables -t mangle -I PREROUTING -s $IP -j DROP
	query=$(echo "iptables -t mangle -D PREROUTING -s $IP -j DROP")
	echo "$query" | at now + 10 minutes
	printf "$dat\n address $IP banned for DDOS" | mail -s "DDOS on your website" ayoubbrs@gmail.com 
	log_msg
	exit 0 # disable to iterat all
}

netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr > temp1.txt

while read line
do
	nbr_connx=$(echo "$line" | awk -F' ' '{print $1}')
	IP=$(echo "$line" | awk -F' ' '{print $2}')
	rm temp1.txt

	if (( nbr_connx > 25 )); then
		dat=$(date)
		iptablz
	fi
done < temp1.txt
