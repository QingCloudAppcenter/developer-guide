# 制作 KVM 镜像

提示:<table><tr style="background-color:rgb(240,240,240);color:red"><td><b>除了允许用户登陆的节点(配置文件里定义 user_access 为 true) 之外，其它类型节点如果有持久化数据必须用挂盘，不能保存到系统盘，切记！且在主机里不要操作资源比如 halt 主机，青云会负责资源调度，用户只需要关注应用即可。</b></td></tr></table>

所谓持久化数据是指跟具体用户有关的数据，如 session、用户自己的数据等，比如说数据库应用，数据库应用程序本身不是持久化数据，因为它可以无差别的重复部署而不影响服务，但用户的数据库信息、用户设置的参数、日志等是持久化数据。

制作镜像有以下几个步骤：

* 创建主机

  跟平常一样到您控制台选择需要的系统镜像创建主机，以下系统镜像(括号内为镜像 ID )已经过测试:

  + Ubuntu: 12.10 64-bit (quantalx64b)，13.10 64-bit (saucysrvx64b)，14.04.1 LTS 64-bit (trustysrvx64c)，16.04 LTS 64-bit (xenialx64)
  + CentOS: 6.4 64-bit (centos64x64b)，7 64-bit (centos7x64b)
  + Debian: Wheezy 7.5 64-bit (wheezyx64g)
  + OpenSUSE: 12.3 64-bit (opensuse12x64c)
  + Fedora: 18 64-bit (fedora18x64b)，20 64-bit (fedora20x64b)
  + Windows: Windows Server 2008 (win2k8r2eechsi, win2k8r2eechdc, win2k8r2seen), Windows Server 2012 (winsrv2012r2chsh)

* 安装自己的应用

* 安装 agent

  下载青云提供的 app agent [Linux 版本](http://appcenter-docs.qingcloud.com/developer-guide/scripts/app-agent-linux-amd64.tar.gz), [Windows 版本](http://appcenter-docs.qingcloud.com/developer-guide/scripts/app-agent-windows-386.zip)，解压后运行 ./install.sh (Windows 下双击 install.bat)。此 agent 中包含了自动配置文件程序 confd，该程序是在开源 [confd](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md) 的基础上修改了一些 bug 并且增加了一些算术功能，详情见 [QingCloud confd](https://github.com/yunify/confd/)。

* 创建模版文件

  开发一些必须的模版文件，这些文件会监听青云 metadata service 的变化从而更新自己应用的配置文件。这些文件后缀名为 toml 和 tmpl，例如，ZooKeeper 有两个配置文件 zoo.cfg 和 myid，每个配置文件需要一套相应的 toml 和 tmpl 模版对应，详情请见[范例](https://github.com/search?q=topic%3Aqingcloud-sample-apps+org%3AQingCloudAppcenter&type=Repositories)中的应用。

	+ /etc/confd/conf.d/zoo.cfg.toml

  ``` toml
[template]
src = "zoo.cfg.tmpl"
dest = "/opt/zookeeper/conf/zoo.cfg"
keys = [
    "/",
]
reload_cmd = "/opt/zookeeper/bin/restart-server.sh"
	```

  toml 文件中 src 代表模版文件名，dest 即应用的配置文件，这个配置文件会根据 src 模版刷新 dest 内容，keys 即进程 confd 监控青云 metadata service 关于该节点所在集群信息的更新，有变化则更新，如果模版中需要用到某个 key 的信息，则需要监听这个 key，也可以直接监听根目录"/"。reload_cmd 则是配置文件被刷新后的操作，脚本开发者自行提供脚本，如果不需要触发动作可以去掉 reload_cmd 这一行。toml 文件里可加上权限控制 比如 uid，gid，mode 等，详情请见 [confd](https://github.com/yunify/confd/blob/master/docs/quick-start-guide.md)

	+  /etc/confd/templates/zoo.cfg.tmpl

  ```
tickTime=2000
initLimit=1ini0
syncLimit=5
dataDir=/zk_data/zookeeper
clientPort=2181
maxClientCnxns=1000
{{range $dir := lsdir "/hosts"}}{{$sid := printf "/hosts/%s/sid" $dir}}
{{$ip := printf "/hosts/%s/ip" $dir}}server.{{getv $sid}}={{getv $ip}}:2888:3888{{end}}
  ```

  tmpl 模版文件决定应用配置文件内容，confd 读取青云 metadata service 刷新这些变量的值，如此例 range 这一行是读取该节点所在集群节点的 IP 和 server ID 信息，然后刷新为如下信息：

  ```
server.1=192.168.100.2:2888:3888
server.2=192.168.100.3:2888:3888
server.3=192.168.100.4:2888:3888
  ```

  更多模版语法参见 [confd templates](https://github.com/kelseyhightower/confd/blob/master/docs/templates.md)，注意的是青云的 confd 在开源基础上增加了一些对算术的支持，如 add,div,mul,sub,eq,ne,gt,ge,lt,le,mod 等。
