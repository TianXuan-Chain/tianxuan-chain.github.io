## 1.4.1. 安装节点

将生成的安装包传至相应 *Ip* 的服务器上，解压并安装各节点。

```sh
tar -zxvf 101.35.234.160_agency.tar.gz #注意替换成自己的压缩包名
cd 101.35.234.160_agency #进入工作目录
bash install_node.sh #运行安装脚本
```

执行成功后，会在每个 *node* 目录中生成 *thanos-chain* 和 *thanos-gateway* 两个目录。

## 1.4.2. 启动节点应用 <a href="#id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-ying-yong" id="id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-ying-yong"></a>

启动四个节点应用，顺序为先启动 *thanos-chain* 应用，再启动 *thanos-gateway* 应用。

```bash
# 以node0为例
cd node0/thanos-chain
bash start_chain.sh
```

当配置的初始节点应用均已启动，则链启动完成。脚本中每个进程默认设置占用 *1g* 的内存，如果需要修改，可以进入脚本中直接修改运行指令。

运行脚本会后台启动应用，运行结果不会直接输出，请转至相应的 `logs` 目录下查看运行日志。

```bash
# 以node0为例
cd node0
tail -f thanos-chain/logs/thanos-chain.log | grep 'empty do commit cost' #如果持续打印该消息，说明节点chain应用启动成功并参与共识。
```

## 1.4.3. 启动节点网关 <a href="#id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-wang-guan" id="id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-wang-guan"></a>

节点应用启动成功后，再启动 *thanos-gateway*

```bash
# 以node0为例
cd node0/thanos-gateway
bash start_gateway.sh
```

网关启动后查看 *log* 日志如下，则启动成功

```bash
# 以node0为例
cd node0
cat thanos-gateway/logs/thanos-gateway.log |grep 'INFO [main]  Main start success!!' #如果打印该消息，说明节点gateway应用启动成功。
```

## 其他问题

**内存不足**

如果在运行程序时，遇到启动失败且无任何日志时，可能时服务器内存不住的原因。脚本中每个进程默认设置占用 *1g* 的内存，所以 *chain* 和 *gateway* 总共会占用至少 *2g* 的内存。

如果需要修改，可以直接进入 `start-chain.sh` 以及 `start-gateway.sh` 脚本中修改运行指令。
* start-chain\.sh

```bash
nohup java  -Xmx256m -Xms256m -Xmn256m -Xss4M -XX:SurvivorRatio=8  -jar thanos-chain.jar >/dev/null &
```

* start-gateway\.sh

```bash
nohup java  -Xmx256m -Xms256m -Xmn256m -Xss4M -XX:SurvivorRatio=8  -jar thanos-gateway.jar >/dev/null &
```

**rpc 端口绑定失败**

如果节点网关 *rpc* 端口绑定失败，`thanos-gateway.log` 中会出现如下报错信息

```
java.net.BindException: Cannot assign requested address (Bind failed)
    at java.net.PlainSocketImpl.socketBind(Native Method)
    at java.net.AbstractPlainSocketImpl.bind(AbstractPlainSocketImpl.java:387)
    at java.net.ServerSocket.bind(ServerSocket.java:375)
    at java.net.ServerSocket.<init>(ServerSocket.java:237)
    at javax.net.DefaultServerSocketFactory.createServerSocket(ServerSocketFactory.java:231)
    at com.thanos.gateway.jsonrpc.RpcServiceProvider.loadServerSocket(RpcServiceProvider.java:69)
    at com.thanos.gateway.jsonrpc.RpcServiceProvider.<init>(RpcServiceProvider.java:44)
    at com.thanos.gateway.jsonrpc.JsonRpcInit.init(JsonRpcInit.java:14)
    at com.thanos.gateway.Main.main(Main.java:31)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at org.springframework.boot.loader.MainMethodRunner.run(MainMethodRunner.java:49)
    at org.springframework.boot.loader.Launcher.launch(Launcher.java:108)
    at org.springframework.boot.loader.Launcher.launch(Launcher.java:58)
    at org.springframework.boot.loader.JarLauncher.main(JarLauncher.java:65)
```

需要查看 `node0/thanos-gateway/resource/thanos-gateway.conf` 配置文件并找到 *rpc.address* 条目，例如 *address=10.8.0.1:8180*
* 检查对应的 8180 端口是否在安全组中配置打开
* 检查 *Ip* 地址是否为内网地址 (目前 *rpc* 限制为仅内网可访问，而 *http* 为外网访问)

检查并修改完成后，重新执行 `start_gateway.sh` 运行网关，注意如果上一次运行的进程如果未关闭，需要先手动关闭。
```sh
ps -ef | grep java #查询运行中的 java 进程
kill -9 进程号 #找到对应的进程，并关闭
```
