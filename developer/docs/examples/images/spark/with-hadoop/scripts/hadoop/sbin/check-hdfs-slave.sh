#!/usr/bin/env bash

HADOOP_LOG_PATH="/bigdata1/hadoop/logs"

ret_val=0

dn_pid=`ps ax | grep datanode | grep -v grep | awk '{print $1}'`
if [ "x$dn_pid" = "x" ]; then
    echo "Datanode is not running!"
    ret_val=$[$ret_val + 1]
fi

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
    find $HADOOP_LOG_PATH -type f -mtime +7 -name "hadoop-root-*" -delete
fi

exit $ret_val
