#!/bin/bash

iptables -F
iptables -X

#allow nothing
iptables -t filter -P INPUT DROP

#local traffic
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

#allow ping
iptables -t filter -A INPUT -i enp0s3 -p icmp --icmp-type echo-request -j ACCEPT
iptables -t filter -A OUTPUT -o enp0s3 -p icmp --icmp-type echo-reply -j ACCEPT

#allow related established conex
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#allow http, https
iptables -t filter -A INPUT -p tcp -m multiport --dport 80,443 -j ACCEPT

#rejects conn from hosts that have more than 20 established conn
iptables -A INPUT -p tcp -m connlimit --connlimit-above 30 -j REJECT --reject-with tcp-reset

#limits new tcp conn that a client can establish per second
#iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 30 -j ACCEPT
#iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP

#iptables -t filter -A INPUT -p icmp -m hashlimit --hashlimit-name -icmp --hashlimit-mode srcip --hashlimit 1/m --hashlimit-burst 1 -j ACCEPT

#iptables -N http-flood
#iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 1 -j http-flood
#iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 1 -j http-flood
#iptables -A http-flood -m limit --limit 10/s --limit-burst 10 -j RETURN
#iptables -A http-flood -m limit --limit 1/s --limit-burst 10 -j LOG --log-prefix "http-flood"
#iptables -A http-flood -j DROP

#limit conn per source ip
#iptables -t filter -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset
#iptables -t filter -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 5 -j REJECT --reject-with tcp-reset

#limit new conn per sec per ip
#iptables -t filter -A INPUT -p tcp --dport 80 -m state --state NEW -m limit --limit 2/s --limit-burst 5 -j ACCEPT
#iptables -t filter -A INPUT -p tcp -m state --state NEW -j DROP
#iptables -t filter -A INPUT -p tcp --dport 443 -m state --state NEW -m limit --limit 5/s --limit-burst 7 -j ACCEPT
#iptables -t filter -A INPUT -p tcp -m state --state NEW -j DROP

#iptables -A INPUT -p tcp --dport 80 -m limit --limit 60/s --limit-burst 10 -j ACCEPT

#Watch the IP connecting to your enp0s3 interface
#iptables -t filter -A INPUT -p tcp --dport 80 -i enp0s3 -m state --state NEW -m recent --set
#will check if the connection is new within the last 10 seconds 
#and if the packet flow is higher than 5 and if so it will drop the connection.
#iptables -t filter -A INPUT -p tcp --dport 80 -i enp0s3 -m state --state NEW -m recent --update --seconds 10 --hitcount 5 -j DROP

