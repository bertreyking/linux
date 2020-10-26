# 目录
- [x] [Tutorialspoint](https://www.tutorialspoint.com/unix/unix-system-logging.htm)
- [x] [scripts](https://github.com/bertreyking/linux/tree/main/scripts)
- [x] [tcpdump](https://github.com/bertreyking/linux/blob/main/tcpdump.md)
- [x] [rsyslog logroate](https://github.com/bertreyking/linux/blob/main/logroate.md)
- [x] [ansible](https://github.com/bertreyking/linux/blob/main/ansible.md)
- [x] [dns](https://github.com/bertreyking/linux/blob/main/dns%E8%A7%A3%E6%9E%90%E9%A1%BA%E5%BA%8F.md)
- [x] [yum](https://github.com/bertreyking/linux/blob/main/update%E4%B8%8Eupgrade%E5%8C%BA%E5%88%AB)
- [x] [iptables](https://github.com/bertreyking/linux/blob/main/iptables.md)
- [x] [sawp分区删除](https://github.com/bertreyking/linux/blob/main/linux%E6%B8%85%E7%90%86Swap%E5%88%86%E5%8C%BA.md)
- [x] [文本处理](https://github.com/bertreyking/linux/blob/main/%E6%96%87%E6%9C%AC%E5%A4%84%E7%90%86)

# 学习

# 锦上添花

1. shell 脚本利用 echo 命令输出颜色自定义(linux终端下，体验很好，但需要将结果导出为文本，不建议使用)
- 格式/示例:
echo -e "\033[字背景颜色；文字颜色m字符串\033[0m" 
echo -e "\033[41;36m something here \033[0m" 

- 注解:
其中41代表背景色， 36代表字体颜色 
```
1. 背景颜色和字体颜色之间是英文的; 
2. 字体颜色后面有 m 
3. 字符串前后可以没有空格，如果有的话，输出也是同样有空格
4. \033[0m 为控制项
```
- 字体颜色
```
echo -e "\033[30m 黑色字 \033[0m" 
echo -e "\033[31m 红色字 \033[0m" 
echo -e "\033[32m 绿色字 \033[0m" 
echo -e "\033[33m 黄色字 \033[0m" 
echo -e "\033[34m 蓝色字 \033[0m" 
echo -e "\033[35m 紫色字 \033[0m" 
echo -e "\033[36m 天蓝字 \033[0m" 
echo -e "\033[37m 白色字 \033[0m" 
```
- 背景颜色
```
echo -e "\033[40;37m 黑底白字 \033[0m"
echo -e "\033[41;37m 红底白字 \033[0m"
echo -e "\033[42;37m 绿底白字 \033[0m"
echo -e "\033[43;37m 黄底白字 \033[0m"
echo -e "\033[44;37m 蓝底白字 \033[0m"
echo -e "\033[45;37m 紫底白字 \033[0m"
echo -e "\033[46;37m 天蓝底白字 \033[0m"
echo -e "\033[47;30m 白底黑字 \033[0m"
```
- 控制选项
```
\033[0m 关闭所有属性 
\033[1m 设置高亮度 
\033[4m 下划线 
```

# 参考链接
[rsyslog_haprxoy_1](https://www.e2enetworks.com/help/knowledge-base/enable-logging-of-haproxy-in-rsyslog/)
[rsyslog_haprxoy_2](https://www.percona.com/blog/2014/10/03/haproxy-give-me-some-logs-on-centos-6-5/)
[dns_nameserver](https://www.xiebruce.top/1024.html)
[yum_update_vs_upgrade](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-yum#s1-yum-upgrade-system)
