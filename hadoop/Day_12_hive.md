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

> 我们一般情况下是通过sql语句，想要进行Map端的聚合操作，下面是Map端聚合的示例代码

``` sql
select /*+MAPJOIN(dep)*/
	a.*,b.*
from dw_employee a
join dep b
on a.dep_id = b.dep_id
--或者进行如下设置，新版本比较推荐使用下面的版本
set hive.auto.convert.join=true;
select count(*) from
store_sales join time_dim on (ss_sold_time_sk = t_time_sk)
```


# Order, Sort, Cluster, and Distribute By
> 对于order,sort,cluster,distribute这几概念，在面试的过程中是很容易被提问到的，下面对于这些概念做简单的介绍

## order by

> order by 会对输入做全局排序，因此只有一个reducer（多个reducer无法保证全局有序）只有一个reducer，会导致当输入规模较大时，需要较长的计算时间。

使用order by需要进行下面的设置
``` sql
set hive.mapred.mode=nonstrict; (default value / 默认值)
set hive.mapred.mode=strict;
```

order by和数据库中的操作基本上是一样的，下面对于一些区别简单描述一下



