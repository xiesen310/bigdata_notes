---
title: Day16
tags: hadoop,hbase
grammar_cjkRuby: true
---

# Hbase
## 简介

> HBase(Hadoop Database)是一个开源的、面向列（Column-Oriented）、适合存储海量非结构化数据或半结构化数据的、具备高可靠性、高性能、可灵活扩展伸缩的、支持实时数据读写的分布式存储系统。


存储在HBase中的表的典型特征：
- 大表（BigTable）：一个表可以有上亿行，上百万列
- 面向列：面向列(族)的存储、检索与权限控制
- 稀疏：表中为空(null)的列不占用存储空间

## Hbase的应用场景

Hbase适合一次写入，多次读取的应用场景，例如：订单的查询，交易信息，银行流水,话单信息，日志信息

# Hbase底层实现
Hbase的底层存储是一个key-value键值对
column Family冗余量比较大，所以强烈建议使用一个字母表示
Row key也是越短越好，但是需要唯一确定

# Hbase 在分布式上是如何存储的

1. 一个hbase表分成不同的region，region运行在hregionServer上
2. hbase根据row key划分成region，根据row key的大小顺序来划分region
3. 当region过大时，hbase会帮助我们进行region分裂，一个region分裂成两个，分布在不同的机器上，分裂的过程，region是不能够提供服务的

## row key的特点
1. 唯一
2. 不宜过长
3. 最好不易过长

**meta表：**记录存数据的表在那些hregionServer上运行
meta表时hbase里面的一张表
**root表(meta-region-server): **root记录meta在哪里，root表存储在zookeeper上

HregionServer主要响应用户I/O请求

HregionServer = Hregion + HLog

![][1]


hbase 初始化

删除zookeeper中的hbase目录
删除hdfs上的hbase目录


使用mr读写hbase

  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509332614403.jpg