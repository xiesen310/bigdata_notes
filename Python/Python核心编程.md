---
title: Python核心编程
tags: python,语言,基础
author: XieSen
time: 2018-5-6 
grammar_cjkRuby: true
---

# python起步
## 介绍

> Python 有两种主要的方式来完成你的要求：语句和表达式（函数、算术表达式等）。相信大部分读者已经了解二者的不同，但是不管怎样，我们还是再来复习一下。语句使用关键字来组成命令，类似告诉解释器一个命令。你告诉Python 做什么，它就为你做什么，语句可以有输出，也可以没有输出。下面我们先用print 语句完成程序员们老生常谈第一个编程实例，Hello World:

``` python
>>> print 'Hello World!'
Hello World!
>>> abs(-4)
4
>>> abs(4)
4
```
## 输入/输出

**print之重定向到文件**

``` python
logfile = open('/tmp/mylog.txt', 'a')
print >> logfile, 'Fatal error: invalid input!'
logfile.close()
```
> 注意: 上述实例，当logfile.close执行之后，内容重定向写入mylog.txt文件

**raw_input(),读取标准输入**

``` python
>>> user = raw_input('Enter login name: ')
Enter login name: root
>>> print 'Your login is:', user
Your login is: root
>>> 
```
上面这个例子只能用于文本输入。 下面是输入一个数值字符串(并将字符串转换为整数）的例子：

``` python
>>> num = raw_input('Now enter a number: ')
Now enter a number: 1024
>>> print 'Doubling your number : %d' % (int(num) * 2)
Doubling your number : 2048
```
**从交互式解释器中获得帮助**
在学习 Python 的过程中，如果需要得到一个生疏函数的帮助，只需要对它调用内建函数help()。通过用函数名作为 help()的参数就能得到相应的帮助信息：

``` python
help(raw_input)
Help on built-in function raw_input in module __builtin__:
raw_input(...)
    raw_input([prompt]) -> string
```

## 注释

## 操作符
## 变量与赋值
## Python 类型
## 缩进
## 循环与条件
## 文件
## 错误
## 函数
## 类
## 模块
