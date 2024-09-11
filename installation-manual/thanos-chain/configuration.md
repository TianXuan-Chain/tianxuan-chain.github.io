# 配置说明

## 概述 <a href="#id3.1.3-pei-zhi-shuo-ming-yi-gai-shu" id="id3.1.3-pei-zhi-shuo-ming-yi-gai-shu"></a>

天玄节点应用中，每个节点包含一个主配置`thanos-chain.conf`，日志管理配置`logback.xml`，创世块配置`genesis.json`以及节点身份配置`nodeInfo.properties`。

* `thanos-chain.conf`：主配置文件。包括节点网络配置、共识配置、账本配置文件路径、SSL密钥库配置、密码算法等信息。
* `logback.xml`：日志管理配置文件。包括日志存放路径、日志生成规则等。
* `genesis.json`：创世块配置文件。包括组网节点身份信息、创世区块相关信息等。
* `nodeInfo.properties`：节点身份配置文件。包括本节点的名称、所属机构、节点私钥、节点Id等。

## 主配置文件 thanos-chain.conf <a href="#id3.1.3-pei-zhi-shuo-ming-er-zhu-pei-zhi-wen-jian-thanoschain.conf" id="id3.1.3-pei-zhi-shuo-ming-er-zhu-pei-zhi-wen-jian-thanoschain.conf"></a>

`thanos-chain.conf` 主要包括了`network`、`concesus`、`resource`、`tls`等配置项。配置内容示例如下：

```json
network {
    peer.rpc.ip = 127.0.0.1
    peer.bind.ip = 0.0.0.0
    peer.listen.discoveryPort = 30303
    peer.listen.rpcPort = 9080
    peer.channel.read.timeout = 60
    peer.discovery = {
        # List of the seed peers to start
        # the search for online peers
        ip.list = [
            "127.0.0.1:30304"
        ]
    }
    // need consistency pattern of each node
    transferDataEncrypt = 1
 
    // default false
    epollSupport = false
 
    nettyPoolByteBuf = false
 
    gateway {
        localListenAddress = 7580
        remoteServiceAddress = "127.0.0.1:7180"
        pushTxsQueueSize = 6
    }
}
 
consensus {
    // 1 = MultipleOrderedProposers;
    // 2 = RotatingProposer;
    proposerType = 2
    contiguousRounds = 1
    maxPackSize = 50000
    maxCommitEventNumInMemory = 100
    maxPrunedEventsInMemory = 4
//    reimportUnCommitEvent = true
    poolLimit = 3000
    roundTimeoutBaseMS = 5000
    parallelProcessorNum = 8
}
 
state {
    checkTimeoutMS = 1500
    maxCommitBlockInMemory = 5
}
 
resource {
    database {
        needEncrypt = false
        encryptAlg = AES
        # place to save physical livenessStorage files
        # must use absolute path
        dir = "/root/thanos-chain/node0/database"
    }
    logConfigPath = "/root/thanos-chain/node0/resource/chain-logback.xml"
}
 
vm.structured {
  trace = false
  dir = vmtrace
  initStorageLimit = 10000
}
 
#tls settings, such as path of keystore,truststore,etc
tls {
    keyPath = "/root/thanos-chain/node1/resource/tls/node.key"
    certsPath = "/root/thanos-chain/node1/resource/tls/chain.crt"
}
```

### 配置network <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-network" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-network"></a>

* peer.rpc.ip：节点的rpc地址，用于和其他节点通信。通常填本机的外网或内网地址。
* peer.bind.ip ：节点绑定的IP地址，通常固定为0.0.0.0。
* peer.listen.discoveryPort ：节点监听的p2p端口号，主要用于收发【节点发现】消息（底层udp协议实现）
* peer.listen.rpcPort ：节点监听的rpc端口号，主要用于收发【共识】消息（底层tcp协议实现）
* peer.channel.read.timeout：节点间通道超时时间
* peer.discovery.ip.list：待连接节点的ip列表
* transferDataEncrypt：channel通信是否加密，全节点统一。
* epollSupport：是否启用EpollEventLoopGroup实现JavaNIO。默认为false，表示不启动。当linux系统支持epoll模式时，可将该项置为true，提高性能。
* nettyPoolByteBuf：底层通讯字节是否池化，建议为true
* gateway.localListenAddress：链节点用于监听链网关发送交易的端口。
* gateway.remoteServiceAddress：与该链节点交互的链网关的ip地址和端口号。
* gateway.pushTxsQueueSize：接收gateway 打包交易个数的队列大小，建议为16

### 配置consensus <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-consensus" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-consensus"></a>

