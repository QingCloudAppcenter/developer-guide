#!/bin/sh

# touch /opt/hbase/bin/health-action.sh;chmod +x /opt/hbase/bin/health-action.sh

pid=`ps aux | grep java | grep DataNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "Datanode is not running"
 USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
fi


pid=`ps aux | grep java | grep HRegionServer | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "HRegionServer is not running"
 USER=root /opt/hbase/bin/hbase-daemon.sh start regionserver
fi