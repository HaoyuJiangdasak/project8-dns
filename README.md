# Project 8 鈥?BIND DNS lab (`long90.cn`)

杩欐槸鈥滈」鐩?8锛欴NS 鏈嶅姟鍣ㄩ厤缃€濈殑鍙垎浜暣鐞嗙増銆傚疄楠屽湪 VMware Workstation + RHEL 8.3 涓婂畬鎴愶紝鐩爣鏄湪 VMnet1 绉佹湁缃戠粶涓惌寤轰竴涓潈濞?DNS銆佷竴涓浆鍙?缂撳瓨 DNS 鍜屼竴涓鎴风锛屽苟鐢?`dig`銆乣host`銆乣nslookup`銆乣named-checkconf`銆乣named-checkzone` 鍙嶅楠屾敹銆?
## 褰撳墠缁撴灉

- **Server01 路 `192.168.10.1`**锛欱IND 鏉冨▉鏈嶅姟鍣紝鎵樼 `long90.cn` 姝ｅ悜鍖哄拰 `10.168.192.in-addr.arpa` 鍙嶅悜鍖恒€?- **Server02 路 `192.168.10.2`**锛欱IND `forward only` 杞彂/缂撳瓨鏈嶅姟鍣紝鍙妸鏌ヨ杞彂鍒?Server01銆?- **Client1 路 `192.168.10.11`**锛氶€氳繃 NetworkManager 浣跨敤 `.1`銆乣.2` 浣滀负 DNS锛屾悳绱㈠煙涓?`long90.cn`銆?- **涓绘満/Client3 鏇夸唬 路 `192.168.10.254`**锛歐indows 涓绘満瀹屾垚澶栭儴 `nslookup` 楠屾敹锛涙病鏈夊崟鐙殑 Win10 Client3 铏氭嫙鏈恒€?
鏈€缁堢幇鍦哄鏍告樉绀猴細A銆丆NAME銆丮X銆丯S銆丳TR 鏌ヨ鍧囬€氳繃锛孲erver01/Server02 鐨?`named` 鍧囦负 active + enabled锛岄槻鐏宸叉斁琛?DNS锛孲OA serial 涓?`2026101402`銆?
## DNS 璁板綍

| 鍚嶇О | 绫诲瀷 | 鍊?|
| --- | --- | --- |
| `dns.long90.cn` | A | `192.168.10.1` |
| `mail.long90.cn` | A | `192.168.10.2` |
| `slave.long90.cn` | A | `192.168.10.3` |
| `www.long90.cn` | A | `192.168.10.4` |
| `ftp.long90.cn` | A | `192.168.10.5` |
| `web.long90.cn` | CNAME | `www.long90.cn.` |
| `long90.cn` | MX 10 | `mail.long90.cn.` |
| `192.168.10.1鈥?5` | PTR | `dns/mail/slave/www/ftp.long90.cn.` |

## 浠撳簱缁撴瀯

- [`configs/`](configs)锛氭渶缁堥€氳繃楠岃瘉鐨?BIND 閰嶇疆銆佹鍚?鍙嶅悜 zone 鏂囦欢锛屼互鍙婂凡绉婚櫎瀵嗙爜鐨?Kickstart 妯℃澘銆?- [`scripts/`](scripts)锛氱敤浜庡湪 RHEL 8 鑺傜偣涓婇儴缃插拰楠屾敹鐨勫彲閲嶅鑴氭湰銆?- [`docs/`](docs)锛氬疄楠岃鏄庛€佺綉缁滄嫇鎵戙€佹晠闅滀慨澶嶈褰曞拰鍘嗗彶鑴氭湰璇存槑銆?- [`evidence/`](evidence)锛氱幇鍦洪獙鏀剁煩闃点€佺姸鎬佽緭鍑恒€丳DF 鎬荤粨/璇佹嵁鍥惧唽鍜岀簿閫夋埅鍥俱€?
VMware 铏氭嫙纾佺洏銆丷HEL ISO銆乂Mware 瀹夎鍣ㄣ€佸揩鐓с€佹棩蹇楀拰瀵嗙爜鏂囦欢娌℃湁绾冲叆浠撳簱锛氳繖浜涙枃浠朵綋绉緢澶э紝涓斾細娉勯湶鏈湴鍑嵁銆傚畬鏁村師濮嬪伐浣滅洰褰曚粛淇濈暀鍦?`D:\妞ゅ湱娲?_DNS`銆?
## 蹇€熷鐜?
1. 鍦ㄤ笁鍙?RHEL 8.3 VM 涓娇鐢?`configs/kickstart/` 妯℃澘瀹夎绯荤粺锛屽苟鏍规嵁鑷繁鐨勭幆澧冨畨鍏ㄥ湴璁剧疆 root/鏅€氱敤鎴峰瘑鐮併€?2. 涓夊彴 VM 鎺ュ叆鍚屼竴 VMnet1 缃戞锛屾寜 `docs/network-topology.md` 閰嶇疆闈欐€佸湴鍧€銆?3. 鍦?Server01 鎵ц `scripts/configure_server01.sh`锛屽湪 Server02 鎵ц `scripts/configure_server02.sh`锛屽湪 Client1 鎵ц `scripts/configure_client1.sh`銆?4. 浠?Server01銆丼erver02銆丆lient1 鍜屼富鏈轰晶鎵ц `scripts/verify_dns.sh` 涓殑鏌ヨ鐭╅樀銆?
鑴氭湰榛樿浣跨敤鏈」鐩殑 `long90.cn` 鍜?`192.168.10.0/24`锛涘鏋滃疄楠岀幆澧冧笉鍚岋紝璇峰厛淇敼鍙橀噺骞舵鏌?zone serial銆?
## 鍏抽敭淇璁板綍

鏃╂湡鐗堟湰鏇炬妸 Server01 瑕嗙洊鎴?`project8.lab`锛屽苟閰嶇疆鍏綉 forwarders `8.8.8.8/1.1.1.1`锛屽悓鏃?Client1 鐨?search domain 涔熼敊璇€傜幇鍦哄鏍稿彂鐜板悗锛屾仮澶嶄负 `long90.cn` 鏉冨▉鍖恒€丼erver02 鈫?Server01 鐨?`forward only` 鏋舵瀯锛屽苟鎶?Client1 鏀逛负 `search long90.cn`锛涗慨澶嶅悗鍦?08:02銆?2:05鈥?2:17 鍜?12:24鈥?2:27 澶氭澶嶉獙閫氳繃銆傝瑙?[`docs/lessons-learned.md`](docs/lessons-learned.md)銆?
## 瀹夊叏璇存槑

浠撳簱涓嶅寘鍚疄楠屽瘑鐮併€丟itHub 鍑嵁銆丼SH 绉侀挜銆乂NC 瀵嗙爜銆丠ost key 鎴?VMware 杩愯鐘舵€併€傝嫢鏇惧湪鍏朵粬鍦版柟澶嶇敤杩囧疄楠屽瘑鐮侊紝寤鸿绔嬪嵆鏇存崲锛汫itHub 鐧诲綍璇蜂娇鐢?PAT/SSH 鎴?`gh auth login`锛屼笉瑕佹妸璐︽埛瀵嗙爜鍐欏叆 Git remote URL銆?
