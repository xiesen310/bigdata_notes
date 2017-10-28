---
title: Day15
tags: hadoop,hbase
grammar_cjkRuby: true
---

# zookeeper

> ZooKeeper是一个分布式的，开放源码的分布式应用程序协调服务，它包含一个简单的原语集，分布式应用程序可以基于它实现同步服务，配置维护和命名服务等

Zookeper的作用主要有两点：
1. 统一性：客户端无论连接到那个服务器，展示给用户的都是同一个页面
2. 可靠性：具有简单、健壮、良好的性能，如果消息m被到一台服务器接受，那么它将被所有的服务器接受

## Zookeeper的基本运转流程
1. 选举Leader
2. 同步数据
3. 选举Leader的算法有很多，但是目的都是要达成一致

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
- 列出namespace下的表 `list_namespace_tables 'bd14'`
- 查看表结构 `describe 'bd14:user'`
- 插入数据 

put指令介绍 ` put 'ns1:t1', 'r1', 'c1', 'value'`
参数1，表名称；参数二rowkey；参数三 ，列名称；参数四，值

![][2]


hbase随机读写是如何实现的

  [1]: http://phoenix.apache.org/
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509181103193.jpg