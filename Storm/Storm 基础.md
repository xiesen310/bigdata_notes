---
title: Storm 基础 
tags: storm 
grammar_cjkRuby: true
---

# storm

- 实时计算系统
- 使用场景: 实时分析、在线机器学习、持续计算、流计算
- 速度快，每秒每个节点处理数据百万tuple级别
- toology: 无状态，集群状态和分布式环境信息在zk中保存
- 确保每个消息至少被消费一次


# 核心概念

- tuple: 元组，数据结构，有序的元素列表。通常是任意类型的数据，使用，号分割，交给storm计算
- stream: 一系列元组
- spouts: 水龙头。数据源
- bolts: 转接头，逻辑处理单元。spout数据传给bolt，bolt处理后产生新的数据，可以是filter、聚合、分组。
- topology: 不会停止的，除非手动杀死，MR是会停止的
- tasks: spout和bolt执行的过程就是task
- workers: 工作节点，storm在work之间均衡分布任务。监听job，启动或停止进程
- stream grouping : 控制tuple如何进行路由，内置4个分组策略