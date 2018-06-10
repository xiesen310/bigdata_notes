---
title: centos7命令
tags: centos7,centos
author: XieSen
time: 2018-6-10 
grammar_cjkRuby: true
---

查看ip地址: ip addr
修改网络:
	vi /etc/sysconfig/network-scripts/ifcfg-ens33

``` shell
	TYPE=Ethernet
	BOOTPROTO=static
	NAME=ens33
	DEVICE=ens33
	ONBOOT=yes
	IPADDR=192.168.101.11
	NETMASK=255.255.255.0
	GATEWAY=192.168.101.2
	DNS1=8.8.8.8
```

重新启动网络:
	通用方式:`service network restart`
	centos7推荐使用:`systemctl restart network`

修改主机名:
	centos7版本: `hostnamectl set-hostname node-1`
	通用版本: `vi /etc/hostname`

查看防火墙的状态: `systemctl status firewalld`
关闭防火墙:`systemctl stop firewalld`
设置防火墙开机不启动: `systemctl disable firewalld`
