### ZooKeeper
此示例介绍如何部署单角色的多节点 ZooKeeper v3.4.9 集群。<br>
ZooKeeper 是一个高可用的分布式数据管理与系统协调软件，它可以为分布式应用提供状态同步、配置管理、名称服务、群组服务、分布式锁及队列、以及 Leader 选举等服务。详细介绍请见 [ZooKeeper](http://zookeeper.apache.org/)。

##### 镜像制作
首先在青云平台上创建一个虚机，然后按照下面步骤制作 ZooKeeper 服务所需镜像:
* [配置节点镜像](../examples/images/zookeeper/image-guide.md)

<table><tr style="background-color:rgb(240,240,240);color:red"><td><b>如果有持久化数据必须用挂盘，不能保存到系统盘，切记！</b></td></tr></table>

##### 创建应用模版
应用开发者在开发应用供最终用户使用时需要按照青云提供的规范来定义应用，然后上传到 AppCenter，这样用户才能在 AppCenter 使用此应用。用户在部署您的应用时，填写完必要参数之后点击创建，青云系统就会根据用户提交的信息
创建 ZooKeeper 集群。

* [ZooKeeper 应用模版](../examples/spec/zookeeper.md)
