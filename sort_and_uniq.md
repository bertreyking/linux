# sort
- 参数
```
-n 按数字大小进行排序
-r 降序
-k 指定排序依据的列
-u 去重
```
- 示例
```
sort -nr -k 3 | head -n 10

[root@k8s-master01 ~]# for i in `ps -ef | awk 'NR>1 {print $2}'`;do echo -n $i;echo -n " "; cat /proc/$i/status |grep Threads|awk '{print $2}' ;done | sort -nr -k 2 | head -n 10
1687 46
1385 41
5197 40
1382 25
1386 23
4453 18
4451 18
2613 18
27423 17
```

# uniq
