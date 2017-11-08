---
title: Day22 sqoop 
tags: hadoop,sqoop
grammar_cjkRuby: true
---


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

![][1]


# sqoop下的object

- 基本信息
server
version

![][2]

- 核心对象

connector
> connector是支持sqoop的存储系统连接配置类型
> connector Name是sqoop默认支持的数据连接类型
> Supported Direction中`From/to`表示连接方式，From表示数据来源(导入)，To表示数据去向(导出)

driver
link
job
submission

- 参数信息
option|

- 权限信息
role
principal|
privilege


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510108602999.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510108914754.jpg