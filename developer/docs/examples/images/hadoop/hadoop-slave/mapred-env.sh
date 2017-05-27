#!/usr/bin/env bash

free=`grep MemFree /proc/meminfo | awk '{print $2}'`
buffer=`grep Buffers /proc/meminfo | awk '{print $2}'`
cache=`grep ^Cached /proc/meminfo | awk '{print $2}'`
freemem=`expr $free + $buffer + $cache`
total_free=`expr $freemem / 1024 / 3 - 90`
if [ $total_free -le 0 ]; then
  total_free=20
fi
export HADOOP_JOB_HISTORYSERVER_HEAPSIZE="${total_free}"
            
export HADOOP_MAPRED_ROOT_LOGGER=INFO,RFA
        
export HADOOP_MAPRED_LOG_DIR=/bigdata1/hadoop/logs
export HADOOP_MAPRED_PID_DIR=/bigdata1/hadoop/pids

