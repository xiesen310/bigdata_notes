---
title: Day20
tags: hadoop,flume
grammar_cjkRuby: true
---

# 大数据数据采集

| 数据来源形式    |  数据来源格式   |  文件传输   |
| --- | --- | --- |
|  网络爬虫   |html文档    | flume、kafka    |
| 日志数据    |   log文件，日志流  |  flume、kafka   |
|  业务数据   |  关系型数据库   |    sqoop |
|  传感数据   |  数据流   |  kafka   |

# flume

flume数据采集的数据来源:
1. log文件
2. 网路端口数据
3. 消息队列数据

flume数据发送来源
1. hdfs
2. hive
3. hbase
4. 网络端口
5. 消息队列

flume-ng将采集的过程交给用户开发agent来直接指定

![flume-ng示意图][1]

agent中有三个组件Source、Channel(相当于缓冲区)、sink(目的是从channel中取数据)


``` xml
a1.sources = r1
a1.sinks = s1
a1.channels = c1

a1.sources.r1.type = netcat
a1.sources.r1.bind = localhost
a1.sources.r1.port = 44444

a1.sinks.s1.type = logger

a1.channels.c1.type= memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

a1.sources.r1.channels = c1
a1.sinks.s1.channel = c1
```

netcat:source的一种类型，网络抓取


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509931626942.jpg