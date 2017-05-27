#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"
HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

rm_pid=`ps ax | grep resourcemanager | grep -v grep | awk '{print $1}'`
if [ "x$rm_pid" = "x" ]; then
    echo "Trying to start resource manager..."
    USER=root $HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager 
fi

hs_pid=`ps ax | grep historyserver | grep -v grep | awk '{print $1}'`
if [ "x$hs_pid" = "x" ];then
    echo "Trying to strat job history server..."
    USER=root $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
fi

