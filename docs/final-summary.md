# 项目 8「DNS 服务器配置」最终总结 / Project 8 Final Summary

**域 / Domain：** `long90.cn`
**当前状态 / Status：** **CORRECT & VERIFIED（修复后已多次现场复核通过）**
**最近一次现场演示验收（Asia/Shanghai）：** 2026-10-14 **12:24–12:27**
**此前复核：** 2026-10-14 ~08:02；再次 ~12:05–12:17
**SOA serial：** **2026101402**
**判定：** COMPLETE（核心 DNS 功能正确；曾有配置被覆盖的 bug，已修复并复验）

> 先写**当前正确状态**，再简要记录**曾出现的 bug 与修复**。不以「从未出错」表述。

---

## 一、当前正确状态（以最近演示为准）

### 1. 环境与网络

| 角色 | IP | 说明 |
|---|---|---|
| Server01 | 192.168.10.1/24 | 权威 BIND：`long90.cn` 正向 + `10.168.192.in-addr.arpa` 反向 |
| Server02 | 192.168.10.2/24 | 仅转发：`forwarders { 192.168.10.1; }; forward only;`（非 slave） |
| Client1 | 192.168.10.11/24 | Linux 客户端（教材示例为 .20，见偏差） |
| 主机 / Client3 替代 | 192.168.10.254/24 | Windows 主机当 Client3；**无**独立 Win10 Client3 VM |
| 网络 | VMnet1 | 主机与 VM 直连；**VM 内无代理** |
| 账号 | root / jianghaoyu | 密码由实验环境单独管理，不随仓库提供 |
| Host keys | — | 保留在本机，不随仓库提供 |

主机：LAPTOP-GMRJ9BEM（Windows）；VMware Workstation；三台 RHEL 8.3 VM。

### 2. DNS 记录（权威 @192.168.10.1）

| 名称 | 类型 | 值 |
|---|---|---|
| dns.long90.cn | A | 192.168.10.1 |
| mail.long90.cn | A | 192.168.10.2 |
| slave.long90.cn | A | 192.168.10.3 |
| www.long90.cn | A | 192.168.10.4 |
| ftp.long90.cn | A | 192.168.10.5 |
| web.long90.cn | CNAME | www.long90.cn. |
| long90.cn | NS | dns.long90.cn. |
| long90.cn | MX 10 | mail.long90.cn. |
| 反向 PTR .1–.5 | PTR | dns / mail / slave / www / ftp |

MX / NS / PTR / CNAME 现场均正常。

### 3. Server01 关键配置要点

- `/etc/named.conf`：`listen-on port 53 { any; };`、`allow-query { any; };`、`dnssec-validation no;`、`include "/etc/named.zones";`
- **无**公网 forwarders（8.8.8.8 / 1.1.1.1）
- `/etc/named.zones`：`long90.cn` → `long90.cn.zone`；`10.168.192.in-addr.arpa` → `1.10.168.192.zone`
- named：active + enabled；firewall 含 dns；named-checkconf / named-checkzone 通过

### 4. Server02

- `forwarders { 192.168.10.1; }; forward only;`
- 经 .2 查询为 Non-authoritative（符合缓存/转发）

### 5. Client1

- `resolv.conf`：`search long90.cn`；nameserver `192.168.10.1`、`192.168.10.2`
- dig / host / nslookup 经 .1 与 .2 均可解析 www→.4 等

### 6. 现场验收时间线（Asia/Shanghai）

| 时间 | 内容 |
|---|---|
| ~08:02 | 晨间发现并修复错误配置后，dig/nslookup 矩阵通过；serial 2026101402 |
| ~12:05–12:17 | 午间再次 live 复核，权威/转发/Client1/主机侧正常 |
| ~12:24–12:27 | **Live demo**：ping .1/.2/.11；nslookup 矩阵 www/mail/ftp/dns/web @.1 与 @.2；PTR .4→www；S01/S02 named active + checkconf；C1 search=long90.cn 且 dig www=.4。脚本两处假 FAIL（dns 自解析、.2 非权威 stderr）已复核为真实 PASS。日志：`C:\Users\Lenovo\p8_live_demo\demo_log.txt` |

