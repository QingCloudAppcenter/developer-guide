### ZooKeeper

**类型:** 单角色节点最基本配置

该示例根据[应用模版规范](../../specifications/specifications.md)开发 ZooKeeper 应用的配置包，包括 config.json 和基础版 cluster.json.mustahce。为了示意监控告警等功能，增加了完整版的 cluster.json.mustache。对于单角色分布式系统可以定义角色名字，也可以不用定义。

**config.json**
```json
{
    "type": "array",
    "properties": [{
        "key": "cluster",
        "description": "ZooKeeper release 3.4.9 cluster properties",
        "type": "array",
        "properties": [{
            "key": "name",
            "label": "Name",
            "description": "The name of the ZooKeeper service",
            "type": "string",
            "default": "ZooKeeper",
            "required": "no"
        }, {
            "key": "description",
            "label": "Description",
            "description": "The description of the ZooKeeper service",
            "type": "string",
            "default": "",
            "required": "no"
        }, {
            "key": "vxnet",
            "label": "VxNet",
            "description": "Choose a vxnet to join",
            "type": "string",
            "default": "",
            "required": "yes"
        }, {
            "key": "zk_node",
            "label": "ZooKeeper Node",
            "description": "role-based node properties",
            "type": "array",
            "properties": [{
                "key": "cpu",
                "label": "CPU",
                "description": "CPUs of each node",
                "type": "integer",
                "default": 1,
                "range": [
                    1,
                    2,
                    4,
                    8
                ],
                "required": "yes"
            }, {
                "key": "memory",
                "label": "Memory",
                "description": "memory of each node (in MiB)",
                "type": "integer",
                "default": 2048,
                "range": [
                    1024,
                    2048,
                    4096,
                    8192,
                    16384,
                    32768
                ],
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
                "key": "count",
                "label": "Node Count",
                "description": "Number of nodes for the cluster to create",
                "type": "integer",
                "default": 3,
                "range": [
                    1,
                    3,
                    5,
                    7,
                    9
                ],
                "required": "yes"
            }, {
                "key": "volume_size",
                "label": "Volume Size",
                "description": "The volume size for each node",
                "type": "integer",
                "default": 10,
                "required": "yes"
            }]
        }]
    }]
}
```

**基础版 cluster.json.mustache**
{% raw %}
```json
{
    "name": {{cluster.name}},
    "description": {{cluster.description}},
    "vxnet": {{cluster.vxnet}},
    "nodes": [{
        "container": {
            "type": "kvm",
            "zone": "pek3a",
            "image": "img-w3ezc0yt"
        },
        "count": {{cluster.zk_node.count}},
        "cpu": {{cluster.zk_node.cpu}},
        "memory": {{cluster.zk_node.memory}},
        "instance_class": {{cluster.zk_node.instance_class}},
        "volume": {
            "size": {{cluster.zk_node.volume_size}}
        },
        "server_id_upper_bound": 255,
        "services": {
            "start": {
                "cmd": "/opt/zookeeper/bin/zkServer.sh start"
            },
            "stop": {
                "cmd": "/opt/zookeeper/bin/zkServer.sh stop"
            }
        }
    }],
    "advanced_actions": ["change_vxnet", "scale_horizontal"]
}
```
{% endraw %}

**完整版 cluster.json.mustache (含监控告警、健康检查、endpoints 和 rest 服务)**
{% raw %}
```json
{
    "name": {{cluster.name}},
    "description": {{cluster.description}},
    "vxnet": {{cluster.vxnet}},
    "nodes": [{
        "container": {
            "type": "kvm",
            "zone": "pek3a",
            "image": "img-bwuaz13r"
        },
        "count": {{cluster.zk_node.count}},
        "cpu": {{cluster.zk_node.cpu}},
        "memory": {{cluster.zk_node.memory}},
        "instance_class": {{cluster.zk_node.instance_class}},
        "volume": {
            "size": {{cluster.zk_node.volume_size}}
        },
        "server_id_upper_bound": 255,
        "services": {
            "start": {
                "cmd": "/opt/zookeeper/bin/zkServer.sh start;/opt/zookeeper/bin/rest.sh start"
            },
            "stop": {
                "cmd": "/opt/zookeeper/bin/rest.sh stop;/opt/zookeeper/bin/zkServer.sh stop"
            }
        },
        "advanced_actions": ["change_vxnet", "scale_horizontal"],
        "vertical_scaling_policy": "sequential"
    }],
    "endpoints": {
        "client": {
            "port": 2181,
            "protocol": "tcp"
        },
        "rest": {
            "port": 9998,
            "protocol": "tcp"
        }
    },
    "health_check": {
        "enable": true,
        "interval_sec": 60,
        "timeout_sec": 10,
        "action_timeout_sec": 30,
        "healthy_threshold": 2,
        "unhealthy_threshold": 2,
        "check_cmd": "echo srvr | nc 127.0.0.1 2181",
        "action_cmd": "/opt/zookeeper/bin/restart-server.sh"
    },
    "monitor": {
        "enable": true,
        "cmd": "/opt/zookeeper/bin/get-monitor.sh",
        "items": {
            "mode": {
                "unit": "",
                "value_type": "str",
                "statistics_type": "latest",
                "enums": ["L", "F", "S"]
            },
            "min": {
                "unit": "ms",
                "value_type": "int",
                "statistics_type": "min",
                "scale_factor_when_display": 1
            },
            "avg": {
                "unit": "ms",
                "value_type": "int",
                "statistics_type": "avg",
                "scale_factor_when_display": 1
            },
            "max": {
                "unit": "ms",
                "value_type": "int",
                "statistics_type": "max",
                "scale_factor_when_display": 1
            },
            "received": {
                "unit": "count",
                "value_type": "int",
                "statistics_type": "latest",
                "scale_factor_when_display": 1
            },
            "sent": {
                "unit": "count",
                "value_type": "int",
                "statistics_type": "latest",
                "scale_factor_when_display": 1
            },
            "active": {
                "unit": "count",
                "value_type": "int",
                "statistics_type": "latest",
                "scale_factor_when_display": 1
            },
            "outstanding": {
                "unit": "count",
                "value_type": "int",
                "statistics_type": "latest",
                "scale_factor_when_display": 1
            },
            "znode": {
                "unit": "znode_count",
                "value_type": "int",
                "statistics_type": "latest",
                "scale_factor_when_display": 1
            }
        },
        "groups": {
            "latency":  ["min", "avg", "max"],
            "throughput": ["received", "sent"],
            "connections": ["active", "outstanding"]
        },
        "display": ["mode", "latency", "throughput", "connections", "znode"],
        "alarm": ["avg"]
    }
}
```
{% endraw %}