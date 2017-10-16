---
title: Day_06_Combinner And Reverse Index
tags: hadoop,bigdata,Java,MapReduce
grammar_cjkRuby: true
---


# Mr文件读取的几种方式 的区别
TextInputFormat(LongWritable,Text)：文件偏移量 ：整行数据(默认状态)
KeyValueTextInputFormat(Text,Text)：第一个"\t"前的数据 ： 后面的整行数据
SequenceFileInputFormat：因为这是二进制文件，所以Key-Value都是由用户指定
