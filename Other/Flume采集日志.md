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

## Flume集群配置

![flume 集群配置](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1527560232287.jpg)

> 在我们的场景中，两个Flume Agent分别部署在两台Web服务器上，用来采集Web服务器上的日志数据，然后其数据的下沉方式都为发送到另外一个Flume Agent上，所以这里我们需要配置三个Flume Agent.

### Flume Agent01

该Flume Agent部署在一台Web服务器上，用来采集产生的Web日志，然后发送到Flume Consolidation Agent上，创建一个新的配置文件flume-sink-avro.conf，其配置内容如下：

``` shell
######################################################### ## 
##主要作用是监听文件中的新增数据，采集到数据之后，输出到avro 
## 注意：Flume agent的运行，主要就是配置source channel sink 
## 下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1 ######################################################### 
a1.sources = r1 
a1.sinks = k1 
a1.channels = c1 

#对于source的配置描述 监听文件中的新增数据
exec a1.sources.r1.type = exec 
a1.sources.r1.command = tail -F /home/uplooking/data/data-clean/data-access.log 

#对于sink的配置描述 使用avro日志做数据的消费 
a1.sinks.k1.type = avro 
a1.sinks.k1.hostname = uplooking03 
a1.sinks.k1.port = 44444 

#对于channel的配置描述 使用文件做数据的临时缓存 这种的安全性要高 a1.channels.c1.type = file a1.channels.c1.checkpointDir = /home/uplooking/data/flume/checkpoint a1.channels.c1.dataDirs = /home/uplooking/data/flume/data 

#通过channel c1将source r1和sink k1关联起来 
a1.sources.r1.channels = c1 
a1.sinks.k1.channel = c1
```

配置完成后， 启动Flume Agent，即可对日志文件进行监听：

``` shell
$ flume-ng agent --conf conf -n a1 -f app/flume/conf/flume-sink-avro.conf >/dev/null 2>&1 &
```
### Flume Agent02

该Flume Agent部署在一台Web服务器上，用来采集产生的Web日志，然后发送到Flume Consolidation Agent上，创建一个新的配置文件flume-sink-avro.conf，其配置内容如下：

``` shell
######################################################### ##
##主要作用是监听文件中的新增数据，采集到数据之后，输出到avro 
## 注意：Flume agent的运行，主要就是配置source channel sink 
## 下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1 ######################################################### 
a1.sources = r1 
a1.sinks = k1 
a1.channels = c1 

#对于source的配置描述 监听文件中的新增数据 
exec a1.sources.r1.type = exec 
a1.sources.r1.command = tail -F /home/uplooking/data/data-clean/data-access.log 

#对于sink的配置描述 使用avro日志做数据的消费 
a1.sinks.k1.type = avro 
a1.sinks.k1.hostname = uplooking03 
a1.sinks.k1.port = 44444 

#对于channel的配置描述 使用文件做数据的临时缓存 这种的安全性要高 a1.channels.c1.type = file 
a1.channels.c1.checkpointDir = /home/uplooking/data/flume/checkpoint a1.channels.c1.dataDirs = /home/uplooking/data/flume/data 

#通过channel c1将source r1和sink k1关联起来 
a1.sources.r1.channels = c1 
a1.sinks.k1.channel = c1
```
配置完成后， 启动Flume Agent，即可对日志文件进行监听：

``` shell
flume-ng agent --conf conf -n a1 -f app/flume/conf/flume-sink-avro.conf >/dev/null 2>&1 &
```

### Flume Consolidation Agent

![Flume Consolidation Agent](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1527560601842.jpg)

该Flume Agent用于接收其它两个Agent发送过来的数据，然后将其发送到Kafka上，创建一个新的配置文件flume-source_avro-sink_kafka.conf，配置内容如下：

``` shell
######################################################### ## 
##主要作用是监听目录中的新增文件，采集到数据之后，输出到kafka 
## 注意：Flume agent的运行，主要就是配置source channel sink 
## 下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1 ######################################################### 
a1.sources = r1 
a1.sinks = k1
a1.channels = c1 

#对于source的配置描述 监听avro 
a1.sources.r1.type = avro 
a1.sources.r1.bind = 0.0.0.0 
a1.sources.r1.port = 44444 

#对于sink的配置描述 使用kafka做数据的消费 
a1.sinks.k1.type = org.apache.flume.sink.kafka.KafkaSink a1.sinks.k1.topic = f-k-s 
a1.sinks.k1.brokerList = uplooking01:9092,uplooking02:9092,uplooking03:9092 a1.sinks.k1.requiredAcks = 1 
a1.sinks.k1.batchSize = 20 

#对于channel的配置描述 使用内存缓冲区域做数据的临时缓存 a1.channels.c1.type = memory 
a1.channels.c1.capacity = 1000 
a1.channels.c1.transactionCapacity = 100 

#通过channel c1将source r1和sink k1关联起来 
a1.sources.r1.channels = c1 
a1.sinks.k1.channel = c1
```