复现示例：

```bash
dig @192.168.10.1 www.long90.cn +noall +answer
dig @192.168.10.1 web.long90.cn +noall +answer
dig @192.168.10.1 -x 192.168.10.4 +noall +answer
dig @192.168.10.1 long90.cn MX +noall +answer
dig @192.168.10.2 www.long90.cn +noall +answer
```

Windows：`nslookup www.long90.cn 192.168.10.1` / `nslookup www.long90.cn 192.168.10.2`

---

## 二、曾出现的 Bug 与修复（诚实记录）

先前有版本曾自称 fully_complete，但 **2026-10-14 晨间现场复核**发现：

| 问题 | 现象 | 修复 |
|---|---|---|
| Server01 `named.conf` 被覆盖为 `project8.lab` + 公网 forwarders `8.8.8.8`/`1.1.1.1`，且未 `include "/etc/named.zones"` | `long90.cn` 权威区未加载 → SERVFAIL / 查询超时 | 恢复教材式 options + include named.zones；恢复 long90.cn 正反向区（serial **2026101402**） |
| Client1 `search` 为 `project8.lab` | 短名解析域错误 | NM：`ipv4.dns=192.168.10.1,192.168.10.2` + `ipv4.dns-search=long90.cn` |
| 主机 nslookup 超时 | 权威区修复后恢复 | 以 08:02 及之后复验为准 |

**结论：** 当前状态正确，是**修复 bug 之后**多次 dig/nslookup/live demo 验证的结果，不是「从未出过问题」。

配置副本（证据目录）：`final_s01_named.conf`、`final_s01_named.zones`、`final_s01_long90.cn.zone`、`final_s01_rev.zone`、`final_s02_named.conf`；另有 `apply_fix.log`、`live_matrix_*.txt`、`40_`–`43_*_FIXED.png` 等。

---

## 三、已知非阻塞偏差

| 偏差 | 影响 |
|---|---|
| Client1 IP=.11（教材 .20） | 无功能影响 |
| 无独立 Win10 Client3 VM（教材 .40） | 主机 `.254` 代替；nslookup 已过 |
| 分区 LVM autopart / 安装语言 en_US | 不影响 DNS；时区 Asia/Shanghai |
| 快照未创建 | 可选；当前磁盘可复现 |

**无阻塞项。**

---

## 四、账号表

| 主机 | 用户 | 密码 |
|---|---|---|
| Server01 / Server02 / Client1 | root、jianghaoyu | 未记录于仓库 |
| 主机（Client3 替代） | Lenovo | （本机原有） |

---

## 五、证据与文档路径

- 证据目录：`D:\项目8_DNS\证据\`
- Live demo 日志：`C:\Users\Lenovo\p8_live_demo\demo_log.txt`
- Host keys：保留在本机，不随仓库提供
- 本总结副本：
  - `D:\项目8_DNS\FINAL_SUMMARY.md`
  - `D:\项目8_DNS\最终总结.md`
  - `D:\项目8_DNS\证据\FINAL_SUMMARY.md`
  - `D:\项目8_DNS\证据\最终总结.md`
  - `C:\Users\Lenovo\FINAL_SUMMARY_project8.md`

---

## 六、完成判定对照

- [x] Server01 `.1` 权威 long90.cn 正反向（多次 dig 通过，serial 2026101402）
- [x] Server02 `.2` forward-only → `.1`
- [x] Client1 search=`long90.cn`；dig/nslookup 通过
- [x] 主机（Client3 替代）nslookup 通过
- [x] named active/enabled、firewall dns、checkzone 通过
- [x] 错误配置（project8.lab + 公网 forwarders）已修复并复验
- [x] 2026-10-14 午间 live demo（~12:27）全部 DNS 检查 PASS

**结论：项目 8 在修复后处于正确、可演示状态；以 2026-10-14 12:27 现场演示与此前 08:02 / 12:05–12:17 复核为准。**
