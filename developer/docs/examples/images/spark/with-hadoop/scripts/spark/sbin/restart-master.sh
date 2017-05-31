#!/usr/bin/env bash

SPARK_HOME="/opt/spark"

sk_pid=`ps ax | grep 'spark.*Master' | grep -v grep | awk '{print $1}'`
if [ "x$sk_pid" = "x" ]; then
    exit 0
else
    USER=root $SPARK_HOME/sbin/stop-master.sh
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  sk_pid=`ps ax | grep 'spark.*Master' | grep -v grep | awk '{print $1}'`
  if [ "x$sk_pid" = "x" ]
  then
    force=0
    break
  else
    sleep 3s
    loop=$[$loop - 1]
  fi
done

if [ "$force" -eq 1 ]
then
  kill -9 $sk_pid
fi

USER=root $SPARK_HOME/sbin/start-master.sh
