---
title: ubuntu安装教程 
tags: 安装教程,ubuntu
grammar_cjkRuby: true
---

# ubuntu更换软件源
1. 备份系统本身文件

``` shell
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
```

2. 修改文件内容，将新的软件源写入文件

``` shell
sudo vim /etc/apt/sources.list
#下面是网易数据源的配置信息，如果需要其他的源配置信息，请自行百度。
deb http://mirrors.163.com/ubuntu/ precise main universe restricted multiverse
		deb-src http://mirrors.163.com/ubuntu/ precise main universe restricted multiverse
		deb http://mirrors.163.com/ubuntu/ precise-security universe main multiverse restricted
		deb-src http://mirrors.163.com/ubuntu/ precise-security universe main multiverse restricted
		deb http://mirrors.163.com/ubuntu/ precise-updates universe main multiverse restricted
		deb http://mirrors.163.com/ubuntu/ precise-proposed universe main multiverse restricted
		deb-src http://mirrors.163.com/ubuntu/ precise-proposed universe main multiverse restricted
		deb http://mirrors.163.com/ubuntu/ precise-backports universe main multiverse restricted
		deb-src http://mirrors.163.com/ubuntu/ precise-backports universe main multiverse restricted
		deb-src http://mirrors.163.com/ubuntu/ precise-updates universe main multiverse restricted
```

3. 保存文件，并刷新配置信息

``` shell
sudo apt-get update
sudo apt-get upgrade
```