* proposerType : 提案类型，目前仅支持轮循提案，值 为【2】
* contiguousRounds：主节点正常共识时连续共识的轮数，超过该轮数需要切换主节点。
* maxPackSize：一轮共识中交易最大打包量。
* maxCommitEventNumInMemory：内存中最多存储的已共识事件数。
* maxPrunedEventsInMemory：内存中最多存储的裁剪事件数。
* reimportUnCommitEvent：是否重新共识未共识成功的交易
* poolLimit：交易池交易数量限制
* roundTimeoutBaseMS：chain bft 的每轮共识超时基数，建议为5000（即5秒）
* parallelProcessorNum：dag并行处理交易的cpu 个数

### 配置state <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-state" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-state"></a>

* checkTimeoutMS：异步共识的检测超时时间，建议为1500 （1500 毫秒）
* maxCommitBlockInMemory：内存中保留已共识成功的block 数量

### 配置resource <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-resource" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-resource"></a>

* database.needEncrypt：账本信息是否需要加密存储。
* database.encryptAlg：账本信息加密存储时采用的加密算法。如果无需加密，可忽视该配置项。
* database.dir：账本信息存放路径
* logConfigPath：日志管理配置文件logback.xml所在路径

### 配置tls <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-tls" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-tls"></a>

* keyPath ：节点的私钥文件node.key所在路径
* certsPath ：节点的证书链chain.crt所在路径

## 日志管理配置文件 chain-logback.xml <a href="#id3.1.3-pei-zhi-shuo-ming-san-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml" id="id3.1.3-pei-zhi-shuo-ming-san-ri-zhi-guan-li-pei-zhi-wen-jian-logback.xml"></a>

`chain-logback.xml`指定了节点日志的存放位置和生成规则。配置内容示例如下：

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
            <level>TRACE</level>
        </filter>
    </appender>
 
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>./logs/thanos-chain.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- rollover hourly -->
            <fileNamePattern>./logs/thanos-chain-%d{yyyy-MM-dd-'h'HH}.log</fileNamePattern>
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
 
    <root level="TRACE">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="ASYNC"/>
    </root>
 
    <logger name="main" level="TRACE"/>
    <logger name="gateway" level="INFO"/>
    <logger name="consensus" level="INFO"/>
    <logger name="network" level="INFO"/>
    <logger name="state" level="INFO"/>
    <logger name="tx-pool" level="INFO"/>
    <logger name="rlp" level="ERROR"/>
    <logger name="utils" level="DEBUG"/>
    <logger name="crypto" level="ERROR"/>
    <logger name="thanos-worker" level="DEBUG"/>
    <logger name="executor" level="DEBUG"/>
    <logger name="VM" level="INFO"/>
    <logger name="sync-layer2" level="DEBUG"/>
    <logger name="sync" level="DEBUG"/>
    <logger name="state-verify" level="DEBUG"/>
    <logger name="ledger" level="DEBUG"/>
    <logger name="discover" level="DEBUG"/>
    <logger name="db" level="DEBUG"/>
    <logger name="general" level="DEBUG"/>
    <logger name="repository" level="INFO"/>
    <logger name="java.nio" level="ERROR"/>
    <logger name="io.netty" level="ERROR"/>
    <logger name="io.grpc" level="ERROR"/>
 
