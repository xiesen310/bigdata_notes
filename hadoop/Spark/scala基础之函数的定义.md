---
title: scala基础之函数的定义 
tags: scala
grammar_cjkRuby: true
---

## 函数的定义

> 函数的定义和对象的定义一样，编译器会通过返回值自动判断函数返回值，因此，对绝大数的函数定义，都不需要写返回值类型。只有一种情况例外：递归函数

![一般函数定义形式][1]

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

那么该函数有两个参数都是Int，有一个返回值也是Int，那么在scala中的函数类型描述是(Int,Int) => Int
其中 => 符号分隔参数定义(输入)类型和返回值(输出)类型
Int => Int
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

Arrat是可变(元素可变)的，它和java的数据T[ ]是对应的，数组是定长的，定义的时候必须指定长度，一旦声明长度不可发生变化

``` scala
package top.xiesen.bd14

import scala.util.Random

object ArrayTest {

  // 定义一个函数，接收一个整数n，函数返回一个n个元素的数据，每个位置处的数值是0~n之间的随机数
  def getRandomN(n: Int): Unit = {
    val ran = new Random()
    val array = new Array[Int](n)
    for (i <- 0 until array.length) {
      array(i) = ran.nextInt(n)
    }
    println(array.mkString(","))
  }

  // 定义一个函数 接收一个数据 函数把数组的两两相邻的元素调换位置
  // 32,55,66,77,88,99,100 ---> 55,32,77,66,99,88,100
  def pairReverArray(array: Array[Int]) = {
    for (i <- 0 until(array.length - 1, 2)) {
      val tmp = array(i)
      array(i) = array(i + 1)
      array(i + 1) = tmp
    }
  }

  // 冒泡排序 从小到大
  def bubbleSort(array: Array[Int]) = {
    for (i <- 0 until (array.length - 1); j <- 0 until array.length - i - 1) {
      if (array(j) > array(j + 1)) {
        val tmp = array(j)
        array(j) = array(j + 1)
        array(j + 1) = tmp
      }
    }
  }

  // 选择排序 从小到大
  def selectionSort(array: Array[Int]) = {
    for (i <- 0 until array.length - 1; j <- i + 1 until array.length) {
      if (array(i) > array(j)) {
        array(i) = array(i) ^ array(j)
        array(j) = array(i) ^ array(j)
        array(i) = array(i) ^ array(j)

        /*array(i) = array(i) + array(j)
        array(j) = array(i) - array(j)
        array(i) = array(i) - array(j)*/
      }
    }
  }


  def selectionSort1(array: Array[Int]) = {
    for (i <- 0 until array.length - 1) {
      var k = i
      for (j <- i + 1 until array.length) {
        if (array(j) < array(k)) k = j
      }
      array(k) = array(k) ^ array(i)
      array(i) = array(k) ^ array(i)
      array(k) = array(k) ^ array(i)
    }
  }

  def main(args: Array[String]): Unit = {
    // 数组的声明和字面量的写法
    val array = Array(101, 110, 3, 4, 45,11)

    println(array.mkString(","))
    selectionSort1(array)
    println(array.mkString(","))
    //    println(array.head)
    // 数组取值
    //    println(array(0))
    // 元素是可变的
//    array(0) = 100
    /*println(array.mkString(","))*/
    // 数组的遍历
    /*for(i <- 0 until array.length){
      println(array(i))
    }*/

    /*for(i <- array){
      println(i)
    }*/

    // 有问题
    /*array.foreach(x => {
      println(x)
    })*/

    //数组的字面量声明
    val array1 = new Array[String](10)
    array1(0) = "a"
    array1(1) = "b"
    array1(2) = "c"

    //    println(array1.mkString(","))
    //    getRandomN(10)
    //    getRandomN(9)

    /*println(array.mkString(","))
    pairReverArray(array)
    println(array.mkString(","))*/
    /*println(array.mkString(","))
    bubbleSort(array)
    selectionSort(array)
    println(array.mkString(","))*/

    // 过滤元素字符串中包含a的所有元素
    val fruit = Array("apple", "tomato", "watermallon", "berry")
    val noAFruit = fruit.filterNot(x => x.contains('a'))
    //    println(noAFruit.mkString(","))

    // 判断fruit是否存在长度为5的水果
    val is5Length = fruit.exists(x => x.length == 5)
    //    println(is5Length)

  }
}
```


### ArrayBuffer
ArrayBuffer是变长数组，该类型对象在声明时可以不用指定长度

