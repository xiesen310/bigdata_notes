---
title: MongoDB安装教程
tags: mongodb,安装教程
author: XieSen
time: 2018-6-27 
grammar_cjkRuby: true
---

mongdb一个NoSQL数据库，里面存储的是BSON（Binary Serialized Document Format)，支持集群，高可用、可扩展。

# 安装教程
## 创建普通用户

创建一个普通用户xiaoniu
useradd xiaoniu
#为hadoop用户添加密码：
echo 123456 | passwd --stdin xiaoniu

## 将bigdata添加到sudoers

``` shell
echo "xiaoniu ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/xiaoniu
chmod 0440 /etc/sudoers.d/xiaoniu
```


> 解决sudo: sorry, you must have a tty to run sudo问题，在/etc/sudoer注释掉 Default requiretty 一行
sudo sed -i 's/Defaults    requiretty/Defaults:xiaoniu !requiretty/' /etc/sudoers

## 配置mongo的yum源
sodu vi /etc/yum.repos.d/mongodb-org-3.4.repo

``` shell
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
```

## 关闭selinux

``` shell
vi /etc/sysconfig/selinux 
SELINUX=disabled
```
## 重新启动

``` shell
reboot
```
# mongo的安装和基本使用

