---
title: Day_10_hive
tags: bigdata,hadoop,hive
grammar_cjkRuby: true
---

# Hive
> Hive是一个基于Hadoop的数据仓库，最初由Facebook提供，使用HQL作为查询接口、HDFS作为存储底层、mapReduce作为执行层，设计目的是让SQL技能良好，但Java技能较弱的分析师可以查询海量数据，2008年facebook把Hive项目贡献给Apache。Hive提供了比较完整的SQL功能（本质是将SQL转换为MapReduce），自身最大的缺点就是执行速度慢。Hive有自身的元数据结构描述，可以使用MySql\ProstgreSql\oracle 等关系型数据库来进行存储，但请注意Hive中的所有数据都存储在HDFS中。
## Hive特点
1.	Hive最大的特点是Hive通过SQL来分析大数据，而避免了写MapReduce，使用java程序来分析数据，这样使得分析数据更容易
2.	数据是存储在HDFS上的，Hive本身并不提供数据的存储功能
3.	Hive是将数据映射成数据库和一张张的表，库和表的元数据信息一般存在关系型数据库上
4.	数据存储方面：他能够存储很大的数据集，并且对数据完整性、格式要求并不是很严格
5.	数据处理方面：不适合用于实时计算，适合用于离线查询

## Hive架构

![hive架构示意图][1]

> 用户接口主要有三个CLI(commoned line interface)命令行、Client和web UI
- metaStrore : Hive 的元数据是一般是存储在MySQL 这种关系型数据库上的，Hive 和MySQL 之间通过MetaStore服务交互。
- Driver: 解释器、编译器、优化器完成HQL查询语句从词法分析、语法分析、编译、优化以及查询计划的生成。生成的查询计划存储在HDFS中，并在随后由MapReduce调用执行
	- 解释器：解释器的作用是将HiveSQL 语句转换为语法树（AST）
	- 编译器：编译器是将语法树编译为逻辑执行计划。
	- 优化器：优化器是对逻辑执行计划进行优化。
	- 执行器：执行器是调用底层的运行框架执行逻辑执行计划。
- Hive 的数据是存储在HDFS 上的。Hive 中的库和表可以看做是对HDFS 上数据做的一个映射。所以Hive 必须是运行在一个Hadoop 集群上的。
- Hive 中的执行器，是将最终要执行的MapReduce 程序放到YARN 上以一系列Job 的方式去执行。

## 数据类型

Hive支持的数据类型很多，有数字类型、日期时间类型、字符串类型、复杂类型等等，具体详细类型参考[https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types][2]
 
 # Beeline
> HiveServer2提供了一个新的命令行工具beeline，它是基于SQLLine CLI的JDBC客户端
Beeline的命令行操作流程如下
进入hiveserver2
1.	打开hive服务，执行命令hiveserver2命令
2.	打开Beeline客户端，执行beeline
3.	连接hiveserver2，执行命令 ！connect jdbc：hive2：//localhost:10000
4.	输入用户名，我们使用root用户名
5.	输入密码，因为我们没有设置密码，直接回车即可

![beeline数据类型][3]

 


  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508760689186.jpg
  [2]: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1508760834917.jpg