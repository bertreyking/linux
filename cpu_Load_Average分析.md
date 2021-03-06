# cpu 平均负载冲高性能分析

1. 首先想到的是使用 top/uptime 进行查看系统负载，那么我们看到的 Load Average 具体指什么呢？

```
平均负载： 是指单位时间内，系统处于 可运行状态 和 不可中断状态的平均进程数，也就是说是平均活跃进程数，和cpu的使用率并没有直接的关系。

可运行状态： 正在使用cpu或正在等待cpu的进程，也就是我们经常使用ps 看到的处于 R （Running 或 Runnable) 的进程

不可中断状态的进程： 正处于内核态关键流程中的进程，并且这些流程是不可打断的，比如常见的 等待硬件设备的i/o响应，也就是我们ps 看到的 D 状态 (Uninterruptible Sleep 也成为 disk sleep) 的进程 。 其实不可中断状态 实际上就是系统对进程和硬件设备的一种保护机制从而来保证进程数据与硬件数据保持一致(如，当一个进程在读写数据时，如果此时中断 D状态的进程，那么就可能会导致，进程读写的数据，和disk中的数据不一致)

总结：
平均负载，其实可以理解为，当前系统中，平均活跃进程数
```

2. 如何判断一个系统，当前的负载是正常的呢?
```
平均负载 ，一般大于 当前系统cpu核心数，如果大于cpu 核心数，说明当前系统负载较高，那么我们如何通过 uptime 的三个时间段的负载来评断当前系统的负载是否正常

uptime 反应的是系统 ，1分钟 、5分钟 、 15分钟 的平均活跃进程数(平均负载)

1. 查询当前系统 cpu的核心数
cat /proc/cpuinfo  | grep processor  | wc -l    # 当uptime 结果大于 cpu核心数时，就说名系统当前负载过高(用部分进程没有请求到cpu资源)
2. uptime 反应的是系统 ，1分钟 、5分钟 、 15分钟 的平均活跃进程数(平均负载) ，三个值来看，可能15分钟的负载较高，但是1分钟内的负载较低，说明负载在减少，反之说明 近1分钟负载较高，而且以上两种情况都有可能一直持续下去，所以 高和低只能对当前来说，要判断系统是否达到了瓶颈，需要持续的进行观察
```

