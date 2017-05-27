#!/usr/bin/env bash

SPARK_HOME="/opt/spark"

loop=5
find=0
master_ip=""
while [ "$loop" -gt 0 ]
do
  master_ip=`grep SPARK_MASTER_IP /opt/spark/conf/spark-env.sh | cut -d = -f 2`
  if [ "x$master_ip" = "x" ]
  then
    sleep 3s
    loop=$[$loop - 1]
  else
    find=1
    break
  fi
done

if [ "$find" -eq 0 ]
then
  echo "Failed to find spark master IP" 1>&2
  exit 1
fi

ess_pid=`ps ax | grep ExternalShuffleService | grep -v grep | awk '{print $1}'`
if [ "x$ess_pid" = "x" ];then
    echo "Trying to start ExternalShuffleService..."
    USER=root $SPARK_HOME/sbin/start-shuffle-service.sh
fi

wk_pid=`ps ax | grep 'spark.*Worker' | grep -v grep | awk '{print $1}'`
if [ "x$wk_pid" = "x" ];then
    echo "Trying to start spark workers..."
    USER=root $SPARK_HOME/sbin/start-slave.sh spark://$master_ip:7077
fi
