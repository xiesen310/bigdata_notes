---
title: Flume采集日志
tags: flume,日志
author: XieSen
time: 2018-5-29 
grammar_cjkRuby: true
---

![flume 整合kafka示意图](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1527560136520.jpg)

## 整合思路
> 对于Flume而言，关键在于如何采集数据，并且将其发送到Kafka上，并且由于我们这里了使用Flume集群的方式，Flume集群的配置也是十分关键的。而对于Kafka，关键就是如何接收来自Flume的数据。从整体上讲，逻辑应该是比较简单的，即可以在Kafka中创建一个用于我们实时处理系统的topic，然后Flume将其采集到的数据发送到该topic上即可。

