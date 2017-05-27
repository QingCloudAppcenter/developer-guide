#!/bin/sh

# touch /opt/hbase/bin/health-check.sh;chmod +x /opt/hbase/bin/health-check.sh

HM=`date -d "now" +%H%M`
if [ $HM -eq "0200" ];then
  find /bigdata1/hbase/logs -type f -mtime +7 -name "hbase-root-*" -delete &
  find /bigdata1/hbase/logs -type f -mtime +7 -name "SecurityAuth.audit.*" -delete &
  find /bigdata1/hadoop/logs -type f -mtime +7 -name "hadoop-root-*" -delete &
fi

pid=`ps aux | grep java | grep DataNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "Datanode is not running"
 exit 1
fi


pid=`ps aux | grep java | grep HRegionServer | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "HRegionServer is not running"
 exit 1
fi