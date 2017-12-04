# 常见问题

* 怎么查看集群主机里的 confd 日志

    启动时的 log： /opt/qingcloud/app-agent/log/confd-onetime.log <br>
    其他操作修改时的 log： /opt/qingcloud/app-agent/log/confd.log

* confd 日志显示 key 找不到

    经常会看到类似于如下信息，通常情况是在 toml 文件没 watch 该 key，或者该 key 不存在，可以通过 curl http://metadata/self 查看
    > 2016-10-11T13:54:41+08:00 i-lvn35udh confd[1531]: ERROR template: index.html.tmpl:2:7: executing "index.html.tmpl" at <getv "/self/host/sid...>: error calling getv: key does not exist: /self/host/sid

* 上传配置包时报错：配置验证失败, [config.json] Not valid json

    需要检查config.json文本内容，是否有中文符号或其他不符合json格式的部分，可以通过在线工具验证合法性，比如 [jsonlint](http://jsonlint.com/)；同时配置包中文件不支持 "UTF-8 Unicode (with BOM) text" 文本格式，windows下的编辑器编辑文件默认是此格式也会报此错误，可通过 "格式-> 以utf-8无BOM格式编码" 进行转换。

* tmpl 里想用到 if...else if...else 语法怎么写

    gotemplate 目前不支持 else if 语法，可以用 if...else 嵌套方式解决，参见 [if-elseif-else-inside-golang-templates](http://stackoverflow.com/questions/16985469/switch-or-if-elseif-else-inside-golang-html-templates)

* 我在测试的时候发现设置的服务价格没起作用

    自己测试自己的应用的时候是不收取服务费用的，一旦上线用户使用的时候会收取您设置的服务费用。

* 节点的启动/停止命令执行出错

    当定义的应用的启动/停止/监控命令执行有问题，例如
    文件定义如下

    ``` toml
    "start":"your_script"
    ```

    服务日志如下

    ``` log
    2017-04-13 12:14:19,318 ERROR Failed to execute the [cmd:your_script, id:JPwqtXY56Mp22t0RsqkDtQVu3hQLxxxx] in the node [cln-pwgxxxxx]
    ```

    请确认起停的命令要写全路径。例如

    ``` toml
    "start":"/bin/your_script"
    ```
    
    要保证脚本在任意路径下调用都可以成功返回。例如在创建好的集群中，执行如下命令返回正常
    ···
    cd /tmp; /opt/yourscript.sh
    ···

* 创建节点资源失败

    使用kvm作为镜像模板时，应用创建资源失败，登录创建的节点发现文件系统变成只读，日志如下

    ``` log
    2017-04-17 11:03:48,800 CRITICAL Mount volume [{'mount_point': '/data', 'mount_options': '', 'filesystem': 'ext4'}] on node [cln-bo73222b] failed
    ```

    请确保在制作镜像时正常关机，保证磁盘正常卸载。

* 使用说明和服务条款的 Markdown 语法说明
    * 支持标准的 [Markdown 语法](http://wowubuntu.com/markdown/)，同时你也可以直接使用 HTML 代码
    * Markdown 转换后的内容是没有样式，如果你想再添加样式，可以将下面的 HTML 代码添加到你输入的内容之前：
    ```html
    <link href="https://cdn.bootcss.com/foundation/6.3.1/css/foundation.min.css" rel="stylesheet">
    ```
    * 在使用说明中，如果只输入一个网址，用户在查看使用说明时会直接跳转到该网址


* 如何把任务执行的错误原因更友好的呈现给用户<i id="err_code"></i>

    在执行 scale\_in/scale\_out 的 pre\_check 和 cmd 时，系统会捕获错误码并将 i18n 文件中的对应条目 `err_codeX` (其中 X 为错误码)作为错误消息提示给用户.
    比如 locale/zh-cn.json 文件内容为:
    ```json
{
    "err_code111": "无法删除主节点"
}
```
    在执行 scale\_in 的 pre\_check 如果遇到错误码为 111, 则显示"无法删除主节点"为错误消息。
