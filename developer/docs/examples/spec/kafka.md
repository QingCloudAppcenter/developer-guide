### Kafka

**类型:** 单角色节点、带应用参数设置

该示例根据[应用模版规范](../../specifications/specifications.md)开发 Kafka 应用的配置包

**config.json**
```json
{
    "type": "array",
    "properties": [{
        "key": "cluster",
        "description": "Kafka cluster properties",
        "type": "array",
        "properties": [{
            "key": "name",
            "label": "Name",
            "description": "The name of the Kafka service",
            "type": "string",
            "default": "Kafka",
            "required": "no"
        }, {
            "key": "description",
            "label": "Description",
            "description": "The description of the Kafka service",
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
            "key": "zk_service",
            "label": "ZooKeeper",
            "description": "Choose a ZooKeeper to use",
            "type": "service",
            "tag": ["ZK", "ZooKeeper"],
            "default": "",
            "required": "yes"
        }, {
            "key": "nodes",
            "description": "Kafka nodes",
            "type": "array",
            "properties": [{
                "key": "cpu",
                "label": "CPU",
                "description": "CPUs of each node",
                "type": "integer",
                "default": 1,
                "range": [1, 2, 4, 8, 12, 16],
                "required": "yes"
            }, {
                "key": "memory",
                "label": "Memory",
                "description": "Memory of each node (in MiB)",
                "type": "integer",
                "default": 2048,
                "range": [1024, 2048, 4096, 8192, 16384, 32768],
                "required": "yes"
            }, {
                "key": "count",
                "label": "Count",
                "description": "Number of nodes for the cluster to create",
                "type": "integer",
                "default": 3,
                "range": [1, 3, 5, 7, 9],
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
                "key": "volume_size",
                "label": "Volume Size",
                "description": "The volume size for each instance",
                "type": "integer",
                "default": 10,
                "required": "yes"
            }]
        }]
    }, {
        "key": "env",
        "description": "Kafka service properties",
        "type": "array",
        "properties": [{
            "key": "log_retention_bytes",
            "label": "log.retention.bytes",
            "description": "The maximum size of the log before deleting it",
            "type": "integer",
            "default": 9663676416,
            "required": "yes"
        }, {
            "key": "log_retention_hours",
            "label": "log.retention.hours",
            "description": "The number of hours to keep a log file before deleting it (in hours)",
            "type": "integer",
            "default": 168,
            "required": "yes"
        }, {
            "key": "auto_create_topics_enable",
            "label": "auto.create.topics.enable",
            "description": "Enable auto creation of topic on the server",
            "type": "boolean",
            "default": true,
            "required": "yes"
        }, {
            "key": "default_replication_factor",
            "label": "default.replication.factor",
            "description": "default replication factors for automatically created topics",
            "type": "integer",
            "default": 1,
            "required": "yes"
        }, {
            "key": "delete_topic_enable",
            "label": "delete.topic.enable",
            "description": "default replication factors for automatically created topics",
            "type": "boolean",
            "default": true,
            "required": "yes"
        }, {
            "key": "message_max_bytes",
            "label": "message.max.bytes",
            "description": "This is largest message size Kafka will allow to be appended to this topic.",
            "type": "integer",
            "default": 1000000,
            "required": "yes"
        }, {
            "key": "num_io_threads",
            "label": "num.io.threads",
            "description": "The number of io threads that the server uses for carrying out network requests.",
            "type": "integer",
            "default": 8,
            "required": "yes"
        }, {
            "key": "num_partitions",
            "label": "num.partitions",
            "description": "The default number of log partitions per topic.",
            "type": "integer",
            "default": 1,
            "required": "yes"
        }, {
            "key": "num_replica_fetchers",
            "label": "num.replica.fetchers",
            "description": "Number of fetcher threads used to replicate messages from a source broker.",
            "type": "integer",
            "default": 1,
            "required": "yes"
        }, {
            "key": "queued_max_requests",
            "label": "queued.max.requests",
            "description": "The number of queued requests allowed before blocking the network threads.",
            "type": "integer",
            "default": 500,
            "required": "yes"
        }, {
            "key": "socket_receive_buffer_bytes",
            "label": "socket.receive.buffer.bytes",
            "description": "The SO_RCVBUF buffer of the socket sever sockets.",
            "type": "integer",
            "default": 102400,
            "required": "yes"
        }, {
            "key": "socket_send_buffer_bytes",
            "label": "socket.send.buffer.bytes",
            "description": "The SO_RCVBUF buffer of the socket sever sockets.",
            "type": "integer",
            "default": 102400,
            "required": "yes"
        }, {
            "key": "advertised_host_name",
            "label": "advertised.host.name",
            "description": "This is the hostname that will be given out to other workers to connect to.",
            "type": "string",
            "default": "",
            "required": "no"
        }, {
            "key": "advertised_port",
            "label": "advertised.port",
            "description": "This is the port that will be given out to other workers to connect to.",
            "type": "integer",
            "default": 9092,
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
    "links": {
        "zk_service": {{cluster.zk_service}}
    },
    "nodes": [{
        "container": {
            "zone": "sh1a",
            "type": "kvm",
            "image": "img-kafka821"
        },
        "instance_class": {{cluster.nodes.instance_class}},
        "count": {{cluster.nodes.count}},
        "cpu": {{cluster.nodes.cpu}},
        "memory": {{cluster.nodes.memory}},
        "volume": {
            "size": {{cluster.nodes.volume_size}},
            "mount_point": "/data",
            "filesystem": "xfs"
        },
        "services": {
            "start": {
                "cmd": "/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties"
            },
            "stop": {
                "cmd": "/opt/kafka/bin/kafka-server-stop.sh"
            }
        }
    }],
    "env": {
        "log.retention.bytes": {{env.log_retention_bytes}},
        "log.retention.hours": {{env.log_retention_hours}},
        "auto.create.topics.enable": {{env.auto_create_topics_enable}},
        "default.replication.factor": {{env.default_replication_factor}},
        "delete.topic.enable": {{env.delete_topic_enable}},
        "message.max.bytes": {{env.message_max_bytes}},
        "num.io.threads": {{env.num_io_threads}},
        "num.partitions": {{env.num_partitions}},
        "num.replica.fetchers": {{env.num_replica_fetchers}},
        "queued.max.requests": {{env.queued_max_requests}},
        "socket.receive.buffer.bytes": {{env.socket_receive_buffer_bytes}},
        "socket.send.buffer.bytes": {{env.socket_send_buffer_bytes}},
        "advertised.host.name": {{env.advertised_host_name}},
        "advertised.port": {{env.advertised_port}}
    },
    "advanced_actions": ["change_vxnet", "scale_horizontal"],
    "endpoints": {
        "client": {
            "port": "env.advertised.port",
            "protocol": "tcp"
        }
    }
}
```
{% endraw %}