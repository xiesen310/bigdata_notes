---
title:  hadoop简介
tags: hadoop,bigdata,Java
grammar_cjkRuby: true
---

# hadoop
> Hadoop是Apache下的开源的一个基于分布式的生态系统,其实质我们可以认为是一个框架,使用Hadoop可以为我们解决如下问题:
1.海量数据的存储
2.海量数据的分析
3.资源管理调度 

> 作者是Doug Cutting,其创作的起因也是受到google的三篇论文的启发所开发的这三篇论文分别为GFS(分布式存储系统),MapReduce(分布式运算模型),BigTable(大型的数据库),受到启发开发出对应的HDFS(文件存储系统),MapReduce(分布式计算系统),HBase(分布式的NO-SQL数据库)

# HDFS

> 是Hadoop生态圈的一个分布式的文件存储,将海量的数据分布集群中的很多个数据节点上

# MapReduce

> 是Hadoop生态圈中的一个分布式数据分析框架,主要作用就是将我们的编写的计算的任务分发到集群中的节点上

# YARN

> 从Hadoop的版本1.x到版本2.x变化最大的就是YARN,在1.x版本中YARN框架是在在MapReduce中,为了是给我们写的MapReduce程序,分配cpu资源,内存资源和容器资源,在2.x中将YARN抽离出来,单独的负责资源的调度,而MapReduce只管理我们程序的运行机制(将数据任务分成map任务和Reduce任务),这样被抽离出来后,YARN就不仅仅能管理MapReduce任务,还能管理我们的spark(迭代内存计算)和storm(实时流式计算),这样就扩大了Hapoop的应用范围,使这个生态系统给其他框架提供了更多的支持

# 大量数据的存储和运算
## 数据存储的解决方案

### NFS存储结构
> NFS（Network File System）即网络文件系统，是FreeBSD支持的文件系统中的一种，它允许网络中的计算机之间通过TCP/IP网络共享资源。

