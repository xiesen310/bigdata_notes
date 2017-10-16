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

![][1]

# 程序优化原理分析—combinner
Shuffle过程是从map读取kv结束后到传递给reducerwork调用reducer方法的过程
Shuffle过程是mr中最耗时间的过程，减少shuffle的数据量，能提高mr的运行速度
如果在map上将数据进行聚合，聚合后的结果在发送到reduce上再次聚合，这样
1.	减少shuffle的数据量
2.	把reducer上的计算的压力在每一个reducer上进行分担

## 如何在map端进行聚合
通过在mr中添加Combinner的方式给mr配置map端聚合
Combinner的类型就是Reducer
Combinner的reducer方法定义就是map端聚合的方式
Combinner其实就是reducer，只不过这个reducer是在map节点上完成的，它只是计算map端上的数据
真正的reducer在独立的reducer节点上计算的，它从各个map上找去数据过来一同计算

``` java
Job.setCombinnerClass(SomeCombinnerClass.class);
```

在mr中只要能使用Combinner就最好使用Combinner,因为它减少了Map端向reducer端传送的数据量
**不能使用combinner的场景**
1.	计算平均值，期望，方差等计算过程不能使用
2.	Combinner的输入kv类型必须和输出类型保持一致，否则不适用

![combinner原理分析][2]

> 注意 ：如果combinner与reducer一样并且满足combinner的使用场景，可以将combinner和reducer进行合并

# MR倒排索引

> 如果一个文件被两个或两个以上的mapwork进行分隔，就会出现同一个文件被分配到不同的mapwork上，这样就会出现错误，我们可以通过两种方式进行修改，避免这种问题的发生

1. 在reduce上将解析的文件名和次数相同的进行累加，所有文件名和次数解析之后再输出
2.在map上自定义InputFormat来将同一个文件分到一个split中，这样就解决了上述问题
自定义inputFormat上重写isSplitable方法即可

``` java
/**
	* 项目名称：mapreeduce
	* 类名称：ReversedIndexInputFormat
	* 类描述：为了解决一个文件可能有两个分片，自定义一个inputformat，来设置一个文件只能有一个分片，前提是文件不宜过大，否则另想办法
	* 创建人：Allen
	* @version
	*/
	public static class ReversedIndexInputFormat extends TextInputFormat{
		@Override
		protected boolean isSplitable(JobContext context, Path file) {
			return false;
		}
	}
```


![enter description here][3]


# TopN问题

> 对于topN问题，我们以WordCount来展开叙述，对于这个问题，有两种可行的方案
**方案一**

编写连个mr程序，第一个mr程序进行计数，两一个mr程序获取topN的值，但是这种方式需要书写连个mr程序，过程比较繁琐，不推荐使用

![方案一处理流程示意图][4]

**方案二**
当然，方案二必须是要书写一个mr了，要不多浪费感情啊。MapReduce分为两个阶段，Map阶段和Reduce阶段

**Map**
map阶段主要做的事情是加载数据，解析数据，将数据分隔成单词，然后以kv(单词,1)的形式将数据发送给reduce

**Reduce**

reduce阶段，接收数据，按照key进行统计，计算出词频，然后获取topN，输出结果



  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508153602457.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508153725503.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508154050534.jpg
  [4]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508154487106.jpg