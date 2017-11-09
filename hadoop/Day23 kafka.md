---
title: Day23 kafka
tags: hadoop,kafka
grammar_cjkRuby: true
---

## 批量数据和流数据的区别

- 批量数据
	- 定期产生
	- 数量相对比较大
	- 有特定的生成周期
	- 比如：日志文件、业务数据
	- 去向--->分布式系统
	- 来源--->定期产生的文件、定期传输的文件、定期数据库导出

- 流数据
	- 随时都有可能产生
	- 搜集工具7*24小时运行
	- 数据量相对比较小
	- 实时性强
	- 比如：实时数据分析日志数据、实时业务数据
	- 去向--->分布式文件系统、流计算应用程序
	- 来源---->网络端口、文件、数据库(文件和数据库是通过监听程序监听，然后将数据发送到网络端口，然后再通过流采集工具采集)


## 流处理特点

消息随时产生，实时发出


![冗余特点][1]


## kafka架构

- **broker** 是专门提供消息的读写操作的，并且能够保存消息
- **topic** 是对消息进行分类的
- **partition** 一个partition只能有一个broker负责，但是一个topic可以包含多个partition
- **preducer** 生产者，发送消息
- **consumer** 消费者，获取数据
- **consumer Group** 消费者组，确保消费的数据不重复，提升消费效率


## kafka安装

1. 解压 `tar -zxvf kafka_2.11-0.10.1.1.tgz`
2. 配置环境变量

``` xml
# set kafka enviroment

export KAFKA_HOME=/opt/software/kafka/kafka_2.11-0.10.1.1
export PATH=$PATH:$KAFKA_HOME/bin
```


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510194230689.jpg