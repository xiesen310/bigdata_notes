---
title: Day15
tags: hadoop,hbase
grammar_cjkRuby: true
---

# zookeeper
zookeeper 解决高可用问题

hbase查看地址 master：16010

Zookeeper 是一个分布式的，开源的分布式应用程序协调服务，是Google的开源的实现，是Hadoop和Hbase的重要组件

zookeeper 是以目录的形式存放文件的

zkCli.sh 打开zookeeper的客户端


# Hadoop EcoSystem

phoenix 介绍 [http://phoenix.apache.org/][1]



# Hbase数据模型
hbase是面向列存储的，在保存数据时，是以表的形式来保存的，在表中字段以column Family的形式存储的，每个column Family是一个文件


Hbase数据保存格式

在column Family中存在列名和列值

hbase在使用的时候是非常灵活的

rowkey:行键

hbase冗余量比较大，占用磁盘空间比较大，但是在大数据上查询效率比较高

# Hbase shell
- 创建namespace `create_name 'bd14' `
- 查询namespace  `list_namespace`
- 创建表 `create 'bd14:user','i','c`，指定在哪个namespace以及column Family



 [1]: http://phoenix.apache.org/