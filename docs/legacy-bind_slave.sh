#!/bin/bash
set -e
dnf install -y bind bind-utils || yum install -y bind bind-utils
systemctl enable named
mkdir -p /var/named/slaves
chown named:named /var/named/slaves
cat >/etc/named.conf <<EOF
options {
    listen-on port 53 { 127.0.0.1; 192.168.10.2; };
    listen-on-v6 { none; };
    directory "/var/named";
    allow-query { localhost; 192.168.10.0/24; };
    recursion yes;
    allow-recursion { localhost; 192.168.10.0/24; };
    forwarders { 192.168.10.1; };
    dnssec-validation no;
};
zone "." IN { type hint; file "named.ca"; };
zone "project8.lab" IN { type slave; file "slaves/project8.lab.zone"; masters { 192.168.10.1; }; };
zone "10.168.192.in-addr.arpa" IN { type slave; file "slaves/10.168.192.rev"; masters { 192.168.10.1; }; };
EOF
firewall-cmd --permanent --add-service=dns || true
firewall-cmd --reload || true
named-checkconf
systemctl restart named
sleep 3
dig @127.0.0.1 Server01.project8.lab +short
echo BIND_SLAVE_OK
