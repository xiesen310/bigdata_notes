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





# 日志分析

> 支持删除，需要时orc格式，并且需要分桶
抽取变量 '${dateday}'
1. 编写hql
2. 将hql上传到装hive的机器上
3. 执行 hive -f aa.hql --hivevar dateday=20171027


![enter description here][2]


  [1]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+WindowingAndAnalytics
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509087391253.jpg