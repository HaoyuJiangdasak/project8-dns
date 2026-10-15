#!/bin/bash
set -e
echo nameserver 192.168.10.1 >/etc/resolv.conf
echo nameserver 192.168.10.2 >>/etc/resolv.conf
echo search project8.lab >>/etc/resolv.conf
dnf install -y bind-utils || yum install -y bind-utils || true
dig Server01.project8.lab +short
dig www.project8.lab +short
dig -x 192.168.10.1 +short
host Client1.project8.lab || true
echo CLIENT_DNS_OK
