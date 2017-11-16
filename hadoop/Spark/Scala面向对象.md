---
title: Scala面向对象
tags: scala,spark
grammar_cjkRuby: true
---

## scala 类的定义

> Scala的类定义也是使用class关键字,后面跟类的名称，然后大括号

``` scala
class Person {
}
```

## Java类与Scala类的区别

|    | Java类体内    | Scala类体内    |
| --- | --- | --- |
|  属性   |   静态属性、非静态属性  |非静态属性 |
|    方法 |    静态方法、非静态方法 |非静态方法 |
|   静态代码块  | 类被加载时执行    |非静态代码块 |

> scala中没有static关键词
> Scala中用Object(单例类)来承担静态的成员定义

> 在class定义的属性和方法必须通过实例化的对象才能调用
> 在Object中定义的属性和方法，直接用Object名称就可以调用
> Scala的成员也可以使用private和protected修饰，但是没有public，默认情况下是public

### 权限修饰符
没有：所有其他代码都可以访问
Private：只有自己可以访问，除了自己可以访问之外可以额外开放访问权限
Protected：只有之类和同包下可以访问，除了子类和同包外可以访问之外可以额外开放访问权限

Class里面的非定义(声明代码块)，在类实例化的时候被执行


## 构造方法

Java构造方法
1. 有默认无参构造方法
2. 自定义构造方法时，默认构造方法消失
3. 构造方法可以重载 [public 类名(参数列表){}]
4. 不同的构造方法地位是平等的

Scala构造方法

1. 有无参的默认构造方法
2. 构造方法也可以重载
3. 不同的构造方法之间地位不同，每个scala类都有一个唯一的主构造方法，除了主构造方法之外，所有的次构造方法体内都必须直接或间接的调用主构造方法来完成对象的构建
4. 主构造方法的声明在类声明后面来写，次构造方法是写在类体内的，他们的名字统一都叫this
5. 所有的次构造方法在方法体内必须直接或间接的调用主构造方法才能写自己的构造内容
6. 构造方法不需要返回值，它返回值是Unit类型

### 定义构造方法

``` scala
package top.xiesen.oo
class ConstructionTest(pattr1: String, pattr2: String) {
  // 属性1
  var attr1 = pattr1
  // 属性2
  var attr2 = pattr2

  // 副构造方法
  def this() = {
    this("", "") // 直接调用主构造方法
    println("------执行了副构造方法-------")
    this.attr2 = "副构造方法内赋值"
  }

  def this(pattr1: String) = {
    this() //没有直接调用构造方法，但是间接调用了主构造方法
    println("----执行了副构造方法二")
    this.attr1 = pattr1
  }
}

object ConstructionTestObj {
  def main(args: Array[String]): Unit = {
    val c1 = new ConstructionTest("aaa", "123")
    println(s"c1.attr1: ${c1.attr1}, c1.attr2: ${c1.attr2}")
    val c2 = new ConstructionTest()
    println(s"c2.attr1: ${c2.attr1}, c2.attr2: ${c2.attr2}")
  }
}
```
### 将主构造方法与属性进行合并

``` scala
package top.xiesen.oo
class AttributeDefine(var attr1: String, var attr2: Int,val valAttr: String, private var privateAttr: String) {
  var embobyAttr: String = ""
}

object AttributeDefineObj {
  def main(args: Array[String]): Unit = {
    val ad = new AttributeDefine("aaa",123,"常量","private")
    println(s"ad.attr1: ${ad.attr1}, ad.attr2: ${ad.attr2},ad.valAttr: ${ad.valAttr}")
    // 私有变量下不允许访问
//    println(s"ad.private: ${ad.privateAttr}")

    ad.embobyAttr = "内部声明的变量"
    println(s"ad.embobyAttr: ${ad.embobyAttr}")
  }
}
```

### 使用默认值定义构造方法

> 构造方法可以使用默认值参数，这样能够大大提高构造方法的灵活性

``` scala
package top.xiesen.oo
/**
  * 构造方法可以使用默认值参数，这样能够大大提高构造方法的灵活性
  */
class ConstructionWithDefine (var attr1: String, var attr2:String = "defaultAttr2",var attr3: Int = 10){

  override def toString: String = {
    s"attr1: ${attr1},attr2: ${attr2},attr3: ${attr3}"
  }

}

object ConstructionWithDefineObj {
  def main(args: Array[String]): Unit = {
    val c1 = new ConstructionWithDefine("c1参数")
    println(c1)
    val c2 = new ConstructionWithDefine("c1参数","c2参数")
    println(c2)
    val c3 = new ConstructionWithDefine("c1参数","c2参数",123)
    println(c3)
    val c4 = new ConstructionWithDefine("c1参数",attr3 = 1233)
    println(c4)
  }
}
```
### 主构造方法私有

> 可以通过在主构造方法参数前面添加private的方式来对主构造方法进行私有化

``` scala
package top.xiesen.oo

/**
  * 主构造方法私有
  */
class ConstructionMainPrivate private(var attr1: String,var attr2: String) {

  override def toString: String = {
    s"attr1:${attr1},attr2:${attr2}"
  }
  def this() = {
    this("","")
    println("-----使用公有的辅助构造方法来构建对象-----")
  }
}
object ConstructionMainPrivateObj{
  def main(args: Array[String]): Unit = {
    val c1 = new ConstructionMainPrivate()
    c1.attr1 = "属性1"
    c1.attr2 = "属性2"
    println(c1)
  }
}
```

### 单例对象

> 单例对象的属性和方法，可以直接通过单例对象的名称来调用，不需要实例化，它本身就是一个对象

``` scala
package top.xiesen.oo

/**
  * 单例对象
  */
object ObjectTest {

  var varAttr1 = ""
  private var varAttr2: String = ""
  val valAttr1 = "常量1"
  def method1() = {
    println("执行method1")
  }

  private def method2() = {
    println("执行method2")
  }

  def main(args: Array[String]): Unit = {
    ObjectTest.varAttr1 = "给单例对象属性赋值"
    ObjectTest.varAttr2 = "给单例对象私有属性赋值"
    // 常量本省不能赋值
//    ObjectTest.valAttr1 = "123"
    println(s"ObjectTest单例对象---> valAttr1: ${ObjectTest.valAttr1} ,varAttr1: ${ObjectTest.varAttr1}, varAttr2: ${ObjectTest.varAttr2}")
    ObjectTest.method1()
    ObjectTest.method2()
  }
}
```

### 伴生类和伴生对象



