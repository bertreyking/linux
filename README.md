# TcpDump 使用方法

1. tcpdump 常用参数介绍
```
[root@k8s-master01 ~]# tcpdump --help
tcpdump version 4.9.2
libpcap version 1.5.3
OpenSSL 1.0.2k-fips  26 Jan 2017
Usage: tcpdump [-aAbdDefhHIJKlLnNOpqStuUvxX#] [ -B size ] [ -c count ]
                [ -C file_size ] [ -E algo:secret ] [ -F file ] [ -G seconds ]
                [ -i interface ] [ -j tstamptype ] [ -M secret ] [ --number ]
                [ -Q|-P in|out|inout ]
                [ -r file ] [ -s snaplen ] [ --time-stamp-precision precision ]
                [ --immediate-mode ] [ -T type ] [ --version ] [ -V file ]
                [ -w file ] [ -W filecount ] [ -y datalinktype ] [ -z postrotate-command ]
                [ -Z user ] [ expression ]

-i ens192  #指定网络接口设备
-t         #对抓取所有包不加时间戳 （-tt、-ttt、-tttt 加上不同的时间戳，如秒、年/月/日/时/分/秒）
-s0        #抓取的数据报不会被截断，便于后续进行分析
-n         #抓取的包以IP地址方式显示，不进行主机名解析 （-nn 抓取的包如ssh，已22 的形式进行显示）
-v         #输出较详细的数据 （-vv、-vvv 同理）
-w         #将数据重定向到文件中，而非标准输出
```
2. tcpdump 常用表达式
```
! 
and
or

示例：（and）
[root@k8s-master01 ~]# tcpdump tcp -nn -i ens192 -t -s0 and dst 10.6.203.63 and dst port 22
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens192, link-type EN10MB (Ethernet), capture size 262144 bytes
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [S], seq 3113679214, win 29200, options [mss 1460,sackOK,TS val 3908715180 ecr 0,nop,wscale 7], length 0
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [.], ack 3504717432, win 229, options [nop,nop,TS val 3908715195 ecr 2496275413], length 0
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [.], ack 22, win 229, options [nop,nop,TS val 3908717316 ecr 2496277534], length 0
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [P.], seq 0:10, ack 22, win 229, options [nop,nop,TS val 3908721874 ecr 2496277534], length 10
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [.], ack 41, win 229, options [nop,nop,TS val 3908721875 ecr 2496282093], length 0
IP 10.6.203.60.54956 > 10.6.203.63.22: Flags [F.], seq 10, ack 42, win 229, options [nop,nop,TS val 3908721879 ecr 2496282096], length 0

示例：（or）当有多个dst地址时，可以使用or来进行同时抓取
[root@k8s-master01 ~]# tcpdump tcp -nn -i ens192 -s0 and dst 10.6.203.63 or dst 10.6.203.64  and dst port 22   
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens192, link-type EN10MB (Ethernet), capture size 262144 bytes
12:13:28.961250 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [S], seq 1321753332, win 29200, options [mss 1460,sackOK,TS val 3908829347 ecr 0,nop,wscale 7], length 0
12:13:28.961857 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [.], ack 1921664081, win 229, options [nop,nop,TS val 3908829348 ecr 4223571043], length 0
12:13:28.988597 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [.], ack 22, win 229, options [nop,nop,TS val 3908829375 ecr 4223571069], length 0
12:13:30.143741 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [P.], seq 0:11, ack 22, win 229, options [nop,nop,TS val 3908830530 ecr 4223571069], length 11
12:13:30.144396 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [.], ack 41, win 229, options [nop,nop,TS val 3908830531 ecr 4223572225], length 0
12:13:30.146677 IP 10.6.203.60.33874 > 10.6.203.64.22: Flags [F.], seq 11, ack 42, win 229, options [nop,nop,TS val 3908830533 ecr 4223572227], length 0
12:13:31.676547 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [S], seq 2733737364, win 29200, options [mss 1460,sackOK,TS val 3908832063 ecr 0,nop,wscale 7], length 0
12:13:31.677639 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [.], ack 963419704, win 229, options [nop,nop,TS val 3908832064 ecr 2496392281], length 0
12:13:31.712209 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [.], ack 22, win 229, options [nop,nop,TS val 3908832098 ecr 2496392316], length 0
12:13:33.055319 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [P.], seq 0:8, ack 22, win 229, options [nop,nop,TS val 3908833441 ecr 2496392316], length 8
12:13:33.056220 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [.], ack 41, win 229, options [nop,nop,TS val 3908833442 ecr 2496393660], length 0
12:13:33.056626 IP 10.6.203.60.55726 > 10.6.203.63.22: Flags [F.], seq 8, ack 42, win 229, options [nop,nop,TS val 3908833443 ecr 2496393660], length 0

示例：(!) 排除src/dst地址为10.6.203.64/10.6.203.63 为22的数据包
[root@k8s-master01 ~]# tcpdump tcp -nn -i ens192 -t -s0 and ! dst 10.6.203.63 and ! src 192.168.170.20 and dst port 22      
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on ens192, link-type EN10MB (Ethernet), capture size 262144 bytes
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [S], seq 2539166541, win 29200, options [mss 1460,sackOK,TS val 3915719486 ecr 0,nop,wscale 7], length 0
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [.], ack 253672407, win 229, options [nop,nop,TS val 3915719487 ecr 4230461180], length 0
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [.], ack 22, win 229, options [nop,nop,TS val 3915719518 ecr 4230461211], length 0
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [P.], seq 0:5, ack 22, win 229, options [nop,nop,TS val 3915731003 ecr 4230461211], length 5
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [P.], seq 5:10, ack 22, win 229, options [nop,nop,TS val 3915731850 ecr 4230472697], length 5
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [.], ack 41, win 229, options [nop,nop,TS val 3915731850 ecr 4230473544], length 0
IP 10.6.203.60.50800 > 10.6.203.64.22: Flags [F.], seq 10, ack 42, win 229, options [nop,nop,TS val 3915731851 ecr 4230473544], length 0
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [S], seq 631664675, win 29200, options [mss 1460,sackOK,TS val 3915742485 ecr 0,nop,wscale 7], length 0
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [.], ack 3229258316, win 229, options [nop,nop,TS val 3915742498 ecr 1630199670], length 0
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [.], ack 22, win 229, options [nop,nop,TS val 3915743861 ecr 1630201039], length 0
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [P.], seq 0:5, ack 22, win 229, options [nop,nop,TS val 3915748354 ecr 1630201039], length 5
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [P.], seq 5:7, ack 22, win 229, options [nop,nop,TS val 3915748478 ecr 1630205533], length 2
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [.], ack 41, win 229, options [nop,nop,TS val 3915748480 ecr 1630205658], length 0
IP 10.6.203.60.38270 > 10.6.203.62.22: Flags [F.], seq 7, ack 42, win 229, options [nop,nop,TS val 3915748480 ecr 1630205658], length 0
```

