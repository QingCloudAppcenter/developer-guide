### Spark(Hadoop) worker节点镜像制作

* 安装 agent

下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)

* 创建 toml 文件

  + 创建 /etc/confd/conf.d/spark-env.sh.toml

   ```toml
  [template]
  src = "spark-env.sh.tmpl"
  dest = "/opt/spark/conf/spark-env.sh"
  keys = [
      "/",
  ]
  reload_cmd = "/opt/spark/sbin/restart-slave.sh"
   ```

  + 创建 /etc/confd/conf.d/workers.toml

   ```toml
  [template]
  src = "workers.tmpl"
  dest = "/opt/spark/conf/slaves"
  keys = [
      "/",
  ]
   ```

  + 创建 /etc/confd/conf.d/core-site.xml.toml

   ```toml
  [template]
  src = "core-site.xml.tmpl"
  dest = "/opt/hadoop/etc/hadoop/core-site.xml"
  keys = [
      "/",
  ]
  reload_cmd = "/opt/hadoop/sbin/restart-slave.sh"
   ```

  + 创建 /etc/confd/conf.d/hdfs-site.xml.toml

   ```toml
	[template]
	src = "hdfs-site.xml.tmpl"
	dest = "/opt/hadoop/etc/hadoop/hdfs-site.xml"
	keys = [
	    "/",
	]
  reload_cmd = "/opt/hadoop/sbin/restart-slave.sh"
   ```

  + 创建 /etc/confd/conf.d/slaves.toml

   ```toml
  [template]
  src = "slaves.tmpl"
  dest = "/opt/hadoop/etc/hadoop/slaves"
  keys = [
      "/",
  ]
   ```

  + 创建 /etc/confd/conf.d/authorized_keys.toml

   ```toml
  [template]
  src = "authorized_keys.tmpl"
  dest = "/root/.ssh/authorized_keys"
  keys = [
      "/",
  ]
   ```

  + 创建 /etc/confd/conf.d/hosts.toml

   ```toml
  [template]
  src = "hosts.tmpl"
  dest = "/etc/hosts"
  keys = [,
      "/",
  ]
   ```

* 创建 tmpl 文件

  + 创建 /etc/confd/templates/spark-env.sh.tmpl    

    ```bash
    {% raw %}
    #! /usr/bin/env bash
    export SPARK_LOG_DIR=/bigdata1/spark/logs
    export SPARK_WORKER_DIR=/bigdata1/spark/work
    export SPARK_WORKER_OPTS="-Dspark.worker.cleanup.enabled=true -Dspark.worker.cleanup.interval=28800 -Dspark.worker.cleanup.appDataTtl=86400"
    export SPARK_PID_DIR=/bigdata1/spark/pids
    export SPARK_LOCAL_DIRS=/bigdata1/spark
    export HADOOP_HOME=/opt/hadoop/etc/hadoop
    {{range $dir := lsdir "/hosts/spark-master/"}}{{$ip := printf "/hosts/spark-master/%s/ip" $dir}}
    export SPARK_MASTER_IP={{getv $ip}}{{end}}
    {% endraw %}
   ```
        　　　　
  + 创建 /etc/confd/templates/workers.tmpl

   ```
    {% raw %}
    {{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
  	{{getv $ip}}{{end}}
    {% endraw %}
   ```

  + 创建 /etc/confd/templates/core-site.xml.tmpl

   ```xml
    {% raw %}
    <?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
      <property>
        <name>fs.defaultFS</name>
        {{range $dir := lsdir "/hosts/hadoop-master/"}}{{$ip := printf "/hosts/hadoop-master/%s/ip" $dir}}
       <value>hdfs://{{getv $ip}}:9000</value>{{end}}
      </property>
      <property>
        <name>hadoop.tmp.dir</name>
        <value>/bigdata1/hadoop/tmp</value>
      </property>
      <property>
         <name>dfs.hosts.exclude</name>
         <value>/opt/hadoop/etc/hadoop/exclude</value>
      </property>
      <property>
        <name>io.file.buffer.size</name>
        <value>131072</value>
      </property>
      <property>
        <name>fs.trash.interval</name>
        <value>{{getv "/env/fs.trash.interval"}}</value>
      </property>
    </configuration>
    {% endraw %}
   ```

  + 创建 /etc/confd/templates/hdfs-site.xml.tmpl

   ```xml
    {% raw %}
    <?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
      <property>
        <name>dfs.replication</name>
        <value>{{getv "/env/dfs.replication"}}</value>
      </property>
      <property>
        <name>dfs.replication.max</name>
        <value>10</value>
      </property>
      <property>
        <name>dfs.replication.min</name>
        <value>1</value>
      </property>
      <property>
        <name>dfs.datanode.max.transfer.threads</name>
        <value>40960</value>
      </property>
      <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///bigdata1/hadoop/tmp/dfs/name</value>
      </property>
      <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///bigdata1/hadoop/tmp/dfs/data,/bigdata2/hadoop/tmp/dfs/data,/bigdata3/hadoop/tmp/dfs/data</value>
      </property>
      <property>
        <name>dfs.webhdfs.enabled</name>
        <value>true</value>
      </property>
      <property>
        <name>dfs.namenode.handler.count</name>
        <value>10</value>
      </property>
      <property>
        <name>dfs.namenode.handler.count</name>
        <value>{{getv "/env/dfs.namenode.handler.count"}}</value>
      </property>
      <property>
        <name>dfs.datanode.handler.count</name>
        <value>{{getv "/env/dfs.datanode.handler.count"}}</value>
      </property>
      <property>
        <name>dfs.datanode.handler.count</name>
        <value>10</value>
      </property>
    </configuration>
    {% endraw %}
   ```

  + 创建 /etc/confd/templates/slaves.tmpl

   ```
    {% raw %}
    {{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
  	{{getv $ip}}{{end}}
    {% endraw %}
   ```

  + 创建 /etc/confd/templates/authorized_keys.tmpl

   ```
    {% raw %}
    {{range $dir := lsdir "/hosts/spark-master/"}}{{$pub_key := printf "/hosts/spark-master/%s/pub_key" $dir}}
  	{{getv $pub_key}}{{end}}
  	{{range $dir := lsdir "/hosts/hadoop-master/"}}{{$pub_key := printf "/hosts/hadoop-master/%s/pub_key" $dir}}
  	{{getv $pub_key}}{{end}}
    {% endraw %}
   ```

  + 创建 /etc/confd/templates/hosts.tmpl

   ```
    {% raw %}
    {{range $dir := lsdir "/hosts/spark-master/"}}{{$ip := printf "/hosts/spark-master/%s/ip" $dir}}
  	{{getv $ip}} {{$dir}}{{end}}
  	{{range $dir := lsdir "/hosts/hadoop-master/"}}{{$ip := printf "/hosts/hadoop-master/%s/ip" $dir}}
  	{{getv $ip}} {{$dir}}{{end}}
  	{{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
  	{{getv $ip}} {{$dir}}{{end}}
    {% endraw %}
   ```

