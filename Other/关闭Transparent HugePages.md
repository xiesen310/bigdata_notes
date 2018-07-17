---
title: 关闭Transparent HugePages 
tags: centos,thp
author: XieSen
time: 2018-7-17 
grammar_cjkRuby: true
---

# 查看thp是否在使用

``` shell
# grep Huge /proc/meminfo
AnonHugePages:      2048 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
```
如果输出包含类似于"AnonHugepages: xxxx kB"，并且AnonHugePages > 0kB，则表明内核使用的是Transparent HugePages（透明巨大页面）
它的值我们可以从/proc/meminfo从找到它正在被内核使用的AnonHugePages当前值


``` shell
# cat /sys/kernel/mm/transparent_hugepage/enabled
[always] never 
```
若显示的不是never则证明Transparent HugePages正在被使用。

## 关闭Transparent HugePages操作

``` shell
# vim /etc/grub.conf     ///在kernel /最后添加transparent_hugepage=never，保存退出

title Oracle Linux Server (2.6.32-300.25.1.el6uek.x86_64)
        root (hd0,0)
        kernel /vmlinuz-2.6.32-300.25.1.el6uek.x86_64 ro root=LABEL=/ transparent_hugepage=never
        initrd /initramfs-2.6.32-300.25.1.el6uek.x86_64.img
```



重启下，

``` shell
# grep Huge /proc/meminfo
AnonHugePages:         0 kB
HugePages_Total:       2
HugePages_Free:        2
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
```



``` shell
# cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]
```

可以发现Transparent HugePages已经被关闭，并运用了HugePage

