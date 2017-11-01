---
title: Day16
tags: hadoop,hbase
grammar_cjkRuby: true
---

# Hbase
## 简介

> HBase(Hadoop Database)是一个开源的、面向列（Column-Oriented）、适合存储海量非结构化数据或半结构化数据的、具备高可靠性、高性能、可灵活扩展伸缩的、支持实时数据读写的分布式存储系统。


存储在HBase中的表的典型特征：
- 大表（BigTable）：一个表可以有上亿行，上百万列
- 面向列：面向列(族)的存储、检索与权限控制
- 稀疏：表中为空(null)的列不占用存储空间

## Hbase的应用场景

Hbase适合一次写入，多次读取的应用场景，例如：订单的查询，交易信息，银行流水,话单信息，日志信息

# Hbase底层实现
Hbase的底层存储是一个key-value键值对
column Family冗余量比较大，所以强烈建议使用一个字母表示
Row key也是越短越好，但是需要唯一确定

## HBase集群典型部署组网

![HBase集群典型部署组网][1]

## HBase 系统架构

![HBase 系统架构][2]


## HBase数据模型

![HBase数据模型  ][3]


## HBase访问接口

1. Native Java API，最常规和高效的访问方式，适合Hadoop MapReduce Job并行批处理HBase表数据
2. HBase Shell，HBase的命令行工具，最简单的接口，适合HBase管理使用
3. Thrift Gateway，利用Thrift序列化技术，支持C++，PHP，Python等多种语言，适合其他异构系统在线访问HBase表数据
4. REST Gateway，支持REST 风格的Http API访问HBase, 解除了语言限制
5. Pig，可以使用Pig Latin流式编程语言来操作HBase中的数据，和Hive类似，本质最终也是编译成MapReduce Job来处理HBase表数据，适合做数据统计
6. Hive，当前Hive的Release版本尚没有加入对HBase的支持，但在下一个版本Hive 0.7.0中将会支持HBase，可以使用类似SQL语言来访问HBase

## Hbase shell

| 名称    |   命令表达式  |
| --- | --- |
|  创建表   |  create '表名称', '列名称1','列名称2','列名称N'   |
| 添加记录    | put '表名称', '行名称', '列名称:', '值'   |
| 查看记录    | get '表名称', '行名称'    |
|  查看表中的记录总数   |  count  '表名称'   |
|  删除记录   |    delete  '表名' ,'行名称' , '列名称' |
| 删除一张表    |   先要屏蔽该表，才能对该表进行删除，第一步 disable '表名称' 第二步 drop '表名称'  |
| 查看所有记录    | scan "表名称"    |
|  查看某个表某个列中所有数据   |   scan "表名称" , ['列名称:']  |
| 更新记录    |  就是重写一遍进行覆盖   |

### 一般操作

1.查询服务器状态

``` css
hbase(main):024:0>status
3 servers, 0 dead,1.0000 average load
```


2.查询hive版本

``` css
hbase(main):025:0>version
0.90.4, r1150278,Sun Jul 24 15:53:29 PDT 2011
```
### DDL操作

1.创建一个表

``` css
hbase(main):011:0>create 'member','member_id','address','info'   
0 row(s) in 1.2210seconds
```


2.获得表的描述

``` css
hbase(main):012:0>list
TABLE                                                                                                                                                       
member                                                                                                                                                      
1 row(s) in 0.0160seconds
hbase(main):006:0>describe 'member'
DESCRIPTION                                                                                          ENABLED                                               
{NAME => 'member', FAMILIES => [{NAME=> 'address', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => '0', true                                                 
  VERSIONS => '3', COMPRESSION => 'NONE',TTL => '2147483647', BLOCKSIZE => '65536', IN_MEMORY => 'fa                                                       
lse', BLOCKCACHE => 'true'}, {NAME =>'info', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => '0', VERSI                                                       
ONS => '3', COMPRESSION => 'NONE', TTL=> '2147483647', BLOCKSIZE => '65536', IN_MEMORY => 'false',                                                        
BLOCKCACHE => 'true'}]}                                                                                                                                    
1 row(s) in 0.0230seconds
```

3.删除一个列族，alter，disable，enable
我们之前建了3个列族，但是发现member_id这个列族是多余的，因为他就是主键，所以我们要将其删除。

