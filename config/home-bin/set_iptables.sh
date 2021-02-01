#!/bin/sh

# Flush
sudo iptables -F
# delete chains
sudo iptables -X
# set count 0
sudo iptables -Z

sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Accept by loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

sudo iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT

# internal network
#sudo iptables -A INPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT 
#sudo iptables -A OUTPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT 

# DNS
sudo iptables -A INPUT -p udp -m udp --sport 53 -j ACCEPT
sudo iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

# ICMP( Ping )
sudo iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT 
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT 
sudo iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT 
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT 

# NTP 
#sudo iptables -A INPUT -p udp -m udp --sport 123 -j ACCEPT 
#sudo iptables -A OUTPUT -p udp -m udp --dport 123 -j ACCEPT 

sudo iptables -A INPUT -p tcp -m tcp --sport 37 -j ACCEPT 
sudo iptables -A OUTPUT -p tcp -m tcp --dport 37 -j ACCEPT 

# TELNET
#	to External
#sudo iptables -A INPUT -i eth0 -p tcp -m tcp --sport 23 -j ACCEPT 
#sudo iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 23 -j ACCEPT 
#sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 23 -j ACCEPT 
#sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 23 -j ACCEPT 

#	From External
#sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 23 -j ACCEPT 
#sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 23 -j ACCEPT 

# SSH
#	to External
#sudo iptables -A INPUT -i eth0 -p tcp -m tcp --sport 22 -j ACCEPT 
#sudo iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 22 -j ACCEPT 

#	From External
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 22 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 22 -j ACCEPT 

#	Subversion Client
sudo iptables -A INPUT -p tcp -m tcp --sport 3690 -j ACCEPT 
sudo iptables -A OUTPUT -p tcp -m tcp --dport 3690 -j ACCEPT 

# FTP
#	to External
#sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 21 --dport 1024:65535 -j ACCEPT 
#sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 1024:65535 --dport 21 -j ACCEPT

#sudo iptables -A INPUT -s 192.168.0.72 -p tcp -m tcp --sport 20 -j ACCEPT 
#sudo iptables -A INPUT -s 192.168.0.72 -p tcp -m tcp --sport 21 -j ACCEPT 
#sudo iptables -A OUTPUT -d 192.168.0.72 -p tcp -m tcp --dport 20 -j ACCEPT
#sudo iptables -A OUTPUT -d 192.168.0.72 -p tcp -m tcp --dport 21 -j ACCEPT
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 20 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 21 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 20 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 21 -j ACCEPT

# SFTP
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 115 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 115 -j ACCEPT

#	From External
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 20 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 21 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 20 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 21 -j ACCEPT 

sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 5001:5010 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 5001:5010 -j ACCEPT 
#sudo iptables -A INPUT -p tcp -m tcp --dport 21 -j DROP 

# HTTP
#	to External: Web Surfing
sudo iptables -A INPUT -i eth0 -p tcp -m tcp --sport 80 -j ACCEPT 
sudo iptables -A INPUT -i eth0 -p tcp -m tcp --sport 443 -j ACCEPT 
sudo iptables -A INPUT -i eth0 -p udp -m udp --sport 443 -j ACCEPT 
sudo iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p tcp -m tcp --dport 443 -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p udp -m udp --dport 443 -j ACCEPT
#	From External
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 80 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 80 -j ACCEPT 

# HTTP-Proxy: Jenkins
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 8080 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 8080 -j ACCEPT 

# Samba: 139(netbios0ssn), 445(microsoft-ds)
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 137 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 138 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 139 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 445 -j ACCEPT 

sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 137 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 138 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 139 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 445 -j ACCEPT 

# for external Samba client.
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --dport 137 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --dport 138 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 139 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --dport 445 -j ACCEPT 

sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --sport 137 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --sport 138 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 139 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --sport 445 -j ACCEPT 

#sudo iptables -A INPUT -p tcp -m tcp --dport 139 -j DROP 
#sudo iptables -A INPUT -p tcp -m tcp --dport 445 -j DROP 

# NFS
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 111 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 111 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 2049 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 2049 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 32766:32769 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 32766:32769 -j ACCEPT 

sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 111 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 111 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 2049 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 2049 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 32766:32769 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 32766:32769 -j ACCEPT 

# TFTP
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 69 -j ACCEPT 
sudo iptables -A INPUT -s 192.168.0.0/16 -p udp -m udp --dport 3001:3010 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 69 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p udp -m udp --sport 3001:3010 -j ACCEPT 

# RDP
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 3389 -j ACCEPT 
sudo iptables -A OUTPUT -d 192.168.0.0/16 -p tcp -m tcp --sport 3389 -j ACCEPT 

# SMTP
sudo iptables -A INPUT -p tcp -m tcp --sport 25 -j ACCEPT 
#sudo iptables -A OUTPUT -p tcp -m tcp --sport 25 -j ACCEPT 
sudo iptables -A OUTPUT -p tcp -m tcp --dport 25 -j ACCEPT 
