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

