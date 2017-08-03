# 快速入门


青云QingCloud AppCenter 旨在帮助软件开发者以极低的学习成本快速部署自己的应用到云平台之上，应用可以是单节点部署架构，但 AppCenter 主要是针对于复杂的、多节点甚至多角色节点部署的企业应用而提供的服务。创建一个应用的主要流程：

* [创建应用](../app-mgmt/create-app.md)
* [创建应用版本](../app-version-mgmt/create-app-version.md)
	* [创建应用模版配置文件](../app-version-mgmt/create-app-config.md)
	* [创建应用使用的镜像](../app-version-mgmt/images/README.md)
* [完善应用的详细信息](../app-mgmt/create-app.md#complete_app_details)
* [提交应用版本审核](../app-version-mgmt/submit-app-version.md) 或直接发布到个人应用中心(内部使用的应用)

这个创建流程中除了通过开发者控制台输入一些必要的应用信息外，最核心的是在创建应用版本时候包含的两个步骤：创建应用模版配置文件和制作镜像。为简化起见，下面举两个简单的例子介绍这两个步骤。例子使用了 [应用开发模版规范-基础版](../specifications/basic-specifications.md) 和在制作镜像过程中用到青云提供的 [Metadata](../metadata-service.md) 服务。

* [ZooKeeper 示例](zookeeper.md)
* [Redis Standalone 示例](redis-standalone.md)

* 可以参考视频教程--[这里](https://drive.yunify.com/s/Nzm9xZjz7DEeqRL)
* 更多青云制作的应用可以在[这里](https://github.com/qingCloudAppcenter/)找到．
* 常见的问题请参考－－[常见问题](../faq/README.md)