# Rsyslog&Logroate配置方法
```
1. logroate常用参数
monthly: 日志文件将按月轮循。其它可用值为‘daily’，‘weekly’或者‘yearly’。
rotate 5: 一次将存储5个归档日志。对于第六个归档，时间最久的归档将被删除。
compress: 在轮循任务完成后，已轮循的归档将使用gzip进行压缩。
delaycompress: 总是与compress选项一起用，delaycompress选项指示logrotate不要将最近的归档压缩，压缩将在下一次轮循周期进行。这在你或任何软件仍然需要读取最新归档时很有用。
missingok: 在日志轮循期间，任何错误将被忽略，例如“文件无法找到”之类的错误。
notifempty: 如果日志文件为空，轮循不会进行。
create 644 root root: 以指定的权限创建全新的日志文件，同时logrotate也会重命名原始日志文件。
postrotate/endscript: 在所有其它指令完成后，postrotate和endscript里面指定的命令将被执行。在这种情况下，rsyslogd 进程将立即再次读取其配置并继续运行。
2. cat /etc/logroate.d/haproxy 示例
/var/log/haproxy.log {
    daily
    rotate 200
    missingok
    notifempty
    compress
    sharedscripts
    postrotate
        /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2>/dev/null || true
        /bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2>/dev/null || true
    endscript
}
3. Let’s edit /etc/rsyslog.conf and uncomment these lines:
vi /etc/rsyslog.conf
$ModLoad imudp
$UDPServerRun 514
*.info;mail.none;authpriv.none;cron.none;local2.none                /var/log/messages
local2.* /var/log/haproxy
4. 重新加载rsyslog.service
systemctl reload rsyslog.service
5. logroate进行验证
logrotate -f /etc/logrotate.d/haproxy

```
# ansible-playbook
```
示例playbook
- hosts: cal
  gather_facts: no
  tasks:
  - name: CreateDir
    file:
      path: /root/testDir
      state: directory
    register: mk_dir
  - debug: var=mk_dir.diff.after.path
  
  1. register: 表示将 file模块执行的结果注入到mk_dir里面.以json格式输出
  2. debug:
  常用参数
  var: 将某个任务执行的输出作为变量传递给debug模块，debug会直接将其打印输出
  msg: 输出调试的消息
  verbosity：debug的级别（默认是0级，全部显示）
  3. 常用模块
  file\shell\command\copy\script\mail
 ```
 # linux下域名解析顺序及nameserver配置
 ```
 1. linux主机内解析的顺序
 取决与/etc/nsswitch.conf 配置文件中hosts顺序
 hosts:      files dns myhostname   
 说明：
 #files 表示先去解析/etc/hosts文件中的记录，其实就类似于直接用ip访问后端应用
 node1-web >> node2-data
 #dns   表示去解析/etc/resolv.confg中的dns地址，由dns_server去正向和反向解析对应的记录，解析到后转发至后端应用
 node1-web >> dns_server(node2-data记录) >> node2-data
 #myhostname 类似于127.0.0.1,有点自己ping自己的意思
 2. nameserver 如何配置更改
 方法一：无需重启网络服务直接生效
 vi /etc/resolv.conf
 nameserver 1.1.1.1
 nameserver 2.2.2.2
 重启网络服务后可能会丢失,怎么才不会丢失呢？ 更改/etc/sysconfig/network-scripts/ifcfg-ens2f0 配置文件新增会更改PEERDNS=no，这样重启网络服务就不会有影响了
 方法二：需要重启网络服务
 vi /etc/sysconfig/network-scripts/ifcfg-ens2f0
 DNS1=1.1.1.1
 DNS2=1.1.1.2
 ```
