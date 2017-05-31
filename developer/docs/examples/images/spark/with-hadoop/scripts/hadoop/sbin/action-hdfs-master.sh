#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"
HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

nn_pid=`ps ax | grep proc_namenode | grep -v grep | awk '{print $1}'`
if [ "x$nn_pid" = "x" ]; then
    echo "Trying to start name node..."
    USER=root $HADOOP_HOME/sbin/hadoop-daemon.sh start namenode 
fi

snn_pid=`ps ax | grep secondarynamenode | grep -v grep | awk '{print $1}'`
if [ "x$snn_pid" = "x" ];then
    echo "Trying to start secondary name node..."
    USER=root $HADOOP_HOME/sbin/hadoop-daemon.sh start secondarynamenode
fi


