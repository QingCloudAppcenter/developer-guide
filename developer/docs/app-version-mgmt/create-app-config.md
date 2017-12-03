# 创建配置文件

配置文件包是一组根据应用开发模版规范描述应用实例的文件组成，描述内容包括应用实例基础架构、生命周期及监控告警等，比如说创建应用实例时需要的参数，每个参数的可选项，以及各个节点的映像等。完整的配置文件包需要打包以下几个文件：

+ config.json 该文件包含最终用户创建此应用实例时通过 UI 需设置的参数等信息；
+ cluster.json.mustache 该文件包含创建此应用需要用到的映像、多少类节点、服务启动命令等信息；
+ locale/en.json 英文翻译文件；
+ locale/zh-cn.json 中文翻译文件。

config.json 中定义的参数，在青云QingCloud 控制台上由用户设置，控制台支持语言国际化，默认情况下，所有语言都会按配置项中的 label 和 description 展示，如果您想要适应不同的语言，需要在提交的应用中包含一个 locale 文件夹，并添加对应语言的翻译文件，如上所述。

将以上几个文件压缩打包成 TAR，TAR.GZ，ZIP 或 TAR.BZ 格式并上传。

我们提供了从简单到复杂的应用配置文件样例，详情请参看[应用开发模版规范-完整版](../specifications/specifications.md)，也提供一些[范例](https://github.com/search?q=topic%3Aqingcloud-sample-apps+org%3AQingCloudAppcenter&type=Repositories)供参考。
