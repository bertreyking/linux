# [sort](https://www.geeksforgeeks.org/sort-command-linuxunix-examples/)
- 参数:
```
-n 按数字大小进行排序
-r 降序
-k 指定排序依据的列
-u 去重
```
- 示例:
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

# [uniq](https://www.geeksforgeeks.org/uniq-command-in-linux-with-examples/)
- 参数:
```
-c 统计重复的次数
-d 打印重复的行
-f 去重时跳过前n列
-u 打印不重复的行
-D 打印所有行,配合--all-repeated=separeate,可以在重复行之前和之间插入空白行, 三种：none(default)、prepend(之前)、separeate(之间)
-s 去重时跳过前n个字符
-i 忽略大小写

```
- 示例:
```
[root@k8s-master01 ~]# cat music 
I love music.
I love music.
I love music.

I love music of Kartik.
I love music of Kartik.

Thanks.

[root@k8s-master01 ~]# cat music | uniq 
I love music.

I love music of Kartik.

Thanks.

[root@k8s-master01 ~]# cat music | uniq -c 
      3 I love music.
      1 
      2 I love music of Kartik.
      1 
      1 Thanks.
      
[root@k8s-master01 ~]# cat music | uniq -d 
I love music.
I love music of Kartik.
[root@k8s-master01 ~]# cat music | uniq -f 2 
I love music.

I love music of Kartik.


[root@k8s-master01 ~]# cat music | uniq -u


Thanks.

[root@k8s-master01 ~]# cat music | uniq -D --all-repeated=prepend  

I love music.
I love music.
I love music.

I love music of Kartik.
I love music of Kartik.
[root@k8s-master01 ~]# cat music | uniq -D --all-repeated=separate 
I love music.
I love music.
I love music.

I love music of Kartik.
I love music of Kartik.
```
