---
title: Storm安装教程 
tags: storm
grammar_cjkRuby: true
---


# storm安装须知：

1. 检查java， Java-version
2. 检查python，至少是2.6.6
3. 安装zookeeper集群

# 下载安装

1. 下载  [http://www.apache.org/dyn/closer.lua/storm/apache-storm-1.1.1/apache-storm-1.1.1.tar.gz][1]
2. 解压 `tar -zxvf apache-storm-1.1.1.tar.gz`
3. 配置环境变量

``` shell
vim /etc/profile

export STORM_HOME=/opt/software/storm-1.1.1
export PATH=$PATH:$STORM_HOME/bin
```

# 配置storm

## 基础配置

1. storm.zookeeper.servers

``` shell
 storm.zookeeper.servers:
     - "master"
     - "slave1"
     - "slave2"
```

2. storm.local.dir

``` shell
nimbus.seeds: ["master"]
```

3. nimbus.seeds

``` shell
storm.local.dir: "/root/.storm"
```

4. supervisor.slots.ports

``` shell
 supervisor.slots.ports:
     - 6700
     - 6701
     - 6702
     - 6703
```
##  Supervisors健康监控配置(可选)

``` shell
storm.health.check.dir: "healthchecks"
storm.health.check.timeout.ms: 5000
```




  [1]: http://www.apache.org/dyn/closer.lua/storm/apache-storm-1.1.1/apache-storm-1.1.1.tar.gz