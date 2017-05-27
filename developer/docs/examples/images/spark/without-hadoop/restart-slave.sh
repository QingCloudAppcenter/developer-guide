#!/bin/sh
	
# /opt/spark/sbin/restart-slave.sh
loop=60
find=0
master_ip=""
while [ "$loop" -gt 0 ]
do
  master_ip=`grep SPARK_MASTER_IP /opt/spark/conf/spark-env.sh | cut -d = -f 2`
  if [ "x$master_ip" = "x" ]
  then
    sleep 3s
    loop=`expr $loop - 1`
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

pid=`ps ax | grep java | grep org.apache.spark.deploy.worker.Worker | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  /opt/spark/sbin/start-slave.sh spark://$master_ip:7077
  return
else
  /opt/spark/sbin/stop-slave.sh
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  pid=`ps ax | grep java | grep org.apache.spark.deploy.worker.Worker | grep -v grep| awk '{print $1}'`
  if [ "x$pid" = "x" ]
  then
    force=0
    break
  else
    sleep 3s
    loop=`expr $loop - 1`
  fi
done
if [ "$force" -eq 1 ]
then
  kill -9 $pid
fi

/opt/spark/sbin/start-slave.sh spark://$master_ip:7077
