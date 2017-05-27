#!/bin/sh
	
# /opt/spark/sbin/restart-master.sh
pid=`ps ax | grep java | grep org.apache.spark.deploy.master.Master | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  return
else
  /opt/spark/sbin/stop-master.sh
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  pid=`ps ax | grep java | grep org.apache.spark.deploy.master.Master | grep -v grep| awk '{print $1}'`
  if [ "x$pid" = "x" ]
  then
    force=0
    break
  else
    sleep 10s
    loop=`expr $loop - 1`
  fi
done

if [ "$force" -eq 1 ]
then
  kill -9 $pid
fi

/opt/spark/sbin/start-master.sh
