### Spark(Hadoop) NameNode 节点镜像制作

* 安装 agent <br>
下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)

* 创建 toml 文件

  + 创建 /etc/confd/conf.d/core-site.xml.toml

  ```toml
  [template]
  src = "core-site.xml.tmpl"
  dest = "/opt/hadoop/etc/hadoop/core-site.xml"
  keys = [
  	"/",
  ]
  reload_cmd = "/opt/hadoop/sbin/restart-dfs.sh"
  ```

  + 创建 /etc/confd/conf.d/hdfs-site.xml.toml

  ```toml
  [template]
  src = "hdfs-site.xml.tmpl"
  dest = "/opt/hadoop/etc/hadoop/hdfs-site.xml"
  keys = [
  	"/",
  ]
  reload_cmd = "/opt/hadoop/sbin/restart-dfs.sh"
  ```

  + 创建 /etc/confd/conf.d/slaves.toml

  ```toml
  [template]
  src = "slaves.tmpl"
  dest = "/opt/hadoop/etc/hadoop/slaves"
  keys = [
  	"/",
  ]
  reload_cmd = "/opt/hadoop/sbin/refresh-nodes.sh"
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

  + 创建 /etc/confd/conf.d/exclude.toml

  ```toml
  [template]
  src = "exclude.tmpl"
  dest = "/opt/hadoop/etc/hadoop/exclude"
  keys = [
  	"/",
  ]
  ```

* 创建 tmpl 文件

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

  + 创建 /etc/confd/templates/exclude.tmpl

   ```
    {% raw %}
    {{range $dir := lsdir "/deleting-hosts/worker/"}}{{$ip := printf "/deleting-hosts/worker/%s/ip" $dir}}
    {{getv $ip}}{{end}}
    {% endraw %}
   ```

* 在 Hadoop master image 上
  ```
    touch /opt/hadoop/etc/hadoop/exclude
  ```
