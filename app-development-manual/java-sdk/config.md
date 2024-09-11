# 配置说明

## 概述 <a href="#id4.3.3-pei-zhi-shuo-ming-gai-shu" id="id4.3.3-pei-zhi-shuo-ming-gai-shu"></a>

天玄链中，使用 sdk 需要加载主配置文件`thanos-web3j.conf`以及 日志管理配置`logback.xml`。

## 主配置文件 thanos-web3j.conf <a href="#id4.3.3-pei-zhi-shuo-ming-zhu-pei-zhi-wen-jian-thanosweb3j.conf" id="id4.3.3-pei-zhi-shuo-ming-zhu-pei-zhi-wen-jian-thanosweb3j.conf"></a>

thanos-web3j.conf 主要包括了gateway、resource、tls等配置项。配置内容示例如下：

```editorconfig
gateway = {
    # List of gateway peers rpc port to send msg
    rpc.ip.list = [
        "127.0.0.1:8082",
        "127.0.0.1:8182"
    ]
    web3Size = 3
    #connection check interval (s)
    checkInterval = 60
 
    # List of gateway peers http port to send msg
    http.ip.list = [
       "127.0.0.1:8581",
       "127.0.0.1:8582"
    ]
}
 
resource {
    logConfigPath = "/root/thanos-test/resource/logback.xml"
}
 
#tls settings, such as path of keystore,truststore,etc
tls {
    needTLS = true
    keyPath="/root/thanos-test/resource/tls/node.key"
    certsPath="/root/thanos-test/resource/tls/chain.crt"
}
```

### 配置gateway标签 <a href="#id4.3.3-pei-zhi-shuo-ming-pei-zhi-gateway-biao-qian" id="id4.3.3-pei-zhi-shuo-ming-pei-zhi-gateway-biao-qian"></a>

* rpc.ip.list：gateway提供rpc服务的ip和端口号（列表）。
* web3Size  ：每个gateway节点对应的rpc连接池中的连接数量。
* checkInterval ：rpc连接有效性检测的时间间隔。
* http.ip.list ：gateway提供http服务的ip和端口号（列表）。

### 配置resource标签 <a href="#id4.3.3-pei-zhi-shuo-ming-pei-zhi-resource-biao-qian" id="id4.3.3-pei-zhi-shuo-ming-pei-zhi-resource-biao-qian"></a>

* logConfigPath：日志管理配置文件logback.xml所在路径。

### 配置tls标签 <a href="#id4.3.3-pei-zhi-shuo-ming-pei-zhi-tls-biao-qian" id="id4.3.3-pei-zhi-shuo-ming-pei-zhi-tls-biao-qian"></a>

* needTLS：与 gateway 之间的 rpc 通信是否需要建立 tls 链接，需要与 gateway 端配置保持一致。
* keyPath：sdk 的私钥文件 node.key 所在路径。
* certsPath：sdk 的证书链 chain.crt 所在路径。

## 日志管理配置文件 logback.xml <a href="#id4.3.3-pei-zhi-shuo-ming-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml" id="id4.3.3-pei-zhi-shuo-ming-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml"></a>

logback.xml指定了节点日志的存放位置和生成规则。配置内容示例如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<configuration>
 
    <!-- Be sure to flush latest logs on exit -->
    <shutdownHook class="ch.qos.logback.core.hook.DelayingShutdownHook"/>
 
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %p [%c{1}]  %m%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>DEBUG</level>
        </filter>
    </appender>
 
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>./logs/thanos-test.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- rollover hourly -->
            <fileNamePattern>./logs/thanos-test-%d{yyyy-MM-dd-'h'HH}.log</fileNamePattern>
            <!-- ~1 month -->
            <maxHistory>720</maxHistory>
            <totalSizeCap>50GB</totalSizeCap>
        </rollingPolicy>
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %p [%c{1}]  %m%n</pattern>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>DEBUG</level>
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
    </appender>
 
    <root level="DEBUG">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="ASYNC"/>
    </root>
 
    <logger name="rlp" level="ERROR"/>
    <logger name="rpc" level="INFO"/>
    <!--<logger name="rpc" level="DEBUG"/>-->
    <logger name="test" level="DEBUG"/>
 
</configuration>

```

### 配置打印的日志组件 <a href="#id4.3.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-zu-jian" id="id4.3.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-zu-jian"></a>

通过`<appender>`标签 指定打印的日志组件。在上述示例文件中，指定了三个日志组件：STDOUT、FILE、ASYNC

1）STDOUT 日志组件： 采用`ch.qos.logback.core.ConsoleAppender`组件，将日志打印到控制台中。其中，`<encoder>`标签 对日志进行格式化。

2）FILE 日志组件：采用`ch.qos.logback.core.rolling.RollingFileAppender`组件，将日志滚动记录到文件中。其中，`<file>`标签指定了日志文件名，`<rollingPolicy>`指定了滚动策略。示例中采用`TimeBasedRollingPolicy`滚动策略，即根据时间进行滚动。其中`<fileNamePattern>`指定了滚动日志文件名，`<maxHistory>`控制保留的日志文件最大数量。

3）ASYNC 日志组件： 采用`ch.qos.logback.classic.AsyncAppender`组件，负责异步记录日志。该组件仅充当事件分派器，必须搭配其他`appender`使用，示例文件中搭配 FILE 日志组件，表示将日志事件异步记录到文件中。此外，可通过`<root>`标签，指定日志的打印等级。并通过`<appender-ref>`标签指定生效的日志组件。

### 配置打印的日志等级 <a href="#id4.3.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-deng-ji" id="id4.3.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-deng-ji"></a>

通过`<logger>`标签 指定相应类的日志等级。
