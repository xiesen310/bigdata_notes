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


![时间同步配置2](https://www.github.com/xiesen310/notes_Images/raw/master/images/{year}-{month}/1531796797644.jpg)

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
OK，保存退出，请求服务器前，请先使用ntpdate手动同步下时间

``` shell
# ntpdate -u 192.168.0.135
 
22 Dec 17:09:57 ntpdate[6439]: adjust time server 192.168.1.135 offset 0.004882 sec
```
然后启动服务

``` shell
service ntpd start
```

## 配置开机启动

``` shell
chkconfig --level 35 ntpd on
```
