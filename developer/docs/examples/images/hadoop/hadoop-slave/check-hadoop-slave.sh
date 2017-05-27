#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"
HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

ret_val=0
dn_pid=`ps ax | grep datanode | grep -v grep | awk '{print $1}'`
if [ "x$dn_pid" = "x" ]; then
    echo "Datanode is not running!"
    ret_val=`expr $ret_val + 1` 
fi

nm_pid=`ps ax | grep nodemanager | grep -v grep | awk '{print $1}'`
if [ "x$nm_pid" = "x" ];then
    echo "Node manager is not running!"
    ret_val=`expr $ret_val + 1`
fi

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "hadoop-root-*" -delete
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "yarn-root-*" -delete
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "mapred-root-*" -delete
fi

exit $ret_val
