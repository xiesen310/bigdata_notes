---
title: Day18
tags: hadoop,hbaseJava
grammar_cjkRuby: true
---
## rowkey设计

HBase是一个分布式的、面向列的数据库，它和一般关系型数据库的最大区别是：HBase很适合于存储非结构化的数据，还有就是它基于列的而不是基于行的模式。
既然HBase是采用KeyValue的列存储，那Rowkey就是KeyValue的Key了，表示唯一一行。Rowkey也是一段二进制码流，最大长度为64KB，内容可以由使用的用户自定义。数据加载时，一般也是根据Rowkey的二进制序由小到大进行的。
HBase是根据Rowkey来进行检索的，系统通过找到某个Rowkey (或者某个 Rowkey 范围)所在的Region，然后将查询数据的请求路由到该Region获取数据。HBase的检索支持3种方式：
（1） 通过单个Rowkey访问，即按照某个Rowkey键值进行get操作，这样获取唯一一条记录；
（2） 通过Rowkey的range进行scan，即通过设置startRowKey和endRowKey，在这个范围内进行扫描。这样可以按指定的条件获取一批记录；
（3） 全表扫描，即直接扫描整张表中所有行记录。
HBASE按单个Rowkey检索的效率是很高的，耗时在1毫秒以下，每秒钟可获取1000~2000条记录，不过非key列的查询很慢。


1. 数据的存储
2. region划分
3. rowkey是唯一标识
4. rowkey是表中唯一的索引，不支持其他的索引


### rowkey设计原则

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

``` java
package top.xiesen.bd14.rowkey;

import java.io.IOException;
import java.nio.ByteBuffer;

import org.apache.hadoop.hbase.Cell;
import org.apache.hadoop.hbase.CellScanner;
import org.apache.hadoop.hbase.CellUtil;
import org.apache.hadoop.hbase.CompareOperator;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.filter.RegexStringComparator;
import org.apache.hadoop.hbase.filter.RowFilter;
import org.apache.hadoop.hbase.util.Bytes;


/**
* 项目名称：mrhbase
* 类名称：PersonInfo
* 类描述：以个人信息为例，展示rowkey的生成策略
* @author Allen
*/
public class PersonInfo {
	/**
	* getRowKey rowkey生成策略 ,rowkey一般是字符串
	* 格式为:idcard(18byte) + name(30bytes)
	* @param @param idCard 身份证号码
	* @param @param name 姓名
	* @return byte[] 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public byte[] getRowKey(String idCard,String name){
		byte[] idCardBytes = Bytes.toBytes(idCard);
		if(idCardBytes.length!= 18){
			System.out.println("身份证位数不对!");
			return null;
		}
		byte[] nameBytes = Bytes.toBytes(name);
		ByteBuffer result = ByteBuffer.allocate(48);
		result.put(idCardBytes);
		result.put(nameBytes);
		
//		System.out.println(result.position());
		byte blank = 0x1F;
		while(result.position() < 48){
			result.put(blank);
		}
//		System.out.println(result.position());
		return result.array();
	}
	public Put generatePersonInfo(){
		String idCard = "412824199404201234";
		String name = "张三";
		Put put = new Put(getRowKey(idCard, name));
		put.addColumn("i".getBytes(), "gender".getBytes(), "男".getBytes());
		put.addColumn("i".getBytes(), "age".getBytes(), "28".getBytes());
		return put;
	}
	
	
	/**
	* getDataByName 通过名称获取数据
	* @param @param table Table对象
	* @param @param name 姓名
	* @param @throws IOException 参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void getDataByName(Table table,String name) throws IOException{
		RowFilter filter = new RowFilter(CompareOperator.EQUAL, new RegexStringComparator(name));
		Scan scan = new Scan();
		scan.setFilter(filter);
		ResultScanner rs = table.getScanner(scan);
		Result result = rs.next();
		while(result != null){
			byte[] row = result.getRow();
			String idCard = Bytes.toString(row, 0, 18);
			String username = Bytes.toString(row, 18, 30);
			String age = Bytes.toString(result.getValue(Bytes.toBytes("i"), Bytes.toBytes("age")));
			String gender = Bytes.toString(result.getValue(Bytes.toBytes("i"), Bytes.toBytes("gender")));
			System.out.println("身份证号:" + idCard + "\t姓名:" + username + "\t年龄:" + age + "\t性别:" + gender);
			result = rs.next();
		}
	}
	
	
	public static void main(String[] args) throws IOException {
		PersonInfo personInfo = new PersonInfo();
//		byte[] result = personInfo.getRowKey("412824199404201111", "张三");
		Connection connection = ConnectionFactory.createConnection(HBaseConfiguration.create());
		
		// 创建表: create 'bd14:person','i'
		Table person = connection.getTable(TableName.valueOf("bd14:person"));
		
		person.put(personInfo.generatePersonInfo());
		
		personInfo.getDataByName(person, "张三");
	}
}
```

## 二级索引

使用索引的目的就是为了增加查询的速度，在hbase中默认支持rowkey索引，但在实际的项目开发过程中，我们往往需要使用其他的索引进行查询我们需要的信息，所以就引入了二级索引的概念

在Hbase中实现二级索引的目的是：
1. 实现高性能的范围查询
2. 数据的低冗余(存储所占的数据量)
3. 数据的一致性

创建二级索引分为两种，一种是在插入数据的同时，直接创建索引，另一种形式是已经存在历史数据，我们创建索引




历史数据的索引通过mr批量写入索引表

Phoenix是hbase的sql引擎
hbase只支持单行的事务

hbase不支持表关联