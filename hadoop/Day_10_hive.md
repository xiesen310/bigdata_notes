---
title: Day_10_hive
tags: bigdata,hadoop,hive
grammar_cjkRuby: true
---

# Hive
> Hive是一个基于Hadoop的数据仓库，最初由Facebook提供，使用HQL作为查询接口、HDFS作为存储底层、mapReduce作为执行层，设计目的是让SQL技能良好，但Java技能较弱的分析师可以查询海量数据，2008年facebook把Hive项目贡献给Apache。Hive提供了比较完整的SQL功能（本质是将SQL转换为MapReduce），自身最大的缺点就是执行速度慢。Hive有自身的元数据结构描述，可以使用MySql\ProstgreSql\oracle 等关系型数据库来进行存储，但请注意Hive中的所有数据都存储在HDFS中。
# Hive特点
1.	Hive最大的特点是Hive通过SQL来分析大数据，而避免了写MapReduce，使用java程序来分析数据，这样使得分析数据更容易
2.	数据是存储在HDFS上的，Hive本身并不提供数据的存储功能
3.	Hive是将数据映射成数据库和一张张的表，库和表的元数据信息一般存在关系型数据库上
4.	数据存储方面：他能够存储很大的数据集，并且对数据完整性、格式要求并不是很严格
5.	数据处理方面：不适合用于实时计算，适合用于离线查询

