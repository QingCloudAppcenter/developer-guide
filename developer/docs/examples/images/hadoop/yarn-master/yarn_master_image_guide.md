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

  + 创建/etc/confd/conf.d/hdfs-site.xml.toml

            [template]
            src = "hdfs-site.xml.tmpl"
            dest = "/opt/hadoop/etc/hadoop/hdfs-site.xml"
            keys = [
            	"/",
            ]
  
  + 创建/etc/confd/conf.d/yarn-site.xml.toml
  
			  [template]
			  src = "yarn-site.xml.tmpl"
			  dest = "/opt/hadoop/etc/hadoop/yarn-site.xml"
			  keys = [
			    "/",
			  ]
			  reload_cmd = "/opt/hadoop/sbin/restart-yarn.sh"
            
  + 创建/etc/confd/conf.d/capacity-scheduler.xml.toml
            
            [template]
			 src = "capacity-scheduler.xml.tmpl"
			 dest = "/opt/hadoop/etc/hadoop/capacity-scheduler.xml"
			 keys = [
			    "/",
			 ]
            reload_cmd = "/opt/hadoop/sbin/restart-yarn.sh"
            
  + 创建/etc/confd/conf.d/mapred-site.xml.toml

			[template]
			src = "mapred-site.xml.tmpl"
			dest = "/opt/hadoop/etc/hadoop/mapred-site.xml"
			keys = [
			    "/",
			]
			reload_cmd = "/opt/hadoop/sbin/restart-jobhistory.sh"

  + 创建/etc/confd/conf.d/slaves.toml

            [template]
            src = "slaves.tmpl"
            dest = "/opt/hadoop/etc/hadoop/slaves"
            keys = [
            	"/",
            ]
            reload_cmd = "/opt/hadoop/sbin/refresh-nodes.sh"

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
				    {{range $dir := lsdir "/hosts/hdfs-master/"}}{{$ip := printf "/hosts/hdfs-master/%s/ip" $dir}}
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
				  <property>
				    <name>hadoop.proxyuser.hue.hosts</name>
				    <value>*</value>
				  </property>
				  <property>
				    <name>hadoop.proxyuser.hue.groups</name>
				    <value>*</value>
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
  + 创建/etc/confd/templates/yarn-site.xml.tmpl
  
				<?xml version="1.0" encoding="UTF-8"?>
				<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
				<configuration>
				    <property>
				        <name>yarn.nodemanager.aux-services</name>
				        <value>mapreduce_shuffle</value>
				    </property>
				    <property>
				        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
				        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
				    </property>
				    <property>
				        <name>yarn.nodemanager.resource.memory-mb</name>
				        <value>{{getv "/host/memory" "8192"}}</value>
				    </property>
				    <property>
				        <name>yarn.resourcemanager.address</name>
				 {{range $dir := lsdir "/hosts/yarn-master/"}}{{$ip := printf "/hosts/yarn-master/%s/ip" $dir}}{{$ip_address := getv $ip}}
				        <value>{{$ip_address}}:8032</value>
				    </property>
				    <property>
				        <name>yarn.resourcemanager.scheduler.address</name>
				        <value>{{$ip_address}}:8030</value>
				    </property>
				    <property>
				        <name>yarn.resourcemanager.resource-tracker.address</name>
				        <value>{{$ip_address}}:8033</value>
				    </property>
				    <property>
				        <name>yarn.resourcemanager.admin.address</name>
				        <value>{{$ip_address}}:8031</value>
				    </property>
				    <property>
				        <name>yarn.resourcemanager.webapp.address</name>
				        <value>{{$ip_address}}:8088</value>{{end}}
				    </property>
				    <property>
				        <name>yarn.log-aggregation-enable</name>
				        <value>{{getv "/env/yarn.log-aggregation-enable" "false"}}</value>
				    </property>
				    <property>
				        <name>yarn.log-aggregation.retain-seconds</name>
				        <value>{{getv "/env/yarn.log-aggregation.retain-seconds" "-1"}}</value>
				    </property>
				    <property>
				        <name>yarn.nodemanager.vmem-pmem-ratio</name>
				        <value>{{getv "/env/yarn.nodemanager.vmem-pmem-ratio" "2.1"}}</value>
				    </property>
				</configuration>

  
  + 创建/etc/confd/templates/capacity-scheduler.xml.tmpl

				<?xml version="1.0" encoding="UTF-8"?>
				<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
				<configuration>
				      <property>
				        <name>yarn.scheduler.capacity.maximum-applications</name>
				        <value>10000</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.maximum-am-resource-percent</name>
				        <value>{{getv "/env/yarn.scheduler.capacity.max-am-resource-percent" "0.3"}}</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.resource-calculator</name>
				        <value>org.apache.hadoop.yarn.util.resource.DefaultResourceCalculator</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.queues</name>
				        <value>default</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.capacity</name>
				        <value>100</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.user-limit-factor</name>
				        <value>1</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.maximum-capacity</name>
				        <value>100</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.state</name>
				        <value>RUNNING</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.acl_submit_applications</name>
				        <value>*</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.root.default.acl_administer_queue</name>
				        <value>*</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.node-locality-delay</name>
				        <value>40</value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.queue-mappings</name>
				        <value></value>
				      </property>
				      <property>
				        <name>yarn.scheduler.capacity.queue-mappings-override.enable</name>
				        <value>false</value>
				      </property>
				</configuration>

  
  + 创建/etc/confd/templates/mapred-site.xml.tmpl
  
				<?xml version="1.0" encoding="UTF-8"?>
				<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
				<configuration>
				    <property>
				        <name>mapreduce.framework.name</name>
				        <value>yarn</value>
				    </property>
				    <property>
				        <name>mapreduce.jobhistory.address</name>
				{{range $dir := lsdir "/hosts/yarn-master/"}}{{$ip := printf "/hosts/yarn-master/%s/ip" $dir}}{{$ip_address := getv $ip}}
				        <value>{{$ip_address}}:10020</value>
				    </property>
				    <property>
				        <name>mapreduce.jobhistory.webapp.address</name>
				        <value>{{$ip_address}}:19888</value>{{end}}
				    </property>
				</configuration>

  
  + 创建/etc/confd/templates/slaves.tmpl

            {{range $dir := lsdir "/hosts/hadoop-slave/"}}{{$ip := printf "/hosts/hadoop-slave/%s/ip" $dir}}
			 {{getv $ip}}{{end}}


  + 创建/etc/confd/templates/authorized_keys.tmpl

            {{range $dir := lsdir "/hosts/yarn-master/"}}{{$pub_key := printf "/hosts/yarn-master/%s/pub_key" $dir}}
			 {{getv $pub_key}}{{end}} 
			 {{range $dir := lsdir "/hosts/hdfs-master/"}}{{$pub_key := printf "/hosts/hdfs-master/%s/pub_key" $dir}}
			 {{getv $pub_key}}{{end}}
	
 
  + 创建/etc/confd/templates/hosts.tmpl

            {{range $dir := lsdir "/hosts/yarn-master/"}}{{$ip := printf "/hosts/yarn-master/%s/ip" $dir}}
			 {{getv $ip}} {{$dir}}{{end}}
			 {{range $dir := lsdir "/hosts/hdfs-master/"}}{{$ip := printf "/hosts/hdfs-master/%s/ip" $dir}}
			 {{getv $ip}} {{$dir}}{{end}}
			 {{range $dir := lsdir "/hosts/hadoop-slave/"}}{{$ip := printf "/hosts/hadoop-slave/%s/ip" $dir}}
			 {{getv $ip}} {{$dir}}{{end}}

	
  + 创建/etc/confd/templates/exclude.tmpl

            {{range $dir := lsdir "/deleting-hosts/hadoop-slave/"}}{{$ip := printf "/deleting-hosts/hadoop-slave/%s/ip" $dir}}
            {{getv $ip}}{{end}}


* 在yarn-master image上
   touch /opt/hadoop/etc/hadoop/exclude