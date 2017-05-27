#!/bin/bash
HIVE_HOME=/usr/local/hive
PATH="/sbin:/usr/sbin:/bin:/usr/bin:$HIVE_HOME/bin/"
export PATH

MYSQL_DATA=/data/mysql
CONF_DIR=$HIVE_HOME/conf
LOG_DIR=/data/hive/logs

role="none"
str=`cat /etc/hosts|grep "^\s*# role"`
str=${str/"#"/""}
eval $str
server_name_str=(
"database"
"hiveserver2"
)
section_str=(
"^\[database\]"
"^\[hive\]"
)
for((index=0;index<${#server_name_str[*]};index++));do 
    server_name=${server_name_str[$index]}
    section=${section_str[$index]}
    eval ${server_name}_server=0
    if egrep $section $CONF_DIR/config.ini -A 50 | grep "^\s*# ${server_name}_server_local" >& /dev/null;then
        eval ${server_name}_server=1
        if egrep $section $CONF_DIR/config.ini -A 50 | grep "^\s*# ${server_name}_server_local=true" >& /dev/null;then
            eval ${server_name}_server_local=1
        else
            eval ${server_name}_server_local=0
        fi
    fi
done

init_database() {
    if [ $database_server -eq 1 ];then 
        if [ $role = "hive-server" -a $database_server_local -eq 1 ];then
            if [ -e "$MYSQL_DATA" ]; then
                rm -rf $MYSQL_DATA
            fi
            tar -zxf /usr/local/mysql/mysql.tgz -C /data
            mv /data/data $MYSQL_DATA
            chown -R ubuntu:ubuntu $MYSQL_DATA
        fi
    fi
}
start_database() {
    if [ $database_server -eq 1 ];then 
        if [ $role = "hive-server" -a $database_server_local -eq 1 ];then
            if test -r $MYSQL_DATA/`hostname`.pid;then
                #echo "exit!"
	            return 0
            else
                sudo -u ubuntu service mysql.server start >& /dev/null
                run=$?
                if [ $run -ne 0 ];then
                    exit $run
                fi
            fi
#            ps aux|grep mysql   
        fi
    fi
}
stop_database() {
    if test -r $MYSQL_DATA/`hostname`.pid;then
        sudo -u ubuntu service mysql.server stop >& /dev/null
        run=$?
        if [ $run -ne 0 ];then
            exit $run
        fi
    else
	    return 0
    fi
}
start_daemon(){
    TIMEOUT=5
    name=$1
    cmd=$2
    PID="$LOG_DIR/${name}.pid"
    if test -r $PID; then
        if kill -0 `cat $PID` > /dev/null 2>&1; then
            echo "start $name: command running as process `cat $PID`.  Stop it first."
        else
            rm $PID*
            echo "start $name: pid file error, please try again!"
        fi
    else 
        daemon_cmd="${cmd} > $LOG_DIR/${name}.log 2>&1 &"
        cmd_pid=""
	    loop=$TIMEOUT
	    force=1
	    while [ $loop -gt 0 ];do
            if kill -0 $cmd_pid > /dev/null 2>&1; then 
	            echo $cmd_pid > $PID
	            force=0
                break
	        else
                eval $daemon_cmd
                cmd_pid=$!
	    	    sleep 3
	    	    loop=`expr $loop - 1`
	        fi
	    done
	    if [ $force -eq 0 ]; then
	        echo "start $name: Success."
	    else
	        echo "start $name: Timeout."
	        #exit 1
        fi
    fi
}
stop_daemon(){
    TIMEOUT=10
    name=$1
    PID="$LOG_DIR/${name}.pid"
    if test -r $PID;then
        if kill -0 `cat $PID` > /dev/null 2>&1;then
	    loop=$TIMEOUT
	    force=1
	    while [ $loop -gt 0 ];do
            if kill -0 `cat $PID` > /dev/null 2>&1;then
                kill -9 `cat $PID`
                sleep 1
    	        loop=`expr $loop - 1`
	        else
                force=0
		        rm $PID
                break
	        fi
	    done
	    if [ $force -eq 0 ]; then
	        echo "stop $name: Success."
	    else
	        echo "stop $name: Timeout."
	        #exit 1
            fi
        else
            rm $PID*
            echo "stop $name: pid file error, please try again!"
        fi
    else
        echo "stop $name: No pid file found."
        #exit 1
    fi    
}
start_hiveserver2() {
    if [ $hiveserver2_server -eq 1 ];then 
        if [ $role = "hive-server" -a $hiveserver2_server_local -eq 1 ]||[ $role = "hive-hiveserver2" -a $hiveserver2_server_local -eq 0 ];then
            start_daemon hiveserver2 "hive --service hiveserver2"
        fi
    fi
}
stop_hiveserver2() {
    stop_daemon hiveserver2
}

init_hive() {
    mkdir -p $LOG_DIR
}
start_hive() {
    if [ $role = "hive-server" -a $hiveserver2_server_local -eq 0 ];then
        start_daemon metastore "hive --service metastore -p 9083"
    fi
}
stop_hive() {
    if [ $role = "hive-server" ];then
        stop_daemon metastore
    fi 
}
stop() {
    echo "Stoping hive... "
    stop_hive
    stop_hiveserver2
    stop_database
}
start() {
    start_database
    echo "Starting hive... "
    start_hive
    start_hiveserver2 
}
init() {
    init_database
    init_hive
}
case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    restart)
	stop
	start
	;;
    init)
    init
    ;;
    *)
	echo $"Usage: $ {start|stop|restart|status|init}"
esac
