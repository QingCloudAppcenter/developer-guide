### 本指南介绍如何制作HBase Slave节点镜像制作过程

* 安装 agent <br>
下载青云提供的 app agent [Linux/Unix版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行./install.sh(Windows下双击install.bat)

* 创建可执行文件
  + touch /opt/hbase/bin/hbase-monitor.py;chmod +x /opt/hbase/bin/hbase-monitor.py

* 创建toml文件
  + 创建/etc/confd/conf.d/hbase-site.xml.toml

            [template]
            src = "hbase-site.xml.tmpl"
            dest = "/opt/hbase/conf/hbase-site.xml"
            keys = [
            	"/",
            ]

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

  + 创建/etc/confd/conf.d/hbase-monitor.py.toml

            [template]
            src = "hbase-monitor.py.tmpl"
            dest = "/opt/hbase/bin/hbase-monitor.py"
            keys = [
                "/",
            ]

* 创建tmpl文件

  + 创建/etc/confd/templates/hbase-site.xml.tmpl

            <?xml version="1.0" encoding="UTF-8"?>
            <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
            <configuration>
               <property>
                 <name>hbase.cluster.distributed</name>
                 <value>true</value>
               </property>
               <property>
                 <name>hbase.superuser</name>
                 <value>root</value>
               </property>
               <property>
                  <name>hbase.coprocessor.region.classes</name>
                  <value>org.apache.hadoop.hbase.security.access.AccessController</value>
               </property>
               <property>
                  <name>hbase.coprocessor.master.classes</name>
                  <value>org.apache.hadoop.hbase.security.access.AccessController</value>
               </property>
               <property>
                  <name>hbase.rpc.engine</name>
                  <value>org.apache.hadoop.hbase.ipc.SecureRpcEngine</value>
               </property>
               <property>
                  <name>hbase.regionserver.codecs</name>
                  <value>snappy,lzo</value>
               </property>
               <property>
                 <name>hbase.tmp.dir</name>
                 <value>/bigdata1/hbase/tmp</value>
               </property>
               <property>
                 <name>hbase.rootdir</name>
                 {{range $dir := lsdir "/hosts/hbase-hdfs-master/"}}{{$ip := printf "/hosts/hbase-hdfs-master/%s/ip" $dir}}
                 <value>hdfs://{{getv $ip}}:9000/hbase</value>{{end}}
               </property>
               <property>
                 <name>hbase.fs.tmp.dir</name>
                 <value>/bigdata1/hbase/hbase-staging</value>
               </property>
               <property>
                 <name>hbase.zookeeper.quorum</name>
                 {{if exists "/links/zk_service/cluster/endpoints/client/port"}}{{$port := getv "/links/zk_service/cluster/endpoints/client/port"}}
                 <value>{{range $i, $host := ls (printf "/links/zk_service/hosts")}}{{$ip := printf "/links/zk_service/hosts/%s/ip" $host}}{{if $i}},{{end}}{{getv $ip}}:{{$port}}{{end}}</value>
                 {{else}}
                 <value>{{range $i, $host := ls (printf "/links/zk_service/hosts")}}{{$ip := printf "/links/zk_service/hosts/%s/ip" $host}}{{if $i}},{{end}}{{getv $ip}}:2181{{end}}</value>
                 {{end}}
               </property>
               <property>
                  <name>hbase.zookeeper.property.clientPort</name>
                  {{if exists "/links/zk_service/cluster/endpoints/client/port"}}
                  <value>{{getv "/links/zk_service/cluster/endpoints/client/port"}}</value>
                  {{else}}
                  <value>2181</value>
                  {{end}}
                </property>
               <property>
                 <name>zookeeper.znode.parent</name>
                 <value>/hbase/{{getv "/cluster/cluster_id"}}</value>
               </property>
               <property>
                 <name>hbase.regionserver.handler.count</name>
                 <value>{{getv "/env/hbase.regionserver.handler.count"}}</value>
               </property>
               <property>
                 <name>zookeeper.session.timeout</name>
                 <value>{{getv "/env/zookeeper.session.timeout"}}</value>
               </property>
               <property>
                 <name>hbase.hregion.majorcompaction</name>
                 <value>{{getv "/env/hbase.hregion.majorcompaction"}}</value>
               </property>
               <property>
                 <name>hbase.hstore.blockingStoreFiles</name>
                 <value>{{getv "/env/hbase.hstore.blockingStoreFiles"}}</value>
               </property>
               <property>
                 <name>hbase.regionserver.optionalcacheflushinterval</name>
                 <value>{{getv "/env/hbase.regionserver.optionalcacheflushinterval"}}</value>
               </property>
               <property>
                 <name>hfile.block.cache.size</name>
                 <value>{{getv "/env/hfile.block.cache.size"}}</value>
               </property>
               <property>
                 <name>hfile.index.block.max.size</name>
                 <value>{{getv "/env/hfile.index.block.max.size"}}</value>
               </property>
               <property>
                 <name>hbase.hregion.max.filesize</name>
                 <value>{{getv "/env/hbase.hregion.max.filesize"}}</value>
               </property>
               <property>
                  <name>hbase.master.logcleaner.ttl</name>
                  <value>{{getv "/env/hbase.master.logcleaner.ttl"}}</value>
               </property>
               <property>
                  <name>hbase.ipc.server.callqueue.handler.factor</name>
                  <value>{{getv "/env/hbase.ipc.server.callqueue.handler.factor"}}</value>
               </property>
               <property>
                  <name>hbase.ipc.server.callqueue.read.ratio</name>
                  <value>{{getv "/env/hbase.ipc.server.callqueue.read.ratio"}}</value>
               </property>
               <property>
                  <name>hbase.ipc.server.callqueue.scan.ratio</name>
                  <value>{{getv "/env/hbase.ipc.server.callqueue.scan.ratio"}}</value>
               </property>
               <property>
                  <name>hbase.regionserver.msginterval</name>
                  <value>{{getv "/env/hbase.regionserver.msginterval"}}</value>
               </property>
               <property>
                  <name>hbase.regionserver.logroll.period</name>
                  <value>{{getv "/env/hbase.regionserver.logroll.period"}}</value>
               </property>
               <property>
                  <name>hbase.regionserver.regionSplitLimit</name>
                  <value>{{getv "/env/hbase.regionserver.regionSplitLimit"}}</value>
               </property>
               <property>
                  <name>hbase.balancer.period</name>
                  <value>{{getv "/env/hbase.balancer.period"}}</value>
               </property>
               <property>
                  <name>hbase.regions.slop</name>
                  <value>{{getv "/env/hbase.regions.slop"}}</value>
               </property>
               <property>
                  <name>io.storefile.bloom.block.size</name>
                  <value>{{getv "/env/io.storefile.bloom.block.size"}}</value>
               </property>
               <property>
                  <name>hbase.rpc.timeout</name>
                  <value>{{getv "/env/hbase.rpc.timeout"}}</value>
               </property>
               <property>
                  <name>hbase.column.max.version</name>
                  <value>{{getv "/env/hbase.column.max.version"}}</value>
               </property>
               <property>
                  <name>hbase.security.authorization</name>
                  <value>{{getv "/env/hbase.security.authorization"}}</value>
               </property>
               {{if exists "/env/qingcloud.phoenix.on.hbase.enable"}}{{$phoenix := getv "/env/qingcloud.phoenix.on.hbase.enable"}}
                 {{if eq $phoenix "true"}}
               <property>
                  <name>phoenix.functions.allowUserDefinedFunctions</name>
                  <value>{{getv "/env/phoenix.functions.allowUserDefinedFunctions"}}</value>
               </property>
               <property>
                  <name>phoenix.transactions.enabled</name>
                  <value>{{getv "/env/phoenix.transactions.enabled"}}</value>
               </property>
               <property>
                  <name>hbase.regionserver.wal.codec</name>
                  <value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value>
               </property>
               <property>
                  <name>hbase.region.server.rpc.scheduler.factory.class</name>
                  <value>org.apache.hadoop.hbase.ipc.PhoenixRpcSchedulerFactory</value>
               </property>
               <property>
                  <name>hbase.rpc.controllerfactory.class</name>
                  <value>org.apache.hadoop.hbase.ipc.controller.ServerRpcControllerFactory</value>
               </property>
               <property>
                  <name>data.tx.snapshot.dir</name>
                  <value>/tephra/snapshots</value>
               </property>
                 {{end}}
               {{end}}
            </configuration>

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

  + 创建/etc/confd/templates/hbase-monitor.py.tmpl

            import sys
            import urllib2
            import json

            HBASE_ROLE_MASTER = "hbase-master"
            HBASE_DFS_ROLE_MASTER = "hbase-hdfs-master"
            HBASE_ROLE_SLAVE = "hbase-slave"


            def parse_hbase_stat(role, hjson):
                if "beans" not in hjson:
                    return
                stats = {}
                if role == HBASE_ROLE_MASTER:
                    for sub_dict in hjson["beans"]:
                        if "name" in sub_dict and sub_dict["name"] == "Hadoop:service=HBase,name=Master,sub=AssignmentManger":
                            if "ritCount" in sub_dict:
                                stats["ritCount"] = sub_dict["ritCount"]
                                return stats
                elif role == HBASE_ROLE_SLAVE:
                    for sub_dict in hjson["beans"]:
                        if "name" in sub_dict and sub_dict["name"] == "Hadoop:service=HBase,name=RegionServer,sub=Server":
                            stats["readRequestCount"] = sub_dict["readRequestCount"]
                            stats["writeRequestCount"] = sub_dict["writeRequestCount"]
                            stats["blockCacheHitCount"] = sub_dict["blockCacheHitCount"]
                            stats["blockCacheCountHitPercent"] = str(float(sub_dict["blockCacheCountHitPercent"]) * 100)
                            stats["slowDeleteCount"] = sub_dict["slowDeleteCount"]
                            stats["slowIncrementCount"] = sub_dict["slowIncrementCount"]
                            stats["slowGetCount"] = sub_dict["slowGetCount"]
                            stats["slowAppendCount"] = sub_dict["slowAppendCount"]
                            stats["slowPutCount"] = sub_dict["slowPutCount"]
                        if "name" in sub_dict and sub_dict["name"] == "Hadoop:service=HBase,name=JvmMetrics":
                            stats["GcTimeMillisConcurrentMarkSweep"] = sub_dict["GcTimeMillisConcurrentMarkSweep"]
                    return stats

            if __name__ == '__main__':
                ip = {{getv "/host/ip"}}
                role = "hbase-slave"
                port = "16030"
                res = urllib2.urlopen("http://%s:%s/jmx" % (ip, port))
                pjson = json.loads(res.read())
                print parse_hbase_stat(role, pjson)
