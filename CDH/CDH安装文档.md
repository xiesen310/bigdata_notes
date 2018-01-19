---
title: CDH安装文档 
tags: CDH，安装教程
grammar_cjkRuby: true
---

# 概述

本文档描述CDH5.8在CentOS6.6操作系统上的安装部署过程。

Cloudera企业级数据中心的安装主要分为4个步骤：
1.	集群服务器配置，包括安装操作系统、关闭防火墙、同步服务器时钟等；
2.	外部数据库安装，通常使用mysql
3.	安装Cloudera Manager管理器；
4.	安装CDH集群；
5.	集群完整性检查，包括HDFS文件系统、MapReduce、Hive等是否可以正常运行。


本文档纪录大数据平台的安装过程并基于以下基本信息：
1.	操作系统版本：CentOS6.6
2.	MySQL数据库版本为5.6.30
3.	CM版本：CM 5.8.1
4.	CDH版本：CDH 5.8.0
5.	采用root对集群进行部署
6.	已经提前下载CDH和CM的安装包

# 安装文件准备

## 下载CDH文件

下载地址: [http://archive.cloudera.com/cdh5/parcels/5.8.0/][1]

![][2]

下载：CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel	
		  CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel.sha1
		  manifest.json

下载的cdh文件要与操作系统版本一致。如：CDH-5.8.0-1.cdh5.8.0.p0.42-el6.parcel中的 el6是指redhat6版本,因为我们本次安装使用redhat内核的CentOS6.6，所以下载el6的文件。

## 下载CM文件

下载地址[http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/5.8.1/RPMS/x86_64/][3]

![][4]

**全部下载**


# 服务器基本信息

## 配件信息

|   服务器名称  |  服务器ip   |  CPUs & RAM & Storage   | 操作系统    | 数量    |
| --- | --- | --- | --- | --- |
|  大数据平台   |  172.18.0.71   | E5-2603 v4 @ 1.70GHz    |   CentOS  |  3   |
|   服务器  |    172.18.0.73 |  & 256G & 600G SAS*2+2T SATA*6   |  6.6   |     |



## 服务器角色分布


|   角色名称  |  服务器   |  说明   |
| --- | --- | --- |
|   Cloudera Manager  |hadoop1     |  Cloudera平台管理工具   |
|   HDFS  | hadoop1/hadoop2/hadoop3    |  Hadoop分布式文件系统   |
|  Hive   |hadoop1/hadoop2/hadoop3     |   Hive数据库  |
| Hue    |hadoop3     |    图形化数据查询器 |
|   Oozie  |   hadoop3  |  流程调度   |
|    Spark |    hadoop1/hadoop2/hadoop3 | 分布式内存计算引擎    |
| Yarn    |  hadoop1/hadoop2/hadoop3   | 分布式资源调度   |
|   Zookeeper  |  hadoop1/hadoop2/hadoop3   |  分布式协调管理   |
|   JournalNodes  |hadoop1/hadoop2/hadoop3     |   HDFS HA  |


# 系统配置

## 	IP地址和主机名配置

目的：集群中各个节点之间能互相通信使用静态IP地址。

IP地址和主机名通过/etc/hosts配置，主机名/etc/HOSTNAME进行配置。

配置完成后，三台服务器对应IP地址和主机名：	
- 172.18.0.71	hadoop1
- 172.18.0.72	hadoop2
- 172.18.0.73	hadoop3

每台服务器的/etc/hosts文件如下:

![][5]

**注意**： 通常会在一台服务器上配置后分发到其它各个服务器，保证一致性。

## 关闭禁用防火墙

service iptables stop  --关闭掉iptables的服务

验证防火墙是否关闭：

service iptables status 

![][6]

	
chkconfig iptables off  --重启系统后iptables不会启动

验证结果：chkconfig | grep iptables ----正常结果都是off

该操作每台服务器都要做。
	
## 设置ssh免密码登录

主机SSH其他机器不需要访问密码，本次设定为hadoop1节点为主机。

1、主机执行：
ssh-keygen -t rsa -P '' 	---执行该命令，使用空密码

![][7]

-  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
 - chmod 700 ~/.ssh
 - chmod 600 ~/.ssh/authorized_keys
 
 2、将主机id_rsa.pub文件添加到各个从机authorized_keys中：
 
 - ssh-copy-id -i ~/.ssh/id_rsa.pub 172.18.0.72
 - ssh-copy-id -i ~/.ssh/id_rsa.pub 172.18.0.73

![][8]

3、从主机登陆其它节点验证：

![][9]

##  关闭selinux(强访问控制系统)

 vim /etc/sysconfig/selinux
将SELINUX= enforcing设置为：SELINUX=disabled

![][10]

> 该操作每台服务器都要做。

## 修改ulimits(打开文件数限制)

ulimit -n 检查是否是65535而不是默认的1024 否则执行如下三步配置：
- 执行 # ulimit -n 65535 
- 编辑/etc/security/limits.conf 最后增加如下两行记录：

``` shell
* soft nofile 65535
* hard nofile 65535 
```
- 编辑/etc/security/limits.d/90-nproc.conf
	将其中的1024也修改为65535

## 关闭swap

Swap会对系统的稳定性带来较大影响，一般hadoop生态圈均禁用swap。
所有节点执行：

``` shell
swapoff -a
```

## 修改transparent_hugepage 参数

这一参数默认值会导致CDH 性能下降

``` shell
vim /etc/grub.conf
设置：transparent_hugepage=never
```
![][11]

> 该操作每台服务器都要做。
> 完成后重启服务器。

## 配置ntp时间同步

目的：安装cloudera 环境检查时，如果时间不同步会有警告。

将172.18.0.71机器作为本地ntp服务器，其他2台机器与其保持同步，配置如下：
	

``` shell
172.18.0.71：
vim /etc/ntp.conf
```
其中，添加内容如下：

![][12]

其他机器：172.18.0.72/172.18.0.73

``` shell
vim /etc/ntp.conf
其中，添加内容如下：
```
![][13]

重启所有机器的ntp服务：

``` shell
service ntpd start; 
chkconfig ntpd on
```
验证始终同步：

![][14]

## 安装JDK

安装之前卸掉centos自带的jdk
下载地址： [http://www.oracle.com/technetwork/java/javaseproducts/downloads/index.html][15]

下载以tar.gz结尾的安装包
解压 `tar -zxvf 文件名`
配置环境变量
export PATH="/usr/java/jdk1.7.0_67-cloudera/bin:$PATH"。
保存退出后source /etc/profile并执行java -version验证java版本。

## 安装mysql

该操作在cloudera manager要运行的机器上安装，本次为hadoop1。

mysql的安装参考 [https://github.com/xiesen310/personal_notes/blob/master/Linux/Linux%E4%B8%8B%E5%AE%89%E8%A3%85%E7%A8%8B%E5%BA%8F.md][16]

> 设置root授权访问以上所有的数据库：

``` shell
#授权root用户在主节点拥有所有数据库的访问权限
grant all privileges on *.* to 'root'@'cdh1' identified by 'xxxx' with grant option;
flush privileges;
```


# 安装Cloudera Manager Server 和Agent 

## 主节点解压安装 

cloudera manager的目录默认位置在/opt下 <br/>
解压：`tar -xzvf cloudera-manager*.tar.gz` <br/>
将解压后的cm-5.3.3和cloudera目录放到/opt目录下。 <br/>
为Cloudera Manager 5建立数据库,首先需要去MySql的官网下载JDBC驱动，[http://dev.mysql.com/downloads/connector/j/][17] <br/>
解压后，找到mysql-connector-java-5.1.35-bin.jar，放到/opt/cm-5.3.3/share/cmf/lib/中。 <br/>
在主节点初始化CM5的数据库：

``` shell
/opt/cm-5.3.3/share/cmf/schema/scm_prepare_database.sh mysql cm -hlocalhost -uroot -pxxxx --scm-host localhost scm scm scm
```

## Agent配置 
修改/opt/cm-5.3.3/etc/cloudera-scm-agent/config.ini中的server_host为主节点的主机名。 
同步Agent到其他节点

``` shell
scp -r /opt/cm-5.3.3 root@n2:/opt/
```
在所有节点创建cloudera-scm用户

``` shell
useradd --system --home=/opt/cm-5.3.3/run/cloudera-scm-server/ --no-create-home --shell=/bin/false --comment "Cloudera SCM User" cloudera-scm
```
# 准备Parcels，用以安装CDH5 

将CHD5相关的Parcel包放到主节点的/opt/cloudera/parcel-repo/目录中（parcel-repo需要手动创建）。 
相关的文件如下：
- CDH-5.3.3-1.cdh5.3.3.p0.5-el6.parcel
- CDH-5.3.3-1.cdh5.3.3.p0.5-el6.parcel.sha1
- manifest.json

最后将CDH-5.3.3-1.cdh5.3.3.p0.5-el6.parcel.sha1，重命名为CDH-5.3.3-1.cdh5.3.3.p0.5-el6.parcel.sha，这点必须注意，否则，系统会重新下载CDH-5.3.3-1.cdh5.3.3.p0.5-el6.parcel.sha1文件。

## 相关启动脚本 

- 通过/opt/cm-5.3.3/etc/init.d/cloudera-scm-server start启动服务端。 
- 通过/opt/cm-5.3.3/etc/init.d/cloudera-scm-agent start启动Agent服务。 

> 我们启动的其实是个service脚本，需要停止服务将以上的start参数改为stop就可以了，重启是restart。 

## CDH5的安装配置 
Cloudera Manager Server和Agent都启动以后，就可以进行CDH5的安装配置了。 
这时可以通过浏览器访问主节点的7180端口测试一下了（由于CM Server的启动需要花点时间，这里可能要等待一会才能访问），默认的用户名和密码均为admin




  [1]: http://archive.cloudera.com/cdh5/parcels/5.8.0/
  [2]: ./images/1516352321214.jpg
  [3]: http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/5.8.1/RPMS/x86_64/
  [4]: ./images/1516357432901.jpg
  [5]: ./images/1516358498395.jpg
  [6]: ./images/1516358552805.jpg
  [7]: ./images/1516358623548.jpg
  [8]: ./images/1516358729628.jpg
  [9]: ./images/1516358747170.jpg
  [10]: ./images/1516358788820.jpg
  [11]: ./images/1516359005195.jpg
  [12]: ./images/1516359098004.jpg
  [13]: ./images/1516359133290.jpg
  [14]: ./images/1516359174365.jpg
  [15]: http://www.oracle.com/technetwork/java/javaseproducts/downloads/index.html
  [16]: https://github.com/xiesen310/personal_notes/blob/master/Linux/Linux%E4%B8%8B%E5%AE%89%E8%A3%85%E7%A8%8B%E5%BA%8F.md
  [17]: http://dev.mysql.com/downloads/connector/j/