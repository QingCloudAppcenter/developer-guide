#!/bin/sh
	
# touch /opt/hadoop/sbin/refresh-nodes.sh;chmod +x /opt/hadoop/sbin/refresh-nodes.sh
pid=`ps ax | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  exit 0
else
  USER=root /opt/hadoop/bin/hdfs dfsadmin -refreshNodes
fi
