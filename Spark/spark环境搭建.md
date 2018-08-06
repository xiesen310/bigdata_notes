---
title: spark环境搭建 
tags: spark,环境搭建
author: XieSen
time: 2018-8-6 
grammar_cjkRuby: true
---

# 虚拟机安装

## centos6.5安装
1. 我们安装的是CentOS-6.5-i386-minimal.iso。
2. 创建虚拟机：打开Virtual Box，点击“新建”按钮，点击“下一步”，输入虚拟机名称为spark1，选择操作系统为Linux，选择版本为Red Hat，分配1024MB内存，后面的选项全部用默认，在Virtual Disk File location and size中，一定要自己选择一个目录来存放虚拟机文件，最后点击“create”按钮，开始创建虚拟机。
3. 设置虚拟机网卡：选择创建好的spark1虚拟机，点击“设置”按钮，在网络一栏中，连接方式中，选择“Bridged Adapter”。
4. 安装虚拟机中的CentOS 6.5操作系统：选择创建好的虚拟机spark1，点击“开始”按钮，选择安装介质（即本地的CentOS 6.5镜像文件），选择第一项开始安装-Skip-欢迎界面Next-选择默认语言-Baisc Storage Devices-Yes, discard any data-主机名:spark1-选择时区-设置初始密码为hadoop-Replace Existing Linux System-Write changes to disk-CentOS 6.5自己开始安装。
5. 安装完以后，CentOS会提醒你要重启一下，就是reboot，你就reboot就可以了。

## centos6.5 网络配置

1. 先临时性设置虚拟机ip地址：ifconfig eth0 192.168.1.107，在/etc/hosts文件中配置本地ip（192.168.1.107）到host（spark1）的映射
2. 配置windows主机上的hosts文件：C:\Windows\System32\drivers\etc\hosts，192.168.1.107 hadoop1
3. 使用SecureCRT从windows上连接虚拟机，自己可以上网下一个SecureCRT的绿色版，网上很多。
4. 永久性配置CentOS网络

``` shell
vi /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.1.107
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
```
5. 重启网卡 `service network restart`
6. 即使更换了ip地址，重启网卡，可能还是联不通网。那么可以先将IPADDR、NETMASK、GATEWAY给删除，将BOOTPROTO改成dhcp。然后用service network restart重启网卡。此时linux会自动给分配一个ip地址，用ifconfig查看分配的ip地址。然后再次按照之前说的，配置网卡，将ip改成自动分配的ip地址。最后再重启一次网卡。

## centos6.5 防火墙和DNS配置

1. 关闭防火墙

``` shell
service iptables stop
chkconfig iptables off
vi /etc/selinux/config
SELINUX=disabled
```
自己在win7的控制面板中，关闭windows的防火墙！

2. 配置dns服务器

``` shell
vi /etc/resolv.conf
nameserver 61.139.2.69
ping www.baidu.com
```
## centos6.5yum配置

1. 修改repo
使用WinSCP（网上很多，自己下一个），将CentOS6-Base-163.repo上传到CentOS中的/usr/local目录下

``` shell
cd /etc/yum.repos.d/
rm -rf *
```

mv 自己的repo文件移动到/etc/yum.repos.d/目录中：`cp /usr/local/CentOS6-Base-163.repo` .
修改repo文件，把所有gpgcheck属性修改为0

2. 配置yum

``` shell
yum clean all
yum makecache
yum install telnet
```
## jdk1.7安装

1. 将jdk-7u60-linux-i586.rpm通过WinSCP上传到虚拟机中
2. 安装JDK：rpm -ivh jdk-7u65-linux-i586.rpm
3. 配置jdk相关的环境变量

``` shell
vi .bashrc
export JAVA_HOME=/usr/java/latest
export PATH=$PATH:$JAVA_HOME/bin
source .bashrc
```

4. 测试jdk安装是否成功：`java -version`
5. `rm -f /etc/udev/rules.d/70-persistent-net.rules`

## 配置集群ssh免密

1. 首先在三台机器上配置对本机的ssh免密码登录
生成本机的公钥，过程中不断敲回车即可，ssh-keygen命令默认会将公钥放在/root/.ssh目录下

``` shell
ssh-keygen -t rsa
# 将公钥复制为authorized_keys文件，此时使用ssh连接本机就不需要输入密码了
cd /root/.ssh
cp id_rsa.pub authorized_keys
```
2. 接着配置三台机器互相之间的ssh免密码登录
使用ssh-copy-id -i spark命令将本机的公钥拷贝到指定机器的authorized_keys文件中（方便好用）

