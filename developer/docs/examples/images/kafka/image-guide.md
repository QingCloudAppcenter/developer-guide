### Kafka 节点镜像制作

* 安装 agent <br>
下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)

* 创建 /etc/confd/conf.d/server.properties.toml

	```toml
    [template]
	src = "server.properties.tmpl"
	dest = "/opt/kafka/config/server.properties"
	keys = [
	    "/",
	]
	reload_cmd = "/opt/kafka/bin/kafka-server-restart.sh"
	```

* 创建 /etc/confd/templates/server.properties.tmpl

	```
		# fixed params
		log.segment.bytes=1073741824
		socket.send.buffer.bytes=202400
		num.network.threads=3
		log.cleaner.enable=false
		port=9092
		num.recovery.threads.per.data.dir=1
		log.dirs=/data/kafka/kafka-logs
		log.flush.interval.messages=10000
		zookeeper.connection.timeout.ms=6000
		log.retention.check.interval.ms=300000
		zookeeper.session.timeout.ms=6000
		log.flush.interval.ms=1000
		replica.fetch.max.bytes=1000000

		# params input by user
		{{range gets "/env/*"}}{{$v := .Value}}{{ if gt ( len ( $v ) ) 0 }}
		{{base .Key}}={{.Value}}{{end}}{{end}}

		# dependency
		{{if exists "/links/zk_service/cluster/endpoints/client/port"}}{{$port := getv "/links/zk_service/cluster/endpoints/client/port"}}
		zookeeper.connect={{range $i, $host := ls (printf "/links/zk_service/hosts")}}{{$ip := printf "/links/zk_service/hosts/%s/ip" $host}}{{if $i}},{{end}}{{getv $ip}}:{{$port}}{{end}}/kafka/{{getv "/cluster/cluster_id"}}
		{{else}}
		zookeeper.connect={{range $i, $host := ls (printf "/links/zk_service/hosts")}}{{$ip := printf "/links/zk_service/hosts/%s/ip" $host}}{{if $i}},{{end}}{{getv $ip}}:2181{{end}}/kafka/{{getv "/cluster/cluster_id"}}
		{{end}}

		# self
		host.name={{getv "/host/ip"}}
		broker.id={{getv "/host/sid"}}
		{{$ahost := getv "/env/advertised.host.name"}}{{ if le ( len ( $ahost ) ) 0 }}advertised.host.name={{getv "/host/ip"}}{{end}}
	```

* 创建 /opt/kafka/bin/kafka-server-restart.sh

	```bash
	#! /bin/bash

	pid=`ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep| awk '\{print $1\}'`
	if [ "x$pid" = "x" ]
	then
	  echo "zk server is not running" 1>&2
	  return
	fi

	/opt/kafka/bin/kafka-server-stop.sh
	sleep 10
	/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties
    if [ $? -eq 0 ]; then
        echo "Restart Kafka server successful"
	    exit 0
	else
	    echo "Failed to restart Kafka server" 1>&2
	    exit 1
	fi
	```
