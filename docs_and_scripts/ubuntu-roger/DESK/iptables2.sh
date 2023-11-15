
# Flush the input and output tables.
 iptables -F 
 iptables -X
#  
#  # Set the default policies to allow no input
  iptables -t filter -P INPUT DROP
   
#   # Allow all local traffic 
   iptables -t filter -A INPUT -i lo -j ACCEPT
   iptables -t filter -A OUTPUT -o lo -j ACCEPT

#   # allow ping
   iptables -t filter -A INPUT -i enp0s3 -p icmp --icmp-type echo-request -j ACCEPT
   iptables -t filter -A OUTPUT -o enp0s3 -p icmp --icmp-type echo-reply -j ACCEPT
#
#   # Allow Established and Related Incoming Connections
#   # As network traffic generally needs to be two-way—incoming and outgoing—to work properly
   iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
#
#   # allow some incoming ports for services that should be public available
   iptables -t filter -A INPUT -p tcp -m multiport --dport 80,443 -j ACCEPT

### 1: Drop invalid packets ### 
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP  

### 2: Drop TCP packets that are new and are not SYN ### 
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP 

### 4: Block packets with bogus TCP flags ### 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP 
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP  

### 6: Drop ICMP (you usually don't need this protocol) ### 
iptables -t mangle -A PREROUTING -p icmp -j DROP  

### 7: Drop fragments in all chains ### 
iptables -t mangle -A PREROUTING -f -j DROP  

### 8: Limit connections per source IP ### 
iptables -A INPUT -p tcp -m connlimit --connlimit-above 60 -j REJECT --reject-with tcp-reset

### 9: Limit RST packets ### 
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT 
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP  

### 10: Limit new TCP connections per second per source IP ### 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 5 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP  

### SSH brute-force protection ### 
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set 
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP  

### Protection against port scanning ### 
iptables -N port-scanning 
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 5/s --limit-burst 2 -j RETURN 
iptables -A port-scanning -j DROP
