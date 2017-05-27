#!/bin/sh
	
# touch /opt/hbase/bin/start-regionserver.sh;chmod +x /opt/hbase/bin/start-regionserver.sh
pid=`ps ax | grep java | grep HRegionServer | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  USER=root /opt/hbase/bin/hbase-daemon.sh start regionserver
else
  exit 0
fi