#!/bin/sh
	
# chmod +x /opt/hadoop/sbin/start_hdfs_slave.sh
pid=`ps ax | grep java | grep DataNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
else
  return
fi

