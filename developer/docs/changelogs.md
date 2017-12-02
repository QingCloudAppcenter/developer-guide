# 版本变更记录

>提示：在 AppCenter 2.0 正式发布之前，版本升级没有考虑兼容，因此您需要删掉自己的测试集群，更新应用版本的配置包，重新部署新的配置包和集群。

### 版本发布时间
* 2.0 Alpha  : 2016年12月26日
* 2.0 Beta   : 2017年3月6日
* 2.0 Release : 2017年3月23日
* 2.1 Release : 2017年10月29日

### Alpha 到 Beta 主要变更记录

##### Specifications 变更
* 为了更好的规范化 specifications，统一使用名称的复数形式，变更如下：
  * endpoint --> endpoints
  * advanced\_action --> advanced_actions
  * node --> nodes
  * service --> services
* endpoints 增加关键字段 reserved_ips 为集群预留 IP 资源
* 增加 metadata\_root_access 支持集群主机通过 confd 访问 metadata service 根目录下信息
* 增加 agent_installed 支持用户不装青云提供的 App agent 而仍能使用 AppCenter 2.0 的调度系统管理自己的纯主机集群
* 增加 custom_metadata 通过开发者自定义的脚本提供集群主机的 token，如开源容器集群管理系统利用此信息来伸缩集群
* 增加 vertical\_scaling_policy 控制集群纵向伸缩时每个节点是串行执行还是并行执行操作 
* 增加 user_access 允许最终用户登陆某类主机
* services 下增加 destroy 销毁命令，在删除集群或者节点时触发该命令的执行, 可用于检查是否可以删除集群或节点
* passphraseless (ssh 无密码登录) 增加支持 ssh-rsa
* 增加 add_links，允许最终用户动态添加外部依赖集群
* services 下自定义服务支持传递 json 格式参数 
* volume 增加 mount_options
* 执行脚本的名称定义统一为 cmd：
  * health\_check 下 check\_script --> check\_cmd
  * health\_check 下 action\_script --> action_cmd
  * monitor 下 script --> cmd
* env 里增加 pattern 正则字段来规范配置
  
##### Metadata Service 变更
* 同上，endpoint 在 metadata service 里也改成 endpoints，同时把 endpoints 从根目录挪到 <cluster_id>/cluster/ 下，以满足本集群节点访问自身 endpoints 的需求
* endpoints 下增加 reserved_ips
* 主机 (hosts, host, adding-hosts, deleting-hosts) 增加主机通过 custom_metadata 获取的 token 信息
* 主机 (同上) 增加 gsid (global server ID)，这是一个全局唯一的 ID
* 主机 (同上) 增加 gid (group id)，主机分组 ID
* 集群 cluster 下增加 global_uuid 给某些需要依据此信息生成 license key 的 app 使用	

##### 功能
* 支持 Windows


### Beta 到 2.0 Release 主要变更记录

##### Specifications 变更
  
##### Metadata Service 变更
* 主机 (hosts, host, adding-hosts, deleting-hosts) 增加节点 instance_id 信息
* 集群 cluster 下增加集群所在 zone 信息


### 2.0 Release 到 2.1 Release 主要变更记录

##### Specifications 变更
* 增加 env 的 changeable 选项, 定义该项 env 在集群创建完毕以后是否可以修改.
* advanced_actions 里增加 add_nodes 选项，表示只允许增加节点，不允许删除节点.
* 增加 upgrade_policy 定义当前应用的哪些版本可以升级到当前版本.
* 增加 backup_policy 定义应用的备份策略, 支持 device 和 custom.
* 增加 incremental_backup_supported 定义应用是否支持增量备份。
* loadbalancer 下的 port 支持列表定义, 来监听多个后端服务器端口.
* services 下:
  * 增加 upgrade 升级命令, 在升级集群时触发该命令的执行.
  * 增加 backup 备份命令, 在备份集群时触发该命令的执行.
  * 增加 restore 恢复命令, 由备份恢复集群时触发该命令的执行.
  * 增加 delete_snapshot 备份删除命令, 删除备份时触发该命令的执行.
  * scale_in, scale_out 增加 pre_check 预检查命令, 删除节点或新增节点时优先触发命令的执行.
  * destroy 增加 allow_force, 控制是否允许强制删除节点
* 增加 display_tabs 展示自定义 tab 页命令, 开发者可以展示更多的集群信息给用户, 用户点击列表项时触发该命令的执行.
* locale 下翻译文件中, 支持 err_code 定义, 在出现错误时展示给用户相应的信息.

##### Metadata Service 变更
* 主机 (hosts, host, adding-hosts, deleting-hosts) 增加节点 instance_class, volume_class, volume_size, gpu, gpu_class, reserved_ips, eip 信息
* 集群 cluster 下:
  * 增加 user_id 信息.
  * 增加 api_server 信息, 包括 host, port, protoco．在集群内部可通过内网向 api server 发送请求.

##### 功能
* 支持按资源价格比例计费方式
* 支持价格随应用版本升级而变动
* 开发者可以查看到用户集群的环境变量
* 已上架应用所使用的 image 免费
* 支持查询 image 被哪些 app 使用
* 支持为集群中节点绑定 eip 和防火墙
* 支持创建, 切换网络时手动配置集群节点ip