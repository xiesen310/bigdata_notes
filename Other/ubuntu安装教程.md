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
# 基础软件安装

1. 卸载jdk

``` shell
sudo apt-get remove openjdk*
```

2. 卸载自带的软件

``` shell
sudo apt-get remove libreoffice-common
sudo apt-get remove unity-webapps-common

sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install
sudo apt-get remove onboard deja-dup
```
3. 安装vim

``` shell
sudo apt-get install vim
```
4. 设置时间为UTC

``` shell
sudo vim /etc/default/rcS
将UTC=no改为UTC=yes
```
5. ubuntu 安装google浏览器

- 下载deb文件
- 安装google支持 sudo apt install libappdicator1 libdicator7
- 安装google浏览器 sudo dpkg –I deb文件
- 更新安装列表库，并且修复依赖关系Sudo apt –f install
6. ubuntu安装搜狗输入法
- 在语言支持中修改键盘输入法系统为fictix
- sudo dpkg –I sougou文件
- sudo apt –f install

7. 设置语言支持
system setting ---> language support ---> click add and remove language 添加 Chinese (Simple) ---> 将汉语拖拽到顶部 ---> 选择另一个选项卡，设置为中文 --->点击应用到整个系统
8. 设置任务栏在底部