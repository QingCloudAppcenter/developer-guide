#!/usr/bin/env bash

HADOOP_HOME="/opt/hadoop"

dn_pid=`ps ax | grep datanode | grep -v grep | awk '{print $1}'`
if [ "x$dn_pid" = "x" ]; then
    echo "Trying to start data node..."
    USER=root $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode 
fi
