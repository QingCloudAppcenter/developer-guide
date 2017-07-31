### Redis Cluster 镜像制作

* 安装 agent <br>
下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)

* 创建 toml 文件

	+ 创建 /etc/confd/conf.d/redis.conf.toml

	```toml
	[template]
	src = "redis.conf.tmpl"
	dest = "/opt/redis/redis.conf"
	keys = [
	    "/",
	]
	reload_cmd = "/opt/redis/bin/restart-redis-server.sh"
	```

	+ 创建 /etc/confd/conf.d/nodes.info.toml

	```toml
	[template]
	src = "nodes.info.tmpl"
	dest = "/opt/redis/nodes.info"
	keys = [
	    "/",
	]
	```

	+ 创建 /etc/confd/conf.d/scaling-out.info.toml

  	```toml
	[template]
	src = "scaling-out.info.tmpl"
	dest = "/opt/redis/scaling-out.info"
	keys = [
	    "/",
	]
	```

	+ 创建 /etc/confd/conf.d/scaling-in.info.toml

  	```toml
	[template]
	src = "scaling-in.info.tmpl"
	dest = "/opt/redis/scaling-in.info"
	keys = [
	    "/",
	]
	```

* 创建 tmpl 文件

	+ 创建 /etc/confd/templates/redis.conf.tmpl

		```
		  aof-rewrite-incremental-fsync yes
			appendfilename appendonly.aof
			auto-aof-rewrite-percentage 10
			auto-aof-rewrite-min-size 64mb
			bind 0.0.0.0
			client-output-buffer-limit normal 0 0 0
			client-output-buffer-limit pubsub 32mb 8mb 60
			client-output-buffer-limit slave 256mb 64mb 60
			daemonize yes
			databases 16
			dbfilename dump.rdb
			dir /data/redis
			hll-sparse-max-bytes 3000
			hz 10
			logfile /data/redis/logs/redis-server.log
			loglevel notice
			lua-time-limit 5000
			pidfile /var/run/redis/redis-server.pid
			repl-disable-tcp-nodelay no  
			rdbchecksum yes
			rdbcompression yes
			save ""
			slave-priority 0
			slave-read-only yes
			slave-serve-stale-data yes
			slowlog-max-len 128
			stop-writes-on-bgsave-error yes
			tcp-backlog 511
			cluster-enabled yes
		    cluster-config-file /data/redis/nodes-6379.conf
		    cluster-node-timeout 5000
		    cluster-migration-barrier 5000            
		    port 6379
		    slave-priority 100            
			{{range gets "/env/*"}}{{$v := .Value}}{{ if gt ( len ( $v ) ) 0 }}{{base .Key}} {{.Value}}
			{{ else }}{{base .Key}} ""
			{{end}}{{end}}
		```

	+ 创建 /etc/confd/templates/nodes.info.tmpl

		```
			{{range $dir := lsdir "/hosts/master/"}}{{$ip := printf "/hosts/master/%s/ip" $dir}}
			M:{{getv $ip}}{{end}}     
		    {{range $dir := lsdir "/hosts/master-replica/"}}{{$ip := printf "/hosts/master-replica/%s/ip" $dir}}
			S:{{getv $ip}}{{end}}
		```
	<table><tr style="background-color:rgb(240,240,240)"><td><b>注：</b>在 lsdir 里的 master 后面必须跟斜杠号(/)</td></tr></table>

	+ 创建 /etc/confd/templates/scaling-out.info.tmpl

		```
			{{range $dir := lsdir "/adding-hosts/master/"}}{{$ip := printf "/adding-hosts/master/%s/ip" $dir}}
		    master {{getv $ip}}{{end}}
		    {{range $dir := lsdir "/adding-hosts/master-replica/"}}{{$ip := printf "/adding-hosts/master-replica/%s/ip" $dir}}
		    master-replica {{getv $ip}}{{end}}
		```

	+ 创建 /etc/confd/templates/scaling-in.info.tmpl

		```
			{{range $dir := lsdir "/deleting-hosts/master/"}}{{$ip := printf "/deleting-hosts/master/%s/ip" $dir}}
		    {{getv $ip}}{{end}}
		    {{range $dir := lsdir "/deleting-hosts/master-replica/"}}{{$ip := printf "/deleting-hosts/master-replica/%s/ip" $dir}}
		    {{getv $ip}}{{end}}		    `
		```

* 补充脚本

	+ 创建 /opt/redis/bin/init-cluster.sh

  	```bash
	#! /bin/bash
	#
	# The file /opt/redis/nodes.info contains the < master IPs > < replicate IPs >

	nodes="/opt/redis/nodes.info"
	masters=""
	slaves=""
	while IFS='' read -r line || [[ -n "$line" ]]; do
	  if [ "x$line" = "x" ] # skip empty line
	  then
	    continue
	  fi
	  role=`echo $line | cut -d ":" -f 1`
	  ip=`echo $line | cut -d ":" -f 2`
	  if [ "$role" = "M" ]
	  then
	    masters="$\{masters\} $ip:6379"
	  else
	    slaves="$\{slaves\} $ip:6379"
	  fi
	done < "$nodes"

	# Get replica number       
	masters_num=`echo $masters | awk '\{print NF\}'`
	slaves_num=`echo $slaves | awk '\{print NF\}'`
	mod=`expr $slaves_num % $masters_num`
	if [ $mod -gt 0 ]
	then
	  echo "The number of nodes are not correct"
	  exit 1
	fi

	replicas=`expr $slaves_num / $masters_num`
    echo yes | /opt/redis/bin/redis-trib.rb create --replicas $replicas $masters $slaves > /var/log/init_redis.log 2>&1
	if [ $? -eq 0 ]; then
	    echo "initiate redis cluster successful"
	    exit 0
	else
	    echo "Failed to initiate redis cluster"
	    exit 1
	fi
	```

	+ 创建 /opt/redis/bin/stop-redis-server.sh

  	```bash
   　#! /bin/bash
	#
	# Copyright (C) 2015 Yunify Inc.
	#
	# Script to stop redis-server.

	PID=$(pidof redis-server)
	if [ -z "$PID" ]; then
	    echo "redis-server is not running"
	    exit 0
	fi

	# Try to terminate redis-server
	kill -SIGTERM $PID

	# Check if redis-server is terminated
	for i in $(seq 0 2); do
	   if ! ps -ef | grep ^stop-redis-server > /dev/null; then
	       echo "redis-server is successfully terminated"
	       exit 0
	   fi
	   sleep 1
	done

	#　Not terminated yet, now I am being rude!
	#　In case of a new redis-server process is somebody else (unlikely though),
	#　we get the pid again here.
	kill -9 $(pidof redis-server)
	if [ $? -eq 0 ]; then
	    echo "redis-server is successfully killed"
	    exit 0
	else
	    echo "Failed to kill redis-server" 1>&2
	    exit 1
	fi
	```

	+ 创建 /opt/redis/bin/restart-redis-server.sh

	```bash
	#! /bin/bash

	PID=$(pidof redis-server)
	if [ -z "$PID" ]; then
	    echo "redis-server is not running"
	    exit 0
	fi

	# Stop redis server
	/opt/redis/bin/stop-redis-server.sh

	# Start redis server
	if [ $? -eq 0 ]; then
	    /opt/redis/bin/redis-server /opt/redis/redis.conf
	    if [ $? -eq 0 ]; then
	        echo "Restart redis-server successful"
		    exit 0
		else
		    echo "Failed to restart redis-server" 1>&2
		    exit 1
		fi
	else
	    echo "Failed to kill redis-server" 1>&2
	    exit 1
	fi
	```

	+ 创建 /opt/redis/bin/scaling-out.sh

	```bash
	#! /bin/bash

	python /opt/redis/bin/redis-scale-out.py
	if [ $? -eq 0 ]; then
	    echo "Scaling out is successful"
	    exit 0
	else
	    echo "Scaling out failed"
	    exit 1
	fi
	```

	+ 创建 /opt/redis/bin/scaling-in.sh

  	```bash
	#! /bin/bash

	python /opt/redis/bin/redis-scale-in.py
	if [ $? -eq 0 ]; then
	    echo "Scaling in is successful"
	    exit 0
	else
	    echo "Scaling in failed"
	    exit 1
	fi
	```
