---
title: scala基础之函数的定义 
tags: scala
grammar_cjkRuby: true
---

## 函数的定义

> 函数的定义和对象的定义一样，编译器会通过返回值自动判断返回值，因此，在绝大数的函数定义，都不需要写返回值类型。只有一种情况例外：递归函数

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
如果定义函数时把函数的类型指定为Unit，那么不管该函数的语句块的最后一句是什么，该函数的返回值始终是Unit()

## 函数类型

> 因为scala中函数是一等公民，因此它和对象一样也有自己的类型
> 因为函数中涉及的类型包含参数的类型，返回值类型，因此函数的类型就用参数类型和返回值类型共同定义

如：

``` scala
def plusInt(x : Int,y:Int) = {
x + y
}
```

那么该函数有两个参数都是Int，有一个返回值也是Int，那么在scala中的函数类型描述是(Int,Int)=>Int
其中=>符号分隔参数定义(输入)类型和返回值(输出)类型

## 函数字面量(匿名函数)

函数的字面量也是使用=> 进行来定定义，左边是参数(输入)，右边是参数(输出)

``` scala
val plusIntVal: (Int, Int) => Int = (x, y) => x + y
val plusIntVal1 = (x:Int,y:Int) => x + y
```

def 定义的函数不可以被当做函数进行传递
val 定义的函数可以被当做函数进行传递
val定义的函数名称，后面不加小括号代表的是对函数的引用，后面加小括号代表的是对函数的调用

## 函数当做参数进行传递

``` scala
// 求圆面积的函数 (Int) => Double
  val roundArea = (r: Int) => {
    println(s"计算圆的面积：${3.14 * r * r}")
    3.14 * r * r
  }

  // 求正方形的面积 (Int) => Double
  val squareArea = (l: Int) => {
    println(s"计算正方形的面积: ${l * l * 1.00}")
    l * l * 1.00
  }
   // 计算圆的面积
    caculateArea(4, roundArea)
    // 计算正方形的面积
    caculateArea(4, squareArea)
    // 计算等边三角形的面积
    caculateArea(4, x => {
      println(s"等边三角形的面积: ${x * x * math.sqrt(3) / 4}")
      x * x * math.sqrt(3) / 4
    })
```

## 数组



