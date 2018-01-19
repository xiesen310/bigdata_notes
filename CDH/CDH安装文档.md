---
title: CDH安装文档 
tags: CDH，安装教程
grammar_cjkRuby: true
---

# 概述

本文档描述CDH5.8在CentOS6.6操作系统上的安装部署过程。

Cloudera企业级数据中心的安装主要分为4个步骤：
1.	集群服务器配置，包括安装操作系统、关闭防火墙、同步服务器时钟等；
2.	外部数据库安装，通常使用mysql
3.	安装Cloudera Manager管理器；
4.	安装CDH集群；
5.	集群完整性检查，包括HDFS文件系统、MapReduce、Hive等是否可以正常运行。
本文档纪录大数据平台的安装过程并基于以下基本信息：
1.	操作系统版本：CentOS6.6
2.	MySQL数据库版本为5.6.30
3.	CM版本：CM 5.8.1
4.	CDH版本：CDH 5.8.0
5.	采用root对集群进行部署
6.	已经提前下载CDH和CM的安装包

# 安装文件准备

## 下载CDH文件

下载地址: [http://archive.cloudera.com/cdh5/parcels/5.8.0/][1]

![][2]

下载：CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel	
		  CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel.sha1
		  manifest.json

下载的cdh文件要与操作系统版本一致。如：CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel中的 el6是指redhat6版本,因为我们本次安装使用redhat内核的CentOS6.6，所以下载el6的文件。

## 下载CM文件

下载地址[http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/5.8.1/RPMS/x86_64/][3]

![][4]

全部下载


# 服务器基本信息

## 配件信息

|   服务器名称  |  服务器ip   |  CPUs & RAM & Storage   | 操作系统    | 数量    |
| --- | --- | --- | --- | --- |
|     |     |     |     |     |
|     |     |     |     |     |

## 服务器角色分布





  [1]: http://archive.cloudera.com/cdh5/parcels/5.8.0/
  [2]: ./images/1516352321214.jpg
  [3]: http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/5.8.1/RPMS/x86_64/
  [4]: ./images/1516357432901.jpg