1. 查找大文件
```
find / -type f -size +500M -print0 | xargs -0 ls -lrth
find / -type f -size +500M -print | xargs ls -lrth
find / -type f -size +500M -print | xargs /bin/rm -rf 
```
2. 查找大目录
```
df -h --max-depth=2
```
