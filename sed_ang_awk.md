# sed
1. 以插入模式全局替换文件内容，
   - s: 替换
   - g：全局替换所有匹配成功的 str、不写就替换一次
   - -i: 修改模式
   - " ": 支持变量的形式
```
sed -i 's/123/456/g' /etc/testfile
sed -i 's/123/456/' /etc/testfile
sed  's/123/456/g' /etc/testfile
app=anme
sed  "s/123/${app}/g" /etc/testfile
```
2. 若文件中存在路径类似的替换内容(如：/etc/passwd 替换为 /etc/password)
```
/ 需要进行转义(转义符: \)
sed -i 's/\/etc\/passwd/\/etc\/password/g' /etc/testfile
或者更改分隔符
sed -i 's#/etc/passwd#/etc/password#g' /etc/testfile
```
# awk
1. 按列进行处理,$0 表示打印全部内容，$9 以上需要加{}
```
awk '{print $1,$9,${10}}'
```
2. 按列并对列值进行判断并打印
```
awk '{if($2>10)print $0}'
```
3. 字符匹配(正则)
```
awk '//'
awk '/^[A-Za-z]/{print $1}'
```
4. 按分隔符进行列打印
```
awk -F ":" '{print $2}'
awk -F "_" '{print $2}'
```
5. 计算集群资源信息
```
kubectl describe node | awk -F '[m]+' '/cpu[[:space:]]+[0-9]+m/ {print $1}' | awk '{sum+=$2} END {print "cpu_requests:",sum}'
注释：
    /cpu[[:space:]]+[0-9]+m/ : 匹配 cpu 和 数字中间有空格的行，+ 至少匹配一次
    -F '[m]+' 、 awk '{sum+=$2} END {print "cpu_requests:",sum} 和后面没什么花头自己Google即可
```
6. 格式化打印字符串
```
# 按指定列、指定列间隔进行打印
awk '{printf("%-50s%-50s%-50s\n"),$1,$2,$6}'
```
