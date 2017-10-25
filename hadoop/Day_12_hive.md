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

> order by和数据库中的操作基本上是一样的，下面对于一些区别简单描述一下
order by的使用上与mysql最大的不同，请看以下sql语句：

``` sql
select cardno,count(*)
from tableA
group by idA
order by count(*) desc limit 10
```

这个语句在mysql中查询的时候，肯定是没有问题的，而且我们实际上也经常这么干。但是如果将上述语句提交给hive，会报以下错误：

``` sql
FAILED: SemanticException [Error 10128]: Line 4:9 Not yet supported place for UDAF 'count'
```
怎么样可以呢？将count(*)给一个别名就好：

``` sql
select cardno,count(*) as num
from tableA
group by idA
order by num desc limit 10
```

这样就可以了。本博主没查源码，估计是因为hive查询的时候起的是mr任务，mr任务里排序的时候，不认得count(*)是什么东东，所以给个别名就好。

hive的底层原理是将order by进行了全排序，在单个节点上可以进行排序的，在多个节点就显的力不从心了。因此，对于大数据order by就无能为力了


## Sort by 
> sort by不是全局排序，其在数据进入reducer前完成排序.
因此，如果用sort by进行排序，并且设置mapred.reduce.tasks>1， 则sort by只保证每个reducer的输出有序，不保证全局有序。
sort by 不受 hive.mapred.mode 是否为strict ,nostrict 的影响
sort by 的数据只能保证在同一reduce中的数据可以按指定字段排序。
使用sort by 你可以指定执行的reduce 个数 （set mapred.reduce.tasks=<number>）,对输出的数据再执行归并
排序，即可以得到全部结果。
注意：可以用limit子句大大减少数据量。使用limit n后，传输到reduce端（单机）的数据记录数就减少到n* （map个数）。否则由于数据过大可能出不了结果。

``` sql
set mapreduce.job.reduces = 2
create table dep_sort as
-- 计算每一个部门的人数和薪水支出
select * from(
select a.dep_id 
	,a.dep_name
	,a.dep_address
	,count(b.emp_id) p_num
	,sum(nvl(salary,0)) a_salary
from dep a
left join dw_employee b
on cast(a.dep_id as int) = b.dep_id
Group by a.dep_id 
	,a.dep_name
	,a.dep_address
)a
sort by p_num
```


## distribute by

>  按照指定的字段对数据进行划分到不同的输出reduce  / 文件中。
 insert overwrite local directory '/home/hadoop/out' select * from test order by name distribute by length(name);  
 此方法会根据name的长度划分到不同的reduce中，最终输出到不同的文件中。 
 length 是内建函数，也可以指定其他的函数或这使用自定义函数。
 
 

``` sql
-- distribute by
create table emp_distribute as
select * from dw_employee
distribute by status

dfs -cat /user/hive/warehouse/db14.db/emp_distribute/000000_0
dfs -cat /user/hive/warehouse/db14.db/emp_distribute/000001_0

select * 
from dw_employee
distribute by status sort by status,salary desc
```

## Cluster by

> Cluster by 不够灵活，因为使用哪个字段进行分区，就要使用哪个字段进行排序
Cluster by 是distribute by 和sort by 的结合
只允许升序，不允许升序
Eg:
Cluster by column_1等价于
Distribute by column_1 sort by column_1


``` sql
select *
from dw_employee
cluster by dep_id
```

# 复杂数据类型

复杂数据类型array、map、union、struct等等，下面我们以一个例子来说明

首先，我们创建一个对应数据类型的表，对表进行操作，下面是创建表的sql

``` sql
drop table test_serializer
create table test_serializer(
	string1 string
	,int1 int
	,tinnyint1 tinyint
	,smallint1 smallint
	,bigint1 bigint
	,boolean1 boolean
	,float1 float
	,double1 double
	,list1 array<string>
	,map1 map<string,int>
	,struct1 struct<sint:int,sboolean:boolean,sstring:string>
	,union1 uniontype<float,boolean,string>
	,enum1 string
	,nullableint int
	,bytes1 binary
	,fixed1 binary
)
row format delimited
fields terminated by ','
collection items terminated by ':'
MAP KEYS TERMINATED BY '#'
lines terminated by '\n'
NULL DEFINED AS 'NULL'
stored as textfile
```
> 对于基本类型的操作，相信大家已经熟记于心，下面对于复杂数据类型做简单的描述

## array

![][1]

## Map

![][2]

![][3]

- 展平map记录

![][4]

- 展平array记录

![][5]

## Struct


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508930825204.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508930844609.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508930866200.jpg
  [4]: http://markdown.xiaoshujiang.com/img/spinner.gif "[[[1508930878943]]]"
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508930910082.jpg