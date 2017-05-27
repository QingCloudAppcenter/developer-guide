#!/bin/sh
	
# /opt/hadoop/sbin/refresh-nodes.sh
pid=`ps ax | grep java | grep ResourceManager | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  return
else
  USER=root /opt/hadoop/bin/yarn rmadmin -refreshNodes
fi
