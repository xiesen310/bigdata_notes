---
title: Day22 sqoop 
tags: hadoop,sqoop
grammar_cjkRuby: true
---


# sqoop安装

1. 解压
2. 配置环境变量 
3. 修改hadoop中的core-site.xml

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


