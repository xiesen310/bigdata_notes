---
title: Day18
tags: hadoop,hbaseJava
grammar_cjkRuby: true
---
## rowkey设计

1. 数据的存储
2. region划分
3. rowkey是唯一标识
4. rowkey是表中唯一的索引，不支持其他的索引

- rowkey长度原则

rowkey长度最大64k，使用时不能超过100个字节，rowkey的长度定长，rowkey的长度最好是8的整数倍

- rowkey散列原则

rowkey散列的方法：
1. 随机数
2. uuid
3. MD5,hash等加密算法
4. 业务有序数据反向(对业务有序数据进行 reverse)

rowkey唯一性原则

rowkey作为索引原则
rowkey是hbase里面唯一的索引，对于查询频繁的限定条件需要把内容放在rowkwy里面


事实耿勋索引

1. 当有新的数据进入Order——item时，在程序里面，手动的插入一条索引到二级索引表
2. 定义一种触发器，当order_tem表中有数据更新时，自动触发把索引表中应该保存的数据保存进去,这种东西有自己的名字，叫做协处理器 coprocesser

endpoint：存储过程
observer：触发器

历史数据的索引通过mr批量写入索引表

Phoenix是hbase的sql引擎
hbase只支持单行的事务

hbase不支持表关联