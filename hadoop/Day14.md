---
title: Day14
tags: hadoop,hive
grammar_cjkRuby: true
---

* [窗口函数的使用](#窗口函数的使用)
* [日志分析](#日志分析)
* [Hive优化](#hive优化)
	* [Group by 优化](#group-by-优化)
	* [order by 优化](#order-by-优化)
	* [sql语句优化](#sql语句优化)
	* [join 优化](#join-优化)

# 窗口函数的使用
> 我们都知道在sql中有一类函数叫做聚合函数,例如sum()、avg()、max()等等,这类函数可以将多行数据按照规则聚集为一行,一般来讲聚集后的行数是要少于聚集前的行数的.但是有时我们想要既显示聚集前的数据,又要显示聚集后的数据,这时我们便引入了窗口函数.
> 在SQL处理中，窗口函数都是最后一步执行，而且仅位于Order by字句之前.
详细内容参考官方文档
[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+WindowingAndAnalytics][1]

``` sql
create table ntile_order_item
stored as orc
as
select order_iten_id
	,order_item_order_id
	,order_item_product_id
	,order_item_quantity
	,order_item_subtotal
	,order_item_product_price
	,ntile(2) over(order by order_item_product_price) splitno
from order_items
```

 - 每个部门按照时间计算每个月的年累计完成销量

``` sql
-- 每个部门按照时间计算每个月的年累计完成销量
select date_month
	,dep_name
	,finish_amount
	,task_amount
	-- 每个部门按照时间计算每个月的年累计完成销量
	,sum(finish_amount) over(partition by dep_name order by to_date(date_month))
	-- 计算部门一年总的完成量
	,sum(finish_amount) over(partition by dep_name)
	-- 计算部门最近三个有的完成量
	,sum(finish_amount) over(partition by dep_name order by to_date(date_month) rows between 2 preceding  and current row)
	-- 计算部门当前月前面两个月，在向后一个月的完成量
	,sum(finish_amount) over(partition by dep_name order by to_date(date_month) rows between 2 preceding  and 1 following)
	--计算部门累计完成量，向下累计
	,sum(finish_amount) over(partition by dep_name order by to_date(date_month) rows between current row and unbounded following)
from month_finish
```

- 计算每个部门的年任务累计完成率

``` sql
-- 计算每个部门的年任务累计完成率
select *,a.m/a.y from (
select date_month
	,dep_name
	,finish_amount
	,task_amount
	,sum(finish_amount) over(partition by dep_name order by to_date(date_month)) m
	,sum(task_amount) over(partition by dep_name) y
from month_finish
) a
```

# 日志分析

> 原来我们将分析日志，是直接在SQuirrel工具上执行的，没有考虑到sql的固化操作，等等。下面以日志分析为例子，阐述一下sql固化的问题
1. 编写hql
dateday是一个变量名，将日期给抽取出来了，提高代码的复用率

``` sql
use db14;

-- create table
CREATE external TABLE if not exists apache_log (
  host STRING,
  identity STRING,
  username STRING,
  time STRING,
  request STRING,
  status STRING,
  size STRING,
  referer STRING,
  agent STRING)
  partitioned by (date_day string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "([^ ]*) ([^ ]*) ([^ ]*) (-|\\[[^\\]]*\\]) ([^ \"]*|\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^ \"]*|\"[^\"]*\"))?"
  ,"output.format.string"="%1$s %2$s %3$s %4$s %5$s %6$s %7$s %8$s %9$s"
)
STORED AS TEXTFILE;

alter table apache_log drop partition(date_day='${dateday}');
alter table apache_log add partition(date_day='${dateday}') location '/apachlog/${dateday}';
set hive.support.concurrency=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;
set hive.compactor.initiator.on=true;
set hive.compactor.worker.threads=1;


create table if not exists day_pv_uv(
	date_day int
	,pv int
	,uv int
)
clustered by(date_day) into 2 buckets
stored as orc
tblproperties("transactional"="true");

delete from day_pv_uv where date_day = '${dateday}';
insert into day_pv_uv
select  ${dateday}
	,count(1) pv
	,count(distinct host) uv
from apache_log 
where date_day = '${dateday}';

```
2. 将hql上传到装hive的机器上

![][2]

3. 执行 hive -f aa.hql --hivevar dateday=20171027

![][3]

# Hive优化

## Group by 优化

> Group By 很容易导致数据倾斜问题，因为实际业务中，通常是数据集中在某些点上，这也符合常见的2/8 原则，这样会造成对数据分组后，某一些分组上数据量非常大，而其他的分组上数据量很小，而在mapreduce 程序中，同一个分组的数据会分配到同一个reduce 操作上去，导致某一些reduce 压力很大，其他的reduce 压力很小，这就是数据倾斜，整个job 执行时间取决于那个执行最慢的那个reduce。
> 解决这个问题的方法是配置一个参数：set hive.groupby.skewindata=true。
当选项设定为 true，生成的查询计划会有两个 MR Job。第一个 MR Job 中， Map 的输出结果会随机分布到 Reduce 中，每个 Reduce 做部分聚合操作，并输出结果，这样处理的结果是相同的Group By Key 有可能被分发到不同的 Reduce 中，从而达到负载均衡的目的；第二个 MR Job再根据预处理的数据结果按照 Group By Key 分布到 Reduce 中（这个过程可以保证相同的GroupBy Key 被分布到同一个 Reduce 中），最后完成最终的聚合操作。

## order by 优化

> 因为order by 只能是在一个reduce 进程中进行的，所以如果对一个大数据集进行order by,会导致一个reduce 进程中处理的数据相当大，造成查询执行超级缓慢。在要有进行order by 全局排序的需求时，用以下几个措施优化：
1. 在最终结果上进行order by，不要在中间的大数据集上进行排序。如果最终结果较少，可以
在一个reduce 上进行排序时，那么就在最后的结果集上进行order by。
2.  如果需求是取排序后前N 条数据，那么可以使用distribute by 和sort by 在各个reduce 上进行排
序后取前N 条，然后再对各个reduce 的结果集合并后在一个reduce 中全局排序，再取前N 条，因为参与
全局排序的Order By 的数据量最多有reduce 个数*N，所以速度很快。

``` sql
select a.leads_id,a.user_name from
(
select leads_id,user_name from dealer_leads
distribute by length(user_name) sort by length(user_name) desc limit 10
) a order by length(a.user_name) desc limit 10;
```
## sql语句优化
1. 尽量在select后面不要用*，需要哪些字段，使用字段名称来获取
2. 尽量不要使用distinct，用group by的特性来对数据进行排重
3. 使用exists和not exists代替in和not in
4. 有些时候or和可以使用union方式代替 

## join 优化

- 优先过滤后再join,最大限度地减少参与Join 的数据量。

``` sql
select *
from employee a
inner join department b
on a.belong_dep_code=b.dep_code
where a.gender='女' and b.dep_address like '%北京%'
 
select *
from (
select * from employee where gender='女'
)a
inner join （
select * from department where dep_address like '%北京%'
）b
on a.belong_dep_code=b.dep_code
```
- 表 join 大表原则

> 应该遵守小表join 大表原则，原因是Join 操作的reduce 阶段，位于join 左边的表内容会被加载进内存，将条目少的表放在左边，可以有效减少发生内存溢出的几率。join 中执行顺序是从做到右生成Job，应该保证连续查询中的表的大小从左到右是依次增加的。

-  join on 条件相同的放入一个job

> hive 中，当多个表进行join 时，如果join on 的条件相同，那么他们会合并为一个MapReduce Job，所以利用这个特性，可以将相同的join on 的放入一个job 来节省执行时间。

``` sql
select pt.page_id,count(t.url) PV
from rpt_page_type pt
join
(
select url_page_id,url from trackinfo where ds='2016-10-11'
) t on pt.page_id=t.url_page_id
join
(
select page_id from rpt_page_kpi_new where ds='2016-10-11'
) r on t.url_page_id=r.page_id
group by pt.page_id;
```


  [1]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+WindowingAndAnalytics
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509101669949.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509101714769.jpg