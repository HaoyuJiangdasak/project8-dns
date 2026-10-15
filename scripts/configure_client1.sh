#!/usr/bin/env bash
set -euo pipefail

# Run as root on Client1 (192.168.10.11).
CONNECTION="${1:-static0}"
dnf install -y bind-utils
nmcli connection modify "$CONNECTION" \
  ipv4.dns "192.168.10.1,192.168.10.2" \
  ipv4.dns-search "long90.cn" \
  ipv4.ignore-auto-dns yes
nmcli connection up "$CONNECTION"
cat /etc/resolv.conf
echo "Client1 DNS configured."
