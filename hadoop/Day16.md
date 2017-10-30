---
title: Day16
tags: hadoop,hbase
grammar_cjkRuby: true
---
# Hbase的应用场景

Hbase适合一次写入，多次读取的应用场景，例如：订单的查询，交易信息，银行流水,话单信息，日志信息

# Hbase底层实现
Hbase的底层存储是一个key-value键值对
column Family冗余量比较大，所以强烈建议使用一个字母表示
Row key也是越短越好，但是需要唯一确定

# Hbase 在分布式上是如何存储的

1. 一个hbase表分成不同的region，region运行在hregionServer上
2. hbase根据row key划分成region，根据row key的大小顺序来划分region


## row key的特点
1. 唯一
2. 不宜过长
3. 最好不易过长
