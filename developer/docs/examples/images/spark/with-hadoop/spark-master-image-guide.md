### Spark(Hadoop) master节点镜像制作

* 安装 agent <br>
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
    reload_cmd = "/opt/spark/sbin/restart-master.sh"
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
    keys = [
    	"/",
    ]
    ```

* 创建 tmpl 文件

    + 创建 /etc/confd/templates/workers.tmpl

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
    {{getv "/host/ip"}} localhost
    {{range $dir := lsdir "/hosts/spark-master/"}}{{$ip := printf "/hosts/spark-master/%s/ip" $dir}}
    {{getv $ip}} {{$dir}}{{end}}
    {{range $dir := lsdir "/hosts/hadoop-master/"}}{{$ip := printf "/hosts/hadoop-master/%s/ip" $dir}}
    {{getv $ip}} {{$dir}}{{end}}
    {{range $dir := lsdir "/hosts/worker/"}}{{$ip := printf "/hosts/worker/%s/ip" $dir}}
    {{getv $ip}} {{$dir}}{{end}}
     {% endraw %}
     ```

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

Note: must make /opt/spark/conf/slaves empty