# 安装hadoop包

1. 安装hadoop-2.4.1.tar.gz，使用WinSCP上传到CentOS的/usr/local目录下。
2. 将hadoop包进行解压缩：`tar -zxvf hadoop-2.4.1.tar.gz`
3. 对hadoop目录进行重命名：`mv hadoop-2.4.1 hadoop`
4. 配置hadoop相关环境变量

``` shell
vi .bashrc
export HADOOP_HOME=/usr/local/hadoop
export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin
source .bashrc
```
## 修改core-site.xml

``` shell
<property>
  <name>fs.default.name</name>
  <value>hdfs://spark1:9000</value>
</property>
```

## 修改hdfs-site.xml文件

``` shell
<property>
  <name>dfs.name.dir</name>
  <value>/usr/local/data/namenode</value>
</property>
<property>
  <name>dfs.data.dir</name>
  <value>/usr/local/data/datanode</value>
</property>
<property>
  <name>dfs.tmp.dir</name>
  <value>/usr/local/data/tmp</value>
</property>
<property>
  <name>dfs.replication</name>
  <value>3</value>
</property>
```

## 修改maperd-site.xml

``` shell
<property>
  <name>mapreduce.framework.name</name>
  <value>yarn</value>
</property>
```
## 修改yarn-site.xml

``` shell
<property>
  <name>yarn.resourcemanager.hostname</name>
  <value>spark1</value>
</property>
<property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
</property>
```

## 修改slaves

``` shell
spark1
spark2
spark3
```

## 在另外两台机器上搭建hadoop

1. 使用如上配置在另外两台机器上搭建hadoop，可以使用scp命令将spark1上面的hadoop安装包和.bashrc配置文件都拷贝过去。
2. 要记得对.bashrc文件进行source，以让它生效。
3. 记得在spark2和spark3的/usr/local目录下创建data目录。

## 启动hdfs集群

1. 格式化namenode：在spark1上执行以下命令，hdfs namenode -format
2. 启动hdfs集群：start-dfs.sh
3. 验证启动是否成功：jps、50070端口

spark1：namenode、datanode、secondarynamenode
spark2：datanode
spark3：datanode

## 启动yarn集群

1. 启动yarn集群：start-yarn.sh
2. 验证启动是否成功：jps、8088端口
spark1：resourcemanager、nodemanager
spark2：nodemanager
spark3：nodemanager

# 安装hive
1. 下载apache-hive-0.13.1-bin.tar.gz使用WinSCP上传到spark1的/usr/local目录下。
2. 解压缩hive安装包：tar -zxvf apache-hive-0.13.1-bin.tar.gz。
3. 重命名hive目录：mv apache-hive-0.13.1-bin hive
4. 配置hive相关的环境变量

``` shell
vi .bashrc
export HIVE_HOME=/usr/local/hive
export PATH=$HIVE_HOME/bin
source .bashrc
```
## 安装mysql

1、在spark1上安装mysql。
2、使用yum安装mysql server。

``` shell
yum install -y mysql-server
service mysqld start
chkconfig mysqld on
```
3、使用yum安装mysql connector
yum install -y mysql-connector-java
4、将mysql connector拷贝到hive的lib包中

``` shell
cp /usr/share/java/mysql-connector-java-5.1.17.jar /usr/local/hive/lib
```

5、在mysql上创建hive元数据库，并对hive进行授权

``` sql
create database if not exists hive_metadata;
grant all privileges on hive_metadata.* to 'hive'@'%' identified by 'hive';
grant all privileges on hive_metadata.* to 'hive'@'localhost' identified by 'hive';
grant all privileges on hive_metadata.* to 'hive'@'spark1' identified by 'hive';
flush privileges;
use hive_metadata;
```
## 配置hive-site.xml

``` shell
mv hive-default.xml.template hive-site.xml
vi hive-site.xml
<property>
  <name>javax.jdo.option.ConnectionURL</name>
  <value>jdbc:mysql://spark1:3306/hive_metadata?createDatabaseIfNotExist=true</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionDriverName</name>
  <value>com.mysql.jdbc.Driver</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionUserName</name>
  <value>hive</value>
</property>
<property>
  <name>javax.jdo.option.ConnectionPassword</name>
  <value>hive</value>
</property>
<property>
  <name>hive.metastore.warehouse.dir</name>
  <value>/user/hive/warehouse</value>
</property>
```

## 配置hive-site.sh和hive-config.sh

``` shell
mv hive-env.sh.template hive-env.sh

vi /usr/local/hive/bin/hive-config.sh
export JAVA_HOME=/usr/java/latest
export HIVE_HOME=/usr/local/hive
export HADOOP_HOME=/usr/local/hadoop
```

## 验证hive是否成功

直接输入hive命令，可以进入hive命令行


# zookeeper安装

## 下载zookeeper包

1. 下载zookeeper-3.4.5.tar.gz使用WinSCP拷贝到spark1的/usr/local目录下。
2. 对zookeeper-3.4.5.tar.gz进行解压缩：tar -zxvf zookeeper-3.4.5.tar.gz。
3. 对zookeeper目录进行重命名：mv zookeeper-3.4.5 zk。
4. 配置zookeeper相关的环境变量

``` shell
vi .bashrc
export ZOOKEEPER_HOME=/usr/local/zk
export PATH=$ZOOKEEPER_HOME/bin
source .bashrc
```
## 配置zoo.cfg

``` shell
cd zk/conf
mv zoo_sample.cfg zoo.cfg
```
vi zoo.cfg
修改：`dataDir=/usr/local/zk/data`
新增：

``` shell
server.0=spark1:2888:3888	
server.1=spark2:2888:3888
server.2=spark3:2888:3888
```
## 设置zk节点标识

``` shell
cd zk
mkdir data
cd data

vi myid
0
```
## 搭建zk集群

1. 在另外两个节点上按照上述步骤配置ZooKeeper，使用scp将zk和.bashrc拷贝到spark2和spark3上即可。
2. 唯一的区别是spark2和spark3的标识号分别设置为1和2。

## 启动zk集群

1. 分别在三台机器上执行：zkServer.sh start。
2. 检查ZooKeeper状态：zkServer.sh status

# kafka安装

## scala安装
1. 下载scala-2.11.4.tgz使用WinSCP拷贝到spark1的/usr/local目录下。
2. scala-2.11.4.tgz进行解压缩：`tar -zxvf scala-2.11.4.tgz`。
3. 对scala目录进行重命名：`mv scala-2.11.4 scala`
4. 配置scala相关的环境变量

``` shell
vi .bashrc
export SCALA_HOME=/usr/local/scala
export PATH=$SCALA_HOME/bin
source .bashrc
```
5. 查看scala是否安装成功：`scala -version`
6. 按照上述步骤在spark2和spark3机器上都安装好scala。使用scp将scala和.bashrc拷贝到spark2和spark3上即可。

## 安装kafka包

1. 下载kafka_2.9.2-0.8.1.tgz使用WinSCP拷贝到spark1的/usr/local目录下。
2. 对kafka_2.9.2-0.8.1.tgz进行解压缩：tar -zxvf kafka_2.9.2-0.8.1.tgz。
3. 对kafka目录进行改名：mv kafka_2.9.2-0.8.1 kafka
4. 配置kafka
vi /usr/local/kafka/config/server.properties
broker.id：依次增长的整数，0、1、2、3、4，集群中Broker的唯一id
zookeeper.connect=192.168.1.107:2181,192.168.1.108:2181,192.168.1.109:2181
5. 安装slf4j
将课程提供的slf4j-1.7.6.zip上传到/usr/local目录下
unzip slf4j-1.7.6.zip
把slf4j中的slf4j-nop-1.7.6.jar复制到kafka的libs目录下面

## 搭建kafka集群

1、按照上述步骤在spark2和spark3分别安装kafka。用scp把kafka拷贝到spark2和spark3行即可。
2、唯一区别的，就是server.properties中的broker.id，要设置为1和2

## 启动kafka集群

1、在三台机器上分别执行以下命令：`nohup bin/kafka-server-start.sh config/server.properties &`

2、解决kafka Unrecognized VM option 'UseCompressedOops'问题

``` shell
vi bin/kafka-run-class.sh 
if [ -z "$KAFKA_JVM_PERFORMANCE_OPTS" ]; then
  KAFKA_JVM_PERFORMANCE_OPTS="-server  -XX:+UseCompressedOops -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true"
fi
# 去掉-XX:+UseCompressedOops即可
```


3、使用jps检查启动是否成功







