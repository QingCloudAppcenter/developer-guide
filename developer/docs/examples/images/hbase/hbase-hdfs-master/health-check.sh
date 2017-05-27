#!/bin/sh

# touch /opt/hadoop/sbin/health-check.sh;chmod +x /opt/hadoop/sbin/health-check.sh

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
  find /bigdata1/hadoop/logs -type f -mtime +7 -name "hadoop-root-*" -delete &
fi

pid=`ps aux | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "Namenode is not running"
 exit 1
fi

pid=`ps aux | grep java | grep SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "SecondaryNamenode is not running"
 exit 1
fi