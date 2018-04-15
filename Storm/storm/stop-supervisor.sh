#!/bin/bash

. /etc/profile

kill -9 `ps -ef | grep supervisor | awk '{print $2}'| head -n 1`
