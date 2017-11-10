---
title: kafka 深入
tags: kafka,hadoop
grammar_cjkRuby: true
---

## 配置sl4j日志

1. 导入sl4j依赖

``` xml
<dependency>
	<groupId>org.slf4j</groupId>
	<artifactId>slf4j-log4j12</artifactId>
	<version>1.7.21</version>
</dependency>
```
2. 添加log4j文件

![][1]


## java API 创建Producer

1. 创建连接

``` java
public ProducerClient() {
		properties = new Properties();
		properties.put("bootstrap.servers", "master:9092,slaver1:9092");
		properties.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		properties.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		producer = new KafkaProducer<>(properties);
	}
```


2. 发送数据
3. 关闭连接
4. 指定分区发送数据
5. 获取topic详细信息
6. 获取集群状态信息

  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510278579304.jpg