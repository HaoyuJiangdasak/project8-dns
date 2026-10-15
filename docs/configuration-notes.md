# 閰嶇疆瑕佺偣

## Server01

- `listen-on port 53 { any; };`
- `allow-query { any; };`
- `dnssec-validation no;`
- include `/etc/named.zones`
- 鏉冨▉鍖猴細`long90.cn` 涓?`10.168.192.in-addr.arpa`

## Server02

- `forwarders { 192.168.10.1; };`
- `forward only;`
- 鏌ヨ缁撴灉搴旀樉绀轰负 non-authoritative锛屾潈濞佹暟鎹粛鏉ヨ嚜 Server01銆?
## Client1

```text
search long90.cn
nameserver 192.168.10.1
nameserver 192.168.10.2
```

Kickstart 鏂囦欢鍙繚鐣欏畨瑁呯粨鏋勶紝瀵嗙爜琛屽凡浠庝粨搴撶Щ闄わ紱璇峰湪鏈湴閫氳繃瀹夊叏鏂瑰紡娉ㄥ叆瀵嗙爜銆?
