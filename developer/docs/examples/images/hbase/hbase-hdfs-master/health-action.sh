#!/bin/sh

# touch /opt/hadoop/sbin/health-action.sh;chmod +x /opt/hadoop/sbin/health-action.sh

pid=`ps aux | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "Namenode is not running"
 USER=root /opt/hadoop/sbin/hadoop-daemon.sh start namenode
fi

pid=`ps aux | grep java | grep SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "SecondaryNamenode is not running"
 USER=root /opt/hadoop/sbin/hadoop-daemon.sh start secondarynamenode
fi