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


