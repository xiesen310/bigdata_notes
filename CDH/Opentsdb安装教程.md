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

``` shell
create 'tsdb-uid',{NAME => 'id', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},{NAME => 'name', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
create 'tsdb',{NAME => 't', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
create 'tsdb-tree',{NAME => 't', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
create 'tsdb-meta',{NAME => 'name', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
```
配置/src/opentsdb.conf

``` shell
# 接受请求的端口  
tsd.network.port = 4242  

# 接受请求的网卡  
tsd.network.bind = 0.0.0.0  

# HTTP客户端的GUI静态页面，这个使用默认值即可。  
tsd.http.staticroot = ./staticroot  

# cache 路径，最好提前创建好，保证读写权限。  
tsd.http.cachedir = /home/opentsdb/tsdb_cache  

# 是否能自动创建统计指标  
tsd.core.auto_create_metrics = true  

# HBase表名称  
tsd.storage.hbase.data_table = tsdb  


```




  [1]: https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz