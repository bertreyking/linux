# linux 性能优化

1. Limit调整
```
- 查看系统/用户级别文件打开数
cat /proc/sys/fs/file-max #一般情况下不需要修改(8c/16g配置都百万级别了)
cat /proc/sys/fs/file-nr 
ulimit -Sa / ulimit -Ha (软硬限制)

- 查看系统/用户最大进程数
cat /proc/sys/kernel/pid_max / sysctl -a | grep pid_max
ulimit -Sa / ulimit -Ha (软硬限制)

- 临时修改(当前用户)
ulimit -Su 16384  
ulimit -Hu 16384  
sysctl -w  kernel.pid_max=102400 / echo 102400 > /proc/sys/kernel/pid_max
ulimit -Sn 65536 
ulimit -Hn 65536 

- 永久修改(所有用户)
echo "*      soft   nproc 16384" >> /etc/security/limits.conf 
echo "*      hard   nproc 16384" >> /etc/security/limits.conf 
echo "*      soft   nofile 65536" >> /etc/security/limits.conf 
echo "*      hard   nofile 65536" >> /etc/security/limits.conf
echo 'kernel.pid_max = 16384' >>/etc/sysctl.conf 
echo 'fs.file-max = xxxxxx' >>/etc/sysctl.conf 

- 注意
需要检查下/etc/security/limits.d/目录下有没有其他的配置文件，如果备份及删除该文件。此处配置为约定的特定配置，系统会将其配置进行生效
```
2. 内核调整
```
- 永久调整
echo 'net.netfilter.nf_conntrack_max = 5120000' >>/etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30' >>/etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 30' >>/etc/sysctl.conf
echo 'net.ipv4.ip_forward = 1' >>/etc/sysctl.conf
echo 'net.ipv4.ip_local_port_range = 1024 65535' >>/etc/sysctl.conf
echo 'net.ipv4.tcp_tw_reuse = 1' >>/etc/sysctl.conf
echo 'net.ipv4.tcp_tw_recycle = 0' >>/etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout = 30' >>/etc/sysctl.conf
echo 'net.ipv4.tcp_slow_start_after_idle = 0' >>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables = 1' >>/etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-iptables = 1' >>/etc/sysctl.conf

- 加入开机自启
echo 'sysctl -p' >> /etc/rc.local
chmod +x /etc/rc.d/rc.local
```

# 参考链接
- [ulimit软硬配置](https://askubuntu.com/questions/1061572/unable-to-modify-ulimit)
- [linux内核优化](https://developer.aliyun.com/article/718976)
