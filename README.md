# hadoop


## Day01
* [概论](#概论)
* [集群](#集群)
	* [克隆虚拟机](#克隆虚拟机)
	* [创建集群](#创建集群)
		* [ssh](#ssh)
		* [hadoop](#hadoop)
	* [异常信息](#异常信息)

## Day02
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
## Day03
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
## Day04
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
## Day05
	* [数据的排序](#数据的排序)
		* [全排序](#全排序)
			* [过程:](#过程)
			* [全局排序代码](#全局排序代码)
		* [二次排序](#二次排序)
			* [原理过程](#原理过程)
			* [二次排序代码:](#二次排序代码)
## Day06
* [Mr文件读取的几种方式 的区别](#mr文件读取的几种方式-的区别)
* [书写MapReducer为什么要使用静态内部类？](#书写mapreducer为什么要使用静态内部类)
* [书写map时，为什么将变量定义在成员变量位置？](#书写map时为什么将变量定义在成员变量位置)
* [设置分隔符的两种方式](#设置分隔符的两种方式)
* [程序优化原理分析—combinner](#程序优化原理分析combinner)
	* [如何在map端进行聚合](#如何在map端进行聚合)
* [MR倒排索引](#mr倒排索引)
* [TopN问题](#topn问题)
## Day07
* [分维度topN问题](#分维度topn问题)
* [Mr串联](#mr串联)
* [mr关联](#mr关联)
	* [map端关联](#map端关联)
	* [reduce端关联](#reduce端关联)
	* [半关联(semijoin)](#半关联semijoin)
## Day08
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

## Day09
* [事实数据和维度数据](#事实数据和维度数据)
* [设置mysql远程调用](#设置mysql远程调用)
* [Hadoop读写关系型数据库](#hadoop读写关系型数据库)
	* [读数据库](#读数据库)
	* [将数据写入到数据库](#将数据写入到数据库)
## Day10
* [Hive](#hive)
	* [Hive特点](#hive特点)
	* [Hive架构](#hive架构)
	* [数据类型](#数据类型)
* [Beeline](#beeline)
	* [Beeline基础命令](#beeline基础命令)
* [SQLuirrel SQL 连接hive](#sqluirrel-sql-连接hive)
	* [数据库语言的几种变现形式](#数据库语言的几种变现形式)
## Day11
* [Hive操作数据库](#hive操作数据库)
	* [Hive操作数据库](#hive操作数据库)
	* [Hive中hql练习](#Hive中hql练习)
	* [sql练习](#sql练习)
## Day12
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
## Day13
## Day14
## Day15
## Day16