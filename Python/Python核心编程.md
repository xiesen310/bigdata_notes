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
Python 是动态类型语言， 也就是说不需要预先声明变量的类型。 变量的类型和值在赋值那一刻被初始化。变量赋值通过等号来执行。
``` python
>>> counter = 0
>>> miles = 100.0
>>> name = 'Bob'
>>> counter = counter + 1
>>> kilometers = 1.609 * miles
>>> print '%f miles is the same as %f km' % (miles,kilometers)
100.000000 miles is the same as 160.900000 km
>>> 
```
## Python 类型
### 数字
Python 支持五种基本数字类型，其中有三种是整数类型。
- int (有符号整数)
- long (长整数)
- bool (布尔值)
- float (浮点值)
- complex (复数)

### 字符串
Python 中字符串被定义为引号之间的字符集合。Python 支持使用成对的单引号或双引号，三引号（三个连续的单引号或者双引号）可以用来包含特殊字符。使用索引运算符( `[ ]`)和切片运算符( `[ : ]` )可以得到子字符串。字符串有其特有的索引规则：第一个字符的索引是 0，最后一个字符的索引是 －1，加号( + )用于字符串连接运算，星号( * )则用于字符串重复。

``` python
>>> pystr = 'Python'
>>> iscool = 'is cool!'
>>> pystr[0]
'P'
>>> pystr[2:5]
'tho'
>>> iscool[3:]
'cool!'
>>> iscool[-1]
'!'
>>> pystr + iscool
'Pythonis cool!'
>>> pystr + ' ' + iscool
'Python is cool!'
>>> pystr * 2
'PythonPython'
>>> '_' * 20
'____________________'
>>> pystr = '''python
... is cool '''
>>> pystr
'python\nis cool '
>>> print pystr
python
is cool 
>>> 
```

### 列表和元组
可以将列表和元组当成普通的“数组”，它能保存任意数量任意类型的Python 对象。和数组一样，通过从0 开始的数字索引访问元素，但是列表和元组可以存储不同类型的对象。列表和元组有几处重要的区别。列表元素用中括号( [ ])包裹，元素的个数及元素的值可以改变。元组元素用小括号(( ))包裹，不可以更改（尽管他们的内容可以）。元组可以看成是只读的列表。通过切片运算( `[ ]` 和 `[ : ]` )可以得到子集，这一点与字符串的使用方法一样。

``` python
>>> aList = [1,2,3,4]
>>> aList
[1, 2, 3, 4]
>>> aList[0]
1
>>> aList[2:]
[3, 4]
>>> aList[:3]
[1, 2, 3]
>>> aList[1] = 5
>>> aList
[1, 5, 3, 4]
>>> 
```
元组也可以进行切片运算，得到的结果也是元组（不能被修改）：

``` python
>>> aTuple = ('robots',77,93,'try')
>>> aTuple
('robots', 77, 93, 'try')
>>> aTuple[:3]
('robots', 77, 93)
>>> aTuple[1]
77
>>> aTuple[1] = 5
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'tuple' object does not support item assignment
>>> 
```
### 字典
字典是python中的映射数据类型，由键-值(key-value)对构成。几乎所有类型的Python 对象都可以用作键，不过一般还是以数字或者字符串最为常用。
值可以是任意类型的Python 对象，字典元素用大括号({ })包裹。

``` python
>>> aDict = {'host':'earch'} # create dict
>>> aDict['port'] = 80 # add to dict
>>> aDict
{'host': 'earch', 'port': 80}
>>> aDict.keys()
['host', 'port']
>>> aDict['host']
'earch'
>>> for key in aDict:
...   print key, aDict[key]
... 
host earch
port 80
>>> 
```

## 缩进
代码块通过缩进对齐表达代码逻辑而不是使用大括号，因为没有了额外的字符，程序的可读性更高。而且缩进完全能够清楚地表达一个语句属于哪个代码块。当然，代码块也可以只有一个语句组成。
## 循环与条件
### if 判断
``` python
>>> x = 1
>>> if x > 0:
...     print '"x" must be atleast 0!'
... 
"x" must be atleast 0!
>>> if x > 0:
...     print '"x > 0"'
... else :
...     print 'x <= 0'
... 
"x > 0"
>>> if x > 0:
...     print 'x > 0'
... elif x == 0:
...     print 'x = 0'
... else:
...     print 'x < 0'
... 
x > 0
>>> 
```
### while 循环

``` python
>>> counter  = 0
>>> while counter < 3:
...     print 'loop #%d' % (counter)
...     counter += 1
... 
loop #0
loop #1
loop #2
```
### for 循环

``` python
>>> for item in ['e-mail', 'net-surfing', 'homework', 'chat']:
...    print item
... 
e-mail
net-surfing
homework
chat
```
print自带换行，想不让换行，直接在print结尾加`，`即可

``` python
>>> for item in ['e-mail', 'net-surfing', 'homework', 'chat']:
...    print item,
... 
e-mail net-surfing homework chat
>>> 
```

## 文件
## 错误
## 函数
## 类
## 模块
