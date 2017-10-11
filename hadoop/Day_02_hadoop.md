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
**secondarynamenode** ： 备份NameNode上的数据，合成fsimage和fsedits文件，是namenode的助手

## yarn

>  主节点 resourceManager ， yarn主节点端口号是8088

**resourceManager** :
**nodeManager** ： 

# 元数据

> 元数据就是描述数据的数据
> 数据字典表就是存储元素数据的表

> 注意：在数据库中将元数据存储在数据字典表中，也就是存储在磁盘文件中，但是在hdfs中，将元数据存储在内存中，因此对于主节点内存的要求就很高了，因此hdfs的缺点就是尽量不要存储小文件，减少元数据的产生

在hadoop生态圈中，对于hdfs中元数据是我们自己指定存储位置的，具体配置在hdfs-site.xml文件中

![enter description here][1]

在data目录下元数据存放在两个文件中，分别是fsimage和fsedits文件中


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722260643.jpg