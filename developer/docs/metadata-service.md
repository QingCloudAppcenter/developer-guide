# Metadata 服务

青云 AppCenter 的 metadata service 是在 etcd 基础之上进行了二次开发，主要增加了 self 属性，即每个节点只能从该服务获取到自身相关的信息，如本机 IP、server ID 等，
此项目已在 [github](https://github.com/yunify/metad) 上开源。

### 元数据结构
每个应用集群在 metadata server 中存储元信息如下结构： <br>
<ul>
  <li style="list-style-type:none;">/<b>self</b></li>
    <ul>
      <li style="list-style-type:none;">/<b>hosts</b>/<i>[role name]</i>/[instance_id]*</li>
        <ul>
          <li style="list-style-type:none;">/<b>ip</b> [IP address]</li>
          <li style="list-style-type:none;">/<b>mac</b> [MAC address]</li>
          <li style="list-style-type:none;">/<b>sid</b> [server ID]</li>
          <li style="list-style-type:none;">/<b>gid</b> [group ID]</li>
          <li style="list-style-type:none;">/<b>gsid</b> [global server ID]</li>
          <li style="list-style-type:none;">/<b>node_id</b> [node ID]</li>
          <li style="list-style-type:none;">/<b>instance_id</b> [instance ID]</li>
          <li style="list-style-type:none;">/<b>cpu</b> [cpu]</li>
          <li style="list-style-type:none;">/<b>gpu</b> [gpu]</li>
          <li style="list-style-type:none;">/<b>memory</b> [memory in MiB]</li>
          <li style="list-style-type:none;">/<b>volume_size</b> [volume size in GiB]</li>
          <li style="list-style-type:none;">/<b>instance_class</b> [instance class]</li>
          <li style="list-style-type:none;">/<b>gpu_class</b> [gpu class]</li>
          <li style="list-style-type:none;">/<b>volume_class</b> [volume class]</li>
          <li style="list-style-type:none;">/<b>physical_machine</b> [ID of the physical machine that hosts the instance]</li>
          <li style="list-style-type:none;">/<b><i>role</i></b> [role name]</li>
          <li style="list-style-type:none;">/<b><i>pub_key</i></b> [pub key string]</li>
          <li style="list-style-type:none;">/<b><i>token</i></b> [token string]</li>
          <li style="list-style-type:none;">/<b><i>reserved_ips</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b>[reserved IP name such as vip]*</b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>value</b> [reserved ip address]</li>
                </ul>
            </ul>
        </ul>
      <li style="list-style-type:none;">/<b>host</b></li>
        <ul>
          <li style="list-style-type:none;">/<b>ip</b> [IP address]</li>
          <li style="list-style-type:none;">/<b>mac</b> [MAC address]</li>
          <li style="list-style-type:none;">/<b>sid</b> [server ID]</li>
          <li style="list-style-type:none;">/<b>gid</b> [group ID]</li>
          <li style="list-style-type:none;">/<b>gsid</b> [global server ID]</li>
          <li style="list-style-type:none;">/<b>node_id</b> [node ID]</li>
          <li style="list-style-type:none;">/<b>instance_id</b> [instance ID]</li>
          <li style="list-style-type:none;">/<b>cpu</b> [cpu]</li>
          <li style="list-style-type:none;">/<b>gpu</b> [gpu]</li>
          <li style="list-style-type:none;">/<b>memory</b> [memory in MiB]</li>
          <li style="list-style-type:none;">/<b>volume_size</b> [volume size in GiB]</li>
          <li style="list-style-type:none;">/<b>instance_class</b> [instance class]</li>
          <li style="list-style-type:none;">/<b>gpu_class</b> [gpu class]</li>
          <li style="list-style-type:none;">/<b>volume_class</b> [volume class]</li>
          <li style="list-style-type:none;">/<b>physical_machine</b> [ID of the physical machine that hosts the instance]</li>
          <li style="list-style-type:none;">/<b><i>role</i></b> [role name]</li>
          <li style="list-style-type:none;">/<b><i>pub_key</i></b> [pub key string]</li>
          <li style="list-style-type:none;">/<b><i>token</i></b> [token string]</li>
          <li style="list-style-type:none;">/<b><i>reserved_ips</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b>[reserved IP name such as vip]*</b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>value</b> [reserved ip address]</li>
                </ul>
            </ul>
        </ul>
      <li style="list-style-type:none;">/<b>cluster</b></li>
        <ul>
          <li style="list-style-type:none;">/<b>app_id</b> [application ID]</li>
          <li style="list-style-type:none;">/<b>cluster_id</b> [cluster ID]</li>
          <li style="list-style-type:none;">/<b>user_id</b> [application ID]</li>
          <li style="list-style-type:none;">/<b>global_uuid</b> [global UUID]</li>
          <li style="list-style-type:none;">/<b>vxnet</b> [VxNet ID]</li>
          <li style="list-style-type:none;">/<b>zone</b> [Zone ID]</li>
          <li style="list-style-type:none;">/<b><i>endpoints</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b>[service name]*</b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>port</b> [port or a reference to env parameter]</li>
                  <li style="list-style-type:none;">/<b>protocol</b> [protocol]</li>
                </ul>
              <li style="list-style-type:none;">/<b><i>reserved_ips</i></b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>[reserved IP name such as vip]*</b></li>
                    <ul>
                      <li style="list-style-type:none;">/<b>value</b> [reserved ip address]</li>
                    </ul>
                </ul>
            </ul>
          <li style="list-style-type:none;">/<b><i>api_server</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b><i>host</i></b> [host of api server]</li>
              <li style="list-style-type:none;">/<b><i>port</i></b> [port of api server]</li>
              <li style="list-style-type:none;">/<b><i>protocol</i></b> [protocol of api server]</li>
            </ul>
        </ul>
      <li style="list-style-type:none;">/<b>env</b>/[parameter key]* [parameter value]</li>
      <li style="list-style-type:none;">/<b>adding-hosts</b>/<i>[role name]</i>/[instance_id]*</li>
        <ul>
          <li style="list-style-type:none;">/<b>ip</b> [IP address]</li>
          <li style="list-style-type:none;">/<b>mac</b> [MAC address]</li>
          <li style="list-style-type:none;">/<b>sid</b> [server ID]</li>
          <li style="list-style-type:none;">/<b>gid</b> [group ID]</li>
          <li style="list-style-type:none;">/<b>gsid</b> [global server ID]</li>
          <li style="list-style-type:none;">/<b>node_id</b> [node ID]</li>
          <li style="list-style-type:none;">/<b>instance_id</b> [instance ID]</li>
          <li style="list-style-type:none;">/<b>cpu</b> [cpu]</li>
          <li style="list-style-type:none;">/<b>gpu</b> [gpu]</li>
          <li style="list-style-type:none;">/<b>memory</b> [memory in MiB]</li>
          <li style="list-style-type:none;">/<b>volume_size</b> [volume size in GiB]</li>
          <li style="list-style-type:none;">/<b>instance_class</b> [instance class]</li>
          <li style="list-style-type:none;">/<b>gpu_class</b> [gpu class]</li>
          <li style="list-style-type:none;">/<b>volume_class</b> [volume class]</li>
          <li style="list-style-type:none;">/<b>physical_machine</b> [ID of the physical machine that hosts the instance]</li>
          <li style="list-style-type:none;">/<b><i>role</i></b> [role name]</li>
          <li style="list-style-type:none;">/<b><i>pub_key</i></b> [pub key string]</li>
          <li style="list-style-type:none;">/<b><i>token</i></b> [token string]</li>
          <li style="list-style-type:none;">/<b><i>reserved_ips</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b>[reserved IP name such as vip]*</b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>value</b> [reserved ip address]</li>
                </ul>
            </ul>
        </ul>
      <li style="list-style-type:none;">/<b>deleting-hosts</b>/<i>[role name]</i>/[instance_id]*</li>
        <ul>
          <li style="list-style-type:none;">/<b>ip</b> [IP address]</li>
          <li style="list-style-type:none;">/<b>mac</b> [MAC address]</li>
          <li style="list-style-type:none;">/<b>sid</b> [server ID]</li>
          <li style="list-style-type:none;">/<b>gid</b> [group ID]</li>
          <li style="list-style-type:none;">/<b>gsid</b> [global server ID]</li>
          <li style="list-style-type:none;">/<b>node_id</b> [node ID]</li>
          <li style="list-style-type:none;">/<b>instance_id</b> [instance ID]</li>
          <li style="list-style-type:none;">/<b>cpu</b> [cpu]</li>
          <li style="list-style-type:none;">/<b>gpu</b> [gpu]</li>
          <li style="list-style-type:none;">/<b>memory</b> [memory in MiB]</li>
          <li style="list-style-type:none;">/<b>volume_size</b> [volume size in GiB]</li>
          <li style="list-style-type:none;">/<b>instance_class</b> [instance class]</li>
          <li style="list-style-type:none;">/<b>gpu_class</b> [gpu class]</li>
          <li style="list-style-type:none;">/<b>volume_class</b> [volume class]</li>
          <li style="list-style-type:none;">/<b>physical_machine</b> [ID of the physical machine that hosts the instance]</li>
          <li style="list-style-type:none;">/<b><i>role</i></b> [role name]</li>
          <li style="list-style-type:none;">/<b><i>pub_key</i></b> [pub key string]</li>
          <li style="list-style-type:none;">/<b><i>token</i></b> [token string]</li>
          <li style="list-style-type:none;">/<b><i>reserved_ips</i></b></li>
            <ul>
              <li style="list-style-type:none;">/<b>[reserved IP name such as vip]*</b></li>
                <ul>
                  <li style="list-style-type:none;">/<b>value</b> [reserved ip address]</li>
                </ul>
            </ul>
        </ul>
      <li style="list-style-type:none;">/<b>links</b>/[service name]* [cluster_id]</li>
      <li style="list-style-type:none;">/<b>cmd</b></li>
        <ul>
          <li style="list-style-type:none;">/<b>id</b> [cmd ID]</li>
          <li style="list-style-type:none;">/<b>cmd</b> [cmd string]</li>
          <li style="list-style-type:none;">/<b>timeout</b> [timeout(second)]</li>
        </ul>
    </ul>
  <li style="list-style-type:none;">/<b>[cluster ID]*</b></li>  
  与 self 平级目录，每个 cluster ID 目录下内容结构与 self 相同，self 通过软链接指向自己的 cluster ID　
</ul>

<table><tr style="background-color:rgb(240,240,240)"><td><b>注：</b><b>黑体字</b>为固定 key，括号内为变量，<i>斜体字</i>为可选项，<b><i>黑色斜体字</i></b>表示此项为可选项，但如果有此项则为固定 key，右上角带*表示该项有 sibling (兄弟)节点。</td></tr></table>

元数据结构中根节点 self 表示发送请求的那个节点，metadata server 接到请求后返回该节点的相关信息，具体信息如下：

* hosts

  hosts 分角色保存节点信息，如果没有角色，就直接保存在 hosts 之下。角色名称的定义来自 [应用开发模版规范-完整版](specifications/specifications.md) 里的定义。节点信息是一组以主机 ID (通常情况也是主机名，即以 i- 开头的字符串)为子目录组成，每个子目录下是此主机以 key-value 形式保存的详细信息。
  + ip <br>
    节点私有 IP 地址
  + mac <br>
    节点 mac 地址
  + sid <br>
    节点 server ID，青云调度系统自动为每个节点分配的从1开始的整数。
  + gid <br>
    节点 group ID，青云调度系统自动为每个组分配的从1开始的整数，每一个节点和它的 replica 组成一个 group，即它们的 gid 相同，这个是为分片式分布式系统(多主多从，每个主和它的从为同一个组)提供的特性。
  + gsid <br>
    节点 global server ID，青云调度系统自动为每个节点分配的全球唯一的9位随机整数 ID。
  + node_id <br>
    节点 node ID，青云调度系统自动为每个节点分配的节点 ID，是一个以 cln- 开头的唯一标识，此 ID 不会变更。
  + instance_id <br>
    节点主机 ID，青云调度系统自动为每个节点分配的主机 ID，是一个以i-开头的唯一标识，此 ID 是主机的 hostname，每次启动都会变更，如关闭集群然后启动集群，该节点 instance ID 可能会变更。
  + cpu <br>
    节点 CPU 核数
  + memory <br>
    节点内存大小， 单位 MiB。
  + volume_size <br>
    节点数据盘大小， 单位 GiB。
  + gpu <br>
    节点 GPU 显卡数
  + instance_class <br>
    节点类型，其中 0 表示性能主机，1 表示超高性能主机。
  + gpu_class <br>
    节点 gpu 显卡类型，其中 0 表示性能型 gpu。
  + volume_class <br>
    数据盘类型，其中 0 表示性能盘，3 表示超高性能盘，2 表示容量盘。
  + physical_machine <br>
    节点所在物理机标识符
  + role <br>
    节点角色名称
  + pub_key <br>
    节点 passphraseless ssh 公钥
  + token <br>
    节点通过开发者自定义脚本在该主机里运行结果，详情参见[应用开发模版规范-完整版](specifications/specifications.md)。
  + reserved_ips <br>
    节点预留 ip 地址. 这个目录下开发者可以定义多个 reserved IP，比如 write\_ip, read\_ip 等等，名称开发者自行定义，value 对应的就是这个 reserved IP 的地址。

  例：通过 /self/hosts/i-abcd2xyz/ip 可获取发起请求的节点所在集群中主机 ID 为 i-abcd2xyz 的 IP 地址；或通过 /self/hosts/master/i-abcd2xyz/ip 可获取发起请求的节点所在集群中主机 ID 为 i-abcd2xyz 的 IP 地址，而此节点是一个 master 节点。

> 在制作镜像的时候由于 confd 会默认配置 prefix 为 /self，所以在镜像里获取信息时可以省略 /self，比如上例可以直接通过 /hosts/i-abcd2xyz/ip 来获取这个节点的 IP 地址。如果在[创建应用版本配置包](app-version-mgmt/create-app-config.md)里定义 [metadata_root_access](specifications/specifications.md) 为 true，则 confd 会配置 prefix为 /，这个时候需要通过 /self/hosts/i-abcd2xyz/ip 来获取这个节点的 IP 地址。

* host　<br>
  + ip <br>
    本节点私有 IP 地址
  + mac <br>
    本节点 mac 地址
  + sid <br>
    本节点 server ID
  + gid <br>
    本节点 group ID
  + gsid <br>
    本节点 global server ID
  + node_id <br>
    本节点 node ID
  + instance_id <br>
    本节点主机 ID
  + cpu <br>
    本节点 CPU 核数
  + memory <br>
    本节点内存大小
  + volume_size <br>
    本节点数据盘大小。
  + gpu <br>
    本节点节点 GPU 显卡数
  + instance_class <br>
    本节点类型。
  + gpu_class <br>
    本节点 gpu 显卡类型。
  + volume_class <br>
    本节点数据盘类型。
  + physical_machine　<br>
    本节点所在物理机标识符
  + role <br>
    本节点角色名称
  + pub_key <br>
    本节点 passphraseless ssh 公钥
  + token <br>
    本节点通过开发者自定义脚本在本主机里运行结果
  + reserved_ips <br>
    本节点预留 ip 地址. 这个目录下开发者可以定义多个 reserved IP，比如 write\_ip, read\_ip 等等，名称开发者自行定义，value 对应的就是这个 reserved IP 的地址。

  例：通过 /self/host/ip 可获取自身节点的 IP 地址

* cluster <br>
  cluster 保存跟集群相关的元信息，包括
  + app_id <br>
    集群所属的应用 ID
  + cluster_id <br>
    集群 ID，用户在创建应用的时候青云调度系统自动生成的一个以 cl- 开头的唯一标识，如 cl-0u0a6u1j。
  + user_id <br>
    用户 ID，创建该集群的用户，如 usr-5DJhqhIN。
  + global_uuid <br>
    集群全球唯一 ID，用户在进入部署应用页面时自动生成的全球唯一标识，这个 ID 可用于需要生成 licence 的应用使用。
  + vxnet <br>
    集群所在网络 ID
  + zone <br>
    集群所在区域 ID
  + endpoints <br>
    应用供第三方使用的 endpoint 定义，service name 可在[应用开发模版规范-完整版](specifications/specifications.md)中任意定义。如果一个第三方应用通过 [links](#links) 链接到本应用，那么就可以通过此功能 (例： /links/*link\_name*/cluster/endpoints/*client*，假定开发者定义这个 endpoint 服务名为 client) 获取到本应用的 endpoint 信息。endpoint 下还可以定义 reserved\_ips，这个目录下开发者可以定义多个 reserved IP，比如 write\_ip, read\_ip 等等，名称开发者自行定义，value 对应的就是这个 reserved IP 的地址。
  + api_server <br>
    集群内部可通过内网访问的 api server 信息, 包括 host，port，protocol。目前仅在 sdn2.0 的 zone 内有此信息: pek3a/pek3b/sh1a/sh1b/gd2a

* env <br>
  env 保存用户可修改的应用参数，key 为参数名，value 为具体参数值。<br>
  例：Redis 节点可通过 /env/maxclients 获取用户配置的 maxclients 数值来更新 redis.conf

* adding-hosts <br>
  adding-hosts 临时保存新加入的节点信息，当 scale out (添加节点)操作完成之后这个子目录下的信息会随之消失。主机信息参见 [hosts](#hosts)。

* deleting-hosts <br>
  deleting-hosts 临时保存即将删除的节点信息，当 scale in (删除节点)操作完成之后这个子目录下的信息会随之消失。主机信息参见 [hosts](#hosts)。

* links <br>
  外部服务依赖定义，有些应用依赖于另外一个服务才能正常工作，如 Kafka 依赖于 ZooKeeper，因此此处需指定被依赖集群的 ID，service name 可在[应用开发模版-完整版](specifications/specifications.md)中任意定义。

* cmd <br>
  cmd 表示本节点需要执行的命令。开发者不需要用到这类信息，这是青云调度系统转发并执行应用命令(开发者只需要在模版中定义命令即可，详情参见[应用开发模版规范-完整版](specifications/specifications.md))，如启动应用命令等。


### 查询
在创建好一个集群后，登陆到任意一个节点，在文件 /etc/confd/confd.toml 里找到 nodes 这一行(这个文件是青云调度系统在用户创建集群的时候自动生成的)，这一行定义的是 metadata server 的 IP 地址，任取一个 IP，运行下面命令即可看到所有信息。注明：同一 VPC 里所有集群这个文件内容相同。
> curl http://[IP]/self

或者直接访问
> curl http://metadata/self
