#!/usr/bin/env bash
set -euo pipefail

AUTH="${AUTH_DNS:-192.168.10.1}"
FWD="${FORWARD_DNS:-192.168.10.2}"

echo '== authoritative A/CNAME/MX/NS =='
dig "@$AUTH" www.long90.cn A +noall +answer
dig "@$AUTH" web.long90.cn CNAME +noall +answer
dig "@$AUTH" long90.cn MX +noall +answer
dig "@$AUTH" long90.cn NS +noall +answer

echo '== authoritative PTR =='
for ip in 192.168.10.1 192.168.10.2 192.168.10.3 192.168.10.4 192.168.10.5; do
  dig "@$AUTH" -x "$ip" +noall +answer
done

echo '== forward-only path =='
dig "@$FWD" www.long90.cn A +noall +answer
dig "@$FWD" web.long90.cn +noall +answer
dig "@$FWD" long90.cn MX +noall +answer

echo '== local checks =='
named-checkconf
systemctl is-active named
systemctl is-enabled named
