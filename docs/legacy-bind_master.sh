#!/bin/bash
set -e
dnf install -y bind bind-utils || yum install -y bind bind-utils
systemctl enable named
cat >/etc/named.conf <<EOF
options {
    listen-on port 53 { 127.0.0.1; 192.168.10.1; };
    listen-on-v6 { none; };
    directory "/var/named";
    allow-query { localhost; 192.168.10.0/24; };
    recursion yes;
    allow-recursion { localhost; 192.168.10.0/24; };
    forwarders { 8.8.8.8; 1.1.1.1; };
    dnssec-validation no;
};
zone "." IN { type hint; file "named.ca"; };
zone "project8.lab" IN { type master; file "project8.lab.zone"; allow-transfer { 192.168.10.2; }; notify yes; };
zone "10.168.192.in-addr.arpa" IN { type master; file "10.168.192.rev"; allow-transfer { 192.168.10.2; }; };
EOF
cat >/var/named/project8.lab.zone <<EOF
$TTL 86400
@ IN SOA Server01.project8.lab. root.project8.lab. ( 2026101301 3600 900 604800 86400 )
@ IN NS Server01.project8.lab.
@ IN NS Server02.project8.lab.
@ IN A 192.168.10.1
Server01 IN A 192.168.10.1
Server02 IN A 192.168.10.2
Client1 IN A 192.168.10.11
gateway IN A 192.168.10.254
www IN A 192.168.10.1
EOF
cat >/var/named/10.168.192.rev <<EOF
$TTL 86400
@ IN SOA Server01.project8.lab. root.project8.lab. ( 2026101301 3600 900 604800 86400 )
@ IN NS Server01.project8.lab.
@ IN NS Server02.project8.lab.
1 IN PTR Server01.project8.lab.
2 IN PTR Server02.project8.lab.
11 IN PTR Client1.project8.lab.
254 IN PTR gateway.project8.lab.
EOF
chown root:named /var/named/project8.lab.zone /var/named/10.168.192.rev
chmod 640 /var/named/project8.lab.zone /var/named/10.168.192.rev
firewall-cmd --permanent --add-service=dns || true
firewall-cmd --reload || true
named-checkconf
named-checkzone project8.lab /var/named/project8.lab.zone
named-checkzone 10.168.192.in-addr.arpa /var/named/10.168.192.rev
systemctl restart named
dig @127.0.0.1 Server01.project8.lab +short
echo BIND_MASTER_OK
