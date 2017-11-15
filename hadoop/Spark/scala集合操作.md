---
title: scala集合操作
tags: scala,spark
grammar_cjkRuby: true
---

## Val、def、lazy定义变量的区别

Val：获取一次，并立即执行(严格执行)
Def：在声明的时候赋值
Lazy：惰性执行，也就是说赋值的时候不执行，等到需要的时候再执行

``` scala
package top.xiesen.bd14
object DefTest {
  def sumInt(x: Int, y: Int) = {
    println("执行sumInt方法")
    x + y
  }
  def main(args: Array[String]): Unit = {
    // val类型的变量,在声明时就会把右边表达式的结果计算并赋值给val变量，一旦赋值，右边的表达式不再计算
    val v = sumInt(3,5)
    println(s"打印val对象v: $v")
    println(s"第二次打印val对象v: $v")

    // def类型的变量，在声明赋值时，右边的表达式是不会计算结果的，在变量类型每次被调用的时候，等号右边的表达式都会被计算一次
    def d = sumInt(3,5)
    println("变量d已经赋值了")
    println(s"打印def对象d: $d")
    println(s"第二次打印def对象d: $d")

    // lazy定义的变量，在声明赋值时，等号右边的表达式不会马上计算结果
    // lazy在对象第一次被调用时，等号右边的表达式会被计算一次，并且被赋值一次
    // 后续的对lazy对象的再次调用，右边的表达式不会再进行计算
    lazy val l = sumInt(3,5)
    println("变量l已经被定义赋值过了")
    println(s"打印变量lazy的值l: $l")
    println(s"第二次打印变量lazy的值l: $l")
  }
}
```

## List

### reduce

`val reducerList = list6.reduce((x1, x2) => x1 + x2)`Reduce是对list6中的所有元素进行迭代计算的函数，reduce计算结束之后相当于把集合中的每一个元素按照迭代函数，迭代计算聚合起来

``` scala
val list6 = List(1, 2, 3, 4, 5)
val reducerList = list6.reduce((x1, x2) => x1 + x2)
val reduceListMax = list6.reduce((x1,x2)=> if(x1 > x2) x1 else x2)
println(s"list6的总和 = $reducerList" )
println(s"list6的最大值 = $reduceListMax" )
```

### fold 

``` scala
val foldResult = list6.fold(0)((x1,x2) => x1 + x2)
println(s"list6中元素的总和是: $foldResult")
```

### foldLeft

``` scala
// 把list6中的元素聚合成一个字符串，字符串中包含有每一个元素
val strFoldResult = list6.foldLeft("")((c,x) => s"${if(c == "") "" else ","}$x")
println(s"fold实现mkString: $list6")
```