* 补充脚本
  + 创建　/opt/spark/sbin/restart-slave.sh

   ```bash
  	#! /bin/sh
  	loop=60
  	find=0
  	master_ip=""
  	while [ "$loop" -gt 0 ]
  	do
  	  master_ip=`grep SPARK_MASTER_IP /opt/spark/conf/spark-env.sh | cut -d = -f 2`
  	  if [ "x$master_ip" = "x" ]
  	  then
  	    sleep 3s
  	    loop=`expr $loop - 1`
  	  else
  	    find=1
  	    break
  	  fi
  	done

  	if [ "$find" -eq 0 ]
  	then
  	  echo "Failed to find spark master IP" 1>&2
  	  exit 1
  	fi

  	pid=`ps ax | grep java | grep org.apache.spark.deploy.worker.Worker | grep -v grep| awk '\{print $1\}'`
  	if [ "x$pid" = "x" ]
  	then
  	  /opt/spark/sbin/start-slave.sh spark://$master_ip:7077
  	  return
  	else
  	  /opt/spark/sbin/stop-slave.sh
  	fi

  	loop=60
  	force=1
  	while [ "$loop" -gt 0 ]
  	do
  	  pid=`ps ax | grep java | grep org.apache.spark.deploy.worker.Worker | grep -v grep| awk '\{print $1\}'`
  	  if [ "x$pid" = "x" ]
  	  then
  	    force=0
  	    break
  	  else
  	    sleep 3s
  	    loop=`expr $loop - 1`
  	  fi
  	done
  	if [ "$force" -eq 1 ]
  	then
  	  kill -9 $pid
  	fi

   	/opt/spark/sbin/start-slave.sh spark://$master_ip:7077
   ```

  + 创建　/opt/hadoop/sbin/restart-slave.sh

   ```bash
  	#! /bin/sh
  	pid=`ps ax | grep java | grep datanode | grep -v grep| awk '\{print $1\}'`
  	if [ "x$pid" = "x" ]
  	then
  	  USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
  	  return
  	else
  	  USER=root /opt/hadoop/sbin/hadoop-daemon.sh stop datanode
  	fi

  	loop=60
  	force=1
  	while [ "$loop" -gt 0 ]
  	do
  	  pid=`ps ax | grep java | grep datanode | grep -v grep| awk '\{print $1\}'`
  	  if [ "x$pid" = "x" ]
  	  then
  	    force=0
  	    break
  	  else
  	    sleep 3s
  	    loop=`expr $loop - 1`
  	  fi
  	done
  	if [ "$force" -eq 1 ]
  	then
  	  kill -9 $pid
  	fi

  	USER=root /opt/hadoop/sbin/hadoop-daemon.sh start datanode
   ```

* 在 worker image 上
  ```
   touch /opt/hadoop/etc/hadoop/exclude
  ```