3. 那么cpu的使用率 又是怎么回事呢?
```
- 平均负载高是不是就意味着，cpu使用率高，其实平均负载是指 单位时间内，处于可运行状态和不可中断黄台的的进程数，所以平均负载，不仅包含了正在使用cpu的进程，还包括了等待cpu 和等待i/o的进程。 而cpu的使用率统计的是 单位时间内cpu繁忙的情况，跟平均负载并一定完全对应。 密集型应用进程，使用大量cpu时会导致平均负载高，这是吻合的，如果i/o密集型进程，等待i/o导致的平均负载高，那么这时cpu使用率就不一定很高，再比如，大量等待cpu的进程调度也会导致平均负载高，而此时cpu使用率也会高，所以要因进程的类型去判断为什么平均负载高，是什么引起的cpu / 平均负载高

```
4. 下面来分析 系统当前负载是否正常
```
执行 yum install sysstat  # 安装系统状态检查的必备工具
- top # 系统自带
- uptime # 系统自带
- iostat
- mpstat  # 常用的多核心 cpu 性能分析工具，查看 每个cpu的性能指标，以及所有cpu的平均指标
- pidstat # 常用的进程 性能分析工具，用来实时查看进程的cpu，内存，i/o 以及上下文切换等性能指标
```
- 案例1
```
stress --cpu 1 --timeout 600 # 模拟一个cpu 100%的场景
watch -d uptime  # -d 变化的地方会高亮显示，系统告警时可以用它查看系统状态
mpstat -P ALL 5 # 每5s打印下所有cpu状态
02:37:11 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
02:37:16 PM  all   40.26    0.00    5.70    0.00    0.00    0.41    0.00    0.00    0.00   53.63
02:37:16 PM    0   48.55    0.00    5.60    0.00    0.00    0.21    0.00    0.00    0.00   45.64
02:37:16 PM    1   71.37    0.00    2.66    0.00    0.00    0.20    0.00    0.00    0.00   25.77
02:37:16 PM    2   20.83    0.00    7.08    0.00    0.00    0.62    0.00    0.00    0.00   71.46
02:37:16 PM    3   19.87    0.00    7.32    0.00    0.00    0.42    0.00    0.00    0.00   72.38

Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
Average:     all   35.54    0.00    5.28    0.02    0.00    0.48    0.00    0.00    0.00   58.68
Average:       0   52.24    0.00    3.69    0.00    0.00    0.39    0.00    0.00    0.00   43.68
Average:       1   45.38    0.00    4.26    0.00    0.00    0.44    0.00    0.00    0.00   49.93
Average:       2   28.09    0.00    6.13    0.02    0.00    0.60    0.00    0.00    0.00   65.16
Average:       3   16.21    0.00    7.08    0.02    0.00    0.46    0.00    0.00    0.00   76.22

通过 mpstat 结果来看， 
平均负载冲高，%usr用户级别是有cpu使用率冲高导致，且iowait始终为0，说明不是io导致的平均负载冲高

那么是谁引起的冲高呢，我们继续排查

pidstat -u 5 10  # -u 打印进程cpu使用率报告，5s ，共打印10次
Linux 3.10.0-862.el7.x86_64 (k8s-master01)      11/19/2020      _x86_64_        (4 CPU)
02:45:04 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:45:09 PM     0         1    0.60    0.60    0.00    1.20     3  systemd
02:45:09 PM     0         9    0.00    0.20    0.00    0.20     0  rcu_sched
02:45:09 PM     0       556    0.20    0.60    0.00    0.80     3  systemd-journal
02:45:09 PM     0       888    0.20    0.00    0.00    0.20     3  systemd-logind
02:45:09 PM    81       892    1.39    0.40    0.00    1.79     3  dbus-daemon
02:45:09 PM   999       906    0.00    0.20    0.00    0.20     0  polkitd
02:45:09 PM     0      1075    0.00    0.20    0.00    0.20     2  vmtoolsd
02:45:09 PM     0      1358    9.16    1.99    0.00   11.16     1  kubelet
02:45:09 PM     0      1359    3.39    0.40    0.00    3.78     2  dockerd
02:45:09 PM     0      1366    0.20    0.00    0.00    0.20     0  rsyslogd
02:45:09 PM     0      1367    0.40    0.20    0.00    0.60     0  node_exporter
02:45:09 PM     0      1667    0.40    0.20    0.00    0.60     2  docker-containe
02:45:09 PM     0      2877    7.37    4.58    0.00   11.95     2  kube-apiserver
02:45:09 PM     0      2939    1.99    1.39    0.00    3.39     3  etcd
02:45:09 PM     0      4346    0.20    0.20    0.00    0.40     0  docker-containe
02:45:09 PM     0      4589    0.80    1.20    0.00    1.99     2  calico-node
02:45:09 PM  1001      4761    0.20    0.00    0.00    0.20     2  dashboard
02:45:09 PM     0      4968   99.20    0.40    0.00   99.60     1  stress
02:45:09 PM     0      5031    0.20    0.20    0.00    0.40     2  coredns
02:45:09 PM     0      5707    0.20    0.20    0.00    0.40     1  coredns
02:45:09 PM     0      6148    0.60    1.20    0.00    1.79     1  promtail
02:45:09 PM     0      6408    0.20    0.20    0.00    0.40     1  docker-containe
02:45:09 PM     0      6506    0.00    0.40    0.00    0.40     0  pidstat
02:45:09 PM     0      7522    0.60    0.40    0.00    1.00     2  kube-scheduler
02:45:09 PM     0      7529    4.38    1.39    0.00    5.78     3  kube-controller

02:45:09 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:45:14 PM     0         1    0.40    0.40    0.00    0.80     3  systemd
02:45:14 PM     0        24    0.00    0.20    0.00    0.20     3  ksoftirqd/3
02:45:14 PM     0       556    0.00    0.20    0.00    0.20     0  systemd-journal
02:45:14 PM     0       888    0.00    0.20    0.00    0.20     2  systemd-logind
02:45:14 PM    81       892    0.60    0.20    0.00    0.80     2  dbus-daemon
02:45:14 PM   999       906    0.20    0.00    0.00    0.20     0  polkitd
02:45:14 PM     0      1075    0.20    0.00    0.00    0.20     0  vmtoolsd
02:45:14 PM     0      1358    5.20    1.20    0.00    6.40     1  kubelet
02:45:14 PM     0      1359    3.20    0.60    0.00    3.80     2  dockerd
02:45:14 PM     0      1366    0.00    0.20    0.00    0.20     0  rsyslogd
02:45:14 PM     0      1367    0.60    0.40    0.00    1.00     3  node_exporter
02:45:14 PM     0      1485    0.00    0.20    0.00    0.20     3  xfsaild/dm-2
02:45:14 PM     0      1667    0.20    0.20    0.00    0.40     2  docker-containe
02:45:14 PM     0      2334    0.20    0.00    0.00    0.20     2  registry
02:45:14 PM     0      2877   20.40    2.00    0.00   22.40     2  kube-apiserver
02:45:14 PM     0      2939    2.20    1.80    0.00    4.00     3  etcd
02:45:14 PM     0      3772    0.20    0.00    0.00    0.20     3  kube-proxy
02:45:14 PM     0      4346    0.00    0.20    0.00    0.20     0  docker-containe
02:45:14 PM     0      4588    0.20    0.00    0.00    0.20     0  calico-node
02:45:14 PM     0      4589    1.00    1.60    0.00    2.60     2  calico-node
02:45:14 PM  1001      4761    0.20    0.00    0.00    0.20     2  dashboard
02:45:14 PM     0      4838    0.00    0.20    0.00    0.20     1  bird6
02:45:14 PM     0      4968   99.60    0.20    0.00   99.80     1  stress
02:45:14 PM     0      5031    0.20    0.40    0.00    0.60     2  coredns
02:45:14 PM     0      5707    0.40    0.20    0.00    0.60     1  coredns
02:45:14 PM     0      6148    0.60    1.60    0.00    2.20     1  promtail
02:45:14 PM     0      6506    0.20    0.40    0.00    0.60     0  pidstat
02:45:14 PM     0      7464    0.00    0.20    0.00    0.20     2  docker-containe
02:45:14 PM     0      7522    0.40    0.20    0.00    0.60     3  kube-scheduler
02:45:14 PM     0      7529    4.80    1.40    0.00    6.20     3  kube-controller
02:45:14 PM     0     24069    0.20    0.20    0.00    0.40     1  watch
02:45:14 PM     0     30488    0.00    0.20    0.00    0.20     2  kworker/2:1

02:45:14 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
02:45:19 PM     0         1    0.80    0.80    0.00    1.60     3  systemd
02:45:19 PM     0         9    0.00    0.20    0.00    0.20     2  rcu_sched
02:45:19 PM     0       556    0.20    0.20    0.00    0.40     0  systemd-journal
02:45:19 PM     0       888    0.20    0.00    0.00    0.20     3  systemd-logind
02:45:19 PM    81       892    1.60    0.40    0.00    2.00     3  dbus-daemon
02:45:19 PM     0      1358   11.80    2.00    0.00   13.80     1  kubelet
02:45:19 PM     0      1359    3.60    0.60    0.00    4.20     2  dockerd
02:45:19 PM     0      1366    0.20    0.00    0.00    0.20     0  rsyslogd
02:45:19 PM     0      1367    0.40    0.20    0.00    0.60     3  node_exporter
02:45:19 PM     0      1667    0.20    0.00    0.00    0.20     2  docker-containe
02:45:19 PM     0      2548    0.00    0.20    0.00    0.20     3  docker-containe
02:45:19 PM     0      2877    7.60    2.00    0.00    9.60     2  kube-apiserver
02:45:19 PM     0      2939    2.40    1.00    0.00    3.40     0  etcd
02:45:19 PM     0      4346    0.20    0.00    0.00    0.20     0  docker-containe
02:45:19 PM     0      4589    1.00    1.40    0.00    2.40     2  calico-node
02:45:19 PM  1001      4761    0.20    0.00    0.00    0.20     2  dashboard
02:45:19 PM     0      4968   99.20    0.20    0.00   99.40     1  stress
02:45:19 PM     0      5031    0.20    0.20    0.00    0.40     2  coredns
02:45:19 PM     0      5707    0.40    0.20    0.00    0.60     1  coredns
02:45:19 PM  1001      5759    0.00    0.20    0.00    0.20     1  metrics-sidecar
02:45:19 PM     0      6148    0.80    1.20    0.00    2.00     1  promtail
02:45:19 PM     0      6506    0.00    0.20    0.00    0.20     0  pidstat
02:45:19 PM     0      7522    0.40    0.20    0.00    0.60     2  kube-scheduler
02:45:19 PM     0      7529    3.60    0.80    0.00    4.40     2  kube-controller
02:45:19 PM     0     24877    0.20    0.00    0.00    0.20     1  sshd

Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
Average:        0         1    0.60    0.60    0.00    1.20     -  systemd
Average:        0         9    0.00    0.13    0.00    0.13     -  rcu_sched
Average:        0        24    0.00    0.07    0.00    0.07     -  ksoftirqd/3
Average:        0       556    0.13    0.33    0.00    0.47     -  systemd-journal
Average:        0       888    0.13    0.07    0.00    0.20     -  systemd-logind
Average:       81       892    1.20    0.33    0.00    1.53     -  dbus-daemon
Average:      999       906    0.07    0.07    0.00    0.13     -  polkitd
Average:        0      1075    0.07    0.07    0.00    0.13     -  vmtoolsd
Average:        0      1358    8.72    1.73    0.00   10.45     -  kubelet
Average:        0      1359    3.40    0.53    0.00    3.93     -  dockerd
Average:        0      1366    0.13    0.07    0.00    0.20     -  rsyslogd
Average:        0      1367    0.47    0.27    0.00    0.73     -  node_exporter
Average:        0      1485    0.00    0.07    0.00    0.07     -  xfsaild/dm-2
Average:        0      1667    0.27    0.13    0.00    0.40     -  docker-containe
Average:        0      2334    0.07    0.00    0.00    0.07     -  registry
Average:        0      2548    0.00    0.07    0.00    0.07     -  docker-containe
Average:        0      2877   11.78    2.86    0.00   14.65     -  kube-apiserver
Average:        0      2939    2.20    1.40    0.00    3.60     -  etcd
Average:        0      3772    0.07    0.00    0.00    0.07     -  kube-proxy
Average:        0      4346    0.13    0.13    0.00    0.27     -  docker-containe
Average:        0      4588    0.07    0.00    0.00    0.07     -  calico-node
Average:        0      4589    0.93    1.40    0.00    2.33     -  calico-node
Average:     1001      4761    0.20    0.00    0.00    0.20     -  dashboard
Average:        0      4838    0.00    0.07    0.00    0.07     -  bird6
Average:        0      4968   99.33    0.27    0.00   99.60     -  stress
Average:        0      5031    0.20    0.27    0.00    0.47     -  coredns
Average:        0      5707    0.33    0.20    0.00    0.53     -  coredns
Average:     1001      5759    0.00    0.07    0.00    0.07     -  metrics-sidecar
Average:        0      6148    0.67    1.33    0.00    2.00     -  promtail
Average:        0      6408    0.07    0.07    0.00    0.13     -  docker-containe
Average:        0      6506    0.07    0.33    0.00    0.40     -  pidstat
Average:        0      7464    0.00    0.07    0.00    0.07     -  docker-containe
Average:        0      7522    0.47    0.27    0.00    0.73     -  kube-scheduler
Average:        0      7529    4.26    1.20    0.00    5.46     -  kube-controller
Average:        0     24069    0.07    0.07    0.00    0.13     -  watch
Average:        0     24877    0.07    0.00    0.00    0.07     -  sshd
Average:        0     30488    0.00    0.07    0.00    0.07     -  kworker/2:1

通过 pidstat 的几次报告来看，有一个进程叫stress的进程cpu使用率持续 99，那么就说明是该进程导致的平均负载以及cpu使用率冲高
```

