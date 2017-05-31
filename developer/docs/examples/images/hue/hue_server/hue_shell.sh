#!/bin/bash
HUE_HOME=/usr/local/hue
PATH="/sbin:/usr/sbin:/bin:/usr/bin:$HUE_HOME/build/env/bin/"
export PATH

MYSQL_DATA=/data/mysql
CONF_DIR=$HUE_HOME/desktop/conf
LOG_DIR=/data/hue/logs
TIMEOUT=10
PIDFILE=supervisor.pid;PID=$HUE_HOME/$PIDFILE
HUE_USER=hue;HUE_GROUP=hue

role="none"
str=`cat /etc/hosts|grep "^\s*# role"`
str=${str/"#"/""}
eval $str
server_name_str=(
"database"
"livy"
)
section_str=(
"^\s*\[\[database\]\]"
"^\[spark\]"
)
for((index=0;index<${#server_name_str[*]};index++));do 
    server_name=${server_name_str[$index]}
    section=${section_str[$index]}
    eval ${server_name}_server=0
    if egrep $section $CONF_DIR/hue.ini -A 50 | grep "^\s*# ${server_name}_server_local" >& /dev/null;then
        eval ${server_name}_server=1
        if egrep $section $CONF_DIR/hue.ini -A 50 | grep "^\s*# ${server_name}_server_local=true" >& /dev/null;then
            eval ${server_name}_server_local=1
        else
            eval ${server_name}_server_local=0
        fi
    fi
done

init_database() {
    if [ $database_server -eq 1 ];then 
        if [ $role = "hue-server" -a $database_server_local -eq 1 ];then
            if [ -e "$MYSQL_DATA" ]; then
                rm -rf $MYSQL_DATA
            fi
            cp -r /usr/local/mysql/mysql.tgz /data/
            tar -zxf /data/mysql.tgz -C /data
            chown -R ubuntu:ubuntu $MYSQL_DATA
            rm /data/mysql.tgz
        fi
    fi
}
start_database() {
    if [ $database_server -eq 1 ];then 
        if [ $role = "hue-server" -a $database_server_local -eq 1 ];then
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
start_livy() {
    if [ $livy_server -eq 1 ];then 
        if [ $role = "hue-server" -a $livy_server_local -eq 1 ]||[ $role = "spark-client" -a $livy_server_local -eq 0 ];then
            /usr/local/livy/bin/livy-server start
        fi
    fi
}
stop_livy() {
    /usr/local/livy/bin/livy-server stop
}
init_hue() {
    #create group if not exists  
    egrep "^$HUE_GROUP" /etc/group >& /dev/null  
    if [ $? -ne 0 ];then  
        groupadd $HUE_GROUP
    fi
    #create user if not exists  
    egrep "^$HUE_USER" /etc/passwd >& /dev/null  
    if [ $? -ne 0 ];then  
        useradd -g $HUE_GROUP $HUE_USER  
    fi
    if [ -e "$LOG_DIR" ]; then
        rm -rf $LOG_DIR
    fi
    mkdir -p $LOG_DIR
    chown -R $HUE_USER:$HUE_GROUP /data/hue
    if [ $database_server -eq 1 ];then 
        this_date=`date +%Y-%m-%d`
        this_time=`date +%T`
        echo "$this_date $this_time LOG" >> $LOG_DIR/init.log
        if [ $role = "hue-server" -a $database_server_local -eq 0 ];then
            mv $CONF_DIR/hue.ini $CONF_DIR/hue.ini.wait
            cp $CONF_DIR/hue.ini.template $CONF_DIR/hue.ini
            hue syncdb --noinput 2>&1 1>>$LOG_DIR/init.log
            hue migrate 2>&1 1>>$LOG_DIR/init.log
            rm $CONF_DIR/hue.ini
            mv $CONF_DIR/hue.ini.wait $CONF_DIR/hue.ini
        fi
        if [ $role = "hue-server" -a $database_server_local -eq 1 ];then
            echo "Local Done!" >> $LOG_DIR/init.log
        fi
    fi
}
start_hue() {
    if test -r $PID; then
        if kill -0 `cat $PID` > /dev/null 2>&1; then
            echo "command running as process `cat $PID`.  Stop it first."
            #exit 1
        else
            rm $PID*
        fi
    else 
        supervisor -l $LOG_DIR -d
	    sleep 1
	    loop=$TIMEOUT
	    force=1
	    while [ $loop -gt 0 ];do
	        if test -r $PID; then
	        	force=0
                break
	        else
	    	    sleep 1
	    	    loop=`expr $loop - 1`
	        fi
	    done
	    if [ $force -eq 0 ]; then
	        echo "Success."
	    else
	        echo "Start Hue Timeout."
	        #exit 1
        fi
    fi
}
stop_hue() {
    if test -r $PID;then
        if kill -0 `cat $PID` > /dev/null 2>&1;then
            kill -2 `cat $PID`
            sleep 1
	        loop=$TIMEOUT
	        force=1
	        while [ $loop -gt 0 ];do
	            if test -r $PID; then
	            	sleep 1
	        	    loop=`expr $loop - 1`
	            else
                    force=0
                    break
	            fi
	        done
	        if [ $force -eq 0 ]; then
	            echo "Success."
	        else
	            echo "Stop Hue Timeout."
	            #exit 1
            fi
        else
            rm $PID*
        fi
    else
        echo "No pid file found."
        #exit 1
    fi    
}
stop() {
    echo "Stoping hue... "
    stop_hue

    stop_database
    stop_livy
}
start() {
    start_database
    start_livy
    
    echo "Starting hue... "
    start_hue
}
init() {
    init_database
    start_database
    init_hue
}
status_hue() {
    if test -r $PID;then
        echo "hue running. pid=`cat $PID`"
    else
        echo "hue not running."
    fi
}
if [ $# -le 1 ];then
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
        status)
    	status_hue
    	;;
        init)
        init
        ;;
        *)
    	echo $"Usage: $ {start|stop|restart|status|init}"
    esac
else
    case "$1" in
        spark)
            case "$2" in
            start)
            start_livy
            ;;
            stop)
            stop_livy
            ;;
            restart)
            stop_livy
            start_livy
            ;;
            *)
            echo $"Usage: spark $ {start|stop|restart}"
            ;;
            esac
        ;;
        *)
        echo $"Usage: $ {spark}"
    esac
fi