``` css
hbase(main):003:0>alter 'member',{NAME=>'member_id',METHOD=>'delete'}
```

ERROR: Table memberis enabled. Disable it first before altering.

报错，删除列族的时候必须先将表给disable掉。

``` css
hbase(main):004:0>disable 'member'                                  
0 row(s) in 2.0390seconds
hbase(main):005:0>alter'member',NAME=>'member_id',METHOD=>'delete'
0 row(s) in 0.0560seconds
hbase(main):006:0>describe 'member'
DESCRIPTION                                                                                          ENABLED                                               
{NAME => 'member', FAMILIES => [{NAME=> 'address', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => '0',false                                                 
  VERSIONS => '3', COMPRESSION => 'NONE',TTL => '2147483647', BLOCKSIZE => '65536', IN_MEMORY => 'fa                                                       
lse', BLOCKCACHE => 'true'}, {NAME =>'info', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => '0', VERSI                                                       
ONS => '3', COMPRESSION => 'NONE', TTL=> '2147483647', BLOCKSIZE => '65536', IN_MEMORY => 'false',                                                        
BLOCKCACHE => 'true'}]}                                                                                                                                    
1 row(s) in 0.0230seconds
```
该列族已经删除，我们继续将表enable

``` css
hbase(main):008:0> enable 'member'  
0 row(s) in 2.0420seconds
```

4.列出所有的表

``` css
hbase(main):028:0>list
TABLE                                                                                                                                                       
member                                                                                                                                                      
temp_table                                                                                                                                                  
2 row(s) in 0.0150seconds
```

5.drop一个表

``` css
hbase(main):029:0>disable 'temp_table'
0 row(s) in 2.0590seconds

hbase(main):030:0>drop 'temp_table'
0 row(s) in 1.1070seconds
```

6.查询表是否存在

``` css
hbase(main):021:0>exists 'member'
Table member doesexist                                                                                                                                     
0 row(s) in 0.1610seconds
```


7.判断表是否enable

``` css
hbase(main):034:0>is_enabled 'member'
true                                                                                                                                                        
0 row(s) in 0.0110seconds
```
8.判断表是否disable

``` css
hbase(main):032:0>is_disabled 'member'
false                                                                                                                                                       
0 row(s) in 0.0110seconds
```
### DML操作


1.插入几条记录

``` css
put'member','scutshuxue','info:age','24'
put'member','scutshuxue','info:birthday','1987-06-17'
put'member','scutshuxue','info:company','alibaba'
put'member','scutshuxue','address:contry','china'
put'member','scutshuxue','address:province','zhejiang'
put'member','scutshuxue','address:city','hangzhou'


put'member','xiaofeng','info:birthday','1987-4-17'
put'member','xiaofeng','info:favorite','movie' 
put'member','xiaofeng','info:company','alibaba'
put'member','xiaofeng','address:contry','china'
put'member','xiaofeng','address:province','guangdong'
put'member','xiaofeng','address:city','jieyang'
put'member','xiaofeng','address:town','xianqiao'
```

2.获取一条数据
获取一个id的所有数据

``` css
hbase(main):001:0>get 'member','scutshuxue'
COLUMN                                   CELL                                                                                                               
address:city                           timestamp=1321586240244, value=hangzhou                                                                            
address:contry                         timestamp=1321586239126, value=china                                                                               
address:province                       timestamp=1321586239197, value=zhejiang                                                                            
info:age                               timestamp=1321586238965, value=24                                                                                  
info:birthday                          timestamp=1321586239015, value=1987-06-17                                                                          
info:company                           timestamp=1321586239071, value=alibaba                                                                             
6 row(s) in 0.4720seconds
```

3. 获取一个id，一个列族的所有数据

``` css
hbase(main):002:0>get 'member','scutshuxue','info'
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321586238965, value=24                                                                                  
info:birthday                          timestamp=1321586239015, value=1987-06-17                                                                          
info:company                           timestamp=1321586239071, value=alibaba                                                                             
3 row(s) in 0.0210seconds
```
4. 获取一个id，一个列族中一个列的所有数据

``` css
hbase(main):002:0>get 'member','scutshuxue','info:age' 
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321586238965, value=24                                                                                  
1 row(s) in 0.0320seconds
```

