---
title: Redis cluster 集群理解
tags: redis,cluster,环境搭建
author: XieSen
time: 2018-5-6 
grammar_cjkRuby: true
---

1. [redis-cluster设计](#redis-cluster设计)
2. [redis集群的搭建](#redis集群的搭建)
	1. [安装redis节点指定端口](#安装redis节点指定端口)
	2. [安装redis-trib所需的 ruby脚本](#安装redis-trib所需的-ruby脚本)
	3. [启动所有的redis节点](#启动所有的redis节点)
	4. [使用redis-trib.rb创建集群](#使用redis-tribrb创建集群)
3. [redis集群的测试](#redis集群的测试)
4. [集群节点选举](#集群节点选举)

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

##  安装redis节点指定端口
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
![修改配置文件信息](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1525607705804.jpg)

##  安装redis-trib所需的 ruby脚本
复制redis解压文件src下的redis-trib.rb文件到redis-cluster目录

``` shell
      [root@localhost redis-cluster]# cp /usr/andy/redis/redis-3.2.0/src/redis-trib.rb ./  
```
安装ruby环境：

``` shell
[root@localhost redis-cluster]# yum install ruby  
[root@localhost redis-cluster]# yum install rubygems  
```
安装redis-trib.rb运行依赖的ruby的包redis-3.2.2.gem,[下载地址](https://zm12.sm-tc.cn/?src=l4uLj4zF0NCNip2GmJqSjNGYk5CdnpPRjIyT0ZmejIuThtGRmovQmJqSjNCNmpuWjNLM0c3RzdGYmpI%3D&uid=33d7587b1a43173009b5ca833db6ff6b&restype=1&from=derive&depth=2&wap=false&force=true&bu=web&v=1&link_type=12)

``` shell
gem install redis-3.2.2.gem  
```
##  启动所有的redis节点

  可以写一个命令脚本start-all.sh
  

``` shell
cd redis01  
  ./redis-server redis.conf  
  cd ..  
  cd redis02  
  ./redis-server redis.conf  
  cd ..  
  cd redis03  
  ./redis-server redis.conf  
  cd ..  
  cd redis04  
  ./redis-server redis.conf  
  cd ..  
  cd redis05  
  ./redis-server redis.conf  
  cd ..  
  cd redis06  
  ./redis-server redis.conf  
  cd ..  
```
设置权限启动

``` shell
[root@localhost redis-cluster]# chmod 777 start-all.sh   
[root@localhost redis-cluster]# ./start-all.sh   
```
查看redis进程启动状态

``` shell
 [root@localhost redis-cluster]# ps -ef | grep redis  
```
     root       4547      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7001 [cluster]  
      root       4551      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7002 [cluster]  
      root       4555      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7003 [cluster]  
      root       4559      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7004 [cluster]  
      root       4563      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7005 [cluster]  
      root       4567      1  0 23:12 ?        00:00:00 ./redis-server 127.0.0.1:7006 [cluster]  
      root       4840   4421  0 23:26 pts/1    00:00:00 grep --color=auto redis  
可以看到redis的6个节点已经启动成功

杀死全部的节点：

``` shell
[root@localhost redis-cluster]# pkill -9 redis
```


## 使用redis-trib.rb创建集群

``` shell
./redis-trib.rb create --replicas 1 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006  
```
使用create命令 --replicas 1 参数表示为每个主节点创建一个从节点，其他参数是实例的地址集合。

``` shell
[root@localhost redis-cluster]# ./redis-trib.rb create --replicas 1 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006  
>>> Creating cluster  
>>> Performing hash slots allocation on 6 nodes...  
Using 3 masters:  
127.0.0.1:7001  
127.0.0.1:7002  
127.0.0.1:7003  
Adding replica 127.0.0.1:7004 to 127.0.0.1:7001  
Adding replica 127.0.0.1:7005 to 127.0.0.1:7002  
Adding replica 127.0.0.1:7006 to 127.0.0.1:7003  
M: dfd510594da614469a93a0a70767ec9145aefb1a 127.0.0.1:7001  
slots:0-5460 (5461 slots) master  
M: e02eac35110bbf44c61ff90175e04d55cca097ff 127.0.0.1:7002  
slots:5461-10922 (5462 slots) master  
M: 4385809e6f4952ecb122dbfedbee29109d6bb234 127.0.0.1:7003  
slots:10923-16383 (5461 slots) master  
S: ec02c9ef3acee069e8849f143a492db18d4bb06c 127.0.0.1:7004  
replicates dfd510594da614469a93a0a70767ec9145aefb1a  
S: 83e5a8bb94fb5aaa892cd2f6216604e03e4a6c75 127.0.0.1:7005  
replicates e02eac35110bbf44c61ff90175e04d55cca097ff  
S: 10c097c429ca24f8720986c6b66f0688bfb901ee 127.0.0.1:7006  
replicates 4385809e6f4952ecb122dbfedbee29109d6bb234  
Can I set the above configuration? (type 'yes' to accept): yes  
>>> Nodes configuration updated  
>>> Assign a different config epoch to each node  
>>> Sending CLUSTER MEET messages to join the cluster  
Waiting for the cluster to join......  
>>> Performing Cluster Check (using node 127.0.0.1:7001)  
M: dfd510594da614469a93a0a70767ec9145aefb1a 127.0.0.1:7001  
slots:0-5460 (5461 slots) master  
M: e02eac35110bbf44c61ff90175e04d55cca097ff 127.0.0.1:7002  
slots:5461-10922 (5462 slots) master  
M: 4385809e6f4952ecb122dbfedbee29109d6bb234 127.0.0.1:7003  
slots:10923-16383 (5461 slots) master  
M: ec02c9ef3acee069e8849f143a492db18d4bb06c 127.0.0.1:7004  
slots: (0 slots) master  
replicates dfd510594da614469a93a0a70767ec9145aefb1a  
M: 83e5a8bb94fb5aaa892cd2f6216604e03e4a6c75 127.0.0.1:7005  
slots: (0 slots) master  
replicates e02eac35110bbf44c61ff90175e04d55cca097ff  
M: 10c097c429ca24f8720986c6b66f0688bfb901ee 127.0.0.1:7006  
slots: (0 slots) master  
replicates 4385809e6f4952ecb122dbfedbee29109d6bb234  
[OK] All nodes agree about slots configuration.  
>>> Check for open slots...  
>>> Check slots coverage...  
[OK] All 16384 slots covered.  
```
上面显示创建成功，有3个主节点，3个从节点，每个节点都是成功连接状态。
# redis集群的测试

1、测试存取值
客户端连接集群redis-cli需要带上 -c ，redis-cli -c -p 端口号

``` shell
[root@localhost redis01]# ./redis-cli -c -p 7001  
  127.0.0.1:7001> set name andy  
  -> Redirected to slot [5798] located at 127.0.0.1:7002  
  OK  
  127.0.0.1:7002> get name  
  "andy"  
```
根据redis-cluster的key值分配，name应该分配到节点7002[5461-10922]上，上面显示redis cluster自动从7001跳转到了7002节点。

我们可以测试一下7006从节点获取name值

``` shell
[root@localhost redis06]# ./redis-cli -c -p 7006  
  127.0.0.1:7006> get name  
  -> Redirected to slot [5798] located at 127.0.0.1:7002  
  "andy"  
  127.0.0.1:7002>  
```
7006位7003的从节点，从上面也是自动跳转至7002获取值，这也是redis cluster的特点，它是去中心化，每个节点都是对等的，连接哪个节点都可以获取和设置数据。

# 集群节点选举

 现在模拟将7002节点挂掉，按照redis-cluster原理会选举会将 7002的从节点7005选举为主节点。
 

``` shell
  [root@localhost redis-cluster]# ps -ef | grep redis  
      root       7950      1  0 12:50 ?        00:00:28 ./redis-server 127.0.0.1:7001 [cluster]  
      root       7952      1  0 12:50 ?        00:00:29 ./redis-server 127.0.0.1:7002 [cluster]  
      root       7956      1  0 12:50 ?        00:00:29 ./redis-server 127.0.0.1:7003 [cluster]  
      root       7960      1  0 12:50 ?        00:00:29 ./redis-server 127.0.0.1:7004 [cluster]  
      root       7964      1  0 12:50 ?        00:00:29 ./redis-server 127.0.0.1:7005 [cluster]  
      root       7966      1  0 12:50 ?        00:00:29 ./redis-server 127.0.0.1:7006 [cluster]  
      root      11346  10581  0 14:57 pts/2    00:00:00 grep --color=auto redis  
      [root@localhost redis-cluster]# kill 7952  
```

在查看集群中的7002节点

``` shell
[root@localhost redis-cluster]#   
  [root@localhost redis-cluster]# ./redis-trib.rb check 127.0.0.1:7002  
  [ERR] Sorry, can't connect to node 127.0.0.1:7002  
  [root@localhost redis-cluster]# ./redis-trib.rb check 127.0.0.1:7005  
  >>> Performing Cluster Check (using node 127.0.0.1:7005)  
  M: a5db243087d8bd423b9285fa8513eddee9bb59a6 127.0.0.1:7005  
  slots:5461-10922 (5462 slots) master  
  0 additional replica(s)  
  S: 50ce1ea59106b4c2c6bc502593a6a7a7dabf5041 127.0.0.1:7004  
  slots: (0 slots) slave  
  replicates dd19221c404fb2fc4da37229de56bab755c76f2b  
  M: f9886c71e98a53270f7fda961e1c5f730382d48f 127.0.0.1:7003  
  slots:10923-16383 (5461 slots) master  
  1 additional replica(s)  
  M: dd19221c404fb2fc4da37229de56bab755c76f2b 127.0.0.1:7001  
  slots:0-5460 (5461 slots) master  
  1 additional replica(s)  
  S: 8bb3ede48319b46d0015440a91ab277da9353c8b 127.0.0.1:7006  
  slots: (0 slots) slave  
  replicates f9886c71e98a53270f7fda961e1c5f730382d48f  
  [OK] All nodes agree about slots configuration.  
  >>> Check for open slots...  
  >>> Check slots coverage...  
  [OK] All 16384 slots covered.  
  [root@localhost redis-cluster]#   
```
 可以看到集群连接不了7002节点，而7005有原来的S转换为M节点，代替了原来的7002节点。我们可以获取name值:
 

``` shell
[root@localhost redis01]# ./redis-cli -c -p 7001  
127.0.0.1:7001> get name  
-> Redirected to slot [5798] located at 127.0.0.1:7005  
"andy"  
127.0.0.1:7005>   
127.0.0.1:7005>   
```
 从7001节点连入，自动跳转到7005节点，并且获取name值。
现在我们将7002节点恢复，看是否会自动加入集群中以及充当的M还是S节点。

``` shell
[root@localhost redis-cluster]# cd redis02  
[root@localhost redis02]# ./redis-server redis.conf   
[root@localhost redis02]#   
```
在check一下7002节点

``` shell
[root@localhost redis-cluster]# ./redis-trib.rb check 127.0.0.1:7002  
>>> Performing Cluster Check (using node 127.0.0.1:7002)  
S: 1f07d76585bfab35f91ec711ac53ab4bc00f2d3a 127.0.0.1:7002  
slots: (0 slots) slave  
replicates a5db243087d8bd423b9285fa8513eddee9bb59a6  
M: f9886c71e98a53270f7fda961e1c5f730382d48f 127.0.0.1:7003  
slots:10923-16383 (5461 slots) master  
1 additional replica(s)  
M: a5db243087d8bd423b9285fa8513eddee9bb59a6 127.0.0.1:7005  
slots:5461-10922 (5462 slots) master  
1 additional replica(s)  
S: 50ce1ea59106b4c2c6bc502593a6a7a7dabf5041 127.0.0.1:7004  
slots: (0 slots) slave  
replicates dd19221c404fb2fc4da37229de56bab755c76f2b  
S: 8bb3ede48319b46d0015440a91ab277da9353c8b 127.0.0.1:7006  
slots: (0 slots) slave  
replicates f9886c71e98a53270f7fda961e1c5f730382d48f  
M: dd19221c404fb2fc4da37229de56bab755c76f2b 127.0.0.1:7001  
slots:0-5460 (5461 slots) master  
1 additional replica(s)  
[OK] All nodes agree about slots configuration.  
>>> Check for open slots...  
>>> Check slots coverage...  
[OK] All 16384 slots covered.  
[root@localhost redis-cluster]#   
```
可以看到7002节点变成了a5db243087d8bd423b9285fa8513eddee9bb59a6 7005的从节点。