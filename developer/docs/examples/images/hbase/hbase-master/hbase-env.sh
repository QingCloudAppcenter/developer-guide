# /opt/hbase/conf/hbase-env.sh

ulimit -u 65535
ulimit -n 65535
export JAVA_HOME=/usr/jdk
export HBASE_LOG_DIR=/bigdata1/hbase/logs
export HBASE_PID_DIR=/bigdata1/hbase/pids
export HBASE_CONF_PATH=/opt/hbase/conf
export HBASE_HOME=/opt/hbase
export HADOOP_HOME=/opt/hadoop
export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native
export HBASE_LIBRARY_PATH=$HBASE_LIBRARY_PATH:$JAVA_LIBRARY_PATH
export HBASE_MANAGES_ZK=false
export HBASE_ROOT_LOGGER=INFO,DRFA
export HBASE_HEAPSIZE=1G
export HBASE_OPTS="-XX:+UseConcMarkSweepGC"

free=`grep MemFree /proc/meminfo | awk '{print $2}'`
buffer=`grep Buffers /proc/meminfo | awk '{print $2}'`
cache=`grep ^Cached /proc/meminfo | awk '{print $2}'`
freemem=`expr $free + $buffer + $cache`
total_free=`expr $freemem / 1024 - 90`
if [ $total_free -le 0 ]; then
  total_free=20
fi
half_free=`expr $total_free / 2`
export HBASE_HEAPSIZE=${half_free}m
export HBASE_MASTER_OPTS="-Xmx${half_free}m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:$HBASE_LOG_DIR/gc-master.log"