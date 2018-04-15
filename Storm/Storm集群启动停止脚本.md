---
title: Storm集群启动停止脚本 
tags: sh,脚本,storm
grammar_cjkRuby: true
---

# storm脚本启动

``` shell
#!/bin/bash
. /etc/profile
source /etc/profile


time=$(date "+%Y-%m-%d %H:%M:%S")
echo ${time}" execute "${BASH_SOURCE}" script"

# Ensure that each supervisor has start-supervisor.sh
bin=$STORM_HOME/bin
# configuration supervisor node hosts
supervisors=$STORM_HOME/bin/supervisor-hosts

echo ${time}" start nimbus and storm ui process ..."
nohup storm nimbus &
nohup storm ui &
# nohup storm logviewer &

# start each node supervisor
cat $supervisors | while read supervisor
do
	echo ${supervisor}" start supervisor process ..."
	ssh $supervisor $bin/start-supervisor.sh &
done

```

# 启动supervisor脚本

``` shell
#!/bin/bash

. /etc/profile

kill -9 `ps -ef | grep supervisor | awk '{print $2}'| head -n 1`
```
# supervisor启动的主机脚本

``` shell
slave1
slave2

```
