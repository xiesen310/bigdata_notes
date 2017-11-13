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
> 运算符中没有++、--

8. 注释
和java中一样

9. 语句块

java中的语句块全部都是过程，没有返回值，只有方法语句块中return才有返回值
scala中大部分的语句块都是有返回值的，而且不需要return
java中语句块的作用主要来划分作用域
scala中的语句块除了划分作用域之外还可以带返回值

``` scala
val str1 = "111"
val str2 = {
	val str3 = s"${str1}defg"
	str3
}
println(str3) // 访问不到
scala中语句块的最后一句，就是该语句的返回值
```


10. if...else...

``` scala
/**
  * 接收分数，判断给出分数的优良中差
  */
object IfElse {

  def main(args: Array[String]): Unit = {
    val score = args(0).toInt
    // 类似java语法
    if(score >= 90){
      println("优秀")
    }else if(score >= 80){
      println("良好")
    }else if(score >= 60){
      println("中等")
    }else{
      println("差")
    }

    // java三木运算 String result = score > 60 ? "优秀" : "差"
    // scala没有三木运算符 if(score > 60) "优秀"else "差"
    //scala的用法
    val result = if(score >= 90)
      "优秀"
    else if(score >= 80)
      "良好"
    else if(score >= 60)
      "中等"
    else
      "差"
    println(result)
  }
}
```

11. while循环

语句块中是没有返回值的

``` scala
/**
  * while 循环
  */
object WhileTest {

  def main(args: Array[String]): Unit = {
    var times = args(0).toInt

    while (times > 0){
      println(s"第${times}此打印")
      times = times - 1
    }

    var times2 = args(0).toInt
    do{
      println(s"doWhile第${times2}此打印")
      times2 -= 1
    }while(times2 > 0)

    // 构建死循环
    while (true){
      // 循环体,轮巡
    }
  }
}
```
12. for循环

for也是scala中少数没有返回值的语句块之一
但是scala提供了一种方式(yield)让其具有返回值的能力

``` java
for(int i = 0; i < 10; i++){
	// 循环体
}
for(String i : sList){}
```
scala中的for循环更像foreach

``` scala
for(i <- list){}
```

通过守卫循环遍历

``` scala
package top.xiesen.bd14

/**
  * for循环
  */
object ForTest {

  def main(args: Array[String]): Unit = {
    val times = args(0).toInt

    for (i <- 1 to times) {
      println(s"1print: $i")
    }

    // 循环守卫通知
    for (i <- 1 to times if i % 2 == 0) println(s"1print$i")
    for (i <- 1 to times if i % 2 == 0 && i > 5) println(s"2println$i")

    // 多重循环(嵌套循环)
      for(i <- 1 to times){
        for(j <- 1 to times){
          println(s"i:$i,j:$j")
        }
      }


    for (i <- 1 to times; j <- 1 to times) {
      println(s"i:$i,j:$j")
    }

    // 嵌套限定条件
    for (i <- 1 to times; j <- 1 to times if i % 2 == 1 && j % 2 == 0) {
      println(s"i:$i,j:$j")
    }

    // i代表长，j代表宽，打印面积大于25的
    for(i <- 1 to times; j <- 1 to times if i * j > 25){
      println(s"长: $i, 宽: $j, 面积: ${i * j}")
    }

    // 对于条件复杂的for循环，可以把小括号写成大括号
    for {
      i <- 1 to times
      j <- 1 to times
      x = i * j
      if x > 25
    } println(s"长: $i, 宽: $j, 面积: ${i * j}")
	
	// 打印乘法口诀表，不能使用var
    for(i <- 1 to 9){
      for(j <- 1 to i){
        print(s"$j * $i = ${i * j}\t")
      }
      println()
    }

    for (i <- 1 to 9; j <- 1 to i) {
      print(s"$j * $i = ${i * j}\t")
      if (i == j) println()
    }

    for(i <- 1 to 9; j <- 1 to i) print(s"$j * $i = ${i * j} ${if(i == j) "\n" else ""}")

  }
}
```

13. Unit类型

java中无返回值的方法类型是void
scala中没有void，它使用Unit类型来代替
Unit的实例就是“()”


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510543129681.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510543347305.jpg