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
3. 配置环境变量 

``` xml
# set sqoop enviroment
export SQOOP_HOME=/opt/software/sqoop/sqoop-1.99.7-bin-hadoop200
export PATH=$PATH:$SQOOP_HOME/bin
export LOGDIR=$SQOOP_HOME/logs
export BASEDIR=$SQOOP_HOME/base
```

4. 

