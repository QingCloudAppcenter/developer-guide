### Redis Standalone master节点镜像制作


* 安装 agent <br>
下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)。

* 创建 /etc/confd/conf.d/redis.conf.toml

	```toml
    [template]
	src = "redis.conf.tmpl"
	dest = "/opt/redis/redis.conf"
	keys = [
	    "/",
	]
	reload_cmd = "/opt/redis/bin/restart-redis-server.sh"
	```

* 创建 /etc/confd/templates/redis.conf.tmpl

	```
		{% raw %}
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
		{{range gets "/env/*"}}{{$v := .Value}}{{ if gt ( len ( $v ) ) 0 }}{{base .Key}} {{.Value}}
		{{ else }}{{base .Key}} ""
		{{end}}{{end}}
		{% endraw %}
	```

>最后 range 部分是 confd (已通过前面安装 agent 的方式部署到镜像里)这个服务读取青云提供的 [metadata](../../../../metadata-service.md) 服务来更新应用的配置，
后面的路径表示这个节点本身所在集群或自身的所有信息，/env 即表示获取本节点的应用参数配置，获取某个 key 的值需要在 toml 模版文件里 监听相应的 key，为简单起见，监听根节点/即可。
if/else 是因为 Redis 对空的值需要用引号引起来。<br>
关于 confd 请参见 [confd quick start guide](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md)
模版文件语法参见 [templates](https://github.com/kelseyhightower/confd/blob/master/docs/templates.md)templates
>

* 补充脚本 <br>
  在此例中有两个脚本 stop-redis-server.sh (应用模版中定义的 [stop service](../../../spec/redis-standalone.md#cluster)) 和 restart-redis-server.sh，Redis 官方并没有提供这些脚本，所以需要自己完善，示范如下。

	* 创建 /opt/redis/bin/stop-redis-server.sh

		```bash
	    #! /bin/bash
		#
		# Copyright (C) 2015 Yunify Inc.
		#
		# Script to stop redis-server.

		PID=$(pidof redis-server)
		if [ -z "$PID" ]; then
		    echo "redis-server is not running" > /var/log/redis.log 2>&1
		    exit 0
		fi

		# Try to terminate redis-server
		kill -SIGTERM $PID

		# Check if redis-server is terminated
		for i in $(seq 0 2); do
		   if ! ps -ef | grep ^stop-redis-server > /dev/null; then
		       echo "redis-server is successfully terminated" >> /var/log/redis.log 2>&1
		       exit 0
		   fi
		   sleep 1
		done

		# Not terminated yet, now I am being rude!
		# In case of a new redis-server process is somebody else (unlikely though),
		# we get the pid again here.
		kill -9 $(pidof redis-server)
		if [ $? -eq 0 ]; then
		    echo "redis-server is successfully killed" >> /var/log/redis.log 2>&1
		    exit 0
		else
		    echo "Failed to kill redis-server" >> /var/log/redis.log 2>&1
		    exit 1
		fi
		```

	* 创建 /opt/redis/bin/restart-redis-server.sh

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
