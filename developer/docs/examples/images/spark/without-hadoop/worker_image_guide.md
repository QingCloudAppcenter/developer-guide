### 本指南介绍如何制作无Hadoop版的Spark worker节点镜像制作过程

* 安装 agent <br>
下载青云提供的 app agent [Linux/Unix版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行./install.sh(Windows下双击install.bat)

* 创建toml文件
  + 创建/etc/confd/conf.d/spark-env.sh.toml

            [template]
            src = "spark-env.sh.tmpl"
            dest = "/opt/spark/conf/spark-env.sh"
            keys = [
            	"/",
            ]
            reload_cmd = "/opt/spark/sbin/restart-slave.sh"

  + 创建/etc/confd/conf.d/workers.toml
         
            [template]
            src = "workers.tmpl"
            dest = "/opt/spark/conf/slaves"
            keys = [
            	"/",
            ]

  + 创建/etc/confd/conf.d/authorized_keys.toml

            [template]
            src = "authorized_keys.tmpl"
            dest = "/root/.ssh/authorized_keys"
            keys = [
            	"/",
            ]

  + 创建/etc/confd/conf.d/\{hosts.toml

            [template]
            src = "hosts.tmpl"
            dest = "/etc/hosts"
            keys = [
            	"/",
            ]

* 创建tmpl文件
  + 创建/etc/confd/templates/spark-env.sh.tmpl

            #! /usr/bin/env bash

            export SPARK_LOG_DIR=/data/spark/logs
            export SPARK_WORKER_DIR=/data/spark/work
            export SPARK_WORKER_OPTS="-Dspark.worker.cleanup.enabled=true -Dspark.worker.cleanup.interval=28800 -Dspark.worker.cleanup.appDataTtl=86400"
            export SPARK_PID_DIR=/data/spark/pids
            export SPARK_LOCAL_DIRS=/data/spark
            export HADOOP_HOME=/opt/hadoop/etc/hadoop
            {{range $dir := lsdir "/hosts/spark-master/"}}{{$ip := printf "/hosts/spark-master/%s/ip" $dir}}
            export SPARK_MASTER_IP={{getv $ip}}{{end}}

  + 创建/etc/confd/templates/workers.tmpl

            {{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
            {{getv $ip}}{{end}}\}

  + 创建/etc/confd/templates/authorized_keys.tmpl

            {{range $dir := lsdir "/hosts/spark-master/"}}{{$pub_key := printf "/hosts/spark-master/%s/pub_key" $dir}}
            {{getv $pub_key}}{{end}}    

  + 创建/etc/confd/templates/hosts.tmpl

            {{range $dir := lsdir "/hosts/spark-master/"}}{{$ip := printf "/hosts/spark-master/%s/ip" $dir}}
            {{getv $ip}} {{$dir}}{{end}}
            {{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
            {{getv $ip}} {{$dir}}{{end}}