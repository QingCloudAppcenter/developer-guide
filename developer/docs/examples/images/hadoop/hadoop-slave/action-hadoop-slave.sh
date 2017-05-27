#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"
HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

dn_pid=`ps ax | grep datanode | grep -v grep | awk '{print $1}'`
if [ "x$dn_pid" = "x" ]; then
    echo "Trying to start data node..."
    USER=root $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode 
fi

nm_pid=`ps ax | grep nodemanager | grep -v grep | awk '{print $1}'`
if [ "x$nm_pid" = "x" ];then
    echo "Trying to start node manager..."
    USER=root $HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
fi


