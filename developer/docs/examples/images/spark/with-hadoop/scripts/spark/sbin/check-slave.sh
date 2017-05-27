#!/usr/bin/env bash

ret_spark=0
ret_hadoop=0

/opt/spark/sbin/check-spark-slave.sh
ret_spark=$?

/opt/hadoop/sbin/check-hdfs-slave.sh
ret_hadoop=$?

ret_val=$[$ret_spark + 100*$ret_hadoop]

exit $ret_val
