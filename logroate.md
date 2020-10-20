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
