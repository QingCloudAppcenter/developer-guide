### Redis Standalone slave节点镜像制作

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
	{{range $dir := lsdir "/hosts/master"}}{{$ip := printf "/hosts/master/%s/ip" $dir}}
	slaveof {{getv $ip}} {{getv "/env/port"}}{{end}}
	{% endraw %}
	```

> 最后一个 range 部分是获取本节点所在集群的主节点信息，包括 IP 和端口号。

* 补充脚本 <br>
  在此例中有两个脚本 stop-redis-server.sh 和 restart-redis-server.sh，redis 官方并没有提供这些脚本，参见 [主节点镜像制作指南](master-image-guide.md)
