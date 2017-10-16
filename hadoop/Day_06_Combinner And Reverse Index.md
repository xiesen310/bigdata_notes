---
title: Day_06_Combinner And Reverse Index
tags: hadoop,bigdata,Java,MapReduce
grammar_cjkRuby: true
---


# Mr文件读取的几种方式 的区别
TextInputFormat(LongWritable,Text)：文件偏移量 ：整行数据(默认状态)
KeyValueTextInputFormat(Text,Text)：第一个"\t"前的数据 ： 后面的整行数据
SequenceFileInputFormat：因为这是二进制文件，所以Key-Value都是由用户指定

KeyValueTextInputFormat默认情况下是以“\t”作为分隔符号，将每行记录按照“\t”分隔成key，value两个部分

# 书写MapReducer为什么要使用静态内部类？

添加static的话属于静态内部类，它和普通的类型没有什么区别，在使用上直接new类型来实例化对象

``` java
IpLoginNewTweetMap map = new IpLoginNewTweetMap();
```
如果不加static的话,内部类的实例化之前要先实例化外部类

``` java
IpLoginNewTweet ilnt = new IpLoginNewTweet();
IpLoginNewTweetMap map = new ilnt.IpLoginNewTweetMap();
```

# 书写map时，为什么将变量定义在成员变量位置？

Mr运行过程中，每个map节点，只实例化一个map对象,但是每行记录都会调用一次map方法，定义在成员变量位置,减少对象在堆中创建资源，减少了垃圾回收机制回收资源,提高了代码的质量 

# 设置分隔符的两种方式




