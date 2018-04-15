#!/bin/bash
. /etc/profile
source /etc/profile

time=$(date "+%Y-%m-%d %H:%M:%S")
echo ${time}" execute "${BASH_SOURCE}" script ..."
# Ensure that each supervisor has stop-supervisor.sh
bin=$STORM_HOME/bin
# configuration supervisor node hosts
supervisors=$STORM_HOME/bin/supervisor-hosts

kill -9 `ps -ef | grep nimbus | awk '{print $2}'| head -n 1`
kill -9 `ps -ef | grep core | awk '{print $2}'| head -n 1`

# start each node supervisor
cat $supervisors | while read supervisor
do
	echo ${supervisor}" start supervisor process ..."
	ssh $supervisor $bin/stop-supervisor.sh &
done
