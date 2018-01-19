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