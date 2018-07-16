---
title: ambari搭建hadoop集群
tags: ambari,hadoop
author: XieSen
time: 2018-7-16 
grammar_cjkRuby: true
---

ambari的安装、配置与启动

1. 集群规划

在这里我们只是测试，和真正的集群环境是不一样的，在这里我们使用的操作系统是Centos6.5版本，JDK版本1.8.0_161，python2.6.6版本服务器的hostname分别为server1.cluster.com、server2.cluster.com、server3.cluster.com，使用server1.cluster.com作为集群的主节点。

2. 搭建本地yum源仓库

安装Ambari系统本身是通过Ambari安装HDP发行版中的Hadoop服务器要通过yum的方式进行安装。

3. 关闭防火墙和SELinux
4. 配置主机表
5. 安装Ambari-Server
6. 配置Ambari-Server
7. 启动Ambari-Server
