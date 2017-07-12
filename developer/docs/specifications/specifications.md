# 应用开发模版规范 - 完整版

如果想快速了解规范可以先阅读[应用开发模版规范 - 基础版](basic-specifications.md)。 <br>
开发者提交一个应用需要包含以下几个文件：

* config.json <br>
  该文件包含最终用户创建此应用实例时需设置的参数等信息，包括各种角色的节点配置、参数配置等。
* cluster.json.mustache <br>
  该文件包含创建此应用实例时的基础架构、应用实例生命周期管理和自定义监控告警等信息，这是一个改进版的 [mustache](http://mustache.github.io/) 文件。

config.json 定义用户在 QingCloud 控制台部署应用时需要填写的表单。控制台支持语言国际化，默认情况下，所有语言都会按配置项中的 label 和 description 展示表单。另外，cluster.json.mustache 文件中的 custom service、监控项等，会使用 key 作为国际化展示。如果您想要适应不同的语言，需要在提交的应用中包含一个 locale 文件夹，并添加对应语言的翻译文件，如：

* locale/en.json
  英文翻译文件
* locale/zh-cn.json
  中文翻译文件

具体的翻译文件格式，请参考 [国际化](#国际化)

>注：以上文件不支持 "UTF-8 Unicode (with BOM) text" 文本格式，windows下的编辑器编辑文件默认是此格式，可通过 "格式-> 以utf-8无BOM格式编码" 进行转换。

### 规范

##### config.json
此配置文件定义用户在创建应用的时候需填入的参数信息，参数包括资源信息如 CPU、内存、节点数等，还包括应用本身配置参数以及外面依赖集群信息等。
这些信息有集群级别的全局设置，也有基于角色节点级别的信息设置。下面是对每个参数详细的解释：

>注：role_name,	common.param名称自定义，右上角带3个星号(*)表示该项有 sibling (兄弟)节点，开发者提交的时候也要去掉这个标记。cluster 的 name 和 description 不需要自定义。另外，env 表示集群的环境变量，每一个变量的 key 会作为配置名直接展示给用户(key不能包含空格)，它的 label 属性可以是空字符串 ""。

```json
{
	"type": "array",
	"properties": [{
		"key": "cluster",
		"description": "cluster properties",
		"type": "array",
		"properties": [{
			"key": "name",
			"label": "Name",
			"description": "The name of the application",
			"type": "string",
			"default": "",
			"required": "no"
		}, {
			"key": "description",
			"label": "Description",
			"description": "The description of the application",
			"type": "string",
			"default": "",
			"required": "no"
		}, {
			"key": "vxnet",
			"label": "VxNet",
			"description": "The vxnet that the application will join",
			"type": "string",
			"default": "",
			"required": "yes"
		}, {***
			"key": "external_service",
			"label": "External Service",
			"description": "Choose an external service to use",
			"type": "service",
			"limits": {
				"app-id"***: ["app-version"***]
			},
			"default": "",
			"required": "yes"
		}, {***
			"key": "role_name",
			"description": "role-based node properties",
			"label": "Role Name",
			"type": "array",
			"properties": [{
				"key": "loadbalancer",
				"label": "Loadbalancer Service",
				"description": "Choose a loadbalancer service to use",
				"type": "loadbalancer",
				"port": 80,
				"default": [],
				"required": "yes"
			}, {
				"key": "cpu",
				"label": "CPU",
				"description": "CPUs of each node",
				"type": "integer",
				"default": 1,
				"range": [1, 2, 4, 8, 16],
				"required": "yes"
			}, {
				"key": "memory",
				"label": "Memory",
				"description": "Memory of each node (in MiB)",
				"type": "integer",
				"default": 2048,
				"range": [2048, 8192, 16384, 32768, 49152],
				"required": "yes"
			}, {
				"key": "count",
				"label": "Count",
				"description": "Number of nodes for the cluster to create",
				"type": "integer",
				"default": 3,
				"max": 100,
				"min": 1,
				"required": "yes"
			}, {
				"key": "instance_class",
				"label": "Instance Class",
				"description": "The instance type for the cluster to run，such as high performance，high performance plus",
				"type": "integer",
				"default": 0,
				"range": [0, 1],
				"required": "yes"
			}, {
				"key": "volume_class",
				"label": "Volume Class",
				"description": "The volume type for each instance，such as high performance，high performance plus，high capacity",
				"type": "integer",
				"default": 0,
				"range": [0, 2, 3],
				"required": "yes"
			}, {
				"key": "volume_size",
				"label": "Volume Size",
				"description": "The volume size for each instance",
				"type": "integer",
				"default": 10,
				"min": 10,
				"max": 1000,
				"step": 10,
				"required": "yes"
			}, {
				"key": "replica",
				"label": "Replica",
				"description": "The replica number for each node with this role",
				"type": "integer",
				"default": 1,
				"required": "yes"
			}]
		}]
	}, {
		"key": "env",
		"description": "application configuration properties",
		"type": "array",
		"properties": [{***
			"key": "common.param",
			"label": "Common Param",
			"description": "The common.param1 for all nodes",
			"type": "string",
			"changeable": true,
			"default": "value1,value11",
			"separator": ",",
			"range": ["value1", "value11", "value111"],
			"multichoice": true,
			"required": "yes"
		}, {***
			"key": "role_name",
			"description": "The role configuration properties of the application",
			"type": "array",
			"properties": [{***
				"key": "param",
				"label": "Role Param",
				"description": "The param for all slave nodes",
				"type": "string",
				"changeable": true,
				"default": "value1",
				"range": ["value1", "value11"],
				"required": "yes"
			}]
		}]
	}, {
		"key": "service_params",
		"description": "Custom service configuration properties",
		"type": "array",
		"properties": [{***
			"key": "common.param",
			"label": "Common Param",
			"description": "The common.param1 for all nodes",
			"type": "string",
			"default": "value1,value11",
			"separator": ",",
			"range": ["value1", "value11", "value111"],
			"multichoice": true,
			"required": "yes"
		}, {***
			"key": "role_name",
			"description": "Custom service the role (role_name) configuration properties",
			"type": "array",
			"properties": [{***
				"key": "param",
				"label": "Role Param",
				"description": "The param for all slave nodes",
				"type": "string",
				"pattern": "^value.+",
				"default": "value1",
				"range": ["value1", "value11"],
				"required": "yes"
			}]
		}]
	}]
}
```

json 配置项中的每一项，都是一个含有 key、label、description、type、range 等参数的 object。配置项支持嵌套，若 type 为 array，则该项的 properties 填写一个有序列表，在用户部署应用的时候填写配置使用，因此需要注意配置项的顺序。配置项中各参数的解释如下：

* key <br>
  对应 [cluster.json.mustache](#cluster.json.mustache) 文件索引的值，例如 {% raw %}{{cluster.name}}{% endraw %} 表示 config.json 中 cluster 内 key=name 的项用户所填写的值。
* label <br>
  用户部署应用时，填写配置项的名称。如果提供了国际化的配置文件，会进行国际化。
* description <br>
  用户部署应用时，填写配置项的描述。如果提供了国际化的配置文件，会进行国际化。
* type <br>
  该配置项的类型，请参考 [数据类型](#数据类型)。
* changeable <br>
  如果为 false 表示该项用户在创建应用实例时候需要赋值，创建完毕以后则不能修改，比如数据库实例用户名和密码等类型的参数，默认值为 true。
* range <br>
  限定配置项的取值范围，是一个可枚举的数组。
* multichoice <br>
  和 range 配合使用，定义为 true 则为多选，默认是 false 为单选。
* separator <br>
  定义 multichoice 为 true 时有效，多选后多个值连接所使用的分隔符，默认值为逗号。
* min <br>
  若配置项 type 为 integer 或 number(浮点数)，指定该项的最小值。
* max <br>
  若配置项 type 为 integer 或 number(浮点数)，指定该项的最大值。
* step <br>
  若配置项是 volume_size，指定硬盘每次调整的最小步长单位。在每个主机挂多块盘时，通常需要指定该项。
* pattern <br>
  正则表达式，可用该值规范填写内容。
* required <br>
  是否为必填项
* default <br>
  该项的默认取值，若 required 设为 "no"，default 值必须提供。

一些系统预留(即必须提供)的项含义如下：

* name <br>
  创建应用时用户填入的名称
* description <br>
  创建应用时用户填入描述信息
* vxnet <br>
  创建应用时所在网络ID

一些特殊项含义如下：

* external\_service <br>
  此应用依赖外部应用信息，名称可以任意定义，即可以命名为 zk_service 表示依赖 ZooKeeper，用户可以选择在同一 VPC 中满足 limits 限定条件的集群作为此应用依赖的服务。limits 限定条件可以指定应用所依赖服务的 app id 及 app version。


##### cluster.json.mustache
该文件是在用户创建应用时需要传给青云 API 的参数，这些信息的具体值是来自用户在 UI 上根据 config.json 定义的变量的输入，每个字段的具体描述如下：

>注： 右上角带3个星号(*)表示该项有 sibling (兄弟)节点，开发者提交的时候也要去掉这个标记。advanced_actions 的内容可以添加在国际化中，在控制台用户操作时展示。

```json
{
	"name": {{cluster.name}},
	"description": {{cluster.description}},
	"vxnet": {{cluster.vxnet}},
	"links": {
		"external_service"***: {{cluster.external_service}}
	},
	"add_links": ["external_service"***],
	"upgrade_policy": [
			"appv-xxxxxxxx",
			"appv-yyyyyyyy"
	],
	"nodes": [{***
		"role": "role_name",
		"loadbalancer": {{cluster.role_name.loadbalancer}},
		"container": {
			"type": "kvm",
			"image": "img-skhdp16m",
			"zone": "pek3a"
		},
		"instance_class": {{cluster.role_name.instance_class}},
		"count": {{cluster.role_name.count}},
		"cpu": {{cluster.role_name.cpu}},
		"memory": {{cluster.role_name.memory}},
		"volume": {
			"size": {{cluster.role_name.volume_size}},
			"mount_point": "/data",
			"mount_options": "defaults,noatime",
			"filesystem": "ext4",
			"class": {{cluster.role_name.volume_class}}
		},
		"replica": {{cluster.role_name.replica}},
		"passphraseless": "ssh-dsa",
		"vertical_scaling_policy": "parallel",
		"user_access": false,
		"services": {
			"init": {
				"nodes_to_execute_on": 1,
				"post_start_service": false,
				"cmd": "mkdir -p /bigdata1/myapp;/opt/myapp/bin/init-cluster.sh"
			},
			"start": {
				"order": 1,
				"cmd": "/opt/myapp/bin/start-server.sh"
			},
			"stop": {
				"cmd": "/opt/myapp/bin/stop-server.sh"
			},
			"scale_out": {
				"cmd": "/opt/myapp/sbin/scale-out.sh"
			},
			"scale_in": {
				"cmd": "/opt/myapp/sbin/scale-in.sh",
				"timeout": 86400
			},
			"restart": {
				"cmd": "/opt/myapp/sbin/restart-server.sh"
			},
			"destroy": {
				"nodes_to_execute_on": 1,
				"post_stop_service": true,
				"cmd": "/opt/myapp/sbin/destroy-server.sh"
			},
			"upgrade": {
				"cmd": "/opt/myapp/sbin/upgrade.sh"
			},
			"backup"***: {
				"type": "custom",
				"cmd": "/opt/myapp/sbin/backup.sh",
				"timeout": 86400,
				"service_params": {
					"service_param"***: {{service_params.role_name.param}}
				}
			}
		},
		"server_id_upper_bound": 255,
		"env": {
			"param"***: {{env.role_name.param}}
		},
		"agent_installed": true,
		"custom_metadata": {
			"cmd": "/opt/myapp/sbin/get_token.sh"
		},
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
		"monitor": {
			"enable": true,
			"cmd": "/opt/myapp/bin/monitor.sh",
			"items": {
				"item_name_x"***: {
					"unit": "",
					"value_type": "str",
					"statistics_type": "avg",
					"scale_factor_when_display": 1,
					"enums": ["value_y"***]
				}
			},
			"groups": {
				"group_name_z"***: ["item_name_x"***]
			},
			"display": ["group_name_z"***, "item_name_x"***],
			"alarm": ["item_name_x"***]
		}
	}],
	"advanced_services": {
	    "update_nodes_names": {
	        "cmd": "/opt/myapp/sbin/update_nodes_names.sh",
		    "timeout": 10
	    }
	},
	"env": {
		"common.param"***: {{env.common_param}}
	},
	"advanced_actions": ["change_vxnet", "scale_horizontal"],
	"endpoints": {
		"client": {
			"port": 2181,
			"protocol": "tcp"
		},
		"reserved_ips": {
			"vip": {
				"value": ""
			}
		}
	},
	"metadata_root_access": false,
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
	"monitor": {
		"enable": true,
		"cmd": "/opt/myapp/bin/monitor.sh",
		"items": {
			"item_name_x"***: {
				"unit": "",
				"value_type": "str",
				"statistics_type": "avg",
				"scale_factor_when_display": 1,
				"enums": ["value_y"***]
			}
		},
		"groups": {
			"group_name_z"***: ["item_name_x"***]
		},
		"display": ["group_name_z"***, "item_name_x"***],
		"alarm": ["item_name_x"***]
	}
}
```

*   name <br>
    新建应用的名称，必填项，但值可以为空。
*   description <br>
    新建应用描述，必填项，但值可以为空。
*   vxnet <br>
    新建应用所在网络 ID，必填项。
*   links <br>
    新建应用可能会依赖外部应用，比如 Kafka 依赖 ZooKeeper，依赖名称可以任意命名，不一定是 external\_service，比如命名为 zk\_service；可以依赖多个外部应用，非必填项。
*   add\_links <br>
    允许增加的外部应用列表，定义在列表中的依赖名称，如 zk\_service，用户部署集群后可以新加以该名字为前缀的依赖如：zk\_service2，这样在定义多种外部依赖时，可以通过匹配前缀信息来得知用户配置的当前 link 属于哪个种类。
*   upgrade\_policy <br>
    定义当前应用的哪些版本可以升级到当前版本，新老版本之间 role 必须相同，数据盘挂载位置必须一致。由于升级后会替换集群的镜像，所以在开发阶段**请仔细测试升级功能**。
*   nodes <br>
    新建应用节点信息，必填项。一个应用的节点可能是无角色区分的，这个时候 nodes 只有一种角色的信息；也可能是多角色组成的复杂应用，这个时候 nodes 就是这些角色节点信息组成的一个数组。
    -   role <br>
        多角色节点应用必填项，单角色应用可以无此项。角色名称自定义，但必须和 config.json 里定义的名字一致。
    -   loadbalancer <br>
        新建应用可能会依赖负载均衡器，不同角色 (role) 以依赖不同的负载均衡器。
    -   container <br>
        镜像信息，必填项。
        + type <br>
          镜像类型，目前支持 kvm，docker。
        + image <br>
          镜像 ID，开发者根据镜像制作指南制作的以 img- 开头的镜像 ID，如果是 docker 则是 docker image name，包含 tag 部分。
        + zone <br>
          镜像制作时所属区域 (如果是 docker 镜像，则无需填写该字段)
    -   instance\_class <br>
        节点类型，支持 0 和 1， 其中0表示性能主机，1表示超高性能主机。可选项，默认值为0。
    -   count <br>
        节点个数，必填项，可以为0，但集群节点总数必须大于0。
    -   cpu <br>
        每个节点 cpu 个数，可选值范围：1, 2, 4, 8, 12, 16。
    -   memory <br>
        每个节点内存大小，单位 MiB。可选值范围：1024, 2048, 4096, 6144, 8192, 12288, 16384, 24576, 32768, 40960, 49152, 65536, 131072。
    -   volume <br>
        每个节点数据盘信息，如果此类节点不需要数据盘，不需要填写此项。
        + size <br>
          每个节点数据容量大小，单位 GiB，注：是单个节点总容量大小，不是每个挂盘容量大小，如果有多个挂盘，则容量平均分配到每个挂盘上，必填项。单张容量盘最大5000G，单张性能盘和超高性能盘最大1000G，且单张步长大小需是10的整数倍。
        + mount\_point <br>
          每个节点数据盘挂载路径，可以是单个数据盘， 也可以有多个数据盘，多个数据盘以数组形式表示，如 "mount\_point": ["/data1","/data2"]。如果image是基于 Linux 操作系统，默认挂载路径为 /data; 如果 image 是基于 Windows 操作系统，默认挂载路径是 d:, 挂载路径是盘符（后面须带冒号，可选的盘符名从 d 开始，z 结束）。目前最大支持3块数据盘挂载到节点上。请注意，如果挂载了多块数据盘，config.json 对应的 volume\_size 部分，最好设置一下 min，max，step 这 3 个值，以配置创建集群、扩容集群时的范围和步长。例如挂载盘数为3，可以指定 {min: 30，max: 3000，step: 30}。
        + mount\_options <br>
          描述数据盘的挂接方式，默认值 ext4 是 defaults,noatime，xfs 是 rw,noatime,inode64,allocsize=16m。
        + filesystem <br>
          数据盘文件系统类型。如果 image 是基于 Linux 操作系统，目前支持 ext4 和 xfs，默认为 ext4; 如果 image 是基于 Windows 操作系统，目前支持 ntfs, 默认为 ntfs。
        + class <br>
          数据盘类型，支持0、2、3，其中0表示性能盘，3表示超高性能盘，2表示容量盘。可选项，如果不写此项，数据盘类型和主机类型一样，即性能主机挂载性能硬盘，超高性能主机挂载超高性能硬盘。容量盘可以挂载在不同类型主机上，但容量盘是通过网络协议挂载的，所以性能相对来说比较差，通常来说如果不是提供必须基于容量盘的服务，最好去掉这个选项，大容量存储可以考虑[对象存储 QingStor](https://docs.qingcloud.com/qingstor/index.html)。
    -   passphraseless　<br>
        生成密钥信息，即提供此类节点能无密码登录其它节点的可能性，但青云调度系统只负责把此信息注册到 metadata service 中，开发者自行去获取密钥配置主机。目前支持 ssh-dsa, ssh-rsa，非必填项。
    -   vertical\_scaling\_policy <br>
        配置纵向伸缩时的操作策略，目前支持：sequential 和 parallel，默认是 parallel 即并行操作，非必填项。比如 ZooKeeper 在扩容时希望不影响对外服务，可设置该值为 sequential，串行重启。
    -   user_access　<br>
        是否允许用户访问，true 表示该角色节点允许用户通过 vnc 登录，默认值为 false，该映像的初始用户名和密码需要在“版本描述”中写清楚以便告知用户。允许用户登陆的节点在集群非活跃状态如关闭时不会销毁主机，所以用户可以往这类主机写入数据。而其它主机是不会持久化数据，必须在挂盘上持久化数据，参见[制作 KVM 镜像](../app-version-mgmt/images/kvm.md)。
    -   server\_id\_upper\_bound <br>
        节点的 index 的上限，从1开始记起，有些服务如 ZooKeeper 要求这个 index (myid) 必须控制在某一个范围内。缺省没有上限，非必填项。
    -   replica <br>
        此类节点每个节点的副本个数，这是给分片式 (即多主多从，如 redis cluster) 分布式系统使用的功能，定义每个分片的主有多少个从。这类应用需要指定 role 名称比如 master，副本节点的 role 系统会自动添加为主节点 role 加 -replica，比如此例 master-replica。因此开发者在定义节点角色名称时不能定义后缀为 "-replica"，这是一个系统保留命名规则，非必填项。
    -   services　<br>
        应用本身服务的初始化、启停等指令，青云 AppCenter 调度系统会发送这些命令到指定节点执行，非必填项。
        + init　<br>
          初始化命令，在创建集群或者新加节点时会触发该命令的执行。
          * nodes\_to\_execute_on　<br>
            控制此命令在此类角色节点上某几个节点上执行，如果需要在所有此类节点上执行该命令可不填此项。
          * post\_start\_service
              控制初始化命令是在 [start](#start) 命令执行完毕后执行还是之前执行，如果 post\_start\_service 为 true 则表示 init 在 start 后执行；默认 (即不加此项) 是之前执行。此项是 init 独有。
          * order　<br>
            控制不同角色节点之间执行此命令顺序。比如主从节点，有时候需要主节点先启动服务，从节点后启动服务，非必填项。
          * cmd　<br>
            具体需执行的命令，必填项。如果 image 是基于 Windows 操作系统，目前仅支持 bat 脚本，且脚本需通过变量 %ERRORLEVEL% 设定返回值。
          * timeout　<br>
            执行该命令 timeout 时间(单位秒)，系统默认10分钟，由于某些命令可能需要迁移数据而耗时比较长，这种情况下需要计算出最长可能时间，最大值是86400，非必填项。
        + start

          服务启动命令，具体参数参考初始化命令 init。

        + stop　<br>
          停止服务命令，具体参数参考初始化命令 init。
        + scale\_out　<br>
          加节点时在非新加节点上需执行的命令，具体参数参考初始化命令 init。
        + scale\_in <br>
          删除节点时在非删除节点上需执行的命令，具体参数参考初始化命令 init。
        + restart <br>
          服务重启动命令，具体参数参考初始化命令 init。
        + destroy <br>
          销毁命令，在删除集群或者节点时会触发该命令的执行，通常用作删除资源之前检查安全性，具体参数参考初始化命令 init。
          * post\_stop\_service　<br>
            控制销毁命令是在 [stop](#stop) 命令执行完毕后执行还是之前执行，如果 post\_stop\_service 为 true 则表示 destroy 在 stop 后执行；默认 (即不加此项) 是之前执行。此项是 destroy 独有。
        + upgrade <br>
          升级集群后执行的命令，具体参数参考初始化命令 init。
          > 注：必须先关机集群后才能升级，升级后再开启集群将会以<strong>新版本的镜像</strong>启动并执行升级命令。如果升级命令执行失败，用户可以关闭集群后降级回老版本。<br> 对于 user\_access 的节点也会使用新的镜像启动，请在使用说明中提醒用户自行备份 user\_access 节点上的数据。

        这几个服务都是系统定义的；除了 post\_start\_service 是 init,upgrade 独有、post\_stop\_service 是 destroy 独有之外，其它配置项每个服务都可配置，比如控制 stop 服务 order 等。这些命令的执行顺序请见 [应用实例生命周期](lifecycle.md)。

        + backup <br>
          用户自定义命令，具体参数参考初始化命令 init，除此之外自定义的服务参数还有：
          * type <br>
            type = custom 表示这个服务是自定义的， 自定义的名字 (即 key，此处为 backup) 开发者自行定义。
          * service\_params <br>
            service\_params 中定义这个 cmd 所需要传的参数，json 格式，非必须项，参数具体定义在 config.json 里，可参考 env 的定义方式。
          > 注：用户可以自定义多个服务。自定义服务在用户使用时，展示的服务名就是该 service 的 key，如 backup。如果想要对其进行国际化，可以在 locale 中添加它的翻译。
    -   env <br>
        特定角色节点的应用参数配置，每类应用有自身特有的可配置应用参数，每类节点也会有不同于应用全局级别的可配置参数。注意：节点之间或节点与集群全局之间的参数没有任何关系，都是独立的。
    -   agent\_installed <br>
    	如果用户想利用这套框架管理纯主机集群，则可以不用装青云提供的 App agent，同时需要指定这个参数为 false，否则系统会提示错误，该参数默认为 true。
    -   custom\_metadata <br>
        节点通过脚本生成的 token (string 类型或返回 json 格式的 string) 需要注册到 metadata service 里供其它节点使用，例如开源容器集群管理系统 (Docker Swarm, Kuburnetes) 会用到此类信息。它是在 start service 之前执行，如果 start 之前有 init 则在 init 之后 start 之前执行。
    -   health\_check <br>
        特定角色节点的健康检查配置，每类应用有自身特有的可配置健康检查参数，每类节点也会有不同于应用全局级别的可配置健康检查参数。详情请见 [应用 health check](#health_check)。
*   env <br>
    应用参数配置，比如 ZooKeeper的 zoo.cfg 里的参数配置等。
*   advanced\_actions <br>
    集群支持高级操作，目前支持两类：变换网络 (change\_vxnet) 和横向伸缩 (scale\_horizontal) 即增加节点或删除节点，这是因为有些应用尤其传统应用并不适合云的弹性要求，因此如果您的应用支持切换网络则加上 change_vxnet，如果支持横向伸缩则加上 scale\_horizontal。如果只有某一类角色需要切换网络或添加/删除节点，其它类型节点不支持，则可以只写到这个角色节点里。如果不支持此类操作则需去掉相应的定义，否则用户在界面看见有此功能而实际上是不支持的。
*   advanced\_services <br>
    应用服务高级指令，青云 AppCenter 调度系统会随机选取一个节点执行这些命令，非必填项。
    - update_nodes_names　<br>
      修改节点显示名称命令。
      * cmd　<br>
        具体需执行的命令，必填项。采集的数据以 JSON Object 的方式输出，JSON Object 的 key 是node_id (cln-xxxxxxxx)，value 是节点显示名称，例如： {"cln-xxxxxxxx": "replica-master"，"cln-xxxxxxxx": "replica-slave"}。如果 image 是基于 Windows 操作系统，目前仅支持 bat 脚本。
      * timeout　<br>
        执行该命令 timeout 时间(单位秒)，默认5秒，最大值是30秒，非必填项。
*   endpoints <br>
    应用可定义 endpoints 供第三方使用，服务名称可以自定义，但建议使用通用的名称比如 client，manager 等，这样第三方应用使用的时候更方便一些，被第三方应用使用的可能性更大一些。详细的服务信息必须包括 port，但 protocol 非必须项，即可以不提供 protocol 信息。port 除可以是整数端口外，也可以是一个指向 env 的变量，如 "port":"env.port"或 "port":"role_name.env.port"，这样用户在更新这个变量的时候会自动更新其关联的 endpoint 端口。如果您的应用是一个大家熟知的且 enpoint 不会被修改，可以省略这一定义，比如 ZooKeeper，通用端口是2181，所以可以省略掉，参见 [ZooKeeper 应用模版](../examples/spec/zookeeper.md)。<br>
*   reserved\_ips <br>
    表示集群要预留一些 IP 资源，由应用自己来分配使用，如果无此需求可不定义。预留 IP 的成员名称由开发者指定，比如这里定义为 "vip"，暂时不支持指定 IP，所以定义时 "value" 的值为空。然后系统会为该集群分配一个 IP 并更新到 "value" 中。比如系统预留了192.168.0.250这个地址给 "vip"，则 reserved_ips 的信息为：
    ```json
	"reserved_ips": {
		"vip": {
			"value":"192.168.0.250"
		}
	}
    ```
*   metadata\_root\_access <br>
    有一些应用用来管理其它应用，因此需要通过 metadata service 获取其它应用实例的信息，默认情况下 (metadata_root_access 为 false) 本应用只能获取自身集群 (即 self) 的信息和通过 self 下的 links 获取外部集群信息，如果设置 metadata_root_access 为 true，则能获取 metadata service 下所有集群的信息。如果您的应用不属于此类管理型应用，则不用设置此项。

    下例示范 tmpl 模版文件遍历所有集群节点 ip 地址 (假定都是无角色的节点)
    {% raw  %}
    ```
    {{range gets "/clusters/*/hosts/*/ip"}}{{.Value}}
	{{end}}
    ```
    {% endraw %}
    下例示范 tmpl 模板文件遍历某一类 App 的所有集群
    {% raw  %}
    ```
    {{$appID := "app-pjkzvd1"}}
    {{range gets"/clusters/*/cluster/app_id" | filter $appID}}
        {{$string := split .Key "/"}}
        {{$cluster_id := (index $string 2)}}
    {{end}}
    ```
    {% endraw %}
    下例示范 tmpl 模板文件遍历某几类 App 的所有集群
    {% raw  %}
    ```
    {{$appID1 := "app-pjkzvd1"}}
    {{$appID2 := "app-ascz121"}}
    {{$appID3 := "app-mjkrm56"}}
    {{$exp := printf "%s|%s|%s" $appID1 $appID2 $appID3}}
    {{range gets"/clusters/*/cluster/app_id" | filter $exp}}
        {{$string := split .Key "/"}}
        {{$cluster_id := (index $string 2)}}
    {{end}}
    ```
    {% endraw %}
*   health_check

    应用可以配置健康检查，详细的配置参数如下：
    - enable <br>
      是否开启健康检查，默认值为 false。
    - interval_sec <br>
      健康检查的周期，默认值为 60，最小值不小于 60。
    - timeout_sec <br>
      健康检查脚本执行的超时时间，默认值为 10，最小值不小于 3，最大值不能超过 interval_sec。
    - action_timeout_sec <br>
      动作脚本执行的超时时间，默认值为 30，最小值不小于 3。
    - healthy_threshold <br>
      节点状态变为健康时，连续健康检查成功所需的最小次数，默认值为 3，最小值不小于 2。
    - unhealthy_threshold <br>
      节点状态变为非健康时，连续健康检查失败所需的最小次数，默认值为 3，最小值不小于 2。
    - check_cmd <br>
      健康检查脚本。如果本次检查节点正常，脚本应返回0，否则返回非0值。如果 image 是基于 Windows 操作系统，目前仅支持 bat 脚本。
    - action_cmd <br>
      节点状态变为非健康时，触发的动作脚本。如果 image 是基于 Windows 操作系统，目前仅支持 bat 脚本。

  	应用节点会继承应用的健康检查配置，当应用节点配置了相同的健康检查参数时，优先使用节点的配置。注明：前端在创建集群之后需要等大约５分钟左右服务检测才会展现出来。
*   monitor <br>
    应用可以配置可采集的监控数据，详细的配置参数如下：
    -   enable <br>
        是否开启监控，默认值为 false。
    -   cmd <br>
        监控数据采集脚本。脚本应保证在5秒内完成，采集的数据以 JSON Object 的方式输出，JSON Object 的 key 是监控项的名字 (item_name)，value 是监控项的值，例如： {"received": 1200，"sent": 1234，"connections": 10}。如果 image 是基于 Windows 操作系统，目前仅支持 bat 脚本。
    -   items <br>
        设置采集的监控项，监控项的个数不能超过50。"items" 对应的值是一个 JSON Object，该 JSON Object 的 key 是监控项的名字 (item_name)，value 是监控项配置，详细的监控项配置参数如下：
        - unit <br>
          监控项的计量单位，默认值为空字符串("")。
        - value_type <br>
          监控项的值类型，目前支持 "int" (整型)和 "str" (字符串型)，默认值为 "int"。
          对于浮点型数据，可以通过乘于一个倍数(例如100)将其转化成整型，并将 scale_factor_when_display 设为该倍数的倒数(例如0.01)来实现数据的采集。
        - statistics\_type <br>
          指定监控项值的统计方式，目前支持如下方式：
          - min <br>
            取监控项在统计区间内采集数据的最小值
          - max <br>
            取监控项在统计区间内采集数据的最大值
          - avg <br>
            取监控项在统计区间内采集数据的平均值
          - delta <br>
            取监控项在统计区间内采集数据的变化值，如果变化值小于0,则设为0。
          - rate <br>
            取监控项在统计区间内采集数据的变化率
          - mode <br>
            取监控项在统计区间内采集数据的众数(即出现次数最多的一个值)
          - median <br>
            取监控项在统计区间内采集数据的中位数
          - latest <br>
            取监控项在统计区间内采集数据的最新值

          值类型为 "int" (整型)的监控数据，支持以上所有类型的统计方式，默认的统计方式为 "avg"。
          值类型为 "str" (字符串型)的监控数据，只支持 "mode" 和 "latest" 两种统计方式，默认的统计方式为 "latest"。
        - enums <br>
          当 value_type 为 "str" 的时候才需要该字段，枚举出该监控项可能的 value 值(为了方便用户配置告警)。
        - scale_factor_when_display <br>
          指定在前端展示时，采集数据的放大倍数，默认值为1。该配置只支持值类型为 "int" (整型)的监控数据。
    -   groups <br>
        设置监控组，每个监控组可以包含1～5个监控项。"groups" 对应的值是一个 JSON Object，该 JSON Object 的 key 是监控组的名字 (group_name)，value 是一个 JSON Array，该 Array 中的每个元素是一个监控项的名字 (item_name)。
    -   display <br>
        指定监控数据的显示顺序，其值是一个 JSON Array，该 JSON Array 中的每个元素可以是一个监控组的名字 (group_name)，也可以是一个监控项的名字 (item_name)。item_name 和 group_name 会进行国际化，如果想要提供各语言环境下的监控项描述，请提供翻译文件。
    -   alarm <br>
        告警指标，其值是一个 JSON Array，该 JSON Array 中的每个元素必须是上面某个监控项的名字 (item_name)，这里的每一项都会成为"控制台-管理-监控告警"下的一个告警指标。

  	应用节点会继承应用的监控配置，当应用节点配置了相同的监控参数时，优先使用节点的配置。注明：前端在创建集群之后需要等５分钟监控项才会展现出来。

### 数据类型
config.json 文件里对每个变量需要定义其类型、取值范围、默认值等，其中类型和默认值为必填项。

* type
变量数据类型，支持：integer，boolean，string，number (浮点数)，array，service，loadbalancer，password。
    - service <br>
      新应用可能会依赖外部应用，比如 Kafka 依赖 ZooKeeper，应用使用该类型表示。
    - loadbalancer <br>
      新应用如需使用负载均衡器，可以使用该类型表示，定义时需要同时定义负载均衡器后端服务端口参数：port，比如搭建的 HTTP 的 web server，可以指定 port 为80。
    - password <br>
      可在 env 或 service_params 变量中使用，界面会用密码形式显示输入。
* range <br>
变量定值的取值范围，数组类型，如 "range": [1,3,5,7,9]。
* max <br>
变量取值的最大值，integer 和 number 类型有效。
* min <br>
变量取值的最小值，integer 和 number 类型有效。
* default <br>
变量默认值

### 国际化
config.json 中的 label 和 description 在控制台呈现时，默认使用配置文件中定义的内容。另外，一些自定义的服务、监控项也会直接展示到集群使用者的操作界面上。控制台的用户切换语言时，不改变该描述。如果您想让不同语言场景的用户能看到该语言的描述，请在提交的包中添加 locale 文件夹，并根据您希望国际化的语言提供翻译文件。

翻译文件是“语言名称.json”这样的格式，如 locale/en.json，locale/zh-cn.json。例如简体中文的翻译文件 zh-cn.json 内容示例如下：

```json
{
    "Master": "主节点",
    "Slave": "从节点",
    "CPU": "CPU",
    "Memory": "内存",
    "VxNet": "私有网络",
    "The name of the service": "服务名称",
    "The description of the service": "服务描述",
    "CPUs of each node": "每个节点的 CPU 数量",
    "Memory of each node (in MiB)": "每个节点的内存大小（单位 MiB）",
    "The vxnet that the application will join": "应用运行的私有网络环境",
    "change_vxnet": "切换私有网络",
    "scale_horizontal": "横向扩容"
}
```

进行国际化的配置内容包括：

* config.json 文件中，角色名称、节点配置、私有网络、外部依赖、环境变量 env 各配置项的 label 作为待填写项名称，description 作为待填项的描述。label 和 description 会进行国际化。
* cluster.json.mustache 文件中 type 为 custom 的 service，会使用 service 的 key 作为用户执行自定义服务的展示内容，并进行国际化。
* cluster.json.mustache 文件中 monitor 部分的 group_name，item_name，会在用户看到的监控视图中，作为监控项名称展示，并进行国际化。


### 示例

参见 [应用模版示例](../examples/spec/README.md)
