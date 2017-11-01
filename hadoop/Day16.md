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

## HBase集群典型部署组网

![HBase集群典型部署组网][1]

## HBase 系统架构

![HBase 系统架构][2]


## HBase数据模型

![HBase数据模型  ][3]


## HBase访问接口

1. Native Java API，最常规和高效的访问方式，适合Hadoop MapReduce Job并行批处理HBase表数据
2. HBase Shell，HBase的命令行工具，最简单的接口，适合HBase管理使用
3. Thrift Gateway，利用Thrift序列化技术，支持C++，PHP，Python等多种语言，适合其他异构系统在线访问HBase表数据
4. REST Gateway，支持REST 风格的Http API访问HBase, 解除了语言限制
5. Pig，可以使用Pig Latin流式编程语言来操作HBase中的数据，和Hive类似，本质最终也是编译成MapReduce Job来处理HBase表数据，适合做数据统计
6. Hive，当前Hive的Release版本尚没有加入对HBase的支持，但在下一个版本Hive 0.7.0中将会支持HBase，可以使用类似SQL语言来访问HBase

## Hbase shell



  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516387564.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516328683.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516439458.jpg