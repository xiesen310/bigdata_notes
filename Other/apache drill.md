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

1. 下载文件 [apache-drill-1.13.0](http://www.apache.org/dyn/closer.lua?filename=drill/drill-1.13.0/apache-drill-1.13.0.tar.gz&action=download)
2. 解压 `tar -zxvf apache-drill-1.13.0`
3. 启动 `bin/drill-embedded`

## 分布式部署


# 测试案例

## 查询简介

Drill对于sql语句的支持很好，但是和标准的sql语句还是有区别的，可参考关系型数据库中的sql语句进行编写drill-sql。Drill提供了多种操作方式，其中包含shell操作和web页面操作。其中web查询界面的地址: [web查询地址](http://localhost:8047/)

![命令行操作界面](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1528860816308.jpg)

![web查询界面](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1528860866764.jpg)

![web查询结果展示界面](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1528860980391.jpg)

## parquet文件
支持parquet文件数据查询,nation.parquet文件在sample-data文件夹内。

``` sql
select * from dfs.`/root/apache-drill-1.13.0/sample-data/nation.parquet` limit 5;
```

## csv文件
csv格式的文件查询

csv源文件如下:

``` java
1101,SteveEurich,Steve,Eurich,16,StoreT
1102,MaryPierson,Mary,Pierson,16,StoreT
1103,LeoJones,Leo,Jones,16,StoreTem
1104,NancyBeatty,Nancy,Beatty,16,StoreT
1105,ClaraMcNight,Clara,McNight,16,Store
```
查询语句,也看可以器别名，语法和标准sql一样。

``` sql
select columns[0],columns[3] from dfs.`/root/apache-drill-1.13.0/sample-data/test.csv`;
```
## json文件

drill对于json的支持挺好的

下面是json模拟数据:

``` json
{
  "ka1": 1,
  "kb1": 1.1,
  "kc1": "vc11",
  "kd1": [
    {
      "ka2": 10,
      "kb2": 10.1,
      "kc2": "vc1010"
    }
  ]
}
{
  "ka1": 2,
  "kb1": 2.2,
  "kc1": "vc22",
  "kd1": [
    {
      "ka2": 20,
      "kb2": 20.2,
      "kc2": "vc2020"
    }
  ]
}
{
  "ka1": 3,
  "kb1": 3.3,
  "kc1": "vc33",
  "kd1": [
    {
      "ka2": 30,
      "kb2": 30.3,
      "kc2": "vc3030"
    }
  ]
}
```
查询语句

``` sql
select *  from dfs.`/root/apache-drill-1.13.0/sample-data/test.json`;

select sum(ka1),avg(kd1[0].kb2) from dfs.`/root/apache-drill-1.13.0/sample-data/test.json`;

select sum(ka1) as sum_ka1,avg(kd1[0].kb2) as avg_kb2 from dfs.`/root/apache-drill-1.13.0/sample-data/test.json`;
```
## join操作
 
 准备数据
 
 

``` java
// test1.csv 数据
1101,man
1102,woman
1103,man
1104,womqn

// test.csv数据
1101,SteveEurich,Steve,Eurich,16,StoreT
1102,MaryPierson,Mary,Pierson,16,StoreT
1103,LeoJones,Leo,Jones,16,StoreTem
1104,NancyBeatty,Nancy,Beatty,16,StoreT
1105,ClaraMcNight,Clara,McNight,16,Store
```
查询语句

``` sql
select tb.columns[0] as id,tb.columns[3] as name,tb.columns[4] as age,tb1.columns[1] as sex from dfs.`/root/apache-drill-1.13.0/sample-data/test.csv` as tb join dfs.`/root/apache-drill-1.13.0/sample-data/test1.csv` as tb1 on tb.columns[0] = tb1.columns[0];
```



