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
bind：资源来源

flume的整个数据采集过程，数据是被封装到Event里面进行传输的

采集日志log文件，把结果存放到hdfs上

log生成的方式
1. 滚动生成
	- 按时间滚动
	- 按文件大小滚动

当有新日志文件产生的时候，把刚写完的日志系统拷贝搭配spoolingdirectory


## spooling Source hdfs sink
source ：Spooling Directory Source
channel：memory
sink ： hdfs sink

``` xml
a1.sources = r1
a1.sinks=s1
a1.channels=c1

a1.sources.r1.type = spooldir
a1.sources.r1.spoolDir = /root/tmp
a1.sources.r1.fileHeader = true

a1.sinks.s1.type = hdfs
a1.sinks.s1.hdfs.path = hdfs://master:9000/flumelog/%Y%m%d
a1.sinks.s1.hdfs.fileSuffix = .log
a1.sinks.s1.hdfs.rollInterval = 0
a1.sinks.s1.hdfs.rollSize = 0
a1.sinks.s1.hdfs.rollCount = 100
a1.sinks.s1.hdfs.fileType = DataStream
a1.sinks.s1.hdfs.writeFormat = Text
a1.sinks.s1.hdfs.useLocalTimeStamp = true


a1.channels.c1.type= memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

a1.sources.r1.channels = c1
a1.sinks.s1.channel = c1
```

执行操作`flume-ng agent  -c conf -f flume_nc_to_hdfs.conf --name a1 -Dflume.root.logger=INFO.console`

## avro source logger sink

> avro文件作为数据采集的对象，logger作为消费者消费的格式
> 现在我们模拟出avro文件的格式发送数据到agent中，下面的java程序就是模拟代码

``` java
enter code here
```





## 配置文件

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
[root@master flumesrc]# cat flume_nc_avro_to_log.conf 
a1.sources = r1
a1.sinks=s1
a1.channels=c1

a1.sources.r1.type = avro
a1.sources.r1.bind = master
a1.sources.r1.port = 8888

a1.channels.c1.type= memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

a1.sinks.s1.type = logger

a1.sources.r1.channels = c1
a1.sinks.s1.channel = c1
```

- agent节点故障问题
- agent接收发送event的能力是有瓶颈的

![enter description here][2]

服务端：
1. 节点故障问题，启动多个agent节点，由当前运行的，有备用的agent节点
2. 消息瓶颈问题，启动多个agent节点，分布式的来接受客户端发送的event

客户端
1. 使用failover类型client
2. 使用loadbalance类型client





  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509931626942.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509956464555.jpg