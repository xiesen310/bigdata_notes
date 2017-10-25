---
title: Day_12_hive
tags: hive,hadoop
grammar_cjkRuby: true
---

# Hive 优化

> 在我们学习阶段，集群都是搭在虚拟机上，相对于真机而言，是很卡的，下面是一些对于集群优化的操作。
> 的是将程序发布在本节点上进行执行，不通过yarn进行发布，避免了RPC的传输过程，从而减少服务器的压力。

``` sql
-- 设置是否自动开启本地模式
set hive.exec.mode.local.auto=true
-- 本地模式容忍的最大文件个数
hive.exec.mode.local.auto.input.files.max=4
-- 本地模式最大输入文件字节数
hive.exec.mode.local.auto.inputbytes.max=134217728

-- reduce处理的数据量
hive.exec.reducers.bytes.per.reducer=256000000
-- reduce最大个数
hive.exec.reducers.max=1009
```

# Map端聚合操作
> 在Map端进行聚合，在一定程度上可以减少数据的传输量，从侧面上提高服务器的性能。对于map端聚合操作，需要在hive上设置一些参数

``` sql
-- 决定是否自动开启map端的关联
-- hive.auto.convert.join=true
-- 决定是否使用map端join，如果关联表有小于这个参数的配置则自动开启map端join
-- hive.mapjoin.smalltable.filesize=25000000
```