``` scala
package top.xiesen.bd14

import scala.collection.mutable.ArrayBuffer
import scala.util.control.Breaks

object ArrayBufferTest {

  def main(args: Array[String]): Unit = {
    // ArrayBuffer的声明和字面量
    val ab1 = ArrayBuffer(1, 2, 3, 4)
    val ab2 = new ArrayBuffer[Int](2)
    val ab3 = new ArrayBuffer[Int]()
    /*println(ab1)
    println(ab2)
    println(ab3)*/

    //    println(ab1(3))
    ab2 += 3
    ab2 += 5

    // 是根据equals方法来判断减的
    ab2 -= 8
    // 如果写入的起始位置超出arratbuffer中的现有的index值的话会报错
    ab2.insert(1, 1212, 121, 111)

    ab2.remove(2, 2)
    //    println(ab2)

    // drop方法也是删除arraybuffer中的数据，但是返回一个新的arraybuffer而不修改原arraybuffer中的数据
    //    println(ab2.drop(1)) // 从左向右删除一个
    //    println(ab2.dropRight(1)) // 从右向左删除一个

    ab2.update(0, 11111111)

    //    println(ab2)

    val ab4 = ArrayBuffer(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    // 生成新的arraybuffer，只留下偶数
    val result = ab4.filter(x => (x % 2 == 0))
    //    println(result)
    // 定义一个函数，接收arraybuffer，和一个函数
    // 函数对每一个arraybuffer中的值进行计算，返回true则留在arraybuffer，返回false直接删除
    removeBy(ab4, x => x % 2 != 0)
    //    println(ab4)

    val ab5 = ArrayBuffer(23, 4, 15, 6, 10)
    //    insertSort(ab5)
    println(ab5)
    val a = insertSort1(ab5)
    println(a)
  }

  def removeBy(ab: ArrayBuffer[Int], f: Int => Boolean) = {
    // 对ab进行遍历
    for (item <- ab) {
      if (!f(item)) ab -= item
    }
  }

  // 利用arraybuffer实现插入排序算法
  def insertSort(ab: ArrayBuffer[Int]) = {
    for (i <- 1 until ab.size) {
      var j = i - 1
      var temp = ab(i)
      while (j >= 0 && ab(j) > temp) {
        ab(j + 1) = ab(j)
        j -= 1
      }
      ab(j + 1) = temp
    }
    ab.foreach(x => print(" " + x))
  }

  def insertSort1(ab: ArrayBuffer[Int]) = {
    val ab1 = new ArrayBuffer[Int]()
    ab1 += ab(0)
    val break = new Breaks()
    for (i <- 1 until ab.length) {
      break.breakable(
        for (j <- 0 until ab1.length) {
          if (ab(i) < ab1(j)) {
            ab1.insert(j, ab(i))
            break.break()
          }
          if (j == ab1.length - 1) ab1.append(ab(i))
        }
      )
    }
    ab1
  }
}
```

## List

``` scala
package top.xiesen.bd14
object ListTest {
  def main(args: Array[String]): Unit = {
    val list = List(1, 2, 3, 4, 5)
    val list1 = List()
    println(list)
    println(list1)
    println(list(0))
    // list元素对象不能更改，不能重新赋值
    //    list(0) = 100

    // list运算符 都是返回新的list对象

    // 添加元素
    println(list.::(23))
    println(23 :: list)
    println(33 :: 44 :: list)

    println(list.+:(22))
    println(list :+ 11)
    println(11 +: list)

    val list2 = List(1, 2, 3)
    val list3 = List(4, 5, 6)
    // 将两个list链接在一起
    println(list2 ++ list3)

    // list中有多少是大于5
    val list4 = List(1, 2, 3, 4, 5, 6, 7, 7, 6, 4, 3, 2)
    val bt5Count = list4.count(x => x > 5)
    println(s"list中大于5的个数是: ${bt5Count}")

    // list中去重
    val distinctList = list4.distinct
    println(s"list去重之后的list集合：${distinctList}")

    // 获取list集合是否以什么结尾
    val isEndWith67 = list4.endsWith(List(6, 7))
    println(s"list4 ${if (isEndWith67) "是" else "不是"} 以6,7结尾")

    // find：返回list中第一个满足查询条件的元素，并用Optional封装
    val findList = list4.find(x => x > 4 && x % 2 == 0)
    println(s"第一个大于4，并且是偶数的元素为： $findList")

    // 把list3中的每个元素各自拆分成一个单词一个元素的list
    val list5 = List("hadoop is good", "spark is better", "sql is the best")
    // flatMap 是一个展平操作，类似于hive中的explore 它接收一个函数，
    // 函数的输出是一个集合，集合中的每个元素拼接成一个新的list
    val flatMapList = list5.flatMap(x => x.split("\\s"))
    println(s"flatMap的展平操作 $flatMapList")

    val list6 = List(1, 2, 3, 4, 5)
    // 计算list中的和
    val sumList = list6.fold(0)(_ + _)
    println(sumList)

    var sum1 = 0
    for (i <- 0 until list6.size) {
      sum1 = sum1 + list6(i)
    }
    println(sum1)

    val reducerList = list6.reduce((x1, x2) => x1 + x2)
    println(s"list6的总和 = $reducerList" )
  }
}
```


> list是不可变的元素列表，里面的元素不可更改，长度不可更改

  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510634131414.jpg