---
title: Day22 sqoop 
tags: hadoop,sqoop
grammar_cjkRuby: true
---

# sqoop
> sqoop是Apache顶级项目，主要用来在Hadoop和关系数据库中传递数据。通过sqoop，我们可以方便的将数据从关系数据库导入到HDFS，或者将数据从HDFS导出到关系数据库。

**sqoop架构**

![sqoop架构示意图][1]

Sqoop工具接收到客户端的shell命令或者Java api命令后，通过Sqoop中的任务翻译器(Task Translator)将命令转换为对应的MapReduce任务，而后将关系型数据库和Hadoop中的数据进行相互转移，进而完成数据的拷贝。
# sqoop安装

1. 解压 `tar -zxvf  sqoop-1.99.7-bin-hadoop200.tar.gz`
2. 修改hadoop中的core-site.xml

``` xml
<property>
  <name>hadoop.proxyuser.sqoop2.hosts</name>
  <value>*</value>
</property>
<property>
  <name>hadoop.proxyuser.sqoop2.groups</name>
  <value>*</value>
</property>
```

3. 在【/opt/software/sqoop/sqoop-1.99.7-bin-hadoop200/conf】下修改sqoop.properties

``` xml
# Hadoop configuration directory
org.apache.sqoop.submission.engine.mapreduce.configuration.directory=/opt/software/hadoop/hadoop
-2.7.4/etc/hadoop
```
4. 配置环境变量 

``` xml
# set sqoop enviroment

export SQOOP_HOME=/opt/software/sqoop/sqoop-1.99.7-bin-hadoop200
# set JDBC drivers to this directory
export SQOOP_SERVER_EXTRA_LIB=$SQOOP_HOME/extra
export PATH=$PATH:$SQOOP_HOME/bin
export LOGDIR=$SQOOP_HOME/logs
export BASEDIR=$SQOOP_HOME/base
```
 5. 配置sqoop加载的驱动的文件夹，也可以不配置，因为它默认加载lib下的jar，我们只需要将jar放在lib下面就可以了

``` xml
export SQOOP_SERVER_EXTRA_LIB=/var/lib/sqoop2/
```

6. 初始化sqoop `sqoop2-tool upgrade`
7. 检查是否初始化成功  `sqoop2-tool verify`
8. 启动sqoop服务 `sqoop2-server start` 关闭sqoop服务 `sqoop2-server stop`
9. 连接client `sqoop2-shell`

![][2]


# sqoop下的object

## 基本信息
server
version

![][3]

## 核心对象

connector
> connector是sqoop当前支持的存储系统连接配置类型
> connector Name是sqoop默认支持的数据连接类型
> Supported Direction中`From/to`表示连接方式，From表示数据来源(导入)，To表示数据去向(导出)

![][4]
driver ： 驱动配置信息，在此查看

![][5]

link、job数据导入导出配置对象
link：配置具体的存储连接，他是以connecter作为类型的
比如某个jdbc数据库的连接，某个hdfs集群的连接等等
job 配置一次导入导出过程的全部细节信息，它是以link作为输入输出的，通常用`from link1 to link2` 表示把link1中的数据导入到link2中
导出数据的具体制定在job里面配置


submission ：查看当前已提交的sqoop导入导出任务

## 参数信息
option

![][6]
## 权限信息
role
principal|
privilege


# 将mysql中的数据导入到hadoop平台


## 创建mysql link

![][7]

将connection String的值改为jdbc:mysql://master:3306/hive,否则会报错

查看link `show link`
connection Properties：数据库的配置参数，可以不写
Identifier enclose：标识符的封装符号，mysql中使用反引号作为标识符 `·`，sqoop中默认的是逗号。

## 创建hdfs link

![][8]


## 创建job

![][9]

查看job `show job`


查看提交的状态信息，需要用到jobhistory服务，下面是启动过程
启动jobhistory

``` xml
mr-jobhistory-daemon.sh start historyserver
```
update link -n localmysql
show link -n localmysql

## 启动sqoop job

启动命令 `start job -n mysql2hdfsjob`
启动成功界面

![][10]

## 启动异常
启动job时，出现链接不上的现象，查看日志，看是否是权限问题

![][11]

![][12]

![][13]

# 将hdfs上的数据导入到mysql数据库




  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510114839464.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510108602999.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510108914754.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510109418562.jpg
  [5]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510109468320.jpg
  [6]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510115138849.jpg
  [7]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510110814293.jpg
  [8]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510111284476.jpg
  [9]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510112455271.jpg
  [10]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510127872035.jpg
  [11]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510125422830.jpg
  [12]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510125368817.jpg
  [13]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510127071077.jpg