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
