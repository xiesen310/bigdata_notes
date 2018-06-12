---
title: kafka常用命令
tags: kafka,commands
author: XieSen
time: 2018-6-12 
grammar_cjkRuby: true
---

// 创建topic

kafka-topics.sh --zookeeper master:2181 --create --partitions 2 --replication-factor 3 --topic test

// 列出所有的topic

kafka-topics.sh --zookeeper master:2181 --list 

// 查看test的详细信息

kafka-topics.sh --zookeeper master:2181 --describe --topic test

// 列举客户端指令信息

kafka-console-producer.sh 

// 连接topic

kafka-console-producer.sh --broker-list slave1:9092,slave2:9092 --topic test

// 列举消费者指令信息

kafka-console-producer.sh 

// 从下次输入开始消费

kafka-console-consumer.sh --bootstrap-server slave1:9092 slave2:9092 --topic test

// 从头开始消费

kafka-console-consumer.sh --bootstrap-server slave1:9092 slave2:9092 --topic test --from-beginning

// 从特定的partition上进行消费 --offset earliest表示从开始处消费

kafka-console-consumer.sh --bootstrap-server slave1:9092 slave2:9092 --topic test --offset earliest --partition 1

// 只是标记删除topic,如果想真的删除，在server。propert文件中设置delete.topic.enable为true，重启即可

// 还可以在zookeeper中删除相对应的topic

kafka-topics.sh --zookeeper master:2181 --delete --topic test

// 进入zookeeper客户端

zkCli.sh 

// 列举出zookeeper中的文件

ls /

// 列举出brokers中的文件

ls /brokers




