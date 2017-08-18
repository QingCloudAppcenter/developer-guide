### ZooKeeper 节点镜像制作

* 安装 agent <br>
下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)

* 安装 ZooKeepr <br>
下载 [ZooKeeper](https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz)，解压安装至 /opt/zookeeper。安装 Java (以 Ubuntu 为例)
```
apt-get install openjdk-7-jre-headless
```

* 创建 toml 文件

	+ 创建 /etc/confd/conf.d/zoo.cfg.toml

		```toml
		[template]
		src = "zoo.cfg.tmpl"
		dest = "/opt/zookeeper/conf/zoo.cfg"
		keys = [
		    "/",
		]
		reload_cmd = "/opt/zookeeper/bin/restart-server.sh"
		```

	+ 创建 /etc/confd/conf.d/myid.toml

		```toml
		[template]
		src = "myid.tmpl"
		dest = "/data/zookeeper/myid"
		keys = [
		    "/",
		]
		```

* 创建 tmpl 文件

	+ 创建 /etc/confd/templates/zoo.cfg.tmpl

	```
	tickTime=2000
	initLimit=10
	syncLimit=5
	dataDir=/data/zookeeper
	{{if exists "/cluster/endpoints/client/port"}}{{$port := getv "/cluster/endpoints/client/port"}}
	clientPort={{$port}}{{else}}clientPort=2181{{end}}
	maxClientCnxns=1000
	{{range $dir := lsdir "/hosts"}}{{$sid := printf "/hosts/%s/sid" $dir}}
	{{$ip := printf "/hosts/%s/ip" $dir}}server.{{getv $sid}}={{getv $ip}}:2888:3888{{end}}
  ```

	+ 创建 /etc/confd/templates/myid.tmpl

	```
  {% raw %}{{getv "/host/sid"}}{% endraw %}
  ```

* ZooKeeper 相关改动

	+ 补充脚本，创建 /opt/zookeeper/bin/restart-server.sh

		```bash
	#! /bin/bash

	# Restart zk server
	/opt/zookeeper/bin/zkServer.sh restart

	sleep 3

	i=0

	while [ $i -lt 10 ]
	do
		/opt/zookeeper/bin/zkServer.sh status
		if [ $? -eq 0 ]; then
			echo "Restart zk server successful" > /var/log/zookeeper.log 2>&1
		    exit 0
		else
		    echo "zk server is not running" > /var/log/zookeeper.log 2>&1
		    /opt/zookeeper/bin/zkServer.sh restart
		fi

		sleep 3
		i=$[$i+1]
	done

	echo "Failed to restart zk server" > /var/log/zookeeper.log 2>&1
	exit 1
	```

	+ 补充环境变量，创建 /opt/zookeeper/conf/java.env

	```bash
	#!/usr/bin/env bash
	free=`grep MemFree /proc/meminfo | awk '{print $2}'`
	buffer=`grep Buffers /proc/meminfo | awk '{print $2}'`
	cache=`grep ^Cached /proc/meminfo | awk '{print $2}'`
	freemem=`expr $free + $buffer + $cache`
	total_free=`expr $freemem / 1024 - 90`
	if [ $total_free -le 0 ]
	then
	  total_free=20
	fi

	export JVMFLAGS="-Xmx${total_free}m"
		```

	+ 更新日志路径，修改文件 /opt/zookeeper/bin/zkEnv.sh，把默认路径修改成如下路径：
    ```
    ZOO_LOG_DIR="/data/zookeeper/logs"
    ```