</configuration>
```

### 配置打印的日志组件 <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-zu-jian" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-zu-jian"></a>

通过`<appender>`标签 指定打印的日志组件。在上述示例文件中，指定了三个日志组件：STDOUT、FILE、ASYNC

1）STDOUT 日志组件： 采用`ch.qos.logback.core.ConsoleAppender`组件，将日志打印到控制台中。其中，`<encoder>`标签 对日志进行格式化。

2）FILE 日志组件：采用`ch.qos.logback.core.rolling.RollingFileAppender`组件，将日志滚动记录到文件中。其中，`<file>`标签指定了日志文件名，`<rollingPolicy>`指定了滚动策略。 示例中采用`TimeBasedRollingPolicy`滚动策略，即根据时间进行滚动。其中`<fileNamePattern>`指定了滚动日志文件名，`<maxHistory>`控制保留的日志文件最大数量。

3）ASYNC 日志组件： 采用`ch.qos.logback.classic.AsyncAppender`组件，负责异步记录日志。该组件仅充当事件分派器，必须搭配其他`appender`使用，示例文件中搭配 FILE 日志组件，表示将日志事件异步记录到文件中。

此外，可通过`<root>`标签，指定日志的打印等级。并通过`<appender-ref>`标签指定生效的日志组件。

### 配置打印的日志等级 <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-deng-ji" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-da-yin-de-ri-zhi-deng-ji"></a>

通过`<logger>`标签 指定相应类的日志等级。

## 创世块配置文件 genesis.json <a href="#id3.1.3-pei-zhi-shuo-ming-si-chuang-shi-kuai-pei-zhi-wen-jian-genesis.json" id="id3.1.3-pei-zhi-shuo-ming-si-chuang-shi-kuai-pei-zhi-wen-jian-genesis.json"></a>

`genesis.json`主要包括了validatorVerifiers，alloc 以及和创世区块相关配置。配置内容示例如下：

```json
{
  "validatorVerifiers": {
    "302a300506032b65700321001537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d": {
      "consensusVotingPower": 1,
      "shardingNum": 1,
      "name": "xiaoming",
      "agency": "agency01",
      "caHash": "caHash01"
    },
    "302a300506032b6570032100d767bd96e2dd0d3807bf87fb3a09bcef1db36d8313dffdc801e19efa6d6dc7f0": {
      "consensusVotingPower": 1,
      "shardingNum": 1,
      "name": "xiaoming01",
      "agency": "agency02",
      "caHash": "caHash02"
    }
  },
  "committeeAddrs": [],
  "operationsStaffAddrs": [],
  "voteThreshold": "2/3",
  "alloc": {
    "5db10750e8caff27f906b41c71b3471057dd2004": {
      "balance": "1606938044258990275541962092341162602522202993782792835301376"
    },
    "31e2e1ed11951c7091dfba62cd4b7145e947219c": {
      "balance": "1606938044258990275541962092341162602522202993782792835301376"
    },
    "ee0250c19ad59305b2bdb61f34b45b72fe37154f": {
      "balance": "1606938044258990275541962092341162602522202993782792835301376"
    }
  },
  "maxShardingNum": 1024,
  "shardingNum": 0,
  "nonce": "0x0000000000000000",
  "difficulty": "0x100000",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "extraData": "0x11bbe8db4e347b4e8c937c1c8370e4b5ed33adb3db69cbdb7a38e1e50b1b82fa",
  "gasLimit": "0x1000000000",
  "startEventNumber": "12"
}
```

### 配置 validatorVerifiers <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-validatorverifiers" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-validatorverifiers"></a>

validatorVerifiers 包括了组网节点的身份信息，k-v 对形式。key 是组网节点的公钥字符串，value 包括以下字段：

* consensusVotingPower：节点的共识投票权重
* shardingNum：节点所处分片。目前可忽略。
* name：节点名称
* agency：节点所属机构
* caHash：节点证书序列号。目前可忽略。

### 配置 committeeAddrs

committeeAddrs 包括了管理链的节点的委员会的公钥信息。

### 配置 operationsStaffAddrs



### 配置 voteThreshold

委员会决策的门阀值

### 配置 alloc <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-alloc" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-alloc"></a>

alloc 包括了创世区块的合约状态。目前可忽略。

### 配置创世块相关信息 <a href="#id3.1.3-pei-zhi-shuo-ming-pei-zhi-chuang-shi-kuai-xiang-guan-xin-xi" id="id3.1.3-pei-zhi-shuo-ming-pei-zhi-chuang-shi-kuai-xiang-guan-xin-xi"></a>

* maxShardingNum：分片最大数量。
* shardingNum：本节点所属分片
* nonce：创世块的nonce值
* difficulty：创世块的计算难度。目前可忽略。
* mixhash：创世块的混合hash。目前可忽略。
* coinbase：创世块的coinbase。目前可忽略。
* timestamp：创世块的时间戳。
* parentHash：创世块的父区块hash。
* extraData：创世块的附加数据。目前可忽略。
* gasLimit：交易执行消耗的最大gas值。
* startEventNumber：初始块高。

## 节点身份配置文件 nodeInfo.properties <a href="#id3.1.3-pei-zhi-shuo-ming-wu-jie-dian-shen-fen-pei-zhi-wen-jian-nodeinfo.properties" id="id3.1.3-pei-zhi-shuo-ming-wu-jie-dian-shen-fen-pei-zhi-wen-jian-nodeinfo.properties"></a>

`nodeInfo.properties`主要包括了节点身份信息。配置内容示例如下：

```editorconfig
#ed25519
name=xiaoming
agency=agency01
caHash=caHash01
nodeIdPrivateKey=e82aa7abc528720865d6ff2f19175305dd75c9943602e266957bff1eecf10b1b
nodeId=1537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d1537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d
#publicKey=302a300506032b65700321001537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d
  
#Encrypt/Decrypt
#AES
nodeEncryptKey=c9ec17b81d5abf18b979693faacbf917
#SM4
#nodeEncryptKey=a77ce8a55dbc209f052d6be716963ec2
```

* name ：节点信息
* agency：节点所属结构
* caHash：节点证书序列号。目前可忽略。
* nodeIdPrivateKey：节点私钥字符串（16进制）
* nodeId：节点Id字符串
* nodeEncryptKey：账本信息加密存储时采用的加密私钥，需要与`database.encryptAlg`配置项指定的加密算法一致（如果无需加密，可忽视该配置项）
