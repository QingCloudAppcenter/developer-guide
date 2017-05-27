### Redis
此示例介绍如何部署一主一从的 Redis v3.0.5 服务。<br>
Redis 是一个基于内存、键值对的开源存储系统，并且支持数据持久化。详细介绍请见 [Redis](http://redis.io/)。


##### 镜像制作
首先在青云平台上创建两个虚机，然后按照下面步骤制作 Redis 服务所需镜像:

* [配置主节点镜像](../examples/images/redis/standalone/master-image-guide.md)
* [配置从节点镜像](../examples/images/redis/standalone/slave-image-guide.md)

<table><tr style="background-color:rgb(240,240,240);color:red"><td><b>如果有持久化数据必须用挂盘，不能保存到系统盘，切记！</b></td></tr></table>

##### 创建应用模版<a id="CreateApp"></a>
应用开发者在开发应用供最终用户使用时需要按照青云提供的规范来定义应用，然后上传到 AppCenter，这样用户才能在 AppCenter 使用此应用。用户在部署您的应用时，填写完必要参数之后点击创建，青云系统就会根据用户提交的信息
创建 Redis 集群。

* [Redis 应用模版](../examples/spec/redis-standalone.md)