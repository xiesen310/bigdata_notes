---
title: Opentsdb安装教程 
tags: opentsdb,安装教程
grammar_cjkRuby: true
---


> 安装opentsdb的前提是需要jdk和hbase，对于jdk和hbase的安装请参考


1. 进入opentsdb的官网下载，并解压

下载地址 [https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz][1]

tar -zxvf opentsdb-2.2.0.tar.gz

2. 设置hbase home

在/etc/profie文件末尾添加export HBASE_HOME=/opt/cloudera/parcels/CDH-5.9.1-1.cdh5.9.1.p0.4/lib/hbase

3. 编译源码：

``` shell
./configure
make
```
4. 配置

在配置的过程中需要在hbase上创建表，创建表的语句如下



  [1]: https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz