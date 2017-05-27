### 本指南介绍如何制作HDFS Master节点镜像制作过程

* 安装 agent <br>
下载青云提供的 app agent [Linux/Unix版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行./install.sh(Windows下双击install.bat)

* 创建toml文件
  + 创建/etc/confd/conf.d/core-site.xml.toml

            [template]
            src = "core-site.xml.tmpl"
            dest = "/opt/hadoop/etc/hadoop/core-site.xml"
            keys = [
            	"/",
            ]
            reload_cmd = "/opt/hadoop/sbin/restart-dfs.sh"

  + 创建/etc/confd/conf.d/hdfs-site.xml.toml

            [template]
            src = "hdfs-site.xml.tmpl"
            dest = "/opt/hadoop/etc/hadoop/hdfs-site.xml"
            keys = [
            	"/",
            ]
            reload_cmd = "/opt/hadoop/sbin/restart-dfs.sh"

  + 创建/etc/confd/conf.d/slaves.toml

            [template]
            src = "slaves.tmpl"
            dest = "/opt/hadoop/etc/hadoop/slaves"
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

  + 创建/etc/confd/conf.d/hosts.toml

            [template]
            src = "hosts.tmpl"
            dest = "/etc/hosts"
            keys = [
            	"/",
            ]

  + 创建/etc/confd/conf.d/exclude.toml

            [template]
            src = "exclude.tmpl"
            dest = "/opt/hadoop/etc/hadoop/exclude"
            keys = [
            	"/",
            ]

* 创建tmpl文件

  + 创建/etc/confd/templates/core-site.xml.tmpl

            <?xml version="1.0" encoding="UTF-8"?>
            <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
            <configuration>
              <property>
                <name>fs.defaultFS</name>
                {{range $dir := lsdir "/hosts/hbase-hdfs-master/"}}{{$ip := printf "/hosts/hbase-hdfs-master/%s/ip" $dir}}
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
                <value>{{getv "/env/fs.trash.interval" "1440"}}</value>
              </property>
            </configuration>

  + 创建/etc/confd/templates/hdfs-site.xml.tmpl

            <?xml version="1.0" encoding="UTF-8"?>
            <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
            <configuration>
              <property>
                <name>dfs.replication</name>
                <value>{{getv "/env/dfs.replication" "2"}}</value>
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
                <value>{{getv "/env/dfs.namenode.handler.count" "10"}}</value>
              </property>
              <property>
                <name>dfs.datanode.handler.count</name>
                <value>{{getv "/env/dfs.datanode.handler.count" "10"}}</value>
              </property>
            </configuration>

  + 创建/etc/confd/templates/slaves.tmpl

            {{range $dir := lsdir "/hosts/hbase-slave/"}}{{$ip := printf "/hosts/hbase-slave/%s/ip" $dir}}
            {{getv $ip}}{{end}}

  + 创建/etc/confd/templates/authorized_keys.tmpl

            {{range $dir := lsdir "/hosts/hbase-master/"}}{{$pub_key := printf "/hosts/hbase-master/%s/pub_key" $dir}}
            {{getv $pub_key}}{{end}} 
            {{range $dir := lsdir "/hosts/hbase-hdfs-master/"}}{{$pub_key := printf "/hosts/hbase-hdfs-master/%s/pub_key" $dir}}
            {{getv $pub_key}}{{end}}

 
  + 创建/etc/confd/templates/hosts.tmpl

            {{range $dir := lsdir "/hosts/hbase-master/"}}{{$ip := printf "/hosts/hbase-master/%s/ip" $dir}}
            {{getv $ip}} {{$dir}}{{end}}
            {{range $dir := lsdir "/hosts/hbase-hdfs-master/"}}{{$ip := printf "/hosts/hbase-hdfs-master/%s/ip" $dir}}
            {{getv $ip}} {{$dir}}{{end}}
            {{range $dir := lsdir "/hosts/hbase-slave/"}}{{$ip := printf "/hosts/hbase-slave/%s/ip" $dir}}
            {{getv $ip}} {{$dir}}{{end}}
	
  + 创建/etc/confd/templates/exclude.tmpl
            {{range $dir := lsdir "/deleting-hosts/hbase-slave/"}}{{$ip := printf "/deleting-hosts/hbase-slave/%s/ip" $dir}}
            {{getv $ip}}{{end}}

* 在hbase-hdfs-master image上
   touch /opt/hadoop/etc/hadoop/exclude