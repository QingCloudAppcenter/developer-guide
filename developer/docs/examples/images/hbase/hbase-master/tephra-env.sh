# /opt/hbase/bin/tephra-env.sh

ulimit -u 65535
ulimit -n 65535
export JAVA_HOME=/usr/jdk
export HBASE_HOME=/opt/hbase
export HADOOP_HOME=/opt/hadoop
export IDENT_STRING=hbase
export HOSTNAME=`hostname`
export LOG_DIR=/bigdata1/hbase/logs
export PID_DIR=/bigdata1/hbase/pids
export OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export OPTS="$OPTS -Xmx1G -XX:+UseConcMarkSweepGC"