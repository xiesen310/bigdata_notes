---
title: Day_11_hive之sql操作
tags: bigdata,hive,hadoop
grammar_cjkRuby: true
---

# 内部表与外部表的区别与联系

> 内部表或外部表如果使用load data操作，hive都会把数据剪贴到hive的目录结构里面
外部表可以通过添加location把hive表和外部目录进行映射

1. 在导入数据到外部表，数据并没有移动到自己的数据仓库目录下(如果指定了location的话)，也就是说外部表中的数据并不是由它自己来管理的！而内部表则不一样
2. 在删除内部表的时候，Hive将会把属于表的元数据和数据全部删掉；而删除外部表的时候，Hive仅仅删除外部表的元数据，数据是不会删除的！
3. 在创建内部表或外部表时加上location 的效果是一样的，只不过表目录的位置不同而已，加上partition用法也一样，只不过表目录下会有分区目录而已，load data local inpath直接把本地文件系统的数据上传到hdfs上，有location上传到location指定的位置上，没有的话上传到hive默认配置的数据仓库中。
4. 外部表相对来说更加安全些，数据组织也更加灵活，方便共享源数据。


# 对于表之间的操作

## 根据已有表创建表

``` sql
create table dw_employee as 
select cast(emp_id as int)
	,emp_name
	,status
	,cast(salary as double)
	,cast(status_salary as double)
	,cast(in_word_date as date)
	,cast(leader_id as int)
	,cast(dep_id as int)
from employee
select * from dw_employee
```
## 表克隆
> 表克隆只克隆表的样式，不克隆数据

``` sql
-- 表克隆
create table employee_clone like employee
select * from employee_clone
```
## 查看表结构


