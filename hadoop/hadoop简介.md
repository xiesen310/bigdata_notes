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

![enter description here][1]

- 缺点1:在某个节点上上共享的数据并发量过高
- 缺点2:单一一个节点损坏,节点进行写操作的时候如何同步

### HDFS存储结构

![HDFS Architecture][2]

- 存放数据的节点称为Datanode
- 一个文件进行存储的时候会被分成很多的块(block)分散到集群中的各个节点中
- 每一个块可以在集群中存放多个副本,解决高可用的问题,并且多台机器可以同时并发的进行读取操作,提高效率
- 对于客户端只需知道文件的虚拟路径,而虚拟路径和真实存放的位置需要有映射关系,Namenode就是实现这个功能的,通过Namenode找到对应的Datanode进行读写操作

## 数据运算解决方案

> 如果有10个文件,每个文件有100G,按照512M进行切割,每个文件被分成200个块,分散到节点中,如何计算count *

- 方法1:用一台强悍的计算机,一个一个的去计算,并且还要经过网络进行数据的读取,效率很低
- 方法2:将计算的逻辑分发到所有的数据节点中,每个节点统计自己本地的block数据,此过程就是Mapreduce中map阶段,再通过网络将map阶段运行的中间结果取出,放在一个节点中,在通过我们写的这个程序进行求和的过程,这个过程就是Mapreduce的reduce阶段,叫做reduce的全局统计并发计算,同样reduce也可以进行分组并发操作

# 集群搭建

## 安装CentOS

- 安装CentOS6.5,注意虚拟机上的网络模式设置为NAT
- 设置ip地址为静态ip

![enter description here][3]

![enter description here][4]

![enter description here][5]

## 命令行界面修改ip地址

- `vi /etc/sysconfig/network-scripts/ifcfg-eth0` 编辑对应的配置文件

![enter description here][6]

- 重启生效 `reboot` 或者 `service network restart`

## 关闭linux的图形界面

- 一次关闭输入命令 `init 3`
- 修改系统配置文件 `vi /etc/inittab` ,5表示图形界面,3表示命令行界面,将 id:5 改为 id:3

## 普通用户执行sudo基本设置

- 输入命令 vi /etc/sudoers
- 添加当前用户
- wq! 进行退出

![enter description here][7]

## 修改主机名

- 输入命令 `vi /etc/sysconfig/network`

![enter description here][8]

- 输入命令  hostname bigdata 进行生效
- xshell中重新连接后,就能看到生效的主机名称

## 修改host文件

- `vi /etc/hosts`
- 添加域名和ip的映射关系

![enter description here][9]

## 安装jdk

- 安装到 `/opt/Software/Java` 下
- 配置环境变量 `vi /etc/profile`

``` xml
export JAVA_HOME=/opt/Software/Java/jdk1.8.0_141
export PATH=$PATH:$JAVA_HOME/bin
```
- 执行 `source /etc/profile`

## 安装Hadoop

- 下载地址 [https://archive.apache.org/dist/hadoop/common/][10]
- 创建/opt/Software/Hadoop文件夹
- 解压Hadoop
- 目录结构

![enter description here][11]

- 在 `share/hadoop` 是hadoop工程中的所需要的jar

![enter description here][12]

## 配置Hadoop

> hadoop的配置文件在`etc/hadoop`下

### 配置hadoop JAVA_HOME路径

- `vim hadoop-env.sh`

![enter description here][13]

### 编辑 core-site.xml
1.	配置hadoop的文件系统为HDFS文件系统

``` xml
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://hadoop01:9000</value>
</property
```

2.	配置hadoop的工作目录

``` xml
<property>
     <name>hadoop.tmp.dir</name>
     <value>/opt/software/hadoop/hadoop-2.7.3/tmp</value>
</property>
```
### 配置 hdfs-site.xml，指定副本数量

``` xml
<configuration>
    <property>
         <name>dfs.replication</name>
         <value>1</value>
    </property>
</configuration>
```
### 配置mapped-site.xml
1.	修改名字mv mapred-site.xml.template mapred-site.xml
2.	配置yarn

``` xml
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
</configuration>
```
### 配置yarn-site.xml

1. 配置resourcemanager的主机地址
2. 配置mapreduce程序以什么机制进行运行

``` xml
<configuration>
	<property>
		<name>yarn.resourcemanager.hostname</name>
		<value>hadoop01</value>
	</property>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>
</configuration>
```
### 关闭防火墙

``` xml
service iptables stop #关闭防火墙
chkconfig iptables off #开机不启动
```
### 配置环境变量

``` xml
# set hadoop environment
export HADOOP_HOME=/opt/software/hadoop/hadoop-2.7.3
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```
### 格式化

``` xml
hadoop namenode -format
```
### 启动hadoop


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507556677357.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507556727724.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507556959317.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507556975197.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507556999256.jpg
  [6]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557307816.jpg
  [7]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557208536.jpg
  [8]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557413846.jpg
  [9]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557486037.jpg
  [10]: https://archive.apache.org/dist/hadoop/common/
  [11]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557668946.jpg
  [12]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557699798.jpg
  [13]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507557915835.jpg