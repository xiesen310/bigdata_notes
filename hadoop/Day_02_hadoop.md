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

**resourceManager** :在YARN中，ResourceManager负责集群中所有资源的统一管理和分配，它接收来自各个节点（NodeManager）的资源汇报信息，并把这些信息按照一定的策略分配给各个应用程序
**nodeManager** ：  NodeManager是运行在单个节点上的代理，它管理Hadoop集群中单个计算节点，功能包括与ResourceManager保持通信，管理Container的生命周期、监控每个Container的资源使用(内存、CPU等）情况、追踪节点健康状况、管理日志和不同应用程序用到的附属服务等。

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

## SecondaryNameNode工作流程

![Secondary NameNode工作流程图][5]

1. namenode 响应 Secondary namenode 请求，将 edit log 推送给 Secondary namenode ， 开始重新写一个新的 edit log 
2. Secondary namenode 收到来自 namenode 的 fsimage 文件和 edit log 
3. Secondary namenode 将 fsimage 加载到内存，应用 edit log ， 并生成一 个新的 fsimage 文件
4. Secondary namenode 将新的 fsimage 推送给 Namenode 
5. Namenode 用新的 fsimage 取代旧的 fsimage ， 在 fstime 文件中记下检查 点发生的时间

# HDFS读写操作原理

## 写操作

![enter description here][6]

![enter description here][7]

> 有一个文件FileA，100M大小。Client将FileA写入到HDFS上。
HDFS按默认配置。
HDFS分布在三个机架上Rack1，Rack2，Rack3。
 
a. Client将FileA按64M分块。分成两块，block1和Block2;
b. Client向nameNode发送写数据请求，如图蓝色虚线①------>。
c. NameNode节点，记录block信息。并返回可用的DataNode，如粉色虚线②--------->。
  >  Block1: host2,host1,host3
  > Block2: host7,host8,host4
	
 **原理**：
        NameNode具有RackAware机架感知功能，这个可以配置。
        若client为DataNode节点，那存储block时，规则为：副本1，同client的节点上；副本2，不同机架节点上；副本3，同第二个副本机架的另一个节点上；其他副本随机挑选。
        若client不为DataNode节点，那存储block时，规则为：副本1，随机选择一个节点上；副本2，不同副本1，机架上；副本3，同副本2相同的另一个节点上；其他副本随机挑选。
d. client向DataNode发送block1；发送过程是以流式写入。
  
**流式写入过程**
        1. 将64M的block1按64k的package划分;
        2. 然后将第一个package发送给host2;
        3. host2接收完后，将第一个package发送给host1，同时client向host2发送第二个package；
        4. host1接收完第一个package后，发送给host3，同时接收host2发来的第二个package。
        5. 以此类推，如图红线实线所示，直到将block1发送完毕。
        6. host2,host1,host3向NameNode，host2向Client发送通知，说“消息发送完了”。如图粉红颜色实线所示。
        7. client收到host2发来的消息后，向namenode发送消息，说我写完了。这样就真完成了。如图黄色粗实线
        8. 发送完block1后，再向host7，host8，host4发送block2，如图蓝色实线所示。
        9. 发送完block2后，host7,host8,host4向NameNode，host7向Client发送通知，如图浅绿色实线所示。
        10client向NameNode发送消息，说我写完了，如图黄色粗实线。。。这样就完毕了。
分析，通过写过程，我们可以了解到：
  > ① 写1T文件，我们需要3T的存储，3T的网络流量带宽。
  >  ② 在执行读或写的过程中，NameNode和DataNode通过HeartBeat进行保存通信，确定DataNode活着。如果发现DataNode死掉了，就将死掉的DataNode上的数据，放到其他节点去。读取时，要读其他节点去。
  > ③ 挂掉一个节点，没关系，还有其他节点可以备份；甚至，挂掉某一个机架，也没关系；其他机架上，也有备份。

## 写操作

![enter description here][8]

![enter description here][9]

> 读操作就简单一些了，如上图所示，client要从datanode上，读取FileA。而FileA由block1和block2组成。 
 
**读操作流程为**：

1. client向namenode发送读请求。
2. namenode查看Metadata信息，返回fileA的block的位置。
    > block1:host2,host1,host3
    > block2:host7,host8,host4

3. block的位置是有先后顺序的，先读block1，再读block2。而且block1去host2上读取；然后block2，去host7上读取；
 
上面例子中，client位于机架外，那么如果client位于机架内某个DataNode上，例如,client是host6。那么读取的时候，遵循的规律是：**优选读取本机架上的数据**

# HDFS通信协议

> 所有的 HDFS 通讯协议都是构建在 TCP/IP 协议上。客户端通过一个可 配置的端口连接到 Namenode，通过 ClientProtocol 与 Namenode 交互。而 Datanode 是使用 DatanodeProtocol 与 Namenode 交互。再设计上， DataNode 通过周期性的向 NameNode 发送心跳和数据块来保持和 NameNode 的通信，数据块报告的信息包括数据块的属性，即数据块属于哪 个文件，数据块 ID ，修改时间等， NameNode 的 DataNode 和数据块的映射 关系就是通过系统启动时 DataNode 的数据块报告建立的。从 ClientProtocol 和 Datanodeprotocol 抽象出一个远程调用 ( RPC ）， 在设计上， Namenode 不会主动发起 RPC ， 而是是响应来自客户端和 Datanode 的 RPC 请求。 


#  HDFS文件权限

HDFS文件权限与Linux文件权限类似
**r:read；w:write；x：execute**
> 如果Linux系统用用户xxx使用hadoop命令创建一个文件，那么，在hdfs中这个文件的owner就是xxx
HDFS的权限目的是将控制权交出去，本身只判断用户和权限，至于用户是不是真的，不管。


# HDFS安全模式

> NameNode是运行在安全模式的。即对外（客户端）只读，所以此段时间内对hdfs的写入、删除、重命名都会失败
> 可以通过命令进出安全模式 `hdfs dfadmin -safemode enter` and  `hdfs dfsadmin -safemode leave`

![enter description here][10]

![enter description here][11]

# HDFS中常用到的命令

hdfs dfs -ls / ：列举出根目录下的内容
hdfs dfs -mkdir /test ：创建文件夹
hdfs dfs -put htfstest.txt /test/ ： 上传文件
hdfs dfs -cat /test/htfstest.txt ： 读取文件
hdfs dfs -get /test/htfstest.txt /root/a.txt ：下载文件
hdfs dfs –help ：查看htfs文档
hdfs dfs -chmod 777 /test/htfstest.txt ：修改文件权限
hdfs dfs -checksum /test/htfstest.txt ：查看MD5信息
hdfs dfs –df ：查看磁盘利用率

 ![enter description here][12]

hdfs dfsadmin -safemode enter : 进入安全模式，安全模式只能读，不能写
hdfs dfsadmin -safemode leave ： 退出安全模式
hdfs fsck / ： 查看目录基本信息

start-balancer.sh : 负载均衡,可以使DataNode节点上选择策略重新平衡DataNode上的数据块的分布


# eclipse 连接hdfs

1. 下载eclipse连接htfs所需要的jar包，下载地址 [https://github.com/winghc/hadoop2x-eclipse-plugin/blob/master/release/hadoop-eclipse-plugin-2.6.0.jar][13]
2. 将下载好的jar包放在eclipse安装路径下的plugins文件下，启动eclipse
3. [window-->Show View --> Other]

![enter description here][14]

![enter description here][15]

4. 点击右上角的图标

![enter description here][16]


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722260643.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722403519.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722766859.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507723844586.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507722918519.jpg
  [6]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507724673557.jpg
  [7]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507724693853.jpg
  [8]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507724992792.jpg
  [9]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507724999865.jpg
  [10]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507725696306.jpg
  [11]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507725772309.jpg
  [12]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507725912851.jpg
  [13]: https://github.com/winghc/hadoop2x-eclipse-plugin/blob/master/release/hadoop-eclipse-plugin-2.6.0.jar
  [14]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507727376865.jpg
  [15]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507727449089.jpg
  [16]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1507727512779.jpg