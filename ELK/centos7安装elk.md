---
title: centos7安装elk 
tags: elk,elasticsearch,logstash,kibana
author: XieSen
time: 2018-6-28 
grammar_cjkRuby: true
---

# elasticSearch安装

## 安装准备

为了运行ElasticSearch，第一步安装的是java，ElasticSearch需要Java7或更高的支持，建议使用java8.检查java版本的命令:`java -version`

## 安装ElasticSearch

当我们设置好java的环境之后，下载ElasticSearch，解压，安装完毕。下载地址:[elasticSearch-5-2-2](https://www.elastic.co/downloads/past-releases/elasticsearch-5-2-2)

## 配置

ElasticSearch配置文件在elasticsearch/config文件夹下，在这个文件夹内有三个文件，一个是elasticsearch配置不同模块的配置文件`elasticsearch.yml`，一个是elasticsearch的日志配置文件`log4j2.properties`，另一个是elasticsearch的jvm配置文件`jvm.options`。

``` yaml
# 集群名称
cluster.name: xs-es

# 节点名称
node.name: node-1

# 节点描述
#node.attr.rack: r1

# 索引存储位置
path.data: /home/elk/elk/elasticsearch-5.2.2/data

# 日志存储位置
path.logs: /home/elk/elk/elasticsearch-5.2.2/logs

# 内存分配模式
#bootstrap.memory_lock: true

# 绑定的网卡IP
network.host: 192.168.221.131

# http协议端口
http.port: 9200

# 开始发现新节点的IP地址
#discovery.zen.ping.unicast.hosts: ["host1", "host2"]

# 最多发现主节点的个数
#discovery.zen.minimum_master_nodes: 3

# 当重启集群节点后最少启动N个节点后开始做恢复
#gateway.recover_after_nodes: 3

# 当删除一个索引的时候，需要制定具体索引的名称
#action.destructive_requires_name: true
```

## 异常解决方案

异常描述一: `ERROR: bootstrap checks failed,max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144] `

解决方案:

1. 切换到root用户修改配置sysctl.conf `vi /etc/sysctl.conf`
2. 添加下面配置：`vm.max_map_count=655360`
3. 并执行命令：`sysctl -p`
4. 然后，重新启动elasticsearch，即可启动成功。

异常描述二: 

``` shell
max file descriptors [4096] for elasticsearch process likely too low, increase to at least [65536]
max number of threads [1024] for user [lishang] likely too low, increase to at least [2048]
```
解决方案:

``` shell
vi /etc/security/limits.conf 

添加如下内容:
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096
```
# kibana安装

kibana是elasticsearch的一个可视化工具，在学习的过程中可以使用kibana来进行api的练习。
 
 ## 安装kibana
 
 安装kibana的前提是我们必须安装配置了elasticsearch，当下我们已经安装好了elasticsearch，下一步是下载kibana，解压，安装完毕。
