#!/usr/bin/env bash

SPARK_LOG_PATH="/bigdata1/spark/logs"

ret_val=0

wk_pid=`ps ax | grep 'spark.*Worker' | grep -v grep | awk '{print $1}'`
if [ "x$wk_pid" = "x" ]; then
    echo "Spark worker is not running!"
    ret_val=$[$ret_val + 1]
fi

ess_pid=`ps ax | grep ExternalShuffleService | grep -v grep | awk '{print $1}'`
if [ "x$ess_pid" = "x" ];then
    echo "ExternalShuffleService is not running!"
    ret_val=$[$ret_val + 2]
fi

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
    find $SPARK_LOG_PATH -type f -mtime +7 -name "spark-root-*" -delete
fi

exit $ret_val
