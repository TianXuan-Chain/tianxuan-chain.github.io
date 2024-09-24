## 2.2.1. 概述 <a href="#id3.2.2-pei-zhi-yi-gai-shu" id="id3.2.2-pei-zhi-yi-gai-shu"></a>

节点网关的配置文件中，主要包含一个主配置 `thanos-gateway.conf` 和日志管理配置 `logback.xml` 。

## 2.2.2. 主配置文件 thanos-chain.conf <a href="#id3.2.2-pei-zhi-er-zhu-pei-zhi-wen-jian-thanoschain.conf" id="id3.2.2-pei-zhi-er-zhu-pei-zhi-wen-jian-thanoschain.conf"></a>

`thanos-gateway.conf` 主要包括了 *gateway* 和 *tls* 等配置项。配置内容示例如下：

```editorconfig
gateway {
    #本机节点信息，用于与其他gateway节点互连
    node.myself = "1:10.246.199.210:100"
 
    rpc {
        #本机rpc服务ip和端口，用于向sdk提供rpc服务。
        address = "10.246.199.210:8180"
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
        address = "10.246.197.244:7580"
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
    keyPath="/root/thanos-gateway/node1/resource/tls/node.key"
    certsPath="/root/thanos-gateway/node1/resource/tls/chain.crt"
}
```

### 2.2.2.1. 配置 gateway 标签 <a href="#id3.2.2-pei-zhi-pei-zhi-gateway-biao-qian" id="id3.2.2-pei-zhi-pei-zhi-gateway-biao-qian"></a>

* **node.myself**：本机节点信息，用于与其他 gateway 节点互连。
* **rpc.address**：本机 *rpc* 服务 *ip* 和端口，用于向 *sdk* 提供 *rpc* 服务，需要注意此 *ip* 地址需要使用内网地址，因为当前限制 *rpc* 只能通过内网访问。
* **rpc.acceptCount**：本机 *rpc* 服务最多接收的连接数
* **rpc.maxThreads**：本机 *rpc* 服务最多开启的线程数
* **rpc.readWriteTimeout**：*rpc* 连接的读写超时时间 (毫秒) 。
* **http.address**：本机 *http* 服务 *ip* 和端口，用于向 *sdk* 提供 *rpc* 服务。
* **http.acceptCount**：本机 *http* 服务最多接收的连接数。
* **http.maxThreads**：本机 *http* 服务最多开启的线程数。
* **http.readWriteTimeout**：*http* 连接的读写超时时间 (毫秒) 。
* **broadcast**：广播节点列表，即其他 *gateway* 节点信息。
* **push.address**：*gateway* 节点推送交易给 *chain* 应用时，*chain* 应用的接收地址。
* **sync.address**：*gateway* 节点的端口号，负责监听 *chain* 应用推送的区块信息。
* **sync.cache.blockLimit**：缓存的的区块最大数量。
* **sync.cache.txPoolDSCacheSizeLimit**：缓存的交易池大小。
* **switch.only.broadcast.globalEvent**：是否仅广播全局节点事件。

### 2.2.2.2. 配置 tls 标签 <a href="#id3.2.2-pei-zhi-pei-zhi-tls-biao-qian" id="id3.2.2-pei-zhi-pei-zhi-tls-biao-qian"></a>

* **needTLS**: *gateway* 与 *web3j* 之间通信，是否要开启 *tls* 认证。
* **keyPath**：节点私钥文件路径。
* **certsPath**：节点证书链文件路径。

## 2.2.3. 日志管理配置文件 gateway-logback.xml <a href="#id3.2.2-pei-zhi-san-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml" id="id3.2.2-pei-zhi-san-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml"></a>

`gateway-logback.xml`指定了节点日志的存放位置和生成规则。配置内容示例如下：

```xml
<?xml version="1.0" encoding="GBK"?>
<configuration debug="false">
 
    <shutdownHook class="ch.qos.logback.core.hook.DelayingShutdownHook"/>
 
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %p [%c{1}]  %m%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>TRACE</level>
        </filter>
    </appender>
 
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>./logs/thanos-gateway.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- rollover hourly -->
            <fileNamePattern>./logs/thanos-gateway-%d{yyyy-MM-dd-'h'HH}.log</fileNamePattern>
            <!-- ~1 month -->
            <maxHistory>720</maxHistory>
            <totalSizeCap>50GB</totalSizeCap>
        </rollingPolicy>
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %p [%c{1}]  %m%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>TRACE</level>
        </filter>
    </appender>
 
    <appender name="ASYNC" class="ch.qos.logback.classic.AsyncAppender">
        <!-- Don't discard INFO, DEBUG, TRACE events in case of queue is 80% full -->
        <discardingThreshold>0</discardingThreshold>
        <!-- Default is 256 -->
        <!-- Logger will block incoming events (log calls) until queue will free some space -->
        <!-- (the smaller value -> flush occurs often) -->
        <queueSize>100</queueSize>
 
        <appender-ref ref="FILE" />
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>TRACE</level>
        </filter>
    </appender>
 
    <root level="INFO">
        <appender-ref ref="FILE"/>
        <appender-ref ref="CONSOLE"/>
    </root>
 
    <logger name="sync" level="DEBUG"/>
    <logger name="jsonrpc" level="DEBUG"/>
    <logger name="txpool" level="DEBUG"/>
    <logger name="node" level="DEBUG"/>
    <logger name="push" level="DEBUG"/>
    <logger name="broadcast" level="DEBUG"/>
    <logger name="java.nio" level="ERROR"/>
    <logger name="io.netty" level="ERROR"/>
    <logger name="io.grpc" level="ERROR"/>
    <logger name="com.googlecode.jsonrpc4j" level="ERROR"/>
 
</configuration>
```

### 2.2.3.1. 配置打印的日志组件 <a href="#id3.2.2-pei-zhi-pei-zhi-da-yin-de-ri-zhi-zu-jian" id="id3.2.2-pei-zhi-pei-zhi-da-yin-de-ri-zhi-zu-jian"></a>

通过 *\<appender>* 标签 指定打印的日志组件。在上述示例文件中，指定了三个日志组件：*STDOUT* 、*FILE* 、*ASYNC*

1）**STDOUT 日志组件**： 采用 *ch.qos.logback.core.ConsoleAppender* 组件，将日志打印到控制台中。其中，*\<encoder>* 标签 对日志进行格式化。

2）**FILE 日志组件**：采用 *ch.qos.logback.core.rolling.RollingFileAppender* 组件，将日志滚动记录到文件中。其中，*\<file>* 标签指定了日志文件名，*\<rollingPolicy>* 定了滚动策略。示例中采用 *TimeBasedRollingPolicy* 滚动策略，即根据时间进行滚动。其中 *\<fileNamePattern>* 指定了滚动日志文件名，*\<maxHistory>* 控制保留的日志文件最大数量。

3）**ASYNC 日志组件**： 采用 *ch.qos.logback.classic.AsyncAppender* 组件，负责异步记录日志。该组件仅充当事件分派器，必须搭配其他 *appender* 使用，示例文件中搭配 FILE 日志组件，表示将日志事件异步记录到文件中。

此外，可通过 *\<root>* 标签，指定日志的打印等级。并通过 *\<appender-ref>* 标签指定生效的日志组件。

### 2.2.3.2. 配置打印的日志等级 <a href="#id3.2.2-pei-zhi-pei-zhi-da-yin-de-ri-zhi-deng-ji" id="id3.2.2-pei-zhi-pei-zhi-da-yin-de-ri-zhi-deng-ji"></a>

通过 *\<logger>* 标签指定相应类的日志等级。