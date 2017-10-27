---
title: Day14
tags: hadoop,hive
grammar_cjkRuby: true
---

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
3. 执行 hive -f aa.hql --hivevar dateday=20171027






  [1]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+WindowingAndAnalytics
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509087391253.jpg