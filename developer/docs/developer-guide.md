# 开发云应用指南

>　青云 QingCloud AppCenter V2.0

## 简介

青云AppCenter是一个使应用尤其复杂的企业应用很方便的集成到青云之上的标准化平台，这些应用通常情况是以集群的形式部署，如何使一个复杂的企业应用部署到云上且具有云的特性如弹性是一个很复杂的开发过程， 青云AppCenter使得这个复杂的开发过程极其简单化、标准化，通过青云的AppCenter云化一个产品从以前长达半年可以缩短到今天的以天计，并且这个学习曲线非常短，几个小时就能快速掌握如何云化一个复杂的应用。应用可以是单节点部署架构，但 AppCenter 主要是针对于复杂的、多节点甚至多角色节点部署的企业应用而提供的服务。

除此之外，青云AppCenter还为开发者提供具有丰富功能的运维、运营管理平台，开发者通过这个管理平台可以发布自己的应用并查看所有与其相关的应用信息，比如用户数量、工单系统、财务报表等。

## 申请入驻

青云QingCloud应用中心欢迎专注各个领域的企业以及个人开发者为用户提供丰富、优秀的服务。在提供服务之前，请按照如下两个步骤申请入驻。

* 首先[注册](https://console.qingcloud.com/signup)成为青云QingCloud 用户；
* 然后[申请](https://console.qingcloud.com/account/profile/partner_verify/)成为青云QingCloud开发者。

我们会在收到您的入驻申请之后的3个工作日之内完成审核，审核通过之后您便可登录[应用管理平台](https://appcenter.qingcloud.com/developer)创建、管理您的应用。青云AppCenter同时也对个人用户开放，但需要注意的是未申请入驻的个人开发者只能创建应用供自己或自己的团队内部使用，无法将应用提供给其他用户使用。

另外，青云AppCenter 试用期间只对合作伙伴开放。

## 应用管理

成功申请入驻之后，便可登录“应用管理”后台开始创建、管理您的应用了。本节将详细介绍应用的基本概念以及创建步骤。

### 基本介绍

创建一个应用的基本流程：

* [创建一个应用](\#create_app_name)；
* [创建该应用的第一个版本](\#create_app_version)；
* 完善[应用的详细信息](\#complete_app_details)；
* [提交应用版本审核](\#submit_app_version)。

### 创建应用

首先登陆[应用管理平台](https://appcenter.qingcloud.com/developer)，点击“应用”部分的“+”号按钮，开始创建第一个应用。

![创建](developer/images/home_create_app.png)

进入创建页面之后，输入应用名称，例如：HBase 1.2.2。

![创建名字](developer/images/create_app.png)

点击“创建应用”按钮，您的第一个应用便创建成功，成功之后将直接进入[“应用版本”](\#create_app_version)中创建该应用的第一个版本，完善应用详细信息的步骤可暂时跳过。

### 应用信息

用户在浏览、搜索和查看应用时是通过基本信息来了解应用的各个方面的，主要包括以下几种信息：

* 应用名称: 为您的应用起一个简单直接的名称，便于用户浏览和搜索；
* 概述: 简单介绍应用的主要功能及特性，让用户进一步了解该应用；
* 应用描述: 可在应用描述中详细介绍应用的各个功能以及特性，当用户想进一步了解应用时，描述内容的完整将变成尤为重要；
* 应用类别: 目前支持的应用类别主要有：基础服务、企业软件、研发管理、运维管理、安全管理和行业增值几大类，请根据应用的功能特性选择适合的应用类别；
* 服务条款: 若用户在使用应用过程中需要同意一些特殊条款请在此声明，用户在部署安装时我们会告知用户；
* 应用图标: 为您的应用设计一枚美观的图标，以代表您的应用并突出应用特点；
* 应用截图: 清晰的界面截图可以辅助以上信息帮助用户直观了解应用的各个方面；

完整、准确的应用信息可以让您的应用更容易被用户搜索到，在应用提交审核的时候以上信息也是管理员严格审核的内容之一。

需要强调的是：若对于已发布的应用需要更新其中部分内容，需要等下次版本发布成功后才可体现在应用中心中。

完善的 HBase 1.2.2 应用信息如下：

![app_info](developer/images/app_info.png)

在应用中心中呈现给最终用户的效果如下：

![app_preview](developer/images/app_preview.png)

### 部署应用

应用(版本)通过审核之后，您可以选择适当的时间发布应用，发布之后用户便可通过[AppCenter](https://appcenter.qingcloud.com/)浏览、搜索查看到此款应用，并购买应用从而部署自己的应用实例。

### 管理应用

应用发布之后则需要您及时的管理好应用的各个方面，包括快速有效的回复用户对于应用的各类问题、查看用户的具体使用情况、了解应用的收入、必要时给相关用户发送应用更新通知等等。这些管理功能陆续都会完善上线并提供完整的使用指南。

### 下架应用

当您的应用不再对用户开放，或出现严重问题时可以选择将应用下架。应用下架意味着应用将不会出现在应用中心，用户也不会浏览搜索到此款应用。

决定下架应用之后，需要您在应用信息页面提出“下架申请”并写明下架原因，我们审核通过之后应用才下架成功。 已下架的应用如果还有用户在使用，开发者必须继续对应用进行必要的维护，以及回复用户提出的相关问题。

### 删除应用

当应用没有任何用户部署的情况下允许开发者将应用删除，从此不再需要进行任何维护与管理。

## 应用版本管理

### 基本介绍

“应用版本”对于一款应用来说是非常重要和关键的概念。一款应用从创建、发布到更新，整个过程中很可能需要提交多个应用版本，每个版本中都包括完整的应用服务功能，其主要属性如下:

* 版本名称: 用数字或者字符表示应用的版本号，例如 1.0、2.1.20。若没有提供版本名称，系统将自动指定一个；
* 版本状态: 包括准备提交、审核中、被拒绝、已通过、已上架、已下架和已删除几种状态，不同的状态对应不同的操作；
* 配置文件: 用于描述应用具体服务的各类文件，文件格式支持 TAR，TAR.GZ，ZIP 和 TAR.BZ，后面将详细介绍配置文件及其制作方法和步骤；
* 版本描述: 此描述内容主要用来记录此版本的具体更新，便于用户在升级应用时做详细了解。

### 创建版本

了解了应用版本的主要属性之后，我们开始创建应用的第一个版本。如果是新创建的应用，那么在第一次进入“应用版本”页面时便可直接创建应用的第一个版本，默认版本名称为“新版本1”，版本状态为“准备提交”。若已有一个或多个版本存在，可以点击“创建新版本”按钮来创建。

![创建版本](developer/images/create_app_version.png)

### 创建配置文件

整个应用服务实际上是通过一系列符合集群应用开发规范的文件所描述的。包括应用所有属性、创建应用实例时需要的参数，每个参数的可选项，以及各个节点的映像等等。所以，完整的配置文件需要打包以下几个文件：

* config.json 该文件包含最终用户创建此应用的实例需设置的参数等信息；
* cluster.json.mustache 该文件包含创建此应用需要用到的映像、多少类节点、服务启动命令等信息，这是一个改进版的mustache 文件；
* locale/en.json 英文翻译文件；
* locale/zh-cn.json 中文翻译文件；

config.json 中定义的参数，在青云 QingCloud 控制台上由用户设置。控制台支持语言国际化，默认情况下，所有语言都会按配置项中的 label 和 description 展示。如果您想要适应不同的语言，需要在提交的应用中包含一个 locale 文件夹，并添加对应语言的翻译文件，如上所述。

将以上几个文件压缩打包成 TAR,　TAR.GZ,　ZIP或 TAR.BZ 格式并上传。

我们提供了从简单到复杂的应用配置文件样例，详情请参看[通用模版规范定义](developer/docs/specifications/specifications.md)，也提供一些[案例](developer/docs/spec-samples)供参考。

### 制作镜像

在整个云化应用过程中，制作镜像是最花时间也是最容易出错的一部分，因为每个应用的部署架构不同，需要调试的时间也会差异很大，通常情况下少则几个小时，多则一周左右。下面详细解释制作镜像的流程，青云AppCenter支持三种镜像类型: KVM, Docker及LXC，目前LXC暂未开放给用户。

#### 制作KVM镜像

提示:<table><tr style="background-color:rgb(240,240,240);color:red"><td><b>如果有持久化数据必须用挂盘，不能保存到系统盘，切记！</b></td></tr></table>

制作镜像有以下几个步骤：<br>

* 创建主机 <br>
  跟平常一样到您控制台选择需要的系统镜像创建主机, 以下系统镜像(括号内为镜像ID)已经过测试:
  * Ubuntu: 12.10 64-bit (quantalx64b), 13.10 64-bit (saucysrvx64b), 14.04.1 LTS 64-bit (trustysrvx64c), 16.04 LTS 64-bit (xenialx64)
  * CentOS: 6.4 64-bit (centos64x64b), 7 64-bit (centos7x64b)
  * Debian: Wheezy 7.5 64-bit (wheezyx64g)
  * OpenSUSE: 12.3 64-bit (opensuse12x64c)
  * Fedora: 18 64-bit (fedora18x64b), 20 64-bit (fedora20x64b)
  * Windows: Windows Server 2008 (win2k8r2eechsi, win2k8r2eechdc, win2k8r2seen), Windows Server 2012(winsrv2012r2chsh)

* 安装自己的应用 <br>
* 安装agent <br>
  下载青云提供的 app agent [Linux 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-linux-amd64.tar.gz), [Windows 版本](https://pek3a.qingstor.com/appcenter/developer/packages/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)。此 agent 中包含了自动配置文件程序 confd，该程序是在开源 [confd](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md) 的基础上修改了一些 bug 并且增加了一些算术功能，详情见 [QingCloud confd](https://github.com/yunify/confd/releases/tag/v0.13.0-alpha1)。

* 创建模版文件　<br>
  开发一些必须的模版文件，这些文件会监听青云metadata service的变化从而更新自己应用的配置文件。这些文件后缀名为toml和templ, 例如，ZooKeeper有两个配置文件 zoo.cfg和myid，每个配置文件需要一套相应的toml和tmpl模版对应。详情请见[配置ZooKeeper镜像](examples/images/zookeeper/image-guide.md)。

	+ /etc/confd/conf.d/zoo.cfg.toml


	        [template]
	        src = "zoo.cfg.tmpl"
	        dest = "/opt/zookeeper/conf/zoo.cfg"
	        keys = [
	            "/",
	        ]
	        reload_cmd = "/opt/zookeeper/bin/restart-server.sh"

    src代表模版文件名，dest即应用的配置文件，这个配置文件会根据模版刷新内容，keys即进程confd监控青云metadata service关于该节点所在集群信息的更新，如果模版中需要用到某个key的信息，则需要监听这个key，也可以直接监听根目录"/"。reload_cmd则在配置文件被刷新后的动作，脚本开发者自行提供。
    toml文件里可加上权限控制 比如owner, mode等，详情请见[confd](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md)

   	+ /etc/confd/templates/zoo.cfg.tmpl

	    	tickTime=2000
	    	initLimit=10
	    	syncLimit=5
	    	dataDir=/zk_data/zookeeper
	    	clientPort=2181
	    	maxClientCnxns=1000
	    	{{range $dir := lsdir "/hosts"}}{{$sid := printf "/hosts/%s/sid" $dir}}
	    	{{$ip := printf "/hosts/%s/ip" $dir}}server.{{getv $sid}}={{getv $ip}}:2888:3888{{end}}

    模版文件决定应用配置文件内容，confd读取青云metadata service刷新这些变量的值，如此例range两行是读取该节点所在集群节点的IP和server ID信息，然后刷新为如下信息

    		server.1=192.168.100.2:2888:3888
    		server.2=192.168.100.3:2888:3888
    		server.3=192.168.100.4:2888:3888

    更多模版语法参见[confd templates](https://github.com/kelseyhightower/confd/blob/master/docs/templates.md)， 注意的是青云的confd在开源基础上增加了一些对算术的支持，如add,div,mul,sub,eq,ne,gt,ge,lt,le,mod

#### 制作Docker镜像

详细参看 [Docker 指南](app-version-mgmt/images/docker.md)

### 测试版本

输入完版本名称、配置文件以及版本描述之后可以点击“保存”按钮更新版本所有信息。要提交审核之前需要对此版本进行完善测试。点击版本编辑表单最下方的“去控制台测试”按钮，可以前往控制台实际部署集群实例并进行各方面测试。

![测试版本按钮](developer/images/btn_test_app.png)
![测试版本](developer/images/test_app.png)

在测试部署集群实例时需要填写创建表单，提交之后便开始部署过程，部署完成之后可在“集群”列表页面看到刚刚创建的集群实例，进入其详情页面可以查看到“基本信息”“节点列表”以及“配置参数”等信息，同时可对集群实例做各项操作以测试其可用性等。

![my_apps](developer/images/my_apps.png)
![app_cluster_list](developer/images/app_cluster_list.png)
![app_cluster](developer/images/app_cluster.png)

### 提交审核

若当前版本各方面测试已通过，可以将此应用版本提交审核。但需要注意的是，提交审核之前请完善必要的应用信息，否则会影响审核结果。此情况下页面上也会有相应提示。

![before_submit_app](developer/images/before_submit_app.png)

提交之后，应用版本的状态将更新为“审核中”。

![app_submitted](developer/images/app_submitted.png)

审核工作将在10个工作日内完成。当审核被拒绝时页面上会显示详细的拒绝原因，请调整后重新提交审核。

![reject_app_version](developer/images/reject_app_version.png)

### 上架版本

审核通过之后，开发者可以根据自己的计划来选择时间上架此应用。应用一旦上架则意味着应用会出现在“应用中心”的应用列表中，用户可以随时浏览、购买并部署应用。且上架的应用版本不允许再做任何修改，如有问题需要修复或服务需要升级请按上面的步骤提交新版本，等待审核通过后可以上架新版本，再将旧版本下架或删除。

![release_app_version](developer/images/release_app_version.png)

### 下架版本

当所有版本都下架时该应用也会自动下架。下架需要提交下架申请并等待青云管理员审核。 下架的应用因为还有用户在使用，所以对于这些用户提交的工单等开发者依旧要给予及时的响应和解决。

### 版本记录

开发者可以查看所有创建过的版本列表，以及每个版本详细的审核记录。

注：此功能将在AppCenter 2.1 发布时提供。

## 用户列表

所有购买、部署了此应用的用户，我们会统计出来显示在“用户”标签下，并且展示了该用户名下所部署的集群实例分别处于什么状态。

![app_users](developer/images/app_users.png)

必要时，开发者可以点击用户 ID 查询该用户名下的集群实例列表，或做一些过滤查询。

![app_user](developer/images/app_user.png)

## 集群实例列表

每次基于应用部署之后都会生成一个集群实例，开发者可在“资源”标签下查看完整的集群实例列表，并根据需要按照“区域”、“应用版本”以及“集群实例状态”进行过滤查询。

集群实例共分以下几种状态：运行中、已停止、已销毁、等待中、已暂停和已删除。

![app_clusters](developer/images/app_clusters.png)

点击集群实例 ID 可进入其详情页面，内容包括：基本信息、节点列表和日志列表。 二期将支持集群实例健康监控和节点 CPU、内存和硬盘等监控图表，帮助开发者更好的定位问题。

![app_cluster](developer/images/app_cluster_nodes.png)

## 操作日志

在集群实例部署和运行过程中会产生日志信息，我们提供完整的日志列表给开发者。日志状态分： 成功、等待中、执行中、部分失败和失败几中。

![app_jobs](developer/images/app_logs.png)

当日志为“部分失败”或“失败时”我们会自动发送告警通知，并提供详细的错误日志内容给开发者，以定位问题原因。

![app_jobs](developer/images/app_log_failed.png)

## 工单系统

工单系统将在应用中心做全面升级，在原来支持开发者或用户向青云提交工单的同时，也支持用户直接向开发者提交工单。另外，当开发者在回复用户问题需要青云工程师协助时可以提出“协助申请”，青云工程师将第一时间收到提醒一起回复用户工单，从而快速有效的为用户服务。

## 财务管理

财务管理主要包括应用收入统计、应用保证金及平台费用管理、提现管理等功能。

注：此功能将在AppCenter 2.1 发布时提供。

## 通知中心

应用实例告警以及系统通知等都会汇集在通知中心向开发者发送。开发者可以针对不同的通知指定接受的通知列表，通知列表支持手机、邮箱以及微信账号三种方式。

## 青云 Metadata 服务

参考 [Metadata Service](metadata-service.md)

## 应用模版规范

参考 [应用开发模版规范](specifications/specifications.md)

## 范例

参考 [青云应用目录](https://github.com/search?q=topic%3Aqingcloud-sample-apps+org%3AQingCloudAppcenter&type=Repositories)
