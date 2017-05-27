#!/usr/bin/env bash

SPARK_HOME="/opt/spark"
loop=60
find=0
master_ip=""
slave_started=1
shuffle_started=1

while [ "$loop" -gt 0 ]
do
  master_ip=`grep SPARK_MASTER_IP $SPARK_HOME/conf/spark-env.sh | cut -d = -f 2`
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

function force_stop_service {
  loop=60
  force=1
  while [ "$loop" -gt 0 ]
  do
    pid=`ps ax | grep java | grep $1 | grep -v grep| awk '{print $1}'`
    if [ "x$pid" = "x" ]
    then
      force=0
      echo "$1 stopped"
      break
    else
      sleep 3s
      loop=$[$loop - 1]
    fi
  done
  if [ "$force" -eq 1 ]
  then
    kill -9 $pid
  fi
}

pid=`ps ax | grep java | grep ExternalShuffleService | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  shuffle_started=0
else
  USER=root $SPARK_HOME/sbin/stop-shuffle-service.sh
  force_stop_service ExternalShuffleService
fi

pid=`ps ax | grep java | grep 'spark.*Worker' | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  slave_started=0
else
  USER=root $SPARK_HOME/sbin/stop-slave.sh
  force_stop_service \'spark.*Worker\'
fi

if [ $shuffle_started -eq 1 ]
then
  USER=root $SPARK_HOME/sbin/start-shuffle-service.sh
fi

if [ $slave_started -eq 1 ]
then
  USER=root $SPARK_HOME/sbin/start-slave.sh spark://$master_ip:7077
fi
