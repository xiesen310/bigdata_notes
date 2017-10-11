---
title: Day_02_hadoop
tags: java,bigdata,linux.hadoop
grammar_cjkRuby: true
---

# 集群中扮演的角色
## hdfs
> 主节点 namenode ，hdfs的端口号是50070

**namenode**： 处理请求，分配处理任务；负责心跳连接；负责均衡；副本
**datanote** : 数据的读写请求执行和数据的保存操作
**secondarynamenode** ： 备份NameNode上的数据，合成fsimage和fsedits文件

## yarn

>  主节点 resourceManager ， yarn主节点端口号是8088

resourceManager
nodeManager