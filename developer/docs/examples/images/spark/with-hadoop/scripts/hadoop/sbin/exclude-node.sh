#!/bin/sh
   
# touch /opt/hadoop/sbin/exclude-node.sh;chmod +x /opt/hadoop/sbin/exclude-node.sh
pid=`ps ax | grep java | grep NameNode | grep -v SecondaryNameNode | grep -v grep| awk '{print $1}'`
if [ "x$pid" = "x" ]
then
 echo "Namenode is not running"
 exit 1
fi

# check if there is enough space to transfer the data from the node ($1)
# ignore checking here

/opt/hadoop/bin/hdfs dfsadmin -refreshNodes

loop=74060
step=120

while [ $loop -ge 0 ]
do
 status=`/opt/hadoop/bin/hdfs dfsadmin -report | grep 'Decommission Status' | cut -d : -f 2`;
 echo $status
 if echo "$status" | grep [p]rogress > /dev/null; then
   echo "It's under decommissing!"
   loop=$[$loop - 1]
   sleep $step
 else
   echo "It's normal"
   break
 fi
done

if [ $loop -le 0 ]
then
 echo "Checking hadoop decommissing status timeout"
 exit 1
fi

exit 0
