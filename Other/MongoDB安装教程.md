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

## 在机器上使用xiaoniu用户登录

（本地安装给你了rpm包，rpm -ivh *.rpm）
sudo yum install -y mongodb-org

## 修改mongo的配置文件

``` shell
sudo vi /etc/mongod.conf 
```


## 注释掉bindIp或者修改成当前机器的某一个ip地址

## 启动mongo

``` shell
sudo service mongod start
```


#连接到mongo
#如果注释掉了bindIp，那么连接时用
mongo
#指定了ip地址
mongo --host 192.168.100.101 --port 27017

#使用或创建database
use xiaoniu

#创建集合（表）
db.createCollection("bike")

#插入数据
db.bike.insert({"_id": 100001, "status": 1, "desc": "test"})
db.bike.insert({"_id": 100002, "status": 1, "desc": "test"})

#查找数据(所有)
db.bine.find()

#退出
exit

#关闭mongo服务
sudu service mongod stop

#设置服务开机启动
sudo chkconfig mongod on

#设置mongo服务开机不启动
sudo chkconfig mongod off