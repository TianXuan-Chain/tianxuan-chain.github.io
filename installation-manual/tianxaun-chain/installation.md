本章介绍天玄节点应用所需的必要安装和配置。本章通过在单机上部署一条天玄测试链，来帮助用户掌握部署流程。

## 1.2.1. 硬件要求 <a href="#id3.1.2-an-zhuang-yi-huan-jing-yao-qiu" id="id3.1.2-an-zhuang-yi-huan-jing-yao-qiu"></a>

| 配置   | 最低配置                                  | 推荐配置   |
| ---- | ------------------------------------- | ------ |
| CPU  | 1.5GHz                                | 2.4GHz |
| 内存   | 2GB                                   | 4GB    |
| 核心数  | 2核                                    | 4核     |
| 网络带宽 | 1Mb                                   | 10Mb   |
| 操作系统 | CentOS (7及以上 64位) 或 Ubuntu(18.04 64位) |        |
| JAVA | JDK 1.8                               |        |

## 1.2.2. 天玄链安装搭建

### 1.2.2.1. 前置依赖软件 <a href="#id3.1.2-an-zhuang-1-qian-zhi-zhun-bei" id="id3.1.2-an-zhuang-1-qian-zhi-zhun-bei"></a>

* [Oracle JDK 1.8](../../quick-start/depoly-tianxaun-chain/software-requirement.md#oracle-jdk-18-安装)
* GmSSL-v2（该软件只支持 *Linux* 系统）

*GmSSL-v2* 的安装流程如下

```bash
# 注意需要安装 GmSSl-2.0，当前 GmSSL 最新代码为 3.0，需要指定 2.0 版本
git clone --branch GmSSL-v2 --single-branch https://github.com/guanzhi/GmSSL.git
cd GmSSL/
./config
make
sudo make install
sudo cp libcrypto.so.1.1 libssl.so.1.1 /lib64
```

由于 *gmssl* 默认安装在 `usr/local/bin` 路径下，如果当前 *linux* 系统的 *$PATH* 变量不包含该路径，需要添加

```bash
vim /etc/profile
```

```editorconfig
#在文件末尾处添加如下语句
export PATH=/usr/local/bin:${PATH}
```

```bash
source /etc/profile
```

执行完成后，查询版本号，如果顺利返回，说明 *gmssl* 安装完成。

```sh
gmssl version
```

### 1.2.2.2. 创建操作目录 <a href="#id3.1.2-an-zhuang-chuang-jian-cao-zuo-mu-lu" id="id3.1.2-an-zhuang-chuang-jian-cao-zuo-mu-lu"></a>

创建当前链节点的操作目录，以 *node0* 为例。

```bash
cd ~ && mkdir -p thanos-chain/node0 && cd thanos-chain/node0
```

然后在节点目录下创建 `database` ，`logs` 和 `resource` 子目录。其中，`database` 目录用于存放节点身份信息配置、创世块配置 以及 生成的链区块；`logs` 目录用于存放链执行日志；`resource` 目录用于存放节点的总配置文件。

```sh
mkdir database logs resource
```

还需在 `resource` 目录下创建 `tls` 文件夹，用于放置证书等文件

```sh
mkdir resource/tls
```

### 1.2.2.3. 添加可执行文件 <a href="#id3.1.2-an-zhuang-tian-jia-ke-zhi-xing-wen-jian" id="id3.1.2-an-zhuang-tian-jia-ke-zhi-xing-wen-jian"></a>

获取可执行文件 `thanos-chain.jar`（获取方式见 [获取可执行文件](executable-file.md)），并放在节点操作目录下，如 `~/thanos-chain/node0/`

### 1.2.2.4. 创建链证书和机构证书 <a href="#id3.1.2-an-zhuang-chuang-jian-lian-zheng-shu-he-ji-gou-zheng-shu" id="id3.1.2-an-zhuang-chuang-jian-lian-zheng-shu-he-ji-gou-zheng-shu"></a>

在配置节点前，需要先准备好链证书、机构证书和机构私钥等信息，用于签发节点证书。具体证书说明见：[证书说明](log.md)

链和机构证书的创建流程如下：

&#x20;1）创建当前链的证书目录

```bash
cd ~ && mkdir -p thanos-chain/ca && cd thanos-chain/ca
```

2）添加证书配置文件

3）创建链私钥、证书和机构私钥，证书 `cert.cnf` , 内容如下

```editorconfig
[ca]
default_ca=default_ca

[default_ca]
default_days = 365
default_md = sha256

[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = CN
countryName_default = CN
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = ZheJiang
localityName = Locality Name (eg, city)
localityName_default = HangZhou
organizationalUnitName = Organizational Unit Name (eg, section)
organizationalUnitName_default = netease
commonName =  Organizational  commonName (eg, netease)
commonName_default = netease
commonName_max = 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment

[ v4_req ]
basicConstraints = CA:TRUE
```

3）创建链私钥、证书和机构私钥、证书，按需求从<mark>国密</mark>和<mark>非国密</mark>中二选一即可，本教程请使用<mark>非国密</mark>

非国密

```sh
# 1. 生成根ca的私钥ca.key与自签名证书ca.crt
gmssl genrsa -out ca.key 2048
gmssl req -new -x509 -days 3650 -key ca.key -out ca.crt

# 2. 生成机构私钥agency.key与证书agency.crt (由根ca签发)
gmssl genrsa -out agency.key 2048
gmssl req -new -key agency.key -config cert.cnf -out agency.csr
gmssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -in agency.csr -out agency.crt  -extensions v4_req -extfile cert.cnf
```

国密

```sh
# 1. 生成根ca的私钥ca.key与自签名证书ca.crt
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out ca.key
gmssl req -new -x509 -days 365 -key ca.key -sm3 -out ca.crt

# 2. 生成机构私钥agency.key与证书agency.crt (由根ca签发)
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out agency.key
gmssl req -new -sm3 -key agency.key -config cert.cnf -out agency.csr
gmssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -in agency.csr -out agency.crt -CAcreateserial -sm3 -extensions v4_req -extfile cert.cnf
```

### 1.2.2.5. 配置单节点 <a href="#id3.1.2-an-zhuang-2-pei-zhi-dan-jie-dian" id="id3.1.2-an-zhuang-2-pei-zhi-dan-jie-dian"></a>

本节主要以 *node0* 节点为例，介绍如何进行节点信息配置，包括节点身份信息、网络端口配置等。其他节点的配置流程相同。

**创建节点密钥及证书**

在 `~/thanos-chain/ca` 目录下，执行如下命令，生成指定算法的节点密钥，并使用机构私钥签发节点证书。

非国密

```bash
# 1. 生成节点私钥和节点证书
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp256k1 -out node.key
gmssl req -new -key node.key -config cert.cnf  -out node.csr
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -extensions v3_req -extfile cert.cnf
gmssl x509  -text -in node.crt | sed -n '5p' |  sed 's/://g' | tr "\n" " " | sed 's/ //g' | sed 's/[a-z]/\u&/g' | cat >node.serial

# 2. 生成证书链文件
cat ca.crt agency.crt  node.crt > chain.crt
```

国密

```bash
# 1. 生成节点私钥和节点证书
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out node.key
gmssl req -new -sm3 -key node.key -config cert.cnf -out node.csr
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -sm3 -extensions v3_req -extfile cert.cnf
gmssl x509  -text -in node.crt | sed -n '5p' |  sed 's/://g' | tr "\n" " " | sed 's/ //g' | sed 's/[a-z]/\u&/g' | cat >node.serial

# 2. 生成证书链文件
cat ca.crt agency.crt  node.crt > chain.crt
```

将生成的 *node0* 节点的密钥及证书添加至 `~/thanos-chain/node0/resource/tls` 目录下。

```sh
cp ca.crt agency.crt ~/thanos-chain/node0/resource/tls
mv node.* chain.crt ~/thanos-chain/node0/resource/tls
```

**添加节点配置**

本节主要介绍节点部署需要添加的配置。配置文件中各配置项的具体含义参见 [thanos-chain 配置说明](./configuration.md)

1）在 `~/thanos-chain/node0/resource/` 目录下 添加节点的总配置文件 `thanos-chain.conf` 和日志管理配置 `chain-logback.xml` 。

`thanos-chain.conf` 内容如下。注意，涉及路径的配置项必须是<mark style="color:red;">绝对路径</mark>，如以下配置项：
* *resource . database . dir*
* *resource . logConfigPath*
* *tls . keyPath* 和 *tls . certsPath*

```editorconfig
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
    keyPath= "/root/thanos-chain/node0/resource/tls/node.key"
    certsPath= "/root/thanos-chain/node0/resource/tls/chain.crt"
}
```

`chain-logback.xml` 内容如下：

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

3）在 `~/thanos-chain/node0/database/` 目录下 添加节点身份配置文件 `nodeInfo.properties` 和 创世块配置文件 `genesis.json` 。

在配置 `nodeInfo.properties` 前，需要先为节点生成 privateKey 和 id ，请先找到并进入 `thanos-common.jar` 所在的目录，并执行以下指令

```bash
# "ECDSA" 是链选用的密钥算法，1 分片链的 id ，当前天玄还未实现分片，所以默认为 1 即可
java -jar ./thanos-common.jar "ECDSA" 1 1>>./node.private
```

打开 `node.private` 文件，会看到如下信息：

```editorconfig
#ECDSA
nodeIdPrivateKey = 0100017548b67007132aa98b0e924ce606624899df5760955a4d8f2a2dbda572d90f09
nodeId = 7b7bd52bef9840c91a8e6e51e2fab685916c60d770b8e5f0821a80cdb4b0dafccba540aa30b340662d6eebc70e2dd6e6bbcbac67af1377683bba18121ac6ede8
publicKey = 010001047b7bd52bef9840c91a8e6e51e2fab685916c60d770b8e5f0821a80cdb4b0dafccba540aa30b340662d6eebc70e2dd6e6bbcbac67af1377683bba18121ac6ede8
```

而后，配置 `nodeInfo.properties` 文件，替换 *nodeIdPrivateKey* 和 *nodeId* 部分。

```editorconfig
# ECDSA
name= xiaoming #节点名称
agency= agency #节点所属机构名称
caHash= caHash01 #节点证书序列号，暂未用到，可随意填
#节点私钥，从node.private文件获取
nodeIdPrivateKey= 0100017548b67007132aa98b0e924ce606624899df5760955a4d8f2a2dbda572d90f09
#节点id，从node.private文件获取
nodeId= 7b7bd52bef9840c91a8e6e51e2fab685916c60d770b8e5f0821a80cdb4b0dafccba540aa30b340662d6eebc70e2dd6e6bbcbac67af1377683bba18121ac6ede8
 
# AES
nodeEncryptKey= c9ec17b81d5abf18b979693faacbf917
 
# SM4
# nodeEncryptKey=a77ce8a55dbc209f052d6be716963ec2
```

注意：在配置 `nodeInfo.properties` 文件时，内容最好手动输入，否则在读取配置的时候可能会出现编码问题，nodeIdPrivateKey 和 nodeId 的值可以复制粘贴。否则，在运行节点时可能会遇到如下错误：

```
Exception in thread "main" org.spongycastle.util.encoders.DecoderException: exception decoding Hex string: 33410
        at org.spongycastle.util.encoders.Hex.decode(Hex.java:132)
        at com.thanos.chain.config.SystemConfig.getMyKey(SystemConfig.java:420)
        at com.thanos.chain.config.SystemConfig.getNodeId(SystemConfig.java:433)
        at com.thanos.chain.network.peer.PeerManager.<init>(PeerManager.java:103)
        at com.thanos.chain.initializer.ComponentInitializer.init(ComponentInitializer.java:21)
        at com.thanos.chain.Main.main(Main.java:23)
Caused by: java.lang.ArrayIndexOutOfBoundsException: 33410
        at org.spongycastle.util.encoders.HexEncoder.decode(HexEncoder.java:176)
        at org.spongycastle.util.encoders.Hex.decode(Hex.java:128)
        ... 5 more
```

`genesis.json` 内容如下，其中 *validatorVerifiers* 为组网节点身份信息
* *key* 为节点公钥
* *value* 为节点身份信息。

请替换 *validatorVerifiers* 中的条目信息为自己节点密钥信息。如将 *key* (如下配置中的 *0100....ede8*) 替换为自己的节点公钥将 `node.private` 文件中的 *publicKey* 。

```json
{
    "validatorVerifiers": {
        "010001047b7bd52bef9840c91a8e6e51e2fab685916c60d770b8e5f0821a80cdb4b0dafccba540aa30b340662d6eebc70e2dd6e6bbcbac67af1377683bba18121ac6ede8": {
      "consensusVotingPower": 1,
      "shardingNum": 1,
      "name": "xiaoming",
      "agency": "agency",
      "caHash": "caHash01"
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
    "maxShardingNum" : 1024,
    "shardingNum": 1,
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

至此，单节点配置完成，可以启动。启动方法为：在节点目录下 `~/thanos-chain/node0/` ，运行如下指令启动节点：

```bash
java  -Xmx256m -Xms256m -Xmn256m -Xss4M -jar thanos-chain.jar
```

如果运行时遇到如下报错:

```
15:46:30.639 ERROR [c.t.c.u.SSLUtil]  loadSSLContext error!
java.lang.SecurityException: JCE cannot authenticate the provider BC
        at javax.crypto.JceSecurity.getInstance(JceSecurity.java:118)
        at javax.crypto.KeyAgreement.getInstance(KeyAgreement.java:270)
        at org.bouncycastle.jcajce.util.ProviderJcaJceHelper.createKeyAgreement(Unknown Source)

```

需要手动将 `bcprov-jdk15on-1.66.jar` 包放置到 `$JAVA_HOME/jre/lib/ext` 目录下，可从此处下载：[https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bcprov-jdk15on-1.66.jar](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bcprov-jdk15on-1.66.jar)

### 1.2.2.6. 配置多节点

&#x20;当多个节点进行组网时，需要完成以下操作：

1）配置所有节点

重复 [配置单节点](installation.md#id3.1.2-an-zhuang-2-pei-zhi-dan-jie-dian) 的步骤完成各共识节点的配置。

2）修改所有节点的 `genesis.json` 配置文件

配置每个节点的 `genesis.json` 文件中的 *validatorVerifiers* 字段，使其包含所有组网节点的公钥和身份信息。举例如下，假设组网节点由 3 个节点组成，其节点信息如下：

```editorconfig
#node0 的 nodeInfo.properties文件内容
name=xiaoming
agency=agency01
caHash=caHash01
nodeIdPrivateKey=be5368036e55a89f9d01486f8b50d4a0076b644eb1dfeff5ec879d93d534bdfe
nodeId=0d3a176a1e51f68e04deda9c6437543dcd87db185b970476c611052b106a2422af7c496e09fd7f6215284ed83cb3b66bc24f9a318eded9ec7f6722fc52616e29
#publicKey=040d3a176a1e51f68e04deda9c6437543dcd87db185b970476c611052b106a2422af7c496e09fd7f6215284ed83cb3b66bc24f9a318eded9ec7f6722fc52616e29
  
#node2 的 nodeInfo.properties文件内容
name=xiaoming01
agency=agency02
caHash=caHash02
nodeIdPrivateKey=a2d68d25918e3d0f8962506517df742ef5c354ec8b516a54315e26e696b82198
nodeId=7cbf053e81cc2cd1896fc5470c428cad1432cc53d19976a40fa70cae0e3a4415cc1648fc37dc07b5fef0f2a7da71093a88f308adb0c8ca24b0dfe983f78a04f7
#publicKey=047cbf053e81cc2cd1896fc5470c428cad1432cc53d19976a40fa70cae0e3a4415cc1648fc37dc07b5fef0f2a7da71093a88f308adb0c8ca24b0dfe983f78a04f7
  
#node3 的 nodeInfo.properties文件内容
name=xiaoming02
agency=agency03
caHash=caHash03
nodeIdPrivateKey=d9694bc7257b6e11d5a6d3076b28fd9011b46fcc036fbfddf2d6f87866673480
nodeId=0be9f1ad6053103cd185995a34e92047eeeccfdeec6db7106d365f35603178ecf3e15e9a69cfbff9c950097fd7acf5190cc03cd7983261ac7f70fa82ca48ff93
#publicKey=040be9f1ad6053103cd185995a34e92047eeeccfdeec6db7106d365f35603178ecf3e15e9a69cfbff9c950097fd7acf5190cc03cd7983261ac7f70fa82ca48ff93
```

则需要配置这三个节点的 `genesis.json` 中的 *validatorVerifiers* 字段，内容如下。该字段包含所有共识节点的公钥和身份信息（ *key* 为节点公钥，*value* 为节点身份信息）。

```json
"validatorVerifiers": {
    "04142abb8c8604ae81aebd56927f372efb225052833316de6e19eb121ae12de6c42c333647b3f26642dd636b8cfd7510d1444c93caf91a535b60917ecb949ddc24": {
      "consensusVotingPower": 1,
      "shardingNum": 1,
      "name": "xiaoming",
      "agency": "agency01",
      "caHash": "caHash01"
    },
    "047cbf053e81cc2cd1896fc5470c428cad1432cc53d19976a40fa70cae0e3a4415cc1648fc37dc07b5fef0f2a7da71093a88f308adb0c8ca24b0dfe983f78a04f7": {
      "consensusVotingPower": 1,
      "shardingNum": 1,
      "name": "xiaoming02",
      "agency": "agency02",
      "caHash": "caHash02"
    },
    "040be9f1ad6053103cd185995a34e92047eeeccfdeec6db7106d365f35603178ecf3e15e9a69cfbff9c950097fd7acf5190cc03cd7983261ac7f70fa82ca48ff93": {
    "consensusVotingPower": 1,
    "shardingNum": 1,
    "name": "xiaoming03",
    "agency": "agency03",
    "caHash": "caHash03"
    }
}
```
