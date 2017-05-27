#!/bin/sh
	
# touch /opt/hadoop/sbin/start-hadoop-slave.sh;chmod +x /opt/hadoop/sbin/start-hadoop-slave.sh
pid=`ps ax | grep java | grep DataNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
else
  exit 0
fi