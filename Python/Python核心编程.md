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
和大部分脚本及Unix-shell 语言一样，Python 也使用 # 符号标示注释，从 # 开始，直到一行结束的内容都是注释。

``` python
>>> # one comment
... print 'Hello World!' # another comment
Hello World!
```
有一种叫做文档字符串的特别注释。你可以在模块、类或者函数的起始添加一个字符串，起到在线文档的功能，这是Java 程序员非常熟悉的一个特性。

``` python
def foo():
"This is a doc string."
return True
```
与普通注释不同，文档字符串可以在运行时访问，也可以用来自动生成文档。
## 操作符

和其他绝大多数的语言一样，Python 中的标准算术运算符以你熟悉的方式工作加、减、乘、除和取余都是标准运算符。Python 有两种除法运算符，单斜杠用作传统除法，双斜杠用作浮点除法（对结果进行四舍五入）。传统除法是指如果两个操作数都是整数的话，它将执行是地板除(取比商小的最大整数)，而浮点除法是真正的除法，不管操作数是什么类型，浮点除法总是执行真正的除法。真正的除法及浮点除法的知识,还有一个乘方运算符， 双星号`(**)`。尽管我们一直强调这些运算符的算术本质， 但是请注意对于其它数据类型，有些运算符是被重载了，比如字符串和列表。。让我们看一个例子：

``` python
>>> print -2 * 4 + 3 ** 2
1
>>> 
```
## 变量与赋值

## Python 类型
## 缩进
## 循环与条件
## 文件
## 错误
## 函数
## 类
## 模块