5. 将scutshuxue的年龄改成99

``` css
hbase(main):004:0>put 'member','scutshuxue','info:age' ,'99'
0 row(s) in 0.0210seconds

hbase(main):005:0>get 'member','scutshuxue','info:age' 
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321586571843, value=99                                                                                  
1 row(s) in 0.0180seconds

```

6. 通过timestamp来获取两个版本的数据

``` css
hbase(main):010:0>get 'member','scutshuxue',{COLUMN=>'info:age',TIMESTAMP=>1321586238965}
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321586238965, value=24                                                                        
1 row(s) in 0.0140seconds

hbase(main):011:0>get 'member','scutshuxue',{COLUMN=>'info:age',TIMESTAMP=>1321586571843}
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321586571843, value=99                                                                                  
1 row(s) in 0.0180seconds
```

7. 全表扫描：

``` css
hbase(main):013:0>scan 'member'
ROW                                     COLUMN+CELL                                                                                                        
scutshuxue                             column=address:city, timestamp=1321586240244, value=hangzhou                                                       
scutshuxue                             column=address:contry, timestamp=1321586239126, value=china                                                        
scutshuxue                             column=address:province, timestamp=1321586239197, value=zhejiang                                                   
scutshuxue                              column=info:age,timestamp=1321586571843, value=99                                                                 
scutshuxue                             column=info:birthday, timestamp=1321586239015, value=1987-06-17                                                    
scutshuxue                             column=info:company, timestamp=1321586239071, value=alibaba                                                        
temp                                   column=info:age, timestamp=1321589609775, value=59                                                                 
xiaofeng                               column=address:city, timestamp=1321586248400, value=jieyang                                                        
xiaofeng                               column=address:contry, timestamp=1321586248316, value=china                                                        
xiaofeng                               column=address:province, timestamp=1321586248355, value=guangdong                                                  
xiaofeng                               column=address:town, timestamp=1321586249564, value=xianqiao                                                       
xiaofeng                               column=info:birthday, timestamp=1321586248202, value=1987-4-17                                                     
xiaofeng                               column=info:company, timestamp=1321586248277, value=alibaba                                                        
xiaofeng                               column=info:favorite, timestamp=1321586248241, value=movie 
3 row(s) in 0.0570seconds
```

8. 删除id为temp的值的‘info:age’字段

``` css
hbase(main):016:0>delete 'member','temp','info:age'
0 row(s) in 0.0150seconds
hbase(main):018:0>get 'member','temp'
COLUMN                                   CELL                                                                                                               
0 row(s) in 0.0150seconds
```
9.删除整行

``` css
hbase(main):001:0>deleteall 'member','xiaofeng'
0 row(s) in 0.3990seconds
```

10. 查询表中有多少行：

``` css
hbase(main):019:0>count 'member'                                        
2 row(s) in 0.0160seconds
```
11. 给‘xiaofeng’这个id增加'info:age'字段，并使用counter实现递增

``` css
hbase(main):057:0*incr 'member','xiaofeng','info:age'                    
COUNTER VALUE = 1

hbase(main):058:0>get 'member','xiaofeng','info:age' 
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321590997648, value=\x00\x00\x00\x00\x00\x00\x00\x01                                                    
1 row(s) in 0.0140seconds

hbase(main):059:0>incr 'member','xiaofeng','info:age'
COUNTER VALUE = 2

hbase(main):060:0>get 'member','xiaofeng','info:age' 
COLUMN                                   CELL                                                                                                               
info:age                               timestamp=1321591025110, value=\x00\x00\x00\x00\x00\x00\x00\x02                                                    
1 row(s) in 0.0160seconds

获取当前count的值
hbase(main):069:0>get_counter 'member','xiaofeng','info:age' 
COUNTER VALUE = 2
```
11. 将整张表清空：

``` css
hbase(main):035:0>truncate 'member'
Truncating 'member'table (it may take a while):
- Disabling table...
- Dropping table...
- Creating table...
0 row(s) in 4.3430seconds
```


可以看出，hbase是先将掉disable掉，然后drop掉后重建表来实现truncate的功能的。

  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516387564.jpg
  [2]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516328683.jpg
  [3]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1509516439458.jpg





