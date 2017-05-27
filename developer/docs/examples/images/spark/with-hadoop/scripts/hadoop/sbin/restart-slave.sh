#! /bin/sh

pid=`ps ax | grep java | grep datanode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  exit 0
else
  USER=root /opt/hadoop/sbin/hadoop-daemon.sh stop datanode
fi

loop=60
force=1
while [ "$loop" -gt 0 ]
do
  pid=`ps ax | grep java | grep datanode | grep -v grep| awk '{print $1}'`
  if [ "x$pid" = "x" ]
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
  kill -9 $pid
fi

USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
