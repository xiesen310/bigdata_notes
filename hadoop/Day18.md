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

rowkey长度最大64k，使用时不能超过100个字节