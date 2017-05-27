#!/bin/sh

hbase_master=$1
hbase_hdfs_master=$2
hbase_slave=$3

echo "cp hbase-master conf to $hbase_master"
scp -r hbase-master/conf.d/* root@$hbase_master:/etc/confd/conf.d/
scp -r hbase-master/templates/* root@$hbase_master:/etc/confd/templates/
ssh root@$hbase_master "touch /opt/hbase/bin/start.sh;chmod +x /opt/hbase/bin/start.sh"
ssh root@$hbase_master "touch /opt/hbase/bin/health-check.sh;chmod +x /opt/hbase/bin/health-check.sh"
ssh root@$hbase_master "touch /opt/hbase/bin/health-action.sh;chmod +x /opt/hbase/bin/health-action.sh"
ssh root@$hbase_master "touch /opt/hbase/bin/hbase-monitor.py;chmod +x /opt/hbase/bin/hbase-monitor.py"
ssh root@$hbase_master "touch /opt/hbase/bin/restart-hbase.sh;chmod +x /opt/hbase/bin/restart-hbase.sh"
ssh root@$hbase_master "touch /opt/hbase/bin/stop.sh;chmod +x /opt/hbase/bin/stop.sh"
scp hbase-master/hbase-env.sh root@$hbase_master:/opt/hbase/conf/hbase-env.sh
scp hbase-master/restart-hbase.sh root@$hbase_master:/opt/hbase/bin/restart-hbase.sh
scp hbase-master/stop.sh root@$hbase_master:/opt/hbase/bin/stop.sh
scp hbase-master/tephra-env.sh root@$hbase_master:/opt/hbase/bin/tephra-env.sh
scp forbidden_ports root@$hbase_master:/tmp/
ssh root@$hbase_master "cat /tmp/forbidden_ports >> /etc/sysctl.conf"

echo "cp hbase-hdfs-master conf to $hbase_hdfs_master"
scp -r hbase-hdfs-master/conf.d/* root@$hbase_hdfs_master:/etc/confd/conf.d/
scp -r hbase-hdfs-master/templates/* root@$hbase_hdfs_master:/etc/confd/templates/
ssh root@$hbase_hdfs_master "touch /opt/hadoop/sbin/exclude-node.sh;chmod +x /opt/hadoop/sbin/exclude-node.sh"
ssh root@$hbase_hdfs_master "touch /opt/hadoop/sbin/health-action.sh;chmod +x /opt/hadoop/sbin/health-action.sh"
ssh root@$hbase_hdfs_master "touch /opt/hadoop/sbin/health-check.sh;chmod +x /opt/hadoop/sbin/health-check.sh"
ssh root@$hbase_hdfs_master "touch /opt/hadoop/sbin/refresh-nodes.sh;chmod +x /opt/hadoop/sbin/refresh-nodes.sh"
ssh root@$hbase_hdfs_master "touch /opt/hadoop/sbin/restart-dfs.sh;chmod +x /opt/hadoop/sbin/restart-dfs.sh"
scp hbase-hdfs-master/exclude-node.sh root@$hbase_hdfs_master:/opt/hadoop/sbin/exclude-node.sh
scp hbase-hdfs-master/hadoop-env.sh root@$hbase_hdfs_master:/opt/hadoop/etc/hadoop/hadoop-env.sh
scp hbase-hdfs-master/health-action.sh root@$hbase_hdfs_master:/opt/hadoop/sbin/health-action.sh
scp hbase-hdfs-master/health-check.sh root@$hbase_hdfs_master:/opt/hadoop/sbin/health-check.sh
scp hbase-hdfs-master/refresh-nodes.sh root@$hbase_hdfs_master:/opt/hadoop/sbin/refresh-nodes.sh 
scp hbase-hdfs-master/restart-dfs.sh root@$hbase_hdfs_master:/opt/hadoop/sbin/restart-dfs.sh
scp forbidden_ports root@$hbase_hdfs_master:/tmp/
ssh root@$hbase_hdfs_master "cat /tmp/forbidden_ports >> /etc/sysctl.conf"

echo "cp hbase-slave conf to $hbase_slave"
scp -r hbase-slave/conf.d/* root@$hbase_slave:/etc/confd/conf.d/
scp -r hbase-slave/templates/* root@$hbase_slave:/etc/confd/templates/
ssh root@$hbase_slave "touch /opt/hbase/bin/hbase-monitor.py;chmod +x /opt/hbase/bin/hbase-monitor.py"
ssh root@$hbase_slave "touch /opt/hbase/bin/health-action.sh;chmod +x /opt/hbase/bin/health-action.sh"
ssh root@$hbase_slave "touch /opt/hbase/bin/health-check.sh;chmod +x /opt/hbase/bin/health-check.sh"
ssh root@$hbase_slave "touch /opt/hadoop/sbin/start-hadoop-slave.sh;chmod +x /opt/hadoop/sbin/start-hadoop-slave.sh"
ssh root@$hbase_slave "touch /opt/hbase/bin/start-regionserver.sh;chmod +x /opt/hbase/bin/start-regionserver.sh"
scp hbase-slave/hadoop-env.sh root@$hbase_slave:/opt/hadoop/etc/hadoop/hadoop-env.sh
scp hbase-slave/hbase-env.sh root@$hbase_slave:/opt/hbase/conf/hbase-env.sh
scp hbase-slave/health-action.sh root@$hbase_slave:/opt/hbase/bin/health-action.sh
scp hbase-slave/health-check.sh root@$hbase_slave:/opt/hbase/bin/health-check.sh
scp hbase-slave/start-hadoop-slave.sh root@$hbase_slave:/opt/hadoop/sbin/start-hadoop-slave.sh
scp hbase-slave/start-regionserver.sh root@$hbase_slave:/opt/hbase/bin/start-regionserver.sh
scp forbidden_ports root@$hbase_slave:/tmp/
ssh root@$hbase_slave "cat /tmp/forbidden_ports >> /etc/sysctl.conf"

