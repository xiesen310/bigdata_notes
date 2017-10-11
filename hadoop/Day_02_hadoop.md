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

==fsimage== 文件存放元数据的具体内容包含以下信息：文件名称、文件大小、路径、创建者、时间、文件的分块信息

==edits== 文件存放元数据的操作日志：创建一个文件、删除、修改，一操作记录的形式保存早edits里面

![enter description here][2]

# HDFS的启动过程

![HDFS架构图][3]

> 如上图所示，HDFS也是按照Master和Slave的结构。分NameNode、SecondaryNameNode、DataNode这几个角色。

- NameNode：是Master节点，是大领导。管理数据块映射；处理客户端的读写请求；配置副本策略；管理HDFS的名称空间；
- SecondaryNameNode：是一个小弟，分担大哥namenode的工作量；是NameNode的冷备份；合并fsimage和fsedits然后再发给namenode。
- DataNode：Slave节点，奴隶，干活的。负责存储client发来的数据块block；执行数据块的读写操作。

- 热备份：b是a的热备份，如果a坏掉。那么b马上运行代替a的工作。
- 冷备份：b是a的冷备份，如果a坏掉。那么b不能马上代替a工作。但是b上存储a的一些信息，减少a坏掉之后的损失。
- fsimage:元数据镜像文件（文件系统的目录树。）
- edits：元数据的操作日志（针对文件系统做的修改操作记录）
- namenode内存中存储的是=fsimage+edits。

SecondaryNameNode负责定时默认1小时，从namenode上，获取fsimage和edits来进行合并，然后再发送给namenode。减少namenode的工作量。

## HDFS启动

![enter description here][4]

> 当启动hdfs时加载加载namenode和datanode.

- 加载namenode
	- 首先加载fsimage文件
	- 加载fsedits文件
	- 当向hdfs中写数据时，fsedits文件会记录操作的过程，时间久了，就会产生大量的文件，当下次重新启动hdfs，hdfs会读取fsimage文件和fsedits文件，因为文件过大，需要读取很长时间。当然，这种现象不是我们想要看到的。因此，hdfs会将这些任务交给secondarynamenode进行监控，可以通过设置一段时间(默认是一个小时)内进行合并，也可以设置当文件达到默认值128M时，进行合并。secondarynamenode的工作原理见下文。

- 加载datanode信息，将datanode上存储的信息返回给namenode，其中包含当前节点上存储的数据块的信息

## Secondary NameNode工作流程

![Secondary NameNode工作流程图][5]

1. namenode 响应 Secondary namenode 请求，将 edit log 推送给 Secondary namenode ， 开始重新写一个新的 edit log 
2. Secondary namenode 收到来自 namenode 的 fsimage 文件和 edit log 
3. Secondary namenode 将 fsimage 加载到内存，应用 edit log ， 并生成一 个新的 fsimage 文件
4. Secondary namenode 将新的 fsimage 推送给 Namenode 
5. Namenode 用新的 fsimage 取代旧的 fsimage ， 在 fstime 文件中记下检查 点发生的时间


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722260643.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722403519.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722766859.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507723844586.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722918519.jpg