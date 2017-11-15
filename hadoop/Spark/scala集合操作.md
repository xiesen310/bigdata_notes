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

### aggregate

> 先进行单个元素之间的迭代，再进行分区之间的聚合

``` scala
val strAggrateResult = list6.aggregate("")(
  (c, x) => s"$c${if (c == "") "" else ","}$x"
  , (c1, c2) => s"$c1,$c2"
)
println(s"aggregate实现mkString: $strAggrateResult")

val sumAggrateResult = list6.aggregate(0)(
  (x1,x2) => x1 + x2
  ,(c1,c2) => c1 + c2
)
println("aggregate实现list6中元素的总和是: " + sumAggrateResult)
```

### 常用函数

``` scala
// 把a b c d 字符构建一个list
val list7 = "a" :: "b" :: "c" :: "d" :: Nil
println(list7)
// 获取list的头部
println(list7.head)
// 获取除第一个元素之外的元素列表
println(list7.tail)
// 获取list的最后一个元素
println(list7.last)
// 获取list除了最后一个元素，其他的元素列表
println(list7.init)

// 将list6按照奇数偶数分成两组
val groupResult = list6.groupBy(x => if(x % 2 == 1) "奇数" else "偶数")
println(s"将list6按照奇数偶数分成两组 : $groupResult")

// 拉链操作,当两个list的元素数量不一样时，在结果集中直接被丢弃
val list8 = List(1,2,3,4)
val list9 = List("a","b","c","d")
println(list8 zip list9)
```

## Set

> Set是不重复的集合，在集合中是无序的。Set的操作基本上是和List中的函数是相同的

![][1]

### Set的声明和字面量

``` scala
// set的声明和字面量
val set1 = Set(1, 2, 3, 4, 5, 4, 5)
println(set1)
// set是无序、不重复，因此不能使用index进行取值
println(set1(0))
```
### Set集合遍历

``` scala
// set遍历
for (i <- set1) println(i)
println("----------------------")
set1.foreach(x => println(x))
```

### 可变set集合

``` scala
val mSet = scala.collection.mutable.Set(3,2,4)
mSet.add(456)
println(mSet)
mSet.add(3)
println(mSet)
mSet += 1
println(mSet)
mSet.remove(3)
println(mSet)
```

## Map

### Map声明，字面量

``` scala
// map声明，字面量，取值
val map1 = Map(1 -> "a", 2 -> "b", 3 -> "c")
println(map1)
val map2 = Map((1,"a"),(2,"b"),(3,"c"))
println(map2)
```

### Map取值

``` scala
// map取值
println(map1(1))
println(map1(2))

val map3 = Map("a" -> 1,"b" -> 2, "c" -> 3)
println(map3("a"))
```

### Map遍历

``` scala
// 遍历
// 方式一
map3.foreach(
  x => println(s"key: ${x._1},value:${x._2}")
)
println("----------------")
// 方式二
for(x <- map3){
  println(s"key: ${x._1}, value: ${x._2}")
}
println("-----------")
// 方式三
for((k,v) <- map3){
  println(s"key: ${k}, value: ${v}")
}
println("------------")
// 方式四
for(ks <- map3.keySet){
  println(s"key: ${ks}, value: ${map3(ks)}")
}
```

### 通过get获取key的value值

``` scala
// get方法，获取指定key的value值
val map4 = Map("zhang" -> 80, "li" -> 85, "liu" -> 90)
println(map4("zhang"))
println(map4.get("zhang"))
// 小括号获取key的value的值，如果key不存在，程序会抛出 java.util.NoSuchElementException 异常
// 建议使用get获取key的value的值
//    println(map4("aaa"))
println(map4.get("wang"))
```
### Map ++

``` scala
// map ++
println(map3 ++ map4)
println(map3 ++ Map("c" -> 100))
```

### Map中判断是否包含key

``` scala
// 判断map4中是否包含key: "zhang"
println(map4.contains("zhang"))
```
### Map count

``` scala
// 计算出value代表key长度(value的值=key的长度)的kv对的数据量
val map5 = Map("apple" -> 5, "pear" -> 4, "peach" -> 5, "tomato" -> 6, "banana" -> 7)
val count1 = map5.count(x => x._1.length == x._2)
println(s"value的值=key的长度 的数量： $count1")
// 计算出key长度是5的kv对数量
val count2 = map5.count(x => x._1.length == 5)
println(s"key长度是5的kv对数量: $count2")
```

### Map drop

``` scala
// drop
println(map5)
println(map5.drop(2))
println(map5.dropRight(2))
```

### 


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510742262626.jpg