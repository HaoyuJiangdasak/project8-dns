#!/usr/bin/env bash
set -euo pipefail

# Run as root on Server02 (192.168.10.2), from the repository root.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dnf install -y bind bind-utils
install -m 0644 "$REPO_ROOT/configs/final_s02_named.conf" /etc/named.conf
restorecon -v /etc/named.conf >/dev/null 2>&1 || true
named-checkconf
firewall-cmd --permanent --add-service=dns
firewall-cmd --reload
systemctl enable --now named
systemctl restart named
systemctl is-active --quiet named
echo "Server02 forward-only DNS configured."
