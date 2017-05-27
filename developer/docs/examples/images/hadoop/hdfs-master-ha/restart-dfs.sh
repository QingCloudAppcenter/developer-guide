#!/bin/sh
	
# /opt/hadoop/sbin/restart-dfs.sh

pid=`ps ax | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  return
else
  # Make sure dfs service be restarted only one time
  local_host = `hostname`
  ha_status = `bin/hdfs haadmin -getServiceState $local_host`
  if [ "$ha_status" != "Active" ]; then
    return
  fi
  USER=root /opt/hadoop/sbin/stop-dfs.sh
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  pid=`ps ax | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
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

USER=root /opt/hadoop/sbin/start-dfs.sh

