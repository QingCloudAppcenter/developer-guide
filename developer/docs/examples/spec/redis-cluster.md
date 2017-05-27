### Redis-Cluster

**类型:** 有副本角色节点、带应用参数设置、初始化集群

该示例根据[应用模版规范](../../specifications/specifications.md)开发 Redis Cluster 应用的配置包

**config.json**
```json
{
    "type": "array",
    "properties": [{
        "key": "cluster",
        "description": "Redis cluster properties",
        "type": "array",
        "properties": [{
            "key": "name",
            "label": "Name",
            "description": "The name of the redis cluster service",
            "type": "string",
            "default": "Redis Cluster",
            "required": "no"
        }, {
            "key": "description",
            "label": "Description",
            "description": "The description of the redis cluster service",
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
            "key": "nodes",
            "description": "Redis nodes",
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
                "range": [1024, 2048, 8192, 16384, 32768, 49152],
                "required": "yes"
            }, {
                "key": "count",
                "label": "Count",
                "description": "Number of master nodes (shards) for the cluster to create",
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
                "key": "replica",
                "label": "Replica",
                "description": "The replica number for each master",
                "type": "integer",
                "default": 1,
                "required": "yes"
            }]
        }]
    }, {
        "key": "env",
        "description": "Spark service properties",
        "type": "array",
        "properties": [{
            "key": "activerehashing",
            "label": "activerehashing",
            "description": "Active rehashing uses 1 millisecond every 100 milliseconds of CPU time in order to help rehashing the main Redis hash table",
            "type": "boolean",
            "default": true,
            "required": "yes"
        }, {
            "key": "appendonly",
            "label": "appendonly",
            "description": "The Append Only File is an alternative persistence mode that provides much better durability.",
            "type": "boolean",
            "default": true,
            "required": "yes"
        }, {
            "key": "appendfsync",
            "label": "appendfsync",
            "description": "It tells the Operating System to actually write data on disk instead of waiting for more data in the output buffer.",
            "type": "string",
            "default": "everysec",
            "range": ["everysec", "no", "always"],
            "required": "yes"
        }, {
            "key": "hash-max-ziplist-entries",
            "label": "hash-max-ziplist-entries",
            "description": "Hashes are encoded using a memory efficient data structure when they have a small number of entries",
            "type": "integer",
            "default": 512,
            "required": "yes"
        }, {
            "key": "hash-max-ziplist-value",
            "label": "hash-max-ziplist-value",
            "description": "Hashes are encoded using a memory efficient data structure when they have a small number of entries",
            "type": "integer",
            "default": 64,
            "required": "yes"
        }, {
            "key": "latency-monitor-threshold",
            "label": "latency-monitor-threshold",
            "description": "It samples different operations at runtime in order to collect data related to possible sources of latency of a Redis instance.",
            "type": "integer",
            "default": 0,
            "required": "yes"
        }, {
            "key": "list-max-ziplist-entries",
            "label": "list-max-ziplist-entries",
            "description": "Small lists are encoded in a special way in order to save a lot of space.",
            "type": "integer",
            "default": 512,
            "required": "yes"
        }, {
            "key": "list-max-ziplist-value",
            "label": "list-max-ziplist-value",
            "description": "Small lists are encoded in a special way in order to save a lot of space.",
            "type": "integer",
            "default": 64,
            "required": "yes"
        }, {
            "key": "maxclients",
            "label": "maxclients",
            "description": "Set the max number of connected clients at the same time.",
            "type": "integer",
            "default": 65000,
            "required": "yes"
        }, {
            "key": "maxmemory-policy",
            "label": "maxmemory-policy",
            "description": "The eviction policy to remove keys when the memory limit is reached.",
            "type": "string",
            "default": "volatile-lru",
            "range": ["volatile-lru", "allkeys-lru", "volatile-random", "allkeys-random", "volatile-ttl", "noeviction"],
            "required": "yes"
        }, {
            "key": "maxmemory-samples",
            "label": "maxmemory-samples",
            "description": "LRU and minimal TTL algorithms are not precise algorithms but approximated algorithms (in order to save memory), using this to tune it for speed or accuracy.",
            "type": "integer",
            "default": 3,
            "required": "yes"
        }, {
            "key": "min-slaves-max-lag",
            "label": "min-slaves-max-lag",
            "description": "A master stops accepting writes if there are less than N slaves connected, having a lag less or equal than M seconds.",
            "type": "integer",
            "default": 10,
            "required": "yes"
        }, {
            "key": "min-slaves-to-write",
            "label": "min-slaves-to-write",
            "description": "A master stops accepting writes if there are less than N slaves connected, having a lag less or equal than M seconds.",
            "type": "integer",
            "default": 0,
            "required": "yes"
        }, {
            "key": "no-appendfsync-on-rewrite",
            "label": "no-appendfsync-on-rewrite",
            "description": "It prevents fsync() from being called in the main process while a BGSAVE or BGREWRITEAOF is in progress.",
            "type": "boolean",
            "default": true,
            "required": "yes"
        }, {
            "key": "notify-keyspace-events",
            "label": "notify-keyspace-events",
            "description": "It selects the events that Redis will notify among a set of classes.",
            "type": "string",
            "default": "",
            "required": "no"
        }, {
            "key": "repl-backlog-size",
            "label": "repl-backlog-size",
            "description": "Set the replication backlog size.",
            "type": "integer",
            "default": 1048576,
            "required": "yes"
        }, {
            "key": "repl-backlog-ttl",
            "label": "repl-backlog-ttl",
            "description": "It configures the amount of seconds that need to elapse, starting from the time the last slave disconnected, for the backlog buffer to be freed.",
            "type": "integer",
            "default": 3600,
            "required": "yes"
        }, {
            "key": "repl-timeout",
            "label": "repl-timeout",
            "description": "It is the replication timeout.",
            "type": "integer",
            "default": 60,
            "required": "yes"
        }, {
            "key": "set-max-intset-entries",
            "label": "set-max-intset-entries",
            "description": "It sets the limit in the size of the set in order to use this special memory saving encoding.",
            "type": "integer",
            "default": 512,
            "required": "yes"
        }, {
            "key": "slowlog-log-slower-than",
            "label": "slowlog-log-slower-than",
            "description": "It logs queries that exceeded a specified execution time.",
            "type": "integer",
            "default": -1,
            "required": "yes"
        }, {
            "key": "slowlog-max-len",
            "label": "slowlog-max-len",
            "description": "It logs queries with the length of the slow log.",
            "type": "integer",
            "default": 128,
            "required": "yes"
        }, {
            "key": "tcp-keepalive",
            "label": "tcp-keepalive",
            "description": "TCP keepalive between server and client.",
            "type": "integer",
            "default": 0,
            "required": "yes"
        }, {
            "key": "timeout",
            "label": "timeout",
            "description": "Close the connection after a client is idle for N seconds (0 to disable).",
            "type": "integer",
            "default": 0,
            "required": "yes"
        }, {
            "key": "zset-max-ziplist-entries",
            "label": "zset-max-ziplist-entries",
            "description": "Sorted sets are specially encoded in order to save a lot of space.",
            "type": "integer",
            "default": 128,
            "required": "yes"
        }, {
            "key": "zset-max-ziplist-value",
            "label": "zset-max-ziplist-value",
            "description": "Sorted sets are specially encoded in order to save a lot of space.",
            "type": "integer",
            "default": 64,
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
        "role": "nodes",
        "container": {
            "type": "kvm",
            "zone": "sh1a",
            "image": "img-redis3-c"
        },
        "instance_class": {{cluster.nodes.instance_class}},
        "count": {{cluster.nodes.count}},
        "cpu": {{cluster.nodes.cpu}},
        "memory": {{cluster.nodes.memory}},
        "volume": {
            "size": {{cluster.nodes.memory}} * 2 / 1024 * 10,
            "mount_point": "/data",
            "filesystem": "xfs"
        },
        "replica": {{cluster.nodes.replica}},
        "services": {
            "init": {
                "nodes_to_execute_on": 1,
                "post_start_service": true,
                "cmd": "/opt/redis/bin/init_cluster.sh"
            },
            "start": {
                "cmd": "mkdir -p /data/redis/logs; ulimit -n 65536; /opt/redis/bin/redis-server /opt/redis/redis.conf"
            },
            "stop": {
                "cmd": "/opt/redis/bin/stop-redis-server.sh"
            },
            "scale_in": {
                "nodes_to_execute_on": 1,
                "cmd": "/opt/redis/bin/scaling-in.sh"
            },
            "scale_out": {
                "nodes_to_execute_on": 1,
                "cmd": "/opt/redis/bin/scaling-out.sh"
            }
        }
    }],
    "env": {
        "activerehashing": {{env.activerehashing}},
        "appendonly": {{env.appendonly}},
        "appendfsync": {{env.appendfsync}},
        "hash-max-ziplist-entries": {{env.hash-max-ziplist-entries}},
        "hash-max-ziplist-value": {{env.hash-max-ziplist-value}},
        "latency-monitor-threshold": {{env.latency-monitor-threshold}},
        "list-max-ziplist-entries": {{env.list-max-ziplist-entries}},
        "list-max-ziplist-value": {{env.list-max-ziplist-value}},
        "maxclients": {{env.maxclients}},
        "maxmemory-policy": {{env.maxmemory-policy}},
        "maxmemory-samples": {{env.maxmemory-samples}},
        "min-slaves-max-lag": {{env.min-slaves-max-lag}},
        "min-slaves-to-write": {{env.min-slaves-to-write}},
        "no-appendfsync-on-rewrite": {{env.no-appendfsync-on-rewrite}},
        "notify-keyspace-events": {{env.notify-keyspace-events}},
        "repl-backlog-size": {{env.repl-backlog-size}},
        "repl-backlog-ttl": {{env.repl-backlog-ttl}},
        "repl-timeout": {{env.repl-timeout}},
        "set-max-intset-entries": {{env.set-max-intset-entries}},
        "slowlog-log-slower-than": {{env.slowlog-log-slower-than}},
        "slowlog-max-len": {{env.slowlog-max-len}},
        "tcp-keepalive": {{env.tcp-keepalive}},
        "timeout": {{env.timeout}},
        "zset-max-ziplist-entries": {{env.zset-max-ziplist-entries}},
        "zset-max-ziplist-value": {{env.zset-max-ziplist-value}}
    },
    "advanced_actions": ["scale_horizontal"],
    "endpoints": {
        "client": {
            "port": 6379,
            "protocol": "tcp"
        }
    }
}
```
{% endraw %}