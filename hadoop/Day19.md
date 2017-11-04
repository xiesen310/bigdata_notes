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

