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


