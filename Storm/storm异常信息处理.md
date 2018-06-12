---
title: storm异常信息处理 
tags: storm，exception
author: XieSen
time: 2018-6-12 
grammar_cjkRuby: true
---

问题: storm发布程序的时,UI界面上找不到发布的程序

原因: storm进行程序发布的时候，是我们的代码写的有问题，如果提交代码如下所示,则会出现提交不到UI界面上的现象，这是因为在提交的时候，我们并没有提交到集群中，而是在当前节点上运行了我们的程序，程序本身并没有提交到集群中。

``` java
if (args == null || args.length < 1) {
	LocalCluster localCluster = new LocalCluster();
	localCluster.submitTopology(TOPOLOGY_NAME, config, topology);
} else {
	config.setNumWorkers(3);
	StormSubmitter.submitTopology(TOPOLOGY_NAME, config, topology);
}
```
针对上述描述的问题，其实修改一下代码就好了。修改代码如下:

``` java
if (args == null || args.length < 1) {
	LocalCluster localCluster = new LocalCluster();
	localCluster.submitTopology(TOPOLOGY_NAME, config, topology);
} else {
	config.setNumWorkers(3);
	StormSubmitter.submitTopology(args[0], config, topology);
}
```

问题：storm程序接收kafka中的数据，在本机上运行没有问题，但是在集群环境下接收不到kafka中的数据

原因: storm程序中有很多的坑，不同版本的storm之间对接kafka的版本是不同的，在接收kafka中的数据时，很有可能是storm的版本和kafka之间的版本不配导致的，下面是测试能够顺利接收到kafka的pom文件，仅供参考。

``` java
<!--storm-->
<dependency>
	<groupId>org.apache.storm</groupId>
	<artifactId>storm-core</artifactId>
	<version>1.2.1</version>
	<!--本地运行时不需要，打包上传到集群时运行需要，因为在集群运行时已经有storm的依赖-->
	<scope>provided</scope>
</dependency>

<!--storm-kafka-->
<dependency>
	<groupId>org.apache.storm</groupId>
	<artifactId>storm-kafka</artifactId>
	<version>1.2.1</version>
</dependency>

<!--kafka-->
<dependency>
	<groupId>org.apache.kafka</groupId>
	<artifactId>kafka-clients</artifactId>
	<version>0.10.0.1</version>
	<!--需要将zookeeper和log4j的依赖去掉，否则会和storm本身的依赖冲突-->
	<exclusions>
		<exclusion>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
		</exclusion>
		<exclusion>
			<groupId>org.apache.zookeeper</groupId>
			<artifactId>zookeeper</artifactId>
		</exclusion>
	</exclusions>
</dependency>
<dependency>
	<groupId>org.apache.kafka</groupId>
	<artifactId>kafka_2.10</artifactId>
	<version>0.10.0.1</version>
	<!--需要将zookeeper和log4j的依赖去掉，否则会和storm本身的依赖冲突-->
	<exclusions>
		<exclusion>
			<groupId>org.apache.zookeeper</groupId>
			<artifactId>zookeeper</artifactId>
		</exclusion>
		<exclusion>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
		</exclusion>
	</exclusions>
</dependency>
```

问题: storm程序在集群上跑，但是只在一个节点上运行

原因: storm默认情况下设置的并行度是1，因此，如果不手动设置的话，storm程序在集群上运行的时候，会选择一个节点运行程序，而不是分布式执行。可通过`config.setNumWorkers(3);`设置worker的数量和`builder.setBolt(CONVERTHOSTNAMEBOLT_ID, new ConvertHostNameBolt(), 2).shuffleGrouping(SPOUT_ID);`设置并行度来进行分布式执行。

