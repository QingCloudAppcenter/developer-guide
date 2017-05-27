# 制作 Docker 镜像

AppCenter 的镜像同时支持 kvm 和 docker，但由于需要实现配置变更，不能直接使用已有的 docker 镜像，需要进行一些改造，docker 镜像默认启动的进程不能是应用本身的进程，而应该是 confd，由 confd 启动服务，并实现配置变更。

### Docker 镜像仓库

为了方便开发者存储自己的 docker 镜像，平台提供了 docker 镜像仓库。当前镜像仓库的控制台管理功能尚未完成，所以如果需要使用 docker 镜像仓库，请先提工单申请。为了保证用户安装程序时的体验，应用如果使用 docker 镜像，镜像需要放置到 QingCloud 的镜像仓库，以保证拉取速度。镜像仓库域名：dockerhub.qingcloud.com

### Docker 镜像制作

1. 将平台提供的confd，exec.sh，以及 confd 相关的配置添加到镜像
* 安装应用依赖的基础包
* 将应用的二进制添加到镜像
* 将应用的 confd 相关配置以及模板，还有脚本添加到镜像。
* 将 confd 设置为 ENTRYPOINT，容器启动时先启动 confd，然后应用通过 confd 来启动。

平台提供了一些基础镜像，包含 confd，以及相关系统配置，方便制作镜像。为了降低镜像的大小，建议通过平台的基础镜像基于 [alpine](https://alpinelinux.org/) 来制作。

### 基础镜像
1. [confd](https://github.com/yunify/docker-images/tree/master/confd)  dockerhub.qingcloud.com/qingcloud/confd:v0.13.7
2. [jdk8](https://github.com/yunify/docker-images/tree/master/jdk) dockerhub.qingcloud.com/qingcloud/jdk8:confd-v0.13.7

### Docker 镜像的cluster启动配置文件
配置文件和 VM 类型的应用基本没有区别，只是配置文件中的 container 的 type 需要设置为 docker，
image 为 docker 镜像的地址。docker 镜像是全局的，不区分区域，所以 zone 字段可以忽略。

```json
"container": {
  "type": "docker",
  "image": "zookeeper"
}
```

### 示例
* 镜像参看 [zookeeper](https://github.com/yunify/docker-images/tree/master/zookeeper)

### 基于 Docker 的本地开发环境
为了方便本地调试镜像，可以通过 Docker 在本地模拟一个集群环境，来测试 confd 的配置以及相关脚本。
具体参看 [zookeeper/dev/start_cluster.sh](https://github.com/yunify/docker-images/blob/master/zookeeper/dev/start_cluster.sh)
