---
title: Redis cluster 集群理解
tags: redis,cluster,环境搭建
author: XieSen
time: 2018-5-6 
grammar_cjkRuby: true
---

# redis-cluster设计
      Redis集群搭建的方式有多种，例如使用zookeeper等，但从redis 3.0之后版本支持redis-cluster集群，Redis-Cluster采用无中心结构，每个节点保存数据和整个集群状态,每个节点都和其他所有节点连接。其redis-cluster架构图如下：

![redis cluster 架构示意图](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1525607528113.jpg)
      其结构特点：

      1、所有的redis节点彼此互联(PING-PONG机制),内部使用二进制协议优化传输速度和带宽。
      2、节点的fail是通过集群中超过半数的节点检测失效时才生效。
      3、客户端与redis节点直连,不需要中间proxy层.客户端不需要连接集群所有节点,连接集群中任何一个可用节点即可。
      4、redis-cluster把所有的物理节点映射到[0-16383]slot上（不一定是平均分配）,cluster 负责维护node<->slot<->value。

      5、Redis集群预分好16384个桶，当需要在 Redis 集群中放置一个 key-value 时，根据 CRC16(key) mod 16384的值，决定将一个key放到哪个桶中。

         1、redis cluster节点分配
      现在我们是三个主节点分别是：A, B, C 三个节点，它们可以是一台机器上的三个端口，也可以是三台不同的服务器。那么，采用哈希槽 (hash slot)的方式来分配16384个slot 的话，它们三个节点分别承担的slot 区间是：
      节点A覆盖0－5460;
      节点B覆盖5461－10922;
      节点C覆盖10923－16383.

      获取数据：

      如果存入一个值，按照redis cluster哈希槽的算法： CRC16('key')384 = 6782。 那么就会把这个key 的存储分配到 B 上了。同样，当我连接(A,B,C)任何一个节点想获取'key'这个key时，也会这样的算法，然后内部跳转到B节点上获取数据 

      新增一个主节点：

      新增一个节点D，redis cluster的这种做法是从各个节点的前面各拿取一部分slot到D上，我会在接下来的实践中实验。大致就会变成这样：

      节点A覆盖1365-5460
      节点B覆盖6827-10922
      节点C覆盖12288-16383
      节点D覆盖0-1364,5461-6826,10923-12287
      同样删除一个节点也是类似，移动完成后就可以删除这个节点了。

           2、Redis Cluster主从模式
      redis cluster 为了保证数据的高可用性，加入了主从模式，一个主节点对应一个或多个从节点，主节点提供数据存取，从节点则是从主节点拉取数据备份，当这个主节点挂掉后，就会有这个从节点选取一个来充当主节点，从而保证集群不会挂掉。
      上面那个例子里, 集群有ABC三个主节点, 如果这3个节点都没有加入从节点，如果B挂掉了，我们就无法访问整个集群了。A和C的slot也无法访问。
      所以我们在集群建立的时候，一定要为每个主节点都添加了从节点, 比如像这样, 集群包含主节点A、B、C, 以及从节点A1、B1、C1, 那么即使B挂掉系统也可以继续正确工作。
      B1节点替代了B节点，所以Redis集群将会选择B1节点作为新的主节点，集群将会继续正确地提供服务。 当B重新开启后，它就会变成B1的从节点。
      不过需要注意，如果节点B和B1同时挂了，Redis集群就无法继续正确地提供服务了。

# redis集群的搭建
 集群中至少应该有奇数个节点，所以至少有三个节点，每个节点至少有一个备份节点，所以下面使用6节点（主节点、备份节点由redis-cluster集群确定）。
下面使用redis-3.2.0安装，下载地址  
解压redis压缩包，编译安装

``` shell
[root@localhost redis-3.2.0]# tar xzf redis-3.2.0.tar.gz  
[root@localhost redis-3.2.0]# cd redis-3.2.0  
[root@localhost redis-3.2.0]# make  
[root@localhost redis01]# make install PREFIX=/usr/andy/redis-cluster
```
  在redis-cluster下 修改bin文件夹为redis01,复制redis.conf配置文件
  配置redis的配置文件redis.conf
  

``` shell
daemonize yes #后台启动
port 7001 #修改端口号，从7001到7006
cluster-enabled yes #开启cluster，去掉注释
cluster-config-file nodes.conf
cluster-node-timeout 15000
appendonly yes
复制六份，修改对应的端口号
```
