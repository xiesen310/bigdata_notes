---
title: Day19
tags: hadoop,hbase,phoenix
grammar_cjkRuby: true
---


## view

view 应用场景：限制数据查看权限，保存复杂的sql


create view ad_limit as 
select * from ad where user_id < 50

`select * from ad_limit` 等同于`select * from (select * from ad where user_id < 50)`


view 不保存数据，保存的是sql

## phoenix sql语句操作HBase

``` sql
select * from system.catalog where table_schem='SYSTEM'and table_name='STATS'and column_name='PHYSICAL_NAME';
-- 创建表必须添加主键
create table phoenix_user(
	user_id integer not null primary key 
	,username varchar(20)
	,age integer
	,birthday varchar(20)
)

-- 查询数据
select * from phoenix_user

-- 插入数据
upsert into phoenix_user (user_id,username,age,birthday) values(1,'张三',12,'2012-01-02');
upsert into phoenix_user (user_id,username,age,birthday) values(2,'李四',12,'2012-04-02');
upsert into phoenix_user (user_id,username,age,birthday) values(3,'王五',12,'2012-07-02');

-- 修改数据,只能根据主键进行修改
upsert into phoenix_user(user_id,age) values(1,25);
upsert inrto phoenix_user(user_id,age) values()

-- 删除数据 年龄大于20的删除1
delete from phoenix_user where age > 20

```


## java API操作phoenix


 