- 案例2
```
stress -i 1 -t 600 # 启动一个io类型的进程，时长 600s
mpstat -P ALL 5 3 # 打印3次 cpu使用情况
03:05:06 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:05:11 PM  all    7.35    0.05   64.72    0.10    0.00    0.47    0.00    0.00    0.00   27.32
03:05:11 PM    0    9.32    0.00   58.80    0.00    0.00    0.83    0.00    0.00    0.00   31.06
03:05:11 PM    1    6.19    0.00   69.69    0.21    0.00    0.21    0.00    0.00    0.00   23.71
03:05:11 PM    2    5.36    0.00   65.36    0.21    0.00    0.62    0.00    0.00    0.00   28.45
03:05:11 PM    3    8.52    0.00   65.07    0.21    0.00    0.21    0.00    0.00    0.00   25.99

03:05:11 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:05:16 PM  all   10.24    0.00   63.43    0.00    0.00    0.51    0.00    0.00    0.00   25.82
03:05:16 PM    0   12.37    0.00   57.73    0.00    0.00    0.41    0.00    0.00    0.00   29.48
03:05:16 PM    1   11.27    0.00   66.39    0.00    0.00    0.41    0.00    0.00    0.00   21.93
03:05:16 PM    2   10.10    0.00   62.68    0.00    0.00    0.62    0.00    0.00    0.00   26.60
03:05:16 PM    3    7.02    0.00   66.74    0.00    0.00    0.62    0.00    0.00    0.00   25.62

03:05:16 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:05:21 PM  all    8.51    0.00   65.08    0.05    0.00    0.41    0.00    0.00    0.00   25.95
03:05:21 PM    0   10.47    0.00   62.42    0.00    0.00    0.41    0.00    0.00    0.00   26.69
03:05:21 PM    1    7.20    0.00   69.34    0.00    0.00    0.41    0.00    0.00    0.00   23.05
03:05:21 PM    2    9.00    0.00   60.33    0.00    0.00    0.41    0.00    0.00    0.00   30.27
03:05:21 PM    3    7.60    0.00   68.38    0.00    0.00    0.21    0.00    0.00    0.00   23.82

通过mpstat 可以看到，%sys 系统级别cpu利用达到 65，且 %iowait 也有小的变化，说明是我们起的 io 的stress引起平均负载冲高，但是 %usr 并不是很高，说明 本次平均负载的冲高不是由cpu使用率冲高引起的。

pidstat -u 5 3  # 打印3次cpu使用情况进程相关
Average:        0     32008    0.20   50.70    0.00   50.90     -  stress
Average:        0     32009    0.20   53.69    0.00   53.89     -  stress
Average:        0     32010    0.20   52.89    0.00   53.09     -  stress
Average:        0     32011    0.20   53.39    0.00   53.59     -  stress

而通过pidstat 也可以查看到，是我们起了多个 stress 进程 引起的平均负载冲高，
```
- 结论
```
1. 当%usr 使用率的冲高，反应的是用户级别的cpu利用率冲高，往往平均负载也会冲高，冲高的原因就是 cpu使用率的冲高导致(大量进程在请求cpu时间片)
2. 当%sys 使用率冲高，反应的是系统级别的cpu利用率冲高，以及如果%io在不同变化，则说明引起平均负载冲高，不是cpu利用引起的
```

- cpu性能分析工具汇总：
```
1. mpstat #查看cpu状态
2. pidstat #查看进程状态
3. top -H
4. ps -aux | awk '{if( $3 > 30) print $0}'
root     17774 35.0  0.0   7312    96 pts/2    R+   15:18   0:40 stress -i 8 -t 600
root     17775 34.5  0.0   7312    96 pts/2    R+   15:18   0:39 stress -i 8 -t 600
root     17776 34.5  0.0   7312    96 pts/2    R+   15:18   0:39 stress -i 8 -t 600
root     17777 34.8  0.0   7312    96 pts/2    D+   15:18   0:40 stress -i 8 -t 600
root     17778 34.7  0.0   7312    96 pts/2    R+   15:18   0:39 stress -i 8 -t 600
root     17779 34.4  0.0   7312    96 pts/2    R+   15:18   0:39 stress -i 8 -t 600
root     17780 35.0  0.0   7312    96 pts/2    D+   15:18   0:40 stress -i 8 -t 600
root     17781 34.7  0.0   7312    96 pts/2    D+   15:18   0:39 stress -i 8 -t 600
```
