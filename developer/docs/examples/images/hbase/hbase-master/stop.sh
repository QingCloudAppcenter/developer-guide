#!/bin/sh

# touch /opt/hbase/bin/stop.sh;chmod +x /opt/hbase/bin/stop.sh

USER=root echo balance_switch false | /opt/hbase/bin/hbase shell
if [ $? -ne 0 ];then
  # do not exit 1
  echo "Start HBase balance_switch failed"
fi

USER=root /opt/hbase/bin/hbase-daemon.sh stop rest -p 8000
if [ $? -ne 0 ];then
  # do not exit 1
  echo "Stop Rest failed"
fi

USER=root /opt/hbase/bin/stop-hbase.sh
if [ $? -ne 0 ];then
  # do not exit 1
  echo "Stop HBase failed"
fi

# force, because of change vxnet or zookeeper lost
USER=root /opt/hbase/bin/hbase-daemon.sh stop master
if [ $? -ne 0 ];then
  # do not exit 1
  echo "HMaster has already been stopped"
fi

USER=root /opt/hbase/bin/hbase-daemon.sh stop thrift2
if [ $? -ne 0 ];then
  # do not exit 1
  echo "Thrift2 has already been stopped"
fi

USER=root /opt/hbase/bin/tephra stop
if [ $? -ne 0 ];then
  # do not exit 1
  echo "HBase phoenix tephra has already been stopped"
fi