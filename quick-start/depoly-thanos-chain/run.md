# 安装并启动节点

## 安装节点

将生成的安装包传至相应ip的服务器上，解压并安装各节点。

```sh
$tar -zxvf 101.35.234.160_agency.tar.gz
$cd 101.35.234.160_agency
$bash install_node.sh
```

执行成功后，会在每个 node 目录中生成 thanos-chain 和 thanos-gateway 两个目录。

## 启动节点应用 <a href="#id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-ying-yong" id="id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-ying-yong"></a>

启动四个节点应用，顺序为先启动 thanos-chain 应用，再启动 thanos-gateway 应用。

```bash
# 以node0为例
$cd node0/thanos-chain
$bash start_chain.sh
```

当配置的初始节点应用均已启动，则链启动完成。脚本中每个进程默认设置占用 1g 的内存，如果需要修改，可以进入脚本中直接修改运行指令。

运行脚本会后台启动应用，运行结果不会直接输出，请转至相应的logs目录下查看运行日志。

```bash
# 以node0为例
$cd node0
$tail -f node0/thanos-chain/logs/thanos-chain.log | grep 'empty do commit cost' #如果持续打印该消息，说明节点chain应用启动成功并参与共识。
```

## 启动节点网关 <a href="#id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-wang-guan" id="id2.4-an-zhuang-bing-qi-dong-jie-dian-qi-dong-jie-dian-wang-guan"></a>

节点应用启动成功后，再启动 thanos-gateway

```bash
# 以node0为例
$cd node0/thanos-gateway
$bash start_gateway.sh
```

网关启动后查看 log 日志如下，则启动成功

```bash
# 以node0为例
$cd node0
$cat node0/thanos-chain/logs/thanos-gateway.log |grep 'INFO [main]  Main start success!!' #如果打印该消息，说明节点gateway应用启动成功。
```

如果节点网关连接节点应用失败，查看完整日志

```bash
# 以node0为例
$cd node0
$node0/thanos-chain/logs/thanos-gateway.log
```

会发现如下报错

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

需要检查对应的连接端口是否正确打通，可以尝试直接修改 node0/thanos-gateway/resource/thanos-gateway.conf 中间中的配置。

找到 rpc.address 条目，直接值修改为 127.0.0.1:8182 ，因为当前 gateway 和 chain 运行在同一台服务器上，所以可以直接通过 127.0.0.1 访问端口，进而屏蔽端口连通性问题。

```editorconfig
rpc {
    address = "127.0.0.1:8182"
    acceptCount = 300
    maxThreads = 400
    readWriteTimeout = 60000
}
```

如果 gateway 和 chain 需要运行在不同服务器上，请正确配置 ip 和 port 后，验证服务器端口连通性

## 其他事项

脚本中每个进程默认设置占用 1g 的内存，如果需要修改，可以直接进入 start-chain.sh 以及 start-gateway.sh 脚本中修改运行指令。

```bash
nohup java  -Xmx1g -Xms1g -Xmn750M -Xss4M -XX:SurvivorRatio=8  -jar thanos-chain.jar >/dev/null &
nohup java  -Xmx1g -Xms1g -Xmn750M -Xss4M -XX:SurvivorRatio=8  -jar thanos-gateway.jar >/dev/null &
```