# yum update 和 upgrade 的区别
```
- update :更新软件包时会保留老版本的软件包 (前提是: /etc/yum.conf 配置文件中该参数 obsoletes=0. 默认为:1)
- upgreade :更新软件包时会清理老版本的软件包
- 所以当obsoletes=1时没有任何区别

# iptables 开启/禁用端口
```
命令：iptables
参数：
- -A 添加一条 input 规则, INPUT 进、OUTPUT 出
- -p 指定协议类型，如 tcp / udp
- -s 源地址
- --dport 目标端口
- --sport 与 dport 相反为源端口 
- -j 决定是接受还是丢掉数据包，ACCEPT 表示接受，DROP 表示丢掉相关数据包

示例1： (开启22端口，接受来自任何节点的ssh 会话，此处需要添加 2 条规则，允许进出都开启 22 端口)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

示例2：（禁止某主机访问节点的 ssh端口）
iptables -A INPUT -p tcp -s 192.168.1.x -j DROP

示例3 （禁止节点与 某主机的 22 端口进行通信）
iptables -D OUTPUT -p tcp -d 192.168.1.x --dport 22 -j DROP
```
```
## 所有参考链接
[haproxy&logroate配置](https://www.e2enetworks.com/help/knowledge-base/enable-logging-of-haproxy-in-rsyslog/)
[rsyslog&haproxy配置](https://www.percona.com/blog/2014/10/03/haproxy-give-me-some-logs-on-centos-6-5/)
[域名解析](https://www.xiebruce.top/1024.html)
[redhat_System_Administrators_Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-yum#s1-yum-upgrade-system)
