---
title: apache drill 
tags: drill,hadoop,查询引擎
author: XieSen
time: 2018-6-13 
grammar_cjkRuby: true
---

# 介绍

Drill 是 Apache 开源的，用于大数据探索的 SQL 查询引擎。她在大数据应用中，面对结构化数据和变化迅速的数据，她能够去兼容，并且高性能的去分析，同时，还提供业界都熟悉的标准的查询语言，即：ANSI SQL 生态系统。Drill 提供即插即用，在现有的 Hive 和 HBase中可以随时整合部署。

# 架构介绍

Apache Drill 是一个低延迟的大型数据集的分布式查询引擎，包括结构化和半结构化数据/嵌套。其灵感来自于谷歌的 Dremel，Drill 的设计规模为上千台节点并且能与 BI 或分析环境互动查询。

在大型数据集上，Drill 还可以用于短，交互式的临时查询。Drill 能够用于嵌套查询，像 JSON 格式，Parquet 格式以及动态的执行查询。Drill 不需要一个集中的元数据仓库。

# 高级架构

Drill包括分布式执行环境，目的用于大规模数据处理。在 Apache Drill 的核心服务是 "Drillbit"，她负责接受来自客户端的请求，处理请求，并返回结果给客户端。

Drillbit 服务能够安装在并运行在 Hadoop 集群上。当 Drillbit 运行在集群的每个数据节点上时，能够最大化去执行查询而不需要网络或是节点之间移动数据。Drill 使用 ZooKeeper 来维护集群的健康状态。

虽然 Drill 工作于 Hadoop 集群环境下，但是 Drill 不依赖 Hadoop，并且可以运行在任何分布式集群环境下。唯一的先决条件就是需要 ZooKeeper。

# 安装教程

## 本地模式安装


