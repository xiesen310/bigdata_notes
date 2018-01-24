---
title: Redis安装教程 
tags: redis,安装教程
grammar_cjkRuby: true
---

## 安装

1. 下载 [http://download.redis.io/releases/redis-3.2.11.tar.gz][1]
2. 解压 `tar -zxvf redis-3.2.11.tar.gz`
3. cd redis-3.2.11.tar.gz
4. make

## 启动

### 方式一

1. `cd src`
2. `./redis-server`

### 方式二
在redis.conf中绑定ip地址。例如：`bind 192.168.1.95`，使用这种方式进行启动，可以支持远程访问
1. `cd src`
2. `./redis-server redis.conf`

## 启动客户端

1. `cd src`
2. `./redic-cli`

## 检查是否安装成功

127.0.0.1 是本机 IP ，6379 是 redis 服务端口。现在我们输入 PING 命令。
``` shell
redis 127.0.0.1:6379> ping
PONG
```

  [1]: http://download.redis.io/releases/redis-3.2.11.tar.gz