### Spark-HDFS

**类型:** 多角色节点、带应用参数设置、挂多数据盘、指定数据盘类型

该示例根据[应用模版规范](../../specifications/specifications.md)开发 Spark with HDFS 应用的配置包

**config.json**
```json
{
    "type": "array",
    "properties": [{
        "key": "cluster",
        "description": "Spark cluster properties",
        "type": "array",
        "properties": [{
            "key": "name",
            "label": "Name",
            "description": "The name of the Spark service",
            "type": "string",
            "default": "Spark",
            "required": "no"
        }, {
            "key": "description",
            "label": "Description",
            "description": "The description of the Spark service",
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
            "key": "spark-master",
            "description": "Spark master properties",
            "type": "array",
            "properties": [{
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
                "label": "Spark Master Count",
                "description": "Number of nodes for the cluster to create",
                "type": "integer",
                "default": 1,
                "range": [1],
                "required": "yes"
            }, {
                "key": "instance_class",
                "label": "Instance Class",
                "description": "The instance type for the cluster to run, such as high performance, high performance plus",
                "type": "integer",
                "default": 0,
                "range": [0, 1],
                "required": "yes"
            }, {
                "key": "volume_class",
                "label": "Volume Class",
                "description": "The volume type for each instance, such as high performance, high performance plus, high capacity",
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
                "required": "yes"
            }]
        }, {
            "key": "hadoop-master",
            "description": "Hadoop master properties",
            "type": "array",
            "properties": [{
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
                "label": "Hadoop Namenode Count",
                "description": "Number of nodes for the cluster to create",
                "type": "integer",
                "default": 1,
                "range": [1],
                "required": "yes"
            }, {
                "key": "instance_class",
                "label": "Instance Class",
                "description": "The instance type for the cluster to run, such as high performance, high performance plus",
                "type": "integer",
                "default": 0,
                "range": [0, 1],
                "required": "yes"
            }, {
                "key": "volume_class",
                "label": "Volume Class",
                "description": "The volume type for each instance, such as high performance, high performance plus, high capacity",
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
                "required": "yes"
            }]
        }, {
            "key": "worker",
            "description": "Spark worker properties",
            "type": "array",
            "properties": [{
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
                "label": "Worker Count",
                "description": "Number of nodes for the cluster to create",
                "type": "integer",
                "default": 3,
                "required": "yes"
            }, {
                "key": "instance_class",
                "label": "Instance Class",
                "description": "The instance type for the cluster to run, such as high performance, high performance plus",
                "type": "integer",
                "default": 0,
                "range": [0, 1],
                "required": "yes"
            }, {
                "key": "volume_class",
                "label": "Volume Class",
                "description": "The volume type for each instance, such as high performance, high performance plus, high capacity",
                "type": "integer",
                "default": 0,
                "range": [0, 2, 3],
                "required": "yes"
            }, {
                "key": "volume_size",
                "label": "Volume Size",
                "description": "The volume size for each instance",
                "type": "integer",
                "step": 30,
                "default": 30,
                "required": "yes"
            }]
        }]
    }, {
        "key": "env",
        "description": "Spark service properties",
        "type": "array",
        "properties": [{
            "key": "dfs_datanode_handler_count",
            "label": "dfs.datanode.handler.count",
            "description": "The number of server threads for the data node",
            "type": "integer",
            "default": 10,
            "required": "yes"
        }, {
            "key": "dfs_namenode_handler_count",
            "label": "dfs.namenode.handler.count",
            "description": "The number of server threads for the name node",
            "type": "integer",
            "default": 10,
            "required": "yes"
        }, {
            "key": "dfs_replication",
            "label": "dfs.replication",
            "description": "The replication factor in HDFS ",
            "type": "integer",
            "default": 3,
            "required": "yes"
        }, {
            "key": "fs_trash_interval",
            "label": "fs.trash.interval",
            "description": "It controls the number of minutes after which a trash checkpoint directory is deleted and the number of minutes between trash checkpoints.",
            "type": "integer",
            "default": 1440,
            "required": "yes"
        }]
    }]
}
```

**cluster.json.mustache**
{% raw %}
```json
{
    "name": {{cluster.name}},
    "description": {{cluster.description}},
    "vxnet": {{cluster.vxnet}},
    "nodes": [{
        "role": "spark-master",
        "container": {
            "type": "kvm",
            "zone": "sh1a",
            "image": "img-skhdp16m"
        },
        "instance_class": {{cluster.spark-master.instance_class}},
        "count": {{cluster.spark-master.count}},
        "cpu": {{cluster.spark-master.cpu}},
        "memory": {{cluster.spark-master.memory}},
        "volume": {
            "size": {{cluster.spark-master.volume_size}},
            "mount_point": "/bigdata1",
            "filesystem": "ext4",
            "class": {{cluster.spark-master.volume_class}}
        },
        "passphraseless": "ssh-dsa",
        "services": {
            "start": {
                "cmd": "USER=root /opt/spark/sbin/start-all.sh"
            },
            "stop": {
                "cmd": "USER=root /opt/spark/sbin/stop-all.sh"
            }
        }
    }, {
        "role": "hadoop-master",
        "container": {
            "type": "kvm",
            "zone": "sh1a",
            "image": "img-hdp260-m"
        },
        "instance_class": {{cluster.hadoop-master.instance_class}},
        "count": {{cluster.hadoop-master.count}},
        "cpu": {{cluster.hadoop-master.cpu}},
        "memory": {{cluster.hadoop-master.memory}},
        "volume": {
            "size": {{cluster.hadoop-master.volume_size}},
            "mount_point": "/bigdata1",
            "filesystem": "xfs",
            "class": {{cluster.hadoop-master.volume_class}}
        },
        "passphraseless": "ssh-dsa",
        "service": {
            "init": {
                "cmd": "mkdir -p /bigdata1/hadoop;/opt/hadoop/bin/hdfs namenode -format"
            },
            "start": {
                "cmd": "USER=root /opt/hadoop/sbin/start-dfs.sh"
            },
            "stop": {
                "cmd": "USER=root /opt/hadoop/sbin/stop-dfs.sh"
            },
            "scale_in": {
                "cmd": "USER=root /opt/hadoop/sbin/exclude-node.sh"
            }
        }
    }, {
        "role": "worker",
        "container": {
            "type": "kvm",
            "zone": "sh1a",
            "image": "img-skhdp16w"
        },
        "instance_class": {{cluster.worker.instance_class}},
        "count": {{cluster.worker.count}},
        "cpu": {{cluster.worker.cpu}},
        "memory": {{cluster.worker.memory}},
        "volume": {
            "size": {{cluster.worker.volume_size}},
            "mount_point": ["/bigdata1", "/bigdata2", "/bigdata3"],
            "filesystem": "ext4",
            "class": {{cluster.worker.volume_class}}
        }
    }],
    "env": {
        "dfs.datanode.handler.count": {{env.dfs_datanode_handler_count}},
        "dfs.namenode.handler.count": {{env.dfs_namenode_handler_count}},
        "dfs.replication": {{env.dfs_replication}},
        "fs.trash.interval": {{env.fs_trash_interval}}
    },
    "advanced_actions": ["change_vxnet", "scale_horizontal"],
    "endpoints": {
        "hdfs_client": {
            "port": 9000,
            "protocol": "tcp"
        },
        "hdfs_monitor": {
            "port": 50070,
            "protocol": "http"
        },
        "spark_client": {
            "port": 7077,
            "protocol": "tcp"
        },
        "spark_monitor": {
            "port": 8080,
            "protocol": "http"
        },
        "spark_driver": {
            "port": 4040,
            "protocol": "http"
        }
    }
}
```
{% endraw %}