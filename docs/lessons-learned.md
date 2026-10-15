# 鏁呴殰涓庝慨澶嶈褰?
鐜板満澶嶆牳鏇惧彂鐜伴厤缃瑕嗙洊锛歋erver01 鐨?`named.conf` 鎸囧悜 `project8.lab` 骞堕厤缃叕缃?forwarders锛屾湭鍔犺浇鏈€缁堢殑 `long90.cn` zone锛汣lient1 鐨?search domain 涔熶粛涓?`project8.lab`銆傜粨鏋滄槸鏉冨▉鏌ヨ鍑虹幇 SERVFAIL/瓒呮椂锛屼富鏈轰晶 `nslookup` 澶辫触銆?
淇姝ラ锛?
1. 鎭㈠ `configs/final_s01_named.conf` 鍜?`configs/final_s01_named.zones`銆?2. 鎭㈠ `final_s01_long90.cn.zone` 涓?`final_s01_rev.zone`锛孲OA serial 鏇存柊涓?`2026101402`銆?3. Server02 鏀逛负 `forwarders { 192.168.10.1; }; forward only;`锛屾槑纭畠鏄浆鍙?缂撳瓨鑺傜偣锛屼笉鎵挎媴鏉冨▉鍖恒€?4. Client1 閫氳繃 NetworkManager 璁剧疆 `192.168.10.1,192.168.10.2` 鍜?`ipv4.dns-search=long90.cn`銆?5. 杩愯 `named-checkconf`銆乣named-checkzone`銆乣dig`銆乣host`銆乣nslookup` 鍜?systemd 鐘舵€佹鏌ャ€?
淇鍚庡湪澶氫釜鏃堕棿鐐瑰畬鎴愮幇鍦哄鏍革紝A銆丆NAME銆丮X銆丯S銆丳TR銆佽浆鍙戞煡璇㈠潎閫氳繃銆傞仐鐣欏亸宸槸 Client1 浣跨敤 `.11` 鑰岄潪鏁欐潗绀轰緥 `.20`锛屼互鍙婃病鏈夌嫭绔?Win10 Client3 VM锛涗袱椤瑰潎涓嶅奖鍝?DNS 鍔熻兘銆?
