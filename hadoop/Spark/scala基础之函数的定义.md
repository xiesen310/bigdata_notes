---
title: scala基础之函数的定义 
tags: scala
grammar_cjkRuby: true
---

## 函数的定义

> 函数的定义和对象的定义一样，编译器会通过返回值自动判断返回值，因此，在绝大数的函数定义，都不需要写返回值类型。智游一种情况例外：递归函数

``` scala
def functionName(x:Int,y:Int):Int = {
	x+y
}
```

在scala中，因为函数是对象，因此它的定义方式有很多
下面的定义是一个过程函数的定义，过程函数是没有返回值的，即返回值是Unit。只要函数这么定义它的返回值都是Unit，就算在函数体内写return，也不会有返回值

``` scala
def functionName(x:Int,y:Int) {
	x+y
}
```



