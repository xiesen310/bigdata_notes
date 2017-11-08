---
title: Day22 sqoop 
tags: hadoop,sqoop
grammar_cjkRuby: true
---


# sqoop安装

1. 解压
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
export PATH=$PATH:$SQOOP_HOME/bin
export LOGDIR=$SQOOP_HOME/logs
export BASEDIR=$SQOOP_HOME/base
```
 5. 配置sqoop加载的驱动的文件夹，也可以不配置，因为它默认加载lib下的jar，我们只需要将jar放在lib下面就可以了

``` xml
export SQOOP_SERVER_EXTRA_LIB=/var/lib/sqoop2/
```


