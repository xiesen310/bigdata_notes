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
1. 选举Leader，选举Leader的算法有很多，但是目的都是要达成一致
2. 选完Leader以后，zookeeper就进入了同步状态
	- leader等待server连接；
	- Follower连接leader，将最大的zxid发送给leader；
	- Leader根据follower的zxid确定同步点；
	- 完成同步后通知follower 已经成为uptodate状态；
	- Follower收到uptodate消息后，又可以重新接受client的请求进行服务了。

![Zookeeper工作流程示意图][1]


## Zookeeper数据结构

> zookeeper是以目录的形式存在的，结构如图所示

![Zookeeper数据结构][2]

Zookeeper 这种数据结构有如下这些特点：
1.	每个子目录项如 NameService 都被称作为 znode，这个 znode 是被它所在的路径唯一标识，如 Server1 这个 znode 的标识为 /NameService/Server1
2.	znode 可以有子节点目录，并且每个 znode 可以存储数据，注意 EPHEMERAL 类型的目录节点不能有子节点目录
3.	znode 是有版本的，每个 znode 中存储的数据可以有多个版本，也就是一个访问路径中可以存储多份数据
4.	znode 可以是临时节点，一旦创建这个 znode 的客户端与服务器失去联系，这个 znode 也将自动删除，Zookeeper 的客户端和服务器通信采用长连接方式，每个客户端和服务器通过心跳来保持连接，这个连接状态称为 session，如果 znode 是临时节点，这个 session 失效，znode 也就删除了
5.	znode 的目录名可以自动编号，如 App1 已经存在，再创建的话，将会自动命名为 App2
6.	znode 可以被监控，包括这个目录节点中存储的数据的修改，子节点目录的变化等，一旦变化可以通知设置监控的客户端，这个是 Zookeeper 的核心特性，Zookeeper 的很多功能都是基于这个特性实现的


# Hbase

> HBase – Hadoop Database，是一个高可靠性、高性能、面向列、可伸缩的分布式存储系统，利用HBase技术可在廉价PC Server上搭建起大规模结构化存储集群。HBase是一个构建在HDFS上的分布式列存储系统。

## Hbase表的特点

- 大：一个表可以有数十亿行，上百万列；
- 无模式：每行都有一个可排序的主键和任意多的列，列可以根据需要动态的增加，同一张表中不同的行可以有截然不同的列；
- 面向列：面向列（族）的存储和权限控制，列（族）独立检索；
- 稀疏：空（null）列并不占用存储空间，表可以设计的非常稀疏；
- 数据多版本：每个单元中的数据可以有多个版本，默认情况下版本号自动分配，是单元格插入时的时间戳；
- 数据类型单一：Hbase中的数据都是字符串，没有类型。




phoenix 介绍 [http://phoenix.apache.org/][3]
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

![][4]


hbase随机读写是如何实现的


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509187154239.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509187454157.jpg
  [3]: http://phoenix.apache.org/
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509181103193.jpg