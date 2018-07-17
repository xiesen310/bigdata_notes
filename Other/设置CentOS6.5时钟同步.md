---
title: 设置CentOS6.5时钟同步 
tags: centos6,时间同步,ntp
author: XieSen
time: 2018-7-17 
grammar_cjkRuby: true
---

## 测试ntp服务

``` shell
rpm -q ntp
```
## 编写配置文件

![时间同步配置1](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1531796757118.jpg)


![时间同步配置2](https://markdown.xiaoshujiang.com/img/spinner.gif "[[[1531796797644]]]" )

配置文件修改完成，保存退出，启动服务

``` shell
service ntp start
```
ntpstat 命令查看时间同步状态，这个一般需要5-10分钟后才能成功连接和同步。所以，服务器启动后需要稍等下。

## 配置其他节点

``` shell
driftfile /var/lib/ntp/drift
restrict 127.0.0.1
restrict -6 ::1
  
# 配置时间服务器为本地的时间服务器
server 192.168.1.135
  
restrict 192.168.1.135 nomodify notrap noquery
  
server  127.127.1.0     # local clock
fudge   127.127.1.0 stratum 10
  
includefile /etc/ntp/crypto/pw
  
keys /etc/ntp/keys
```
