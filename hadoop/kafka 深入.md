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
/**
* 创建一个新的实例 ProducerClient.
* 构造方法
*/
public ProducerClient() {
	properties = new Properties();
	properties.put("bootstrap.servers", "master:9092,slaver1:9092");
	properties.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
	properties.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
	producer = new KafkaProducer<>(properties);
}
```


2. 发送数据

``` java
/**
* sendRecorder 发送数据
* @param @param key
* @param @param value 参数
* @return void 返回类型
* @Exception 异常对象
* @author Allen
*/
public void sendRecorder(String key, String value) {
	ProducerRecord<String, String> record = new ProducerRecord<>("from-java", key, value);
	producer.send(record);
}
```

3. 关闭连接

``` java
/**
* close 刷新数据，关闭连接
* @param  参数
* @return void 返回类型
* @Exception 异常对象
* @author Allen
*/
public void close() {
	producer.flush();
	producer.close();
}
```

4. 指定分区发送数据

``` java
/**
* assignPartitionSend 指定分区发送数据
* @param @param key
* @param @param value 参数
* @return void 返回类型
* @Exception 异常对象
* @author Allen
*/
public void assignPartitionSend(String key, String value) {
	ProducerRecord<String, String> record = new ProducerRecord<>("from-java", 0, key, value);
	producer.send(record);
}
```


5. 获取topic详细信息

``` java
/**
* getTopicPartition 获取topic的详细信息
* @param @param topic 参数
* @return void 返回类型
* @Exception 异常对象
* @author Allen
*/
public void getTopicPartition(String topic) {

	List<PartitionInfo> partitionInfos = producer.partitionsFor(topic);
	for (PartitionInfo partitionInfo : partitionInfos) {
		System.out.println(partitionInfo);
	}
}
```
6. 获取集群状态信息

``` java
/**
* getMetrics 获取集群状态信息
* @param  参数
* @return void 返回类型
* @Exception 异常对象
* @author Allen
*/
public void getMetrics() {
	Map<MetricName, ? extends Metric> metrics = producer.metrics();
	for (MetricName name : metrics.keySet()) {
		System.out.println(name.name() + " : " + metrics.get(name).value());
	}
}
```

7. 发送数据返回状态信息---回调函数

``` java
	/**
	* sendRecorderWithCallback 回调函数返回发送信息
	* @param @param key
	* @param @param value 参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void sendRecorderWithCallback(String key, String value) {

		Logger logger = LoggerFactory.getLogger(ProducerClient.class);
		ProducerRecord<String, String> record = new ProducerRecord<>("from-java", key, value);
		producer.send(record, new Callback() {
			// 回调方法，在整个方法被调用之后，Record的接收和存储是由服务端来完成
			// callback是服务端接收服务器存储完了，返回回调的一个函数
			@Override
			public void onCompletion(RecordMetadata metadata, Exception exception) {
				if (exception == null) {
					logger.info("存储位置:partition:" + metadata.partition() + ",offset:" + metadata.offset()
							+ ",timestrap:" + metadata.timestamp());
				} else {
					logger.warn("服务端出现异常: ");
					exception.printStackTrace();
				}
			}
		});
	}

```


## java API 创建Consumer

1. 创建连接

``` java
/**
* 创建一个新的实例 ConsumerClient.
* 构造方法
*/
public ConsumerClient() {
	properties = new Properties();
	properties.put("bootstrap.servers", "master:9092,slaver1:9092");
	properties.put("group.id", "java_group");
	properties.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	properties.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	consumer = new KafkaConsumer<>(properties);
}
```

2. 订阅topic方法

``` java
	/**
	* subscribeTopic 订阅topic
	* @param  参数
	* @return void 返回类型
	* @Exception 异常对象
	* @author Allen
	*/
	public void subscribeTopic(){
		consumer.subscribe(Arrays.asList("from-java"));
		while(true){
			// 从kafka拉取数据
			ConsumerRecords<String,String> records = consumer.poll(1000);
			
			for (ConsumerRecord<String, String> record : records) {
				System.out.printf("partition = %d, offset = %d, key = %s, value = %s%n", 
						record.partition(), record.offset(), record.key(), record.value());
			}
		}
	}
```




  [1]: https://www.github.com/xiesen310/notes_Images/raw/master/images/1510278579304.jpg