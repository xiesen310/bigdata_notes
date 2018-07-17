---
title: ambari搭建hadoop集群
tags: ambari,hadoop
author: XieSen
time: 2018-7-16 
grammar_cjkRuby: true
---

ambari的安装、配置与启动

1. 集群规划

在这里我们只是测试，和真正的集群环境是不一样的，在这里我们使用的操作系统是Centos6.5版本，JDK版本1.8.0_161，python2.6.6版本服务器的hostname分别为server1.cluster.com、server2.cluster.com、server3.cluster.com，使用server1.cluster.com作为集群的主节点。

2. 搭建本地yum源仓库

安装Ambari系统本身是通过Ambari安装HDP发行版中的Hadoop服务器要通过yum的方式进行安装。并且在企业的内部部署集群环境也是在没有网的环境下进行部署的。HDP的文件多达几个G，通过yum在线安装也是不可能的。

1.1 下载离线安装包
因为是离线安装，所以我们需要首先下载Ambari和HDP的离线安装包。这里我们使用的是Ambari2.4和HDP2.5，下载地址如下:

|   Ambari-2.4  |wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.4.0.1/ambari-2.4.0.1-centos6.tar.gz      |
| --- | --- |
|   HDP2.5  | wget http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.5.0.0/HDP-2.5.0.0-centos6-rpm.tar.gz    |
|  HDP-UTILS   |    wget http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos6/HDP-UTILS-1.1.0.21-centos6.tar.gz |


1.2 安装Apache服务器
这里我们使用Apache来当作HTTP服务器。我们直接使用yum的方式进行安装`yum install httpd`。
安装之后就是启动Apache服务了。 `/etc/init.d/httpd start`
现在我们进入在apache的静态资源目录 `cd /var/www/html`,然后新建ambari和hdp文件夹`mkdir ./hdp; mkdir ./ambari`

1.3 创建yum源配置文件
	为了能够让yum命令找到我们安装的文件，还需要新建两个仓库的配置文件。首先新建一个名为ambari.repo的配置文件，配置项如下:
	

``` shell
#VERSION_NUMBER=2.4.1.0-22

[Ambari-2.4.1.0]
name=Ambari-2.4.1.0
baseurl=http://server1.cluster.com/ambari/AMBARI-2.4.1.0/centos6/2.4.1.0-22
gpgcheck=1
gpgkey=http://server1.cluster.com/ambari/AMBARI-2.4.1.0/centos6/2.4.1.0-22/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1
```
然后新建一个名为hdp.repo的配置文件，配置项如下:

``` shell
#VERSION_NUMBER=2.4.1.0-22

[Ambari-2.4.1.0]
name=Ambari-2.4.1.0
baseurl=http://server1.cluster.com/ambari/AMBARI-2.4.1.0/centos6/2.4.1.0-22
gpgcheck=1
gpgkey=http://server1.cluster.com/ambari/AMBARI-2.4.1.0/centos6/2.4.1.0-22/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins
enabled=1
priority=1
[root@server1 ~]# cat hdp.repo
#VERSION_NUMBER=2.5.0.0-1245
[HDP-2.5.0.0]
name=HDP-2.5.0.0
baseurl=http://server1.cluster.com/hdp/HDP/centos6
path=/
enabled=1
gpgcheck=0

[HDP-UTILS-2.5.0.0]
name=HDP-UTILS-2.5.0.0
baseurl=http://server1.cluster.com/hdp/HDP-UTILS-1.1.0.21
path=/
gpgcheck=0
enabled=1
```
最后将这两个配置文件复制到所有准备安装hadoop组件的机器上的/etc/yum.repos.d目录下。
现在可以执行 `yum repolist` 命令检查一下配置是否正确，如果能够看到ambari2.4.0.1 和HDP2.5.0.0两个yum源就表明配置成功了。如果看不到要检查一下/etc/yum.repos.d目录下是否存在ambari.repo和hdp.repo两个配置为文件。

3. 关闭防火墙和SELinux

``` shell
service iptables stop # 关闭防火墙
chkconfig iptables off 检查防火墙是否已经关闭
打开/etc/selinux/config,修改SELINUX=disabled来禁用SELinux。此项修改需要重启服务器之后才能生效。
```

4. 配置主机表

Ambari所管理的各个服务器之间需要使用FQDN来进行访问，所以我们为各个服务器配置他们的FQDN。linux系统可以通过主机表来配置它的FQDN，执行 `vi /etc/hosts`

``` shell
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.10.128  server1.cluster.com server1
192.168.10.129  server2.cluster.com server2
192.168.10.130  server3.cluster.com server3
```

5. 安装Ambari-Server

虽然Ambari系统是由Ambari-server和Ambari-agent两个部分组成。但是手动安装的时候只需要关注Ambari-server就可以了，因为Ambari-Agent程序在通过Ambari系统新建集群的过程中会自动安装。
我们已将在本地搭建了yum源，在这里安装就比较简单了，执行`yum install ambari-server -y`命令进行安装。之后便会进入到自动安装的步骤。在安装的过程中会出现错误。提示需要postgrepsql-server，且版本需要大于8.1.这是因为Ambari默认通过postgresql数据库来保存它大的元数据信息。所有我们还需要安装postgrepsql数据库，执行`yum install postgrepsql-server`命令安装。
安装之后重新执行 `yum install ambari-server -y`即可顺利安装
6. 配置Ambari-Server


7. 启动Ambari-Server
