# hadoop


## Day01 [连接][1]
* [概论](#概论)
* [集群](#集群)
	* [克隆虚拟机](#克隆虚拟机)
	* [创建集群](#创建集群)
		* [ssh](#ssh)
		* [hadoop](#hadoop)
	* [异常信息](#异常信息)

## Day02 [连接][2]
* [集群中扮演的角色](#集群中扮演的角色)
	* [hdfs](#hdfs)
	* [yarn](#yarn)
* [元数据](#元数据)
	* [元数据的管理](#元数据的管理)
		* [元数据的格式](#元数据的格式)
		* [checkpoint触发机制](#checkpoint触发机制)
* [HDFS的启动过程](#hdfs的启动过程)
	* [HDFS启动](#hdfs启动)
	* [SecondaryNameNode工作流程](#secondarynamenode工作流程)
* [HDFS读写操作原理](#hdfs读写操作原理)
	* [写操作](#写操作)
	* [写操作](#写操作)
* [HDFS通信协议](#hdfs通信协议)
* [HDFS文件权限](#hdfs文件权限)
* [HDFS安全模式](#hdfs安全模式)
* [HDFS中常用到的命令](#hdfs中常用到的命令)
* [eclipse 连接hdfs](#eclipse-连接hdfs)
## Day03 [连接][3]
* [Eclipse基本设置](#eclipse基本设置)
* [阅读文档的基本步骤](#阅读文档的基本步骤)
* [创建maven项目注意事项](#创建maven项目注意事项)
* [Java代码操作hdfs](#java代码操作hdfs)
	* [编写hdfsUtils](#编写hdfsutils)
	* [在hdfs上创建文件，并写入数据](#在hdfs上创建文件并写入数据)
	* [读取hdfs上已有的文件](#读取hdfs上已有的文件)
	* [删除hdfs上已经有的文件或文件夹](#删除hdfs上已经有的文件或文件夹)
	* [上传文件](#上传文件)
	* [下载文件](#下载文件)
	* [迭代文件](#迭代文件)
	* [查看文件状态](#查看文件状态)
* [安装hadoop环境](#安装hadoop环境)
## Day04 [连接][4]
* [FileSystem补充](#filesystem补充)
	* [获取FileSystem](#获取filesystem)
	* [获取用户的家目录](#获取用户的家目录)
		* [HDFS和Linux的区别:](#hdfs和linux的区别)
* [导入项目](#导入项目)
	* [导入数据库](#导入数据库)
* [MapReduce](#mapreduce)
	* [原理](#原理)
		* [map和reduce的运行原理](#map和reduce的运行原理)
		* [wordCount的运行过程](#wordcount的运行过程)
		* [job配置](#job配置)
		* [map,reduce和shuffel](#mapreduce和shuffel)
	* [数据处理分析:](#数据处理分析)
		* [创建map类](#创建map类)
		* [创建reducer](#创建reducer)
		* [编写job](#编写job)
## Day05 [连接][5]

* [数据的排序](#数据的排序)
	* [全排序](#全排序)
		* [过程:](#过程)
		* [全局排序代码](#全局排序代码)
	* [二次排序](#二次排序)
		* [原理过程](#原理过程)
		* [二次排序代码:](#二次排序代码)
## Day06 [连接][6]
* [Mr文件读取的几种方式 的区别](#mr文件读取的几种方式-的区别)
* [书写MapReducer为什么要使用静态内部类？](#书写mapreducer为什么要使用静态内部类)
* [书写map时，为什么将变量定义在成员变量位置？](#书写map时为什么将变量定义在成员变量位置)
* [设置分隔符的两种方式](#设置分隔符的两种方式)
* [程序优化原理分析—combinner](#程序优化原理分析combinner)
	* [如何在map端进行聚合](#如何在map端进行聚合)
* [MR倒排索引](#mr倒排索引)
* [TopN问题](#topn问题)
## Day07 [连接][7]
* [分维度topN问题](#分维度topn问题)
* [Mr串联](#mr串联)
* [mr关联](#mr关联)
	* [map端关联](#map端关联)
	* [reduce端关联](#reduce端关联)
	* [半关联(semijoin)](#半关联semijoin)
## Day08 [连接][8]
* [Avro](#avro)
* [Avro序列化后文件详解](#avro序列化后文件详解)
* [Avro的代码实现](#avro的代码实现)
	* [读写操作](#读写操作)
		* [模式读取](#模式读取)
			* [写操作](#写操作)
			* [读操作](#读操作)
		* [无模式读取](#无模式读取)
		* [写操作](#写操作)
	* [小文件的合并操作](#小文件的合并操作)
	* [对于小文件合并后的大文件进行词频统计](#对于小文件合并后的大文件进行词频统计)

## Day09 [连接][9]
* [事实数据和维度数据](#事实数据和维度数据)
* [设置mysql远程调用](#设置mysql远程调用)
* [Hadoop读写关系型数据库](#hadoop读写关系型数据库)
	* [读数据库](#读数据库)
	* [将数据写入到数据库](#将数据写入到数据库)
## Day10 [连接][10]
* [Hive](#hive)
	* [Hive特点](#hive特点)
	* [Hive架构](#hive架构)
	* [数据类型](#数据类型)
* [Beeline](#beeline)
	* [Beeline基础命令](#beeline基础命令)
* [SQLuirrel SQL 连接hive](#sqluirrel-sql-连接hive)
	* [数据库语言的几种变现形式](#数据库语言的几种变现形式)
## Day11 [hive操作数据量][11] 和 [sql练习][12]
* [Hive操作数据库](#hive操作数据库)
	* [Hive操作数据库](#hive操作数据库)
	* [Hive中hql练习](#Hive中hql练习)
	* [sql练习](#sql练习)
## Day12 [连接][13]
* [Hive 优化](#hive-优化)
* [Map端聚合操作](#map端聚合操作)
* [Order, Sort, Cluster, and Distribute By](#order-sort-cluster-and-distribute-by)
	* [order by](#order-by)
	* [Sort by](#sort-by)
	* [distribute by](#distribute-by)
	* [Cluster by](#cluster-by)
* [复杂数据类型](#复杂数据类型)
	* [array](#array)
	* [Map](#map)
	* [Struct](#struct)
* [文件的保存格式](#文件的保存格式)
* [hive分区](#hive分区)
	* [创建分区文件](#创建分区文件)
	* [静态导入数据](#静态导入数据)
	* [动态导入数据](#动态导入数据)
	* [二级分区](#二级分区)
* [分桶](#分桶)
* [hive压缩](#hive压缩)
* [maven 更换国内镜像](#maven-更换国内镜像)
## Day13 [连接][14]
* [java代码操作hive](#java代码操作hive)
	* [创建maven工程，导入依赖文件](#创建maven工程导入依赖文件)
	* [编写连接小工具](#编写连接小工具)
	* [hive的基本操作](#hive的基本操作)
		* [创建表](#创建表)
* [Hive 函数](#hive-函数)
	* [数学函数](#数学函数)
	* [日期类型函数](#日期类型函数)
	* [条件函数](#条件函数)
	* [string函数](#string函数)
* [日志](#日志)
	* [日志信息结构分析](#日志信息结构分析)
	* [创建日志对应的表](#创建日志对应的表)
	* [加载数据](#加载数据)
	* [计算当日网站的pv uv](#计算当日网站的pv-uv)
	* [统计出网站用户访问使用windows系统和使用mac系统的占比和数量](#统计出网站用户访问使用windows系统和使用mac系统的占比和数量)
* [自定义hive function](#自定义hive-function)
* [异常处理](#异常处理)
## Day14 [连接][15]
* [窗口函数的使用](#窗口函数的使用)
* [日志分析](#日志分析)
* [Hive优化](#hive优化)
	* [Group by 优化](#group-by-优化)
	* [order by 优化](#order-by-优化)
	* [sql语句优化](#sql语句优化)
	* [join 优化](#join-优化)
## Day15 [连接][16]
* [zookeeper](#zookeeper)
	* [Zookeeper的基本运转流程](#zookeeper的基本运转流程)
	* [Zookeeper数据结构](#zookeeper数据结构)
* [Hbase](#hbase)
	* [Hbase表的特点](#hbase表的特点)
	* [Hbase表结构模型](#hbase表结构模型)
	* [HBase访问接口](#hbase访问接口)
* [Hbase数据模型](#hbase数据模型)
* [Hbase shell](#hbase-shell)
## Day16 [连接][17]
* [Hbase](#hbase)
	* [简介](#简介)
	* [Hbase的应用场景](#hbase的应用场景)
* [Hbase底层实现](#hbase底层实现)
	* [HBase集群典型部署组网](#hbase集群典型部署组网)
	* [HBase 系统架构](#hbase-系统架构)
	* [HBase数据模型](#hbase数据模型)
	* [HBase访问接口](#hbase访问接口)
	* [Hbase shell](#hbase-shell)
		* [一般操作](#一般操作)
		* [DDL操作](#ddl操作)
		* [DML操作](#dml操作)
	* [javaAPI 操作Hbase](#javaapi-操作hbase)
	* [初始化构造方法，获取连接](#初始化构造方法获取连接)
	* [关闭连接](#关闭连接)
		* [创建表](#创建表)
		* [列举出数据库下的表](#列举出数据库下的表)
		* [获取表的描述信息](#获取表的描述信息)
		* [删除表](#删除表)
		* [插入数据](#插入数据)
		* [获取表中数据](#获取表中数据)
		* [删除数据](#删除数据)
		* [删除所有数据](#删除所有数据)


## Day17 [连接][18]

* [安装配置](#安装配置)
* [hbase的数据存储结构](#hbase的数据存储结构)
	* [hbase的特点](#hbase的特点)
* [命令](#命令)
* [hbase系统](#hbase系统)
* [hbase的简介](#hbase的简介)
* [Hbase接口](#hbase接口)
* [hbase的数据模型](#hbase的数据模型)
* [hbase的系统架构](#hbase的系统架构)
	* [Client](#client)
	* [Zookeeper](#zookeeper)
	* [HMaster](#hmaster)
	* [HRegionServer](#hregionserver)
* [HBase存储格式](#hbase存储格式)
	* [HFile](#hfile)
	* [HLog File](#hlog-file)

## Day18 [连接][19]

* [rowkey设计](#rowkey设计)
	* [rowkey设计原则](#rowkey设计原则)
* [二级索引](#二级索引)
* [Phoenix](#phoenix)
	* [Phoenix安装教程](#phoenix安装教程)

## Day19 phoenix [连接][20]

* [数据库中view的作用](#数据库中view的作用)
* [phoenix sql语句操作HBase](#phoenix-sql语句操作hbase)
* [java API操作phoenix](#java-api操作phoenix)
* [HBase协处理器](#hbase协处理器)
* [AggregationClient](#aggregationclient)
* [HBase调优](#hbase调优)
	* [client调优](#client调优)
	* [服务端调优](#服务端调优)

## Day20 flume [连接][21]

* [大数据数据采集](#大数据数据采集)
* [flume](#flume)
	* [spooling Source hdfs sink](#spooling-source-hdfs-sink)
	* [avro source logger sink](#avro-source-logger-sink)
* [flume节点故障和消息瓶颈问题](#flume节点故障和消息瓶颈问题)
	* [节点故障问题](#节点故障问题)
	* [消息瓶颈问题](#消息瓶颈问题)
	* [多个节点串行化操作](#多个节点串行化操作)

## Day21 

* [电商平台的数据采集](#电商平台的数据采集)
* [使用当地时间存储在hdfs上,并且动态生成文件目录](#使用当地时间存储在hdfs上并且动态生成文件目录)
* [匹配抓取内容,根据不同内容,分配到不同的channel中(按省份统计数据)(selector)](#匹配抓取内容根据不同内容分配到不同的channel中按省份统计数据selector)
	* [conf文件的配置](#conf文件的配置)
	* [javaAPI发送数据以验证](#javaapi发送数据以验证)
* [给抓取内容中,添加时间戳(interceptor)](#给抓取内容中添加时间戳interceptor)
* [利用interceptor(拦截器)extractor(提取器),只提取包含邮箱的信息,打印或是存储,不提取其他内容,只要邮箱](#利用interceptor拦截器extractor提取器只提取包含邮箱的信息打印或是存储不提取其他内容只要邮箱)
* [利用interceptor(拦截器)fileter(过滤器),只打印包含匹配内容的记录](#利用interceptor拦截器fileter过滤器只打印包含匹配内容的记录)
* [利用interceptor(拦截器)replace(替代器),进行手机号码的脱敏](#利用interceptor拦截器replace替代器进行手机号码的脱敏)
* [利用interceptor做一些聚合运算,例如wordcount](#利用interceptor做一些聚合运算例如wordcount)
* [将telnet的内容写到hive中](#将telnet的内容写到hive中)
* [将telnet的数据存储到hbase上](#将telnet的数据存储到hbase上)

## Day22 sqoop
* [sqoop](#sqoop)
* [sqoop安装](#sqoop安装)
* [sqoop下的object](#sqoop下的object)
	* [基本信息](#基本信息)
	* [核心对象](#核心对象)
	* [参数信息](#参数信息)
	* [权限信息](#权限信息)
* [将mysql中的数据导入到hadoop平台](#将mysql中的数据导入到hadoop平台)
	* [创建mysql link](#创建mysql-link)
	* [创建hdfs link](#创建hdfs-link)
	* [创建job](#创建job)
	* [启动sqoop job](#启动sqoop-job)
	* [启动异常](#启动异常)
* [将hdfs上的数据导入到mysql数据库](#将hdfs上的数据导入到mysql数据库)
* [java API 操作sqoop](#java-api-操作sqoop)
	* [创建link](#创建link)
	* [创建job](#创建job)
	* [启动job](#启动job)
	* [windows上mysql写入到集群中的hdfs上](#windows上mysql写入到集群中的hdfs上)

## Day23 kafka
* [批量数据和流数据的区别](#批量数据和流数据的区别)
* [kafka架构](#kafka架构)
* [为什么使用消息系统](#为什么使用消息系统)
* [kafka安装](#kafka安装)
* [kafka容错机制](#kafka容错机制)
* [kafka命令介绍](#kafka命令介绍)
* [kafka删除topic](#kafka删除topic)
* [kafka topic结构](#kafka-topic结构)
* [Kafka delivery guarantee](#kafka-delivery-guarantee)

## Day24 kafka深入理解
* [配置sl4j日志](#配置sl4j日志)
* [java API 创建Producer](#java-api-创建producer)
* [java API 创建Consumer](#java-api-创建consumer)
* [同步异步](#同步异步)
* [消费者手动提交](#消费者手动提交)
* [flume 发送数据，kafka消费](#flume-发送数据kafka消费)


  [1]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_01%20hadoop.md
  [2]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_02_hadoop.md
  [3]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_03_hadoop.md
  [4]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_04_hadoop.md
  [5]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_05_mapreduce%E7%9A%84%E6%8E%92%E5%BA%8F.md
  [6]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_06_Combinner%20And%20Reverse%20Index.md
  [7]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_07_MR%E4%B8%B2%E8%81%94%E4%B8%8E%E5%85%B3%E8%81%94.md
  [8]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_08_Arvo.md
  [9]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_09_hadoop%E8%AF%BB%E5%86%99%E5%85%B3%E7%B3%BB%E5%9E%8B%E6%95%B0%E6%8D%AE%E5%BA%93.md
  [10]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_10_hive.md
  [11]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_11_hive%E4%B9%8Bsql%E6%93%8D%E4%BD%9C.md
  [12]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/sql%E7%BB%83%E4%B9%A0.md
  [13]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_12_hive.md
  [14]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day_13_.md
  [15]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day14.md
  [16]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day15.md
  [17]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day16.md
  [18]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day17.md
  [19]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day18.md
  [20]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day19.md
  [21]: https://github.com/xiesen310/bigdata_notes/blob/hadoop/hadoop/Day20.md