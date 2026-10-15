#!/usr/bin/env bash
set -euo pipefail

# Run as root on Server01 (192.168.10.1), from the repository root.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
install -d -m 0755 /var/named
dnf install -y bind bind-utils
install -m 0644 "$REPO_ROOT/configs/final_s01_named.conf" /etc/named.conf
install -m 0644 "$REPO_ROOT/configs/final_s01_named.zones" /etc/named.zones
install -o root -g named -m 0640 "$REPO_ROOT/configs/final_s01_long90.cn.zone" /var/named/long90.cn.zone
install -o root -g named -m 0640 "$REPO_ROOT/configs/final_s01_rev.zone" /var/named/1.10.168.192.zone
restorecon -Rv /etc/named.conf /etc/named.zones /var/named >/dev/null 2>&1 || true
named-checkconf
named-checkzone long90.cn /var/named/long90.cn.zone
named-checkzone 10.168.192.in-addr.arpa /var/named/1.10.168.192.zone
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
systemctl enable --now named
systemctl restart named
systemctl is-active --quiet named
echo "Server01 authoritative DNS configured."
