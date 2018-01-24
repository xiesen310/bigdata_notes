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

1. `cd src`
2. `./redis-server redis.conf`

  [1]: http://download.redis.io/releases/redis-3.2.11.tar.gz