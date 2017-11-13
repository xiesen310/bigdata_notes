---
title: scala简介
tags: scala,spark
grammar_cjkRuby: true
---

## scala之Hello World

![][1]

![][2]


## 强类型与弱类型的区别

强类型语言 ：定义对象或变量时们需要指定其归属类型，一旦一个变量类型确定，它所归属的类型不可改变

弱类型语言：定义变量时不用指定变量类型，在程序运行中，可以改变变量的归属类型


1. scala变量定义：
var str = "abcd"
这种写法不是没有指定str的类型，而是没有显式的指定str的类型，它隐式的从变量值中自动判断

显式写法：
var str:String = "abcd"

2. 声明变量有两种修饰符
var： 变量可被重新赋值
val(变量)不可被重新赋值
在编程中，能使用val的地方不使用var

3. 基础数据类型

java基础数据类型，它对应的变量，不是对象，不能通过“`.`”运算符来访问对象的方法。
scala对应的基础数据类型，对应的变量可使用"`.`"操作来访问对象的方法

``` scala
val a = 123
a.toDouble
a.toLong
```
scala字面量

``` scala
val intval = 23
val doubleval = 23.0
val floatval = 23L
val str =“aaa”
```
4. string 类型的字面量
 
``` scala
val s1 = "abcd"
 val s2 = "ab\"cd"
 val s3 = """ab".e0.*ed"""
```
字符串模板嵌套

``` scala
println(s"name:$name,age:$age")
println(s"name:$name",age:${age}aa")
println(s"""name:$name
	age:$age
	over
	"""
)
```
5. 基础数据类型之间的转换方法

对象.to类型

``` scala
123.toDouble
“123”.toInt
123.33.toString
```

6. scala中的运算符
scala中运算符不是语法，而是函数(对象)
`a + b ===> a.+(b)` 前者是后者的简写形式，当一个对象通过点调用其方法的时候，如果该方法只有一个参数，name点号可以省略，对象、方法、参数用空格隔开即可

==运算符(java)

``` java
enter code here
```

== 在scala中方法，这个方法等同于equal方法

``` scala
val a = new String("abc")
val b = new String("abc")
a == b
```

7. 标识符 符合java规范
类的标识符驼峰式命名首字母大写
变量 方法标识符，驼峰式命名，首字母小写
包表示符，全小写，层级使用点分隔

> 注意：val 在scala中虽然定义的是常量，但是一般使用变量的规则来命名标识符

8. 注释
和java中一样

9. if...else...

``` scala

```




  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510543129681.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510543347305.jpg