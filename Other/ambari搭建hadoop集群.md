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

安装Ambari系统本身是通过Ambari安装HDP发行版中的Hadoop服务器要通过yum的方式进行安装。并且在企业的内部部署集群环境也是在没有网的环境下进行部署的。HDP的文件多达几个G，通过yum在线安装也是不可能的。

1.1 下载离线安装包
因为是离线安装，所以我们需要首先下载Ambari和HDP的离线安装包。这里我们使用的是Ambari2.4和HDP2.5，下载地址如下:

|   Ambari-2.4  |wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.4.0.1/ambari-2.4.0.1-centos6.tar.gz      |
| --- | --- |
|   HDP2.5  | wget http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.5.0.0/HDP-2.5.0.0-centos6-rpm.tar.gz    |
|  HDP-UTILS   |    wget http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos6/HDP-UTILS-1.1.0.21-centos6.tar.gz |


1.2 安装Apache服务器


1.3 创建yum源配置文件
	
3. 关闭防火墙和SELinux
4. 配置主机表
5. 安装Ambari-Server
6. 配置Ambari-Server
7. 启动Ambari-Server
