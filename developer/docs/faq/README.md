# 常见问题

<extoc></extoc>

## 1. 作为新手，如何从一个最简单的例子入手？    

我们在  [GitHub](https://github.com/QingCloudAppcenter/)上提供了大量的基于AppCenter开发的实例代码和配置文件，作为新手我们建议从[Zookeeper](https://github.com/QingCloudAppcenter/Zookeeper)或者[Redis](https://github.com/QingCloudAppcenter/Redis-standalone)入手。

## 2. app agent是什么？如何安装app agent程序？   

下载青云提供的 app agent[Linux 版本](http://appcenter-docs.qingcloud.com/developer-guide/scripts/app-agent-linux-amd64.tar.gz), [Windows 版本](http://appcenter-docs.qingcloud.com/developer-guide/scripts/app-agent-windows-386.zip)， 解压后运行 ./install.sh (Windows 下双击 install.bat)。    
此 agent 中包含了自动配置文件程序 confd，该程序是在开源 confd 的基础上修改了一些 bug 并且增加了一些算术功能，详情见 [QingCloud confd](https://github.com/yunify/confd/)。  
> 具体配置请参考文档 [制作 KVM 镜像](https://appcenter-docs.qingcloud.com/developer-guide/docs/app-version-mgmt/images/kvm.html)  

## 3. 如何创建toml和tmpl的模板文件？  

具体配置请参考文档 [制作 KVM 镜像](https://appcenter-docs.qingcloud.com/developer-guide/docs/app-version-mgmt/images/kvm.html)

**关键字**： 创建模版文件

## 4. 什么是Metadata 服务，如何查询Metadata上的值？  

青云 AppCenter 的 metadata service 是在 etcd 基础之上进行了二次开发，主要增加了 self 属性，即每个节点只能从该服务获取到自身相关的信息，如本机 IP、server ID 等， 此项目已在 github 上开源。   
在创建好一个集群后，登陆到任意一个节点，在文件 /etc/confd/confd.toml 里找到 nodes 这一行(这个文件是青云调度系统在用户创建集群的时候自动生成的)，这一行定义的是 metadata server 的 IP 地址，任取一个 IP，运行下面命令即可看到所有信息。   
> 注明：同一 VPC 里所有集群这个文件内容相同。   

```shell
curl http://[IP]/self
```

或者直接访问

```shell
curl http://metadata/self
```

>具体配置请参考文档 [Metadata 服务](https://appcenter-docs.qingcloud.com/developer-guide/docs/metadata-service.html)

## 5. 如何查看日志？  

App有以下几种日志信息需要开发者关注。

- 集群主机里的 confd的日志     
    启动时的 log： /opt/qingcloud/app-agent/log/confd-onetime.log   
    其他操作修改时的 log： /opt/qingcloud/app-agent/log/confd.log  
    >其他操作是指修改了confd相关的.toml和.tmpl文件后,执行了service confd restart命令之后重新生成新的confd相关的日志。

- 应用本身服务调用的日志     
    应用本身服务的初始化、启动、停止等指令，青云 AppCenter 调度系统会发送这些命令到指定节点执行，非必填项。  
    在 [AppCenter 应用开发平台](https://appcenter.qingcloud.com/developer/) 上可以查到相关日志。
    ![faq_applog.png](../../images/faq_applog.png)

- 监控日志
    监控日志主要是指用户开发的健康检查和监控命令调用的日志。   
    在 [AppCenter 应用开发平台](https://appcenter.qingcloud.com/developer/) 上可以查到相关日志。  
    ![faq_applog.png](../../images/faq_appmonitorlog.png)

## 6. 如何理解数据持久化和挂盘，该如何配置？如何检查数据持久化是否配置成功？    

所谓持久化数据是指跟具体用户有关的数据，如 session、用户自己的数据如用户的数据库信息、用户设置的参数、日志等。而应用程序，比如数据库应用程序本身不是持久化数据，因为它可以无差别的重复部署而不影响服务。

基于AppCenter开发的应用实例如果不配置挂载盘是不会保存用户需要持久化的数据的，在实例重启之后数据都会清空。因此需要在config文件中配置挂盘，配置挂载盘之后，每次实例重新启动后会从该挂载盘的路径下读取用户持久化的数据。   
具体参数配置如下图所示：

```json
#cluster.json.mustache文件

"nodes": [
{
    "role": "tomcat_nodes",
    "container": {
            "type": "kvm",
            "zone": "pek3a",
            "image": "img-h73eih5e"
    },
    "loadbalancer": {{cluster.tomcat_nodes.loadbalancer}},
    "instance_class": {{cluster.tomcat_nodes.instance_class}},
    "count": {{cluster.tomcat_nodes.count}},
    "cpu": {{cluster.tomcat_nodes.cpu}},
    "memory": {{cluster.tomcat_nodes.memory}},
    "volume": {
        "size": {{cluster.tomcat_nodes.volume_size}},
        "mount_point": "/data",  ***请注意这里!!!
        "mount_options": "defaults,noatime",
        "filesystem": "ext4"
    }
}
]
```

通常如果配置了数据持久化处理，在配置文件的init脚本中需要编写脚本，将应用的默认的数据路径下的数据复制到挂载盘下。

```text
#cluster.json.mustache文件

"services": {
    "init": {
        "cmd": "systemctl restart rsyslog;mkdir -p /data/webapps;rsync -aqxP /opt/apache-tomcat-7.0.78/webapps/ /data/webapps"
    },    ***请注意这里!!!
}
```

如何检查数据持久化是否配置成功？  
关闭集群，再启动集群，打开应用查看数据是否还在。

>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)  关键字：init

## 7. 如何写健康检查的配置和脚本？  

示例如下：

```json
#cluster.json.mustache文件

"health_check": {
    "enable": true,
    "interval_sec": 60,
    "timeout_sec": 10,
    "action_timeout_sec": 30,
    "healthy_threshold": 3,
    "unhealthy_threshold": 3,
    "check_cmd": "/opt/myapp/bin/check.sh",
    "action_cmd": "/opt/myapp/bin/action.sh"
},
```

如果配置了此参数，在控制台上会展示各个节点的服务状态是否健康。
![faq_healthcheck.png](../../images/faq_healthcheck.png)

>check_cmd的内容为根据你的应用自己编写的脚本，appcenter会根据exit code判断是否健康，exit code为0则健康，非0则不健康。action_cmd的内容为在服务不健康的情况下需要做的动作。

具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：health_check

## 8. 如何写监控数据的配置和脚本？  

示例如下：

```json
#cluster.json.mustache文件

"monitor": {
    "enable": true,
    "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pgmonitor.py",
    "items": {
        "connCnt": {
            "unit": "",
            "value_type": "int",
            "statistics_type": "latest",
            "scale_factor_when_display": 1
        },
        "commitCnt": {
            "unit": "",
            "value_type": "int",
            "statistics_type": "latest",
            "scale_factor_when_display": 1
        }
    },
    "groups": {
        "connCntGrp": ["connCnt"],
        "commitCntGrp": ["commitCnt"]
    },
    "display": ["connCntGrp","commitCntGrp"],
    "alarm": ["connCnt"]
}
```

如果配置了此参数，在控制台上会展示各个节点的具体监控数据的值。
![faq_monitor.png](../../images/faq_monitor.png)
>cmd的内容为根据你的应用自己编写的脚本，其返回结果是特定格式的json。

具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：monitor

## 9. 如何写自定义服务的脚本？  

示例如下：

```json
#cluster.json.mustache文件

"services": {
    "init": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pginit.sh"
    },
    "start": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pgstart.sh"
    },
    "restart": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pgrestart.sh"
    },
    "RebuildStandby": {
        "type": "custom",
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pgrebuildstandby.sh",
        "timeout": 86400
    }
},

```

如果配置了此参数，在控制台上会展示各个节点的具体监控数据的值。   
![faq_customservice.png](../../images/faq_customservice.png)
>cmd的内容为根据你的应用自己编写的脚本，自定义服务的内容。

具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**："type": "custom"

## 10. 如何设置应用自身的配置参数？

首先在config.json文件中定义定义用户在创建应用的时候需填入的参数信息，参数包括资源信息如 CPU、内存、节点数等，还包括应用本身配置参数以及外面依赖集群信息等。 这些信息有集群级别的全局设置，也有基于角色节点级别的信息设置。   
其次，定义好参数信息，在cluster.json.mustache文件中可以引用这些变量。

示例（应用全局级别）如下：

```json
#config.json文件

{
    "key": "env",
    "description": "application configuration properties",
    "type": "array",
    "properties": [
        {
            "key": "DBname",
            "label": "DBname",
            "description": "DB name to create",
            "type": "string",
            "default": "qingcloud",
            "required": "yes",
            "changeable": false
        },
        {
            "key": "max_connections",
            "label": "max_connections",
            "description": "Sets the maximum number of concurrent connections.",
            "type": "integer",
            "default": 256,
            "min": 0,
            "max": 65536,
            "required": "no"
        }
    ]
}
```

```json
#cluster.json.mustache文件

"env": {
    "DBname": {{env.DBname}},
    "max_connections": {{env.max_connections}}
}    
```

同时定义好应用的配置参数，在confd的.tmpl文件中可以使用这些参数。例如:

```go
max_connections= {{getv "/env/max_connections"}}
```

也可以使用shell脚本在metadata server上获取改值。

```shell
curl http://metadata/self/cluster/endpoints/reserved_ips/vip/value
```

如果配置了此参数，在控制台集群列表的`配置参数`tab页可以查看具体配置信息。
![faq_params.png](../../images/faq_params.png)
>角色节点级别的示例和具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：env

## 11. 用户输入参数如何做校验,如何支持正则表达式？  

示例如下：

```json
#config.json文件

{
    "key": "env",
    "description": "Tomcat cluster service properties",
    "type": "array",
    "properties": [
    {
        "key": "tomcat_user",
        "label": "User name to access Tomcat manager GUI",
        "description": "User name to access Tomcat manager GUI, avoid to set it as 'tomcat' because it's already predefined with role 'manager_script'",
        "type": "string",
        "default": "qingAdmin",
        "pattern": "^(？!.*？[tT][oO][mM][cC][aA][tT]).*$",
        "required": "yes"
    }
    ]
}

```

如果配置了此参数，输入非法数据，在提交创建应用的时候会提示错误信息。
![faq_pattern.png](../../images/faq_pattern.png)
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：pattern

## 12. 如何展示节点的其他信息？  

示例如下：

```json
#cluster.json.mustache文件

"display_tabs": {
    "node_details": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pgnodedetails.sh",
        "timeout": 10,
        "description": ""
    }
}  
```

如果配置了此参数，在控制台集群列表会多出一个tab页可以查看具体配置信息。
![faq_nodedetails.png](../../images/faq_nodedetails.png)
cmd内容为采集的数据需执行的命令，必填项。  
采集的数据以 JSON Object 的方式输出，例如：  

```json
{
    "labels": ["节点ID","节点IP", "角色"], 
    "data": [
        ["cln-ydozfe18","192.168.100.2", "Master"], 
        ["cln-fq788j27","192.168.100.6", "Standby"]
    ]
}
```

返回结果会以表格的形式展示在集群详情页自定义标题的tab页下，其中 "labels" 和 "data" 是固定key。    
labels表示表格第一行的标题，是个list，最多可定义5列；     data标示表格里面每行数据，要求data是个list，list下是多个子list，最多255个。    其中每个子list标示一行数据，元素个数需和labels中一致。  
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：display_tabs

## 13. 如何开放VNC给用户，允许用户访问节点？  

示例如下：

```json
#cluster.json.mustache文件

{
    "role": "log_node",
    "container": {
        "type": "kvm",
        "zone": "pek3a",
        "image": "img-b5urfv9t"
    },
    "instance_class": {{cluster.log_node.instance_class}},
    "user_access": true,     ***请注意这里!!!
    "count": 1,
    "cpu": {{cluster.log_node.cpu}}
}
```

如果配置了此参数，在控制台上集群的节点列表下会有一个VNC的小图标，点击该图标可以登录该节点。
![faq_vnc.png](../../images/faq_vnc.png)    
同时，在[AppCenter应用开发](https://appcenter.qingcloud.com/apps/)搜索找到你需要的应用，打开`资源`tab页，右侧有一个VNC小图标。    
![faq_vnc2.png](../../images/faq_vnc2.png)   
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：user_access

## 14. 如何备份？  

backup_policy
定义应用的备份策略，支持 "device" 和 "custom" 两种类型。"device" 表示对节点的挂盘做snapshot；"custom" 则是使用自定义的备份命令进行备份操作，比如备份到某个目录，或拷贝到某个节点。非必填项

示例如下：

```json
#cluster.json.mustache文件
"name": {{cluster.name}},
"description": {{cluster.description}},
"vxnet": {{cluster.vxnet}},
"backup_policy": "device",  ***请注意这里!!!
```

注意，如果设置了备份策略参数的话，必须将service下的backup命令写上，否则该参数不会生效。 示例如下：

```json
#cluster.json.mustache文件

"services": {
    "init": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pginit.sh"
    },
    "backup": {  ***请注意这里!!!
        "cmd": "echo `date '+%Y-%m-%d %H:%M:%S'`':Info: Backup by Appcenter interface!'  >>/data/pgsql/main/pg_log/pgscripts.log",
        "timeout": 86400
    },
    "restore": {
        "cmd": "echo `date '+%Y-%m-%d %H:%M:%S'`:restore by Appcenter interface!>>/data/pgsql/main/pg_log/pgscripts.log",
        "timeout": 86400
    }
}
```

如果配置了此参数，在控制台上集群右键会出现创建备份的菜单。
![faq_backup.png](../../images/faq_backup.png)
以上示例是基于device类型的备份策略，对于custom类型类似，但是需要注意如下几点：

- "backup_policy": "custom",  
- "backup": cmd参数会默认传入一个snapshot id作为参数，在cmd脚本可以获取到这个参数。  
    例如：执行的时候是 `sh /opt/yourbackup.sh '{"snapshot_id": "s-12345678"}`'  开发者可以解析后在cmd命令写成处理成 `cp /opt/data.txt /data/s-12345678`
- "restore": restore操作的时候类似。cmd参数会默认传入一个snapshot id作为参数，在cmd脚本可以获取到这个参数。  
    例如：执行的时候是 `sh /opt/yourrestore.sh '{"snapshot_id": "s-12345678"}'`  开发者可以解析后在cmd命令写成处理成 `cp /data/s-12345678 /opt/data.txt`

>注意：restore 操作是在恢复的新集群上进行操作的。   
    具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)
    
**关键字**：backup_policy、backup

## 15. 如何升级，如何支持应用的大版本升级？

AppCenter支持的升级的原理是，用新的版本的镜像去驱动挂载盘下应用的数据，因此如果应用本身的版本没有变化或者只是小版本升级，可以直接通过AppCenter的升级参数配置进行无缝升级。  
示例如下：

```json
#cluster.json.mustache文件

{
  "name": {{cluster.name}},
  "description": {{cluster.description}},
  "vxnet": {{cluster.vxnet}},
  "backup_policy": "device",
  "upgrade_policy": ["appv-djgirq3p"]
}
```

同时，如果在升级的同时要做一些其他的任务，可以在service的upgrade脚本里编写自己的内容。示例如下：
> 请注意该脚本是在新的应用的集群上运行的，其流程是：关机 => 升级 => 开机 => 执行upgrade cmd=> 执行start cmd

```json
#cluster.json.mustache文件

"services": {
    "init": {
        "cmd": "/usr/lib/postgresql/9.6/bin/scripts/pginit.sh"
    },
    "upgrade": {    ***请注意这里!!!
        "cmd": "/opt/myapp/sbin/upgrade.sh"
    }
}
```

如果配置了此参数，在控制台上原来旧的版本的集群列表集群右侧会出现一个向上的升级箭头，关闭旧的集群，点击该图标就可以直接升级到最新的版本。

对于应用的大版本升级的问题，例如PostgreSQL9.6和PostgreSQL10，如果直接采用上面的方法是不可用的，因为对于新版本的应用（PostgreSQL10）是无法驱动挂载盘下的旧版本（PostgreSQL9.6）格式的数据，需要对挂载盘下的数据做转换才可以以升级后的新版本的应用读取数据。    
因此，我们建议有以下2种方式进行升级处理。

- 新版本不直接支持从旧版本无缝升级到新版本，用户创建好新版本后，自己通过工具将数据从旧版本导入到新版本的集群中去。    
- 新版本直接支持从旧版本无缝升级到新版本，在新版本的镜像中同时安装新旧2个版本，在upgrade的cmd编写脚本，将数据从旧版本转换成新版本可直接读取的文件格式。   

>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：upgrade_policy、upgrade  

## 16. 如何设置集群的VIP？  

示例如下：

```json
#cluster.json.mustache文件

"reserved_ips": {
    "vip": {
        "value": ""
    }
}		
```

如果配置了此参数，在控制台上集群信息左侧会出现VIP的具体信息。   
![faq_vip.png](../../images/faq_vip.png)
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：reserved_ips		

## 17. 如何支持用户下载和查看应用的日志？

对于这个需求，解决的办法可以有多种方式。

- 应用自身提供的web页面的log查看方式。
- 若应用本身不提供web log，可以开放ftp权限给用户去应用的日志路径下查看日志。
- 采用第三方日志收集工具rsyslog，logstash等日志收集到日志节点，允许用户登录该节点查看日志。
- 其他方式。

## 18. 如何语言国际化？     

如果您想要适应不同的语言，需要在提交的应用中包含一个 locale 文件夹，并添加对应语言的翻译文件，如：

- locale/en.json 英文翻译文件
- locale/zh-cn.json 中文翻译文件

示例如下：   

```json
#locale/zh-cn.json文件

{
  "Master": "主节点",
  "Slave": "从节点",
  "CPU": "CPU"
}			
```

config.json 定义用户在 QingCloud 控制台部署应用时需要填写的表单。
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：国际化		

## 19. 应用实例调用的脚本中环境变量不可用的问题？  

如果我们在制作镜像的时候设置了一些环境变量，并在一些脚本文件中直接使用这些环境变量是没有问题的，但在使用这个image实例化应用之后，这些环境变量会不可用。  
因此建议大家在编写脚本的时候重新再export一下环境变量。    
例如export PGDATA=/data/pgsql/main。

## 20. 如何配置依赖其他集群的服务？

示例如下：

```json
#cluster.json.mustache文件

"links": {
            "redis_service": {{cluster.redis_service}},
            "mysql_service": {{cluster.mysql_service}}
 }
```

```json
#config.json文件

{
    "key": "redis_service",
    "label": "Redis",
    "description": " ",
    "type": "service",
    "tag": ["Redis","redis"	],
    "limits": {"app-zydumbxo": ["appv-q1uwklp7"]},
    "default": "",
    "required": "no"
},
{
    "key": "mysql_service",
    "label": "MySql",
    "description": " ",
    "type": "service",
    "tag": ["MySql","mysql"],
    "limits": {"app-00r26u27": ["appv-le9cpyc6"]},
    "default": "",
    "required": "no"
}
```

其中limits参数的值为 app-id***: [app-version***]。  
如果配置了此参数，在控制台上新建集群的时候会出现当前实例所在的私网下存在的所依赖的服务。   
![faq_depend.png](../../images/faq_depend.png)
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：links、limits

## 21. 如何把任务执行的错误原因更友好的呈现给用户？  

在执行 `scale_in/scale_out` 的 `pre_check` 和 `cmd` 时，系统会捕获错误码并将 i18n 文件中的对应条目 err_codeX (其中 X 为错误码)作为错误消息提示给用户.
 比如 `locale/zh-cn.json` 文件内容为:

`{ "err_code111": "无法删除主节点" }`

在执行 `scale_in/scale_out` 的  `pre_check` 如果遇到错误码为 111, 则显示"无法删除主节点"为错误消息。

## 22. 如何配置横向扩容？

示例如下：

```json
#cluster.json.mustache文件

"nodes": [
  {
    "role": "tomcat_nodes",
    "container": {"type": "kvm","zone": "pek3a","image": "img-h73eih5e"},
    "loadbalancer": {{cluster.tomcat_nodes.loadbalancer}},
    "instance_class": {{cluster.tomcat_nodes.instance_class}},
    "count": {{cluster.tomcat_nodes.count}},
    "cpu": {{cluster.tomcat_nodes.cpu}},
    "memory": {{cluster.tomcat_nodes.memory}},             
    "advanced_actions": ["scale_horizontal"]   ***请注意这里!!!
  },  
```

同时，如果在升级的同时要做一些其他的任务，可以在service的upgrade脚本里编写自己的内容。示例如下：

```json
#cluster.json.mustache文件

"services": {
    "scale_out": {
        "pre_check": "/opt/myapp/sbin/scale-out-pre-check.sh",
        "cmd": "/opt/myapp/sbin/scale-out.sh"
    },
    "scale_in": {
        "pre_check": "/opt/myapp/sbin/scale-in-pre-check.sh",
        "cmd": "/opt/myapp/sbin/scale-in.sh",
        "timeout": 86400
    },
}

```

如果配置了此参数，在控制台上集群节点列表上会出现新增节点的按钮。
![faq_scale.png](../../images/faq_scale.png)
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：advanced_actions、scale_horizontal、scale_out、scale_in

## 23. 如何支持集群切换私网网络？  

变换网络 (change_vxnet) 如果您的应用支持切换网络可以加上 change_vxnet。

```json
#cluster.json.mustache文件

{
  "name": {{cluster.name}},
  "description": {{cluster.description}},
  "vxnet": {{cluster.vxnet}},
  "backup_policy": "device",
  "advanced_actions": ["change_vxnet"]
}
```

如果配置了此参数，在控制台上集群列表选中集群右键会出现切换私有网络菜单。
![faq_vxnet.png](../../images/faq_vxnet.png)
>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：advanced_actions、change_vxnet

## 24. 如何将角色的某个节点直接绑定公网IP？

绑定公网IP (associate_eip)  
如果该角色的节点需要直接绑定公网IP可以加上 associate_eip，注意: 绑定公网IP会给这个集群绑定默认集群防火墙, 其他集群如果需要访问这个集群请在集群防火墙中添加对应放行规则。

```json
#cluster.json.mustache文件

{
    "name": {{cluster.name}},
    "description": {{cluster.description}},
    "vxnet": {{cluster.vxnet}},
    "backup_policy": "device",
    "advanced_actions": ["associate_eip"]
}
```

>具体配置请参考文档 [应用开发模版规范 - 完整版](https://appcenter-docs.qingcloud.com/developer-guide/docs/specifications/specifications.html)

**关键字**：advanced_actions、associate_eip

## 25. 如何获取依赖其他集群的服务的AppID和AppVersionID？

在配置依赖服务的时候，配置参数需要知道所依赖的服务的AppID和AppVersionID。     
在[AppCenter应用开发](https://appcenter.qingcloud.com/apps/)搜索找到你需要的应用，打开可以看到相关信息。  
![faq_appid.png](../../images/faq_appid.png)

## 26. 能否提供一些confd templates（即tmpl文件）的使用例子？

示例1：

获取集群中所有节点的ip地址，range循环的用法

```go
{{range $dir := lsdir "/hosts"}}
    {{$sid := printf "/hosts/%s/sid" $dir}}
    {{$ip := printf "/hosts/%s/ip" $dir}}
        server.{{getv $sid}}={{getv $ip}}:2888:3888
{{end}}
```

confd service restart 刷新后的信息为

```text
server.1=192.168.100.2:2888:3888
server.2=192.168.100.3:2888:3888
server.3=192.168.100.4:2888:3888
```

示例 2：

定义一个变量并使用这个变量

```go
{{$tomcat_user :=getv "/env/tomcat_user"}}
{{$tomcat_pwd :=getv "/env/tomcat_pwd"}}

<user username="{{$tomcat_user}}" password="{{$tomcat_pwd}}" roles="manager-gui" />
<user username="tomcat" password="{{$tomcat_pwd}}" roles="standard,manager-script,manager-jmx,manager-status" />
```

示例3：
获取一个key的值

```go
max_connections= {{getv "/env/max_connections"}}
```

示例4：
对算术的支持 div

```go 
{{$shared_buffers := div (getv "/host/memory") 4}}
```

示例5：
if else 的用法

```text
{{$SyncStreamRepl := getv "/env/SyncStreamRepl"}}

{{if eq $SyncStreamRepl "No" }}
    synchronous_standby_names =  ''
{{else}}
    synchronous_standby_names =  '*'
{{end}}
```

示例6：
split的用法

```text
{{ $replicaIPs := split (getv "/host/ip") "." }}
{{index $replicaIPs 0}}.{{index $replicaIPs 1}}.{{index $replicaIPs 2}}.0/24
```

更多template的函数使用示例请参考[yunify/confd](https://github.com/yunify/confd/blob/master/docs/templates.md) 	

## 27. confd 日志显示 key 找不到的错误信息

经常会在confd的日志文件中看到类似于如下错误信息，通常情况是在 toml 文件没 watch 该 key，或者该 key 不存在，可以通过 `curl http://metadata/self` 查看。

 ```text
2016-10-11T13:54:41+08:00 i-lvn35udh confd[1531]: ERROR template: index.html.tmpl:2:7: executing "index.html.tmpl" at <getv "/self/host/sid...>: error calling getv: key does not exist: /self/host/sid
 ```

## 28. 上传配置包时报错：配置验证失败,报[config.json] Not valid json错误？

需要检查config.json文本内容，是否有中文符号或其他不符合json格式的部分，可以通过在线工具验证合法性，比如 [jsonlint](http://jsonlint.com/)。   
同时配置包中文件不支持 "UTF-8 Unicode (with BOM) text" 文本格式，windows下的编辑器编辑文件默认是此格式也会报此错误，可通过 "格式-> 以utf-8无BOM格式编码" 进行转换。

## 29. 我在测试的时候发现设置的服务价格没起作用，原因是什么？

自己测试自己的应用的时候是不收取服务费用的，一旦上线用户使用的时候会收取您设置的服务费用。

## 30. 节点的启动/停止命令执行出错，请确保命令写完整的全路径。

当定义的应用的启动/停止/监控命令执行有问题，例如
文件定义如下

 ```text
"start":"your_script"
 ```

服务日志如下

 ```text
2017-04-13 12:14:19,318 ERROR Failed to execute the [cmd:your_script, id:JPwqtXY56Mp22t0RsqkDtQVu3hQLxxxx] in the node [cln-pwgxxxxx]
 ```

请确认起停的命令要写全路径。例如

 ```text
"start":"/bin/your_script"
 ```

要保证脚本在任意路径下调用都可以成功返回。   
例如在创建好的集群中，执行如下命令返回正常。

 ```shell
cd /tmp  
/opt/yourscript.sh
 ```

## 31. 使用kvm作为镜像模板时，应用创建资源失败，登录创建的节点发现文件系统变成只读，该如何排查？

日志如下

```text
2017-04-17 11:03:48,800 CRITICAL Mount volume [{'mount_point': '/data', 'mount_options': '', 'filesystem': 'ext4'}] on node [cln-bo73222b] failed
```

> 请确保在制作镜像时正常关机，保证磁盘正常卸载。

## 32. 使用说明和服务条款的 Markdown 语法说明

- 支持标准的 [Markdown 语法](http://wowubuntu.com/markdown/)，同时你也可以直接使用 HTML 代码
- Markdown 转换后的内容是没有样式，如果你想再添加样式，可以将下面的 HTML 代码添加到你输入的内容之前：

 ```html
<link href="https://cdn.bootcss.com/foundation/6.3.1/css/foundation.min.css" rel="stylesheet">
 ```

> 在使用说明中，如果只输入一个网址，用户在查看使用说明时会直接跳转到该网址

## 33. 如何把任务执行的错误原因更友好的呈现给用户<i id="err_code"></i>

在执行 scale\_in/scale\_out 的 pre\_check 和 cmd 时，系统会捕获错误码并将 i18n 文件中的对应条目 `err_codeX` (其中 X 为错误码)作为错误消息提示给用户.

比如 locale/zh-cn.json 文件内容为:

```json
{ "err_code111": "无法删除主节点" }
```

在执行 scale\_in 的 pre\_check 如果遇到错误码为 111, 则显示"无法删除主节点"为错误消息。


## 34. 如果只想用 AppCenter 管理纯主机集群

    参考 [管理纯主机集群样例](./agent-no-install.md)

