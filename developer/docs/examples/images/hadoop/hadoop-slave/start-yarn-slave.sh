#!/bin/sh
	
# chmod +x /opt/hadoop/sbin/start_yarn_slave.sh
pid=`ps ax | grep java | grep NodeManager | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
  USER=root /opt/hadoop/sbin/yarn-daemon.sh start nodemanager
else
  return
fi

