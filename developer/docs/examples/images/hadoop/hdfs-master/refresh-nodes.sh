#!/bin/sh
	
# /opt/hadoop/sbin/refresh-nodes.sh
pid=`ps ax | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  return
else
  USER=root /opt/hadoop/bin/hdfs dfsadmin -refreshNodes
fi
