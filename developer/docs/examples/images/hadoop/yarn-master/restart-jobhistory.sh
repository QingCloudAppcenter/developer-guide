#!/bin/sh
	
# /opt/hadoop/sbin/restart-jobhistory.sh
pid=`ps ax | grep java | grep HistoryServer | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  return
else
  USER=root /opt/hadoop/sbin/mr-jobhistory-daemon.sh stop historyserver
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  pid=`ps ax | grep java | grep HistoryServer | grep -v grep| awk '{print $1}'`
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

USER=root /opt/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver


