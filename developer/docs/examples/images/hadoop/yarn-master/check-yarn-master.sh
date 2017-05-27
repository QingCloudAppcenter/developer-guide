#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"
HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

ret_val=0
rm_pid=`ps ax | grep resourcemanager | grep -v grep | awk '{print $1}'`
if [ "x$rm_pid" = "x" ]; then
    echo "Resource manager is not running!"
    ret_val=`expr $ret_val + 1`
fi

hs_pid=`ps ax | grep historyserver | grep -v grep | awk '{print $1}'`
if [ "x$hs_pid" = "x" ];then
    echo "Job history server is not running!"
    ret_val=`expr $ret_val + 1`
fi

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "yarn-root-*" -delete
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "mapred-root-*" -delete
fi

exit $ret_val
