**禁用swap**

- swapoff -a 
- vi /etc/fstab 

```
cat /etc/fstab
/dev/mapper/centos-root /                       xfs     defaults        0 0
UUID=58a170be-2a6f-436d-afd3-1b1a1f56fc26 /boot                   xfs     defaults        0 0
#/dev/mapper/centos-swap swap                    swap    defaults        0 0

free -h
              total        used        free      shared  buff/cache   available
Mem:            15G        218M         15G        8.6M        163M         15G
Swap:            0B          0B
```
**删除swap分区**

- lvremove centos /dev/centos/swap

```
说明：
  - 删除swap所对应的lv，是为了释放出闲置的disk
  - 删除后，需要更新下/boot/grub2/grub.conf配置文件，防止重启后kernel继续加载swap，从而导致系统无法自动启动并进入dracut模式
  - 假如不小心进入dracut，不要怕有方法 ↓↓↓
```
**进入dracut后如何正常引导系统**

报错:
![imagepng](http://blog.xinbaimiao.ml/upload/03b108b50b934efba821e75656cdfc20_image.png) 

命令：

- lvm vgscan
- lvm vgchange -ay    //激活所有文件系统
- exit

示例：
![imagepng](http://blog.xinbaimiao.ml/upload/9b5ef9fa98dd497fbed3abcbfea9ad1f_image.png) 

等待进入系统后，删除grub所对应swap分区的位置即可

**更改grub配置**

图1：
![imagepng](http://blog.xinbaimiao.ml/upload/4cd54997a52b4f5c9c686d5a036646b5_image.png) 
图2：
![imagepng](http://blog.xinbaimiao.ml/upload/3e723137512c445686209d5925090b3c_image.png) 
图3：
![imagepng](http://blog.xinbaimiao.ml/upload/fc9e06623faf4eafb34e2a38a33fa60d_image.png) 
图4：
![imagepng](http://blog.xinbaimiao.ml/upload/5ea8a723dbc945faa9b8f3a266fa868e_image.png) 

更改完成后，重启操作系统便可直接进入操作系统

[参考链接1](https://unix.stackexchange.com/questions/425045/warning-dev-centos-root-swap-centos-root-does-not-exist-after-configuring-dr)
[参考链接2](https://fedoraproject.org/wiki/How_to_debug_Dracut_problems)


