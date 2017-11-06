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