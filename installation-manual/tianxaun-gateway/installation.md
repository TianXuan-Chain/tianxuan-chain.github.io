# 安装

## 硬件要求 <a href="#id3.2.1-an-zhuang-yi-huan-jing-yao-qiu" id="id3.2.1-an-zhuang-yi-huan-jing-yao-qiu"></a>

| 配置   | 最低配置                                  | 推荐配置   |
| ---- | ------------------------------------- | ------ |
| CPU  | 1.5GHz                                | 2.4GHz |
| 内存   | 2GB                                   | 4GB    |
| 核心数  | 2核                                    | 4核     |
| 网络带宽 | 1Mb                                   | 5Mb    |
| 操作系统 | CentOS (7及以上 64位) 或 Ubuntu(18.04 64位) |        |
| JAVA | JDK 1.8                               |        |

## 天玄网关安装 <a href="#id3.2.1-an-zhuang-er-thanosgateway-an-zhuang" id="id3.2.1-an-zhuang-er-thanosgateway-an-zhuang"></a>

### 前置准备 <a href="#id3.2.1-an-zhuang-1-qian-zhi-zhun-bei" id="id3.2.1-an-zhuang-1-qian-zhi-zhun-bei"></a>

**1）在安装节点网关之前，请确保已经安装并运行了节点应用**

**2）网关安装所需依赖**

* Oracle JDK - 1.8
* Maven - 3.3.9
* Git

**3）创建操作目录**

创建网关部署操作的目录，以`node0`为例：

```sh
cd ~ && mkdir -p thanos-gateway/node0 && cd thanos-gateway/node0
```

在节点目录下创建`database`，`logs`和`resource`子目录。其中，`logs`目录用于存放链执行日志。`resource`目录用于存放网关的配置文件。

```sh
mkdir logs resource
```

在`resource`目录下创建`tls`目录，用于存放证书相关文件。

```sh
mkdir resource/tls
```

**4）添加可执行文件**

获取可执行文件`thanos-gateway.jar`，获取方式见：[获取可执行文件](../tianxaun-chain/executable-file.md)。

将`thanos-gateway.jar`放在操作目录下，如`~/thanos-gateway/node0/`。

### 节点网关系统配置

以`node0`节点为例，进行网关系统的配置，包括网络端口配置、tls配置、日志配置等。配置文件中各配置项的具体含义参见：[网关配置说明](./)

1）在`~/thanos-gateway/node0/resource/`目录下 添加网关的总配置文件`thanos-gateway.conf`和日志管理配置`gateway-logback.xml`。

`thanos-gateway.conf`内容模板如下。
```editorconfig
gateway {
    #本机节点信息，用于与其他gateway节点互连
    node.myself = "1:101.35.234.159:100"
 
    rpc {
        #本机rpc服务ip和端口，用于向sdk提供rpc服务。
        address = "127.0.0.1:8180"
        acceptCount = 300
        maxThreads = 400
        readWriteTimeout = 60000
    }
 
    http {
        #本机http服务端口号，用于向sdk提供http服务。
        port = 8580
        acceptCount = 300
        maxThreads = 400
        readWriteTimeout = 12000
    }
    #广播节点列表
    # broadcast = ["2:10.246.199.210:200"]
    broadcast =[]
    push {
        #推送地址
        address = "101.35.234.159:7580"
    }
    sync {
        #同步出块地址
        address = 7180
        cache {
            blockLimit = 10
            txPoolDSCacheSizeLimit = 2000
        }
    }
    switch {
        #是否仅广播全局节点事件
        only.broadcast.globalEvent = 0
    }
    log {
        logConfigPath = "/root/thanos-gateway/node0/resource/gateway-logback.xml"
    }
}
#tls settings, such as path of keystore,truststore,etc
tls {
    #与web3j的通信方式，是否使用tls加密
    needTLS = false
    keyPath="/root/thanos-gateway/node0/resource/tls/node.key"
    certsPath="/root/thanos-gateway/node0/resource/tls/chain.crt"
}
```
当前教程配置单节点天玄链网关，模板中需要修改的配置如下：
* `gateway . rpc . address` 需要将 IP 修改为服务器的<mark>内网 IP 地址</mark>。
* `gateway . log . logConfigPath` 需要修改为相应的 gateway-logback.xml 文件的路劲。注意，涉及路径的配置项必须是<mark>绝对路径</mark>。

`gateway-logback.xml`内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<configuration debug="false">
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <charset>UTF-8</charset>
            <pattern>
                %d %-4relative [%thread] %-5level %logger{36} - %msg%n
            </pattern>
        </encoder>
    </appender>
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/thanos-gateway.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>logs/thanos-gateway.log.%d{yyyy-MM-dd}.%i</fileNamePattern>
            <maxHistory>14</maxHistory>
            <maxFileSize>500MB</maxFileSize>
            <totalSizeCap>15GB</totalSizeCap>
        </rollingPolicy>
        <encoder>
            <pattern>[%d{yyyy-MM-dd HH:mm:ss}] [%thread] %level %logger{35} [T:%X{trans}] %msg%n</pattern>
        </encoder>
    </appender>
 
    <root level="INFO">
        <appender-ref ref="FILE"/>
        <appender-ref ref="CONSOLE"/>
    </root>
 
</configuration>
```

而后，添加 tls 相关证书和密钥等文件。

由于节点网关和节点应用是一一对应的，需要将应用部署中生成的 tls 配置（在`~/thanos-chain/node0/resource/tls`目录下的`node.key`和`chain.crt`两个文件）添加至`~/thanos-gateway/node0/resource/tls`目录下。

```sh
# 复制文件到指定目录
cp ~/thanos-chain/node0/resource/tls/node.key ~/thanos-gateway/node0/resource/tls/
cp ~/thanos-chain/node0/resource/tls/chain.crt ~/thanos-gateway/node0/resource/tls/
```

至此，网关配置完成，可以启动。启动方法为：在网关操作目录`~/thanos-gateway/node0/`下，运行如下指令启动节点：

```sh
java -Xmx256m -Xms256m -Xmn256m -Xss4M -jar thanos-gateway.jar
```
