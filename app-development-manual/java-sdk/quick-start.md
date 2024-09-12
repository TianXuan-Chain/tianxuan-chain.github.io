# 快速入门

## 前置条件 <a href="#id4.3.2-kuai-su-ru-men-qian-zhi-tiao-jian" id="id4.3.2-kuai-su-ru-men-qian-zhi-tiao-jian"></a>

在开始本教程前，请确保已经准备好了以下资源

* **JDK 1.8**： *Java* 应用需要依赖 *oracle jdk1.8* ，且 *JDK* 版本不低于 1.8.0u201
* **Maven3.3.9**： 项目编译需要依赖 *Maven*，且版本不低于 3.3.9
* **bcprov-jdk**： 在使用 *sdk* 时，需要在 *java* 运行环境中（具体为 `$JAVA_HOME`（*JDK* 所在目录）`/jre/lib/ext` 目录下）添加 [bcprov-jdk15on-1.66.jar](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bcprov-jdk15on-1.66.jar) 包
* **IDE**： 进入[*IntelliJ IDEA* 官网](https://www.jetbrains.com/idea/download/)，下载并安装社区版 *IntelliJ IDEA*
* **天玄测试链**： 请参考 [快速搭建天玄网络](../../quick-start/depoly-tianxaun-chain/README.md) 搭建，并获取到相应的 *http* 或者 *rpc* 链接
* **智能合约应用**： 请准备好需要部署的应用合约（本教程涉及的物料包中也提供了两个简单的智能合约示例）

## 编译智能合约 <a href="#id4.3.2-kuai-su-ru-men-bian-yi-zhi-neng-he-yue" id="id4.3.2-kuai-su-ru-men-bian-yi-zhi-neng-he-yue"></a>

目前天玄链支持 *solidity* 编译及运行最高版本为 0.4.25 ，且必须使用附件提供的 *solc* 编译工具编译合约

编译智能合约部分教程请使用 *Linux* 系统进行，推荐 <mark>*Centos 7+* 或者 *Ubuntu 18+*</mark> 。

### 获取相关物料包 <a href="#id4.3.2-kuai-su-ru-men-huo-qu-sdk-wu-liao-bao" id="id4.3.2-kuai-su-ru-men-huo-qu-sdk-wu-liao-bao"></a>

需要从 *GitHub* 上拉取 `thanos-web3j` 代码，由于 `thanos-web3j` 编译依赖于 `thanos-common.jar` ，所以还需要拉取 `thanos-common` 代码。

```bash
git clone https://github.com/TianXuan-Chain/thanos-web3j.git # thanos-web3j代码库
git clone https://github.com/TianXuan-Chain/thanos-common.git # thanos-common代码库 
```

### 编译 <a href="#id4.3.2-kuai-su-ru-men-huo-qu-sdk-wu-liao-bao" id="id4.3.2-kuai-su-ru-men-huo-qu-sdk-wu-liao-bao"></a>

按照依赖顺序，在编译 *thanos-common* 前，还需将其依赖的 `bctls-gm-jdk15on.jar` 加载到本地 *Maven* 仓库当中。

```
mvn install:install-file -Dfile=bctls-gm-jdk15on.jar -DgroupId=org.bouncycastle -DartifactId=bctls-gm-jdk15on -Dversion=0.1 -Dpackaging=jar
```

该文件可以从此处获取：[https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bctls-gm/bctls-gm-jdk15on.jar ](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bctls-gm/bctls-gm-jdk15on.jar)

而后，编译 `thanos-common` 。

```bash
cd thanos-common
mvn clean install -Dmaven.test.skip=true
```

编译后，`thanos-common.jar` 应已被加载到了本地 *Maven* 仓库当中。可以开始编译 *thanos-web3j* 了。

请先检查 *thanos-web3j* 内部文件是否具备可执行权限，如果不具备，可以使用以下指令。

```sh
chmod -R 777 thanos-web3j # 赋予目录内文件最高权限
```

而后运行编译脚本。

```sh
cd thanos-web3j
./compile.sh build
```

编译成功后会在当前目录下产生一个 dist 文件夹，该文件夹结构如下：

```
| 目录             | 说明                                       |
| -------------- | ---------------------------------------- |
| dist/apps      | web3sdk项目编译生成的jar包web3sdk.jar             |
| dist/bin       | - web3sdk: 可执行脚本，调用web3sdk.jar执行web3sdk内方法(如部署系统合约、调用合约工具方法等) <br>  - compile.sh: 调用该脚本可将dist/contracts目录下的合约代码转换成java代码，该功能便于用户基于web3sdk开发更多应用 |
| dist/conf      | 配置目录, 用于配置节点信息、证书信息、日志目录等，详细信息会在下节叙述     |
| dist/contracts | 合约存放目录，调用compile.sh脚本可将存放于该目录下的.sol格式合约代码转换成java代码 |
| dist/lib       | 存放web3sdk依赖库的jar包                         |
| dist/solc      | 存放合约编译工具,solc需要安装到/usr/local/bin/         |
```

如果 `compile.sh` 脚本执行失败，可能是服务器存在网络连接问题或者系统不兼容。可以手动安装 gradle 后进行编译。gradle 安装流程如下：

```bash
# Linux 系统
# 下载 gradle 文件
wget https://services.gradle.org/distributions/gradle-5.6.2-all.zip -P /software
# 解压
sudo unzip -d /software/gradle /software/gradle-5.6.2-all.zip
```

修改配置，将下面内容写入到 `gradle.sh` 中。

```bash
sudo vim /etc/profile.d/gradle.sh
```

```editorconfig
# 将下面下面写入 gradle.sh 中
export GRADLE_HOME=/software/gradle/gradle-5.6.2
export PATH=${GRADLE_HOME}/bin:${PATH}
```

而后执行脚本

```bash
sudo chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh
# 验证 gradle 安装
gradle -v
```

注意：如果第一步拉取 *gradle* 安装包失败，表明服务器网络连接 *gradle* 官网存在限制，请到 [官网网站](https://services.gradle.org/distributions/gradle-5.6.2-all.zip) 下载后上传到服务器。

*gradle* 安装完成后，如果是国内服务器，可以看需求是否修改为国内的镜像源。在 `{USER_HOME}/.gradle/` 目录下创建 `init.gradle` 文件，并添加下面内容：

```editorconfig
allprojects {
    repositories {
        def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/public'
        all { ArtifactRepository repo ->
            if (repo instanceof MavenArtifactRepository) {
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                    remove repo
                }
            }
        }
        maven { url ALIYUN_REPOSITORY_URL }
    }
}
```

安装配置完后，进入 `thanos-web3j` 目录，执行以下指令：

```
# 考虑到后续可能会依赖到 thanos-web3j.jar，所以将其发布到本地 Maven 仓库中
gradle publishToMavenLocal
# 如果不需要将 thanos-web3j.jar 发布到本地 Maven 仓库
# 可以使用 gradle build 指令
```

### 配置 java 运行环境 <a href="#id4.3.2-kuai-su-ru-men-an-zhuang-solc" id="id4.3.2-kuai-su-ru-men-an-zhuang-solc"></a>

在使用 *Web3j SDK* 时，需要在 *java* 运行环境中（具体为 `$JAVA_HOME/jre/lib/ext` 目录下）添加 `bcprov-jdk15on-1.66.jar` 包。该文件可以在此处获取：[https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bcprov-jdk15on-1.66.jar](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bcprov-jdk15on-1.66.jar)

### 安装 solc <a href="#id4.3.2-kuai-su-ru-men-an-zhuang-solc" id="id4.3.2-kuai-su-ru-men-an-zhuang-solc"></a>

将 `dist/solc` 目录下的可执行文件 `solc` 复制到 `/user/local/bin/` 目录下。

```sh
cd dist
cp ./solc/solc /usr/local/bin/
```

查看 *solc* 版本，确认是否安装成功。

```
solc --version
```

有版本信息输出，表示安装成功。

### 编译合约 <a href="#id4.3.2-kuai-su-ru-men-bian-yi-he-yue" id="id4.3.2-kuai-su-ru-men-bian-yi-he-yue"></a>

将需要编译的 *solidity* 合约代码放置到 `dist/contracts` 目录内，当前目录下有两个示例合约 `HelloWorld.sol` 和 `TokensDemo.sol` 。而后运行 `dist/bin/compile.sh` 脚本。

```sh
./bin/compile.sh com
```

执行成功后，会在 `dist` 文件夹内产生一个 `output` 文件夹，合约编译后对应的 *abi* ，*bin* 以及 *java* 文件（在 `com` 文件夹内）都存放在其中。 *java* 文件是基于 *abi* 与 *bin* 文件生成的，其中*abi* 与以太坊的一致，*abi*相关知识可以在此处了解：[https://docs.soliditylang.org/en/latest/abi-spec.html#](https://docs.soliditylang.org/en/latest/abi-spec.html)

## 部署并使用合约应用 <a href="#id4.3.2-kuai-su-ru-men-bu-shu-bing-shi-yong-ying-yong" id="id4.3.2-kuai-su-ru-men-bu-shu-bing-shi-yong-ying-yong"></a>

### 前置准备 <a href="#id4.3.2-kuai-su-ru-men-qian-zhi-zhun-bei" id="id4.3.2-kuai-su-ru-men-qian-zhi-zhun-bei"></a>

* 开始本部分教程时，默认用户已经准备好了<mark>编译为 *Java* 的合约应用</mark>。

* 这部分教程使用 *IntelliJ IDEA* 进行。如果上述流程和编写应用的不是一台机器 (例如：使用 *Windows* 系统进行)。请参考[应用部署示例](../../quick-start/deploy-thanos-app.md)在当前机器重新构建 *Maven* 本地依赖。


### 引入 SDK <a href="#id4.3.2-kuai-su-ru-men-yin-ru-sdk" id="id4.3.2-kuai-su-ru-men-yin-ru-sdk"></a>

**使用 *Gradle* 引入 *SDK***

```java
compile('com.netease.blockchain.thanos:thanos-web3j:1.7.3-SNAPSHOT')
```

**使用 *Maven* 引入 *SDK***

```xml
<dependency>
    <groupId>com.netease.blockchain.thanos</groupId>
    <artifactId>thanos-web3j</artifactId>
    <version>1.7.3-SNAPSHOT</version>
</dependency>
```

### 初始化 SDK 配置 <a href="#id4.3.2-kuai-su-ru-men-chu-shi-hua-sdk-pei-zhi" id="id4.3.2-kuai-su-ru-men-chu-shi-hua-sdk-pei-zhi"></a>

**1）通过 new 方法初始化 SystemConfig**

该方法使用了 *SystemConfig* 的 *new* 方法来初始化系统配置。方法入参说明如下：

```java
public SystemConfig(
    Integer web3Size,  //【rpc】 与单个链节点建立的rpc连接数
    Integer checkInterval, //【rpc】检查时间间隔，即多久检查一次 sdk与链节点之间的rpc连接是否正常
    List<String> gatewayHttpIPList, //【http】链节点 HTTP连接的ip+port列表
    List<String> gatewayRpcIPList,  //【rpc】链节点 RPC连接的ip+port列表
    Boolean needTLS, //【rpc】 rpc连接是否需要建立tls通道
    String certsPath, //【rpc】 建立tls通道时，sdk证书文件存放的绝对路径
    String keyPath, //【rpc】 建立tls通道时，sdk私钥文件存放的绝对路径
    String logConfigPath//【rpc】 日志配置文件存放路径
)
```

如果只需要建立 *HTTP* 连接。

```java
List<String> httpIpPortList = nodeList.stream().map(node -> node.getIp() + ":" + node.getHttpPort()).collect(Collectors.toList());
SystemConfig systemConfig = new SystemConfig(1, 60, httpIpPortList, new ArrayList<>(), false, null, null, null);
```

具体用法可参考 *thanos-web3j* 中的 `test.add.AddHttpTest` 示例文件。

如果只需要建立 *RPC* 连接。

```java
List<String> rpcIpPortList= nodeList.stream().map(node -> node.getIp() + ":" + node.getRPCPort()).collect(Collectors.toList());
SystemConfig systemConfig = new SystemConfig(1, 60, new ArrayList<>(), rpcIpPortList, true, certsPath, keyPath, null);
```

**2）通过配置文件初始化 Web3Manager**

使用 *SDK* 前，需要先生成两个配置文件：

* 主配置文件 `thanos-web3j.conf`
* 日志配置文件 `logback.xml`

配置文件说明文档详见：[*thanos-web3j* 配置说明](config.md)。

完整的应用及配置文件的目录相对关系如下：

```
├── resource
│   ├── logback.xml
│   ├── thanos-web3j.conf
│   └── tls
│       ├── chain.crt
│       └── sdk.key
└── thanos-test.jar(使用sdk的java应用)
```

首先，配置 `thanos-web3j.conf` 文件，示例如下：

```editorconfig
gateway = {
    # List of gateway peers to send msg
    rpc.ip.list = [
        #"127.0.0.1:8082"
        #"10.246.199.210:8182"
        "10.246.200.174:8180","10.246.200.174:8181"
    ]
        web3Size = 3
        #connection check interval (s)
        checkInterval = 60
 
    # List of gateway peers http port to send msg
    http.ip.list = [
        #"127.0.0.1:8082"
        "10.246.200.174:8580",
        "10.246.200.174:8581"
    ]
}
 
resource {
 #   logConfigPath = "F:\\myJava\\blockchain3.0\\thanos-web3j\\src\\main\\resources\\logback.xml"
}
 
#tls settings, such as path of keystore,truststore,etc
tls {
    needTLS = true
    keyPath="F:\\myJava\\blockchain3.0\\thanos-web3j\\src\\main\\resources\\gm-tls\\sdk.key"
    certsPath="F:\\myJava\\blockchain3.0\\thanos-web3j\\src\\main\\resources\\gm-tls\\chain.crt"
}
```

根据实际情况，修改如下配置：

* 日志配置文件所在路径 *logConfigPath* (要求是绝对路径)
* 如果应用需要使用链的 *http* 接口服务（包括合约部署和调用），需要修改配置项 *http.ip.list* ，对应网关所在机器 *ip* 和应用的 *http* 端口
* 如果应用需要使用链的rpc接口服务（除合约部署和调用外，还有权限管理），需要修改配置项 *rpc.ip.list* ，对应网关所在机器 *ip* 和应用的 *rpc* 端口。并修改 *tls* 配置项，配置 *SDK* 密钥文件和链证书文件路径

在业务系统中加载配置并完成 *Web3Manager* 的初始化。

```java
SystemConfig systemConfig = ConfigResourceUtil.loadSystemConfig();
```

### 初始化链连接器

加载日志路径，并使用 *SystemConfig* 初始化 *Web3manager*

```java
ConfigResourceUtil.loadLogConfig(systemConfig.logConfigPath());
Web3Manager web3Manager = new Web3Manager(systemConfig);
```

### SDK 调用

由于 *thanos-web3j* 提供了两种链连接方式（*rpc* 和 *http*），下面分别介绍每种连接方式的调用逻辑。

**1）HTTP接口调用**

初始化 *Web3j* 对象，连接网关节点的 *http* 接口

```java
Web3j web3j = web3Manager.getHttpWeb3jRandomly();
```

部署合约并发起交易，样例给出部署及调用 *SimpleToken* 合约的用例：

```java
SecureKey user = SecureKey.getInstance("ECDSA", 1); //随机生成密钥对
//SecureKey user = SecureKey.fromPrivate(Hex.decode("010001308f761b30da0baa33457550420bb8938d040a0c6f0582d9351fd5cead86ff11"));//根据私钥恢复密钥对
 
Credentials cred = Credentials.create(user);
  
SimpleToken simpleToken = SimpleToken.deploy(web3j, credentials, BigInteger.valueOf(1), BigInteger.valueOf(3000000), BigInteger.valueOf(0)).get();//部署合约
contractAddress = simpleToken.getContractAddress();
SimpleToken proxy = SimpleToken.load(contractAddress, web3j, credentials, BigInteger.ONE, BigInteger.valueOf(3000000));
ThanosTransactionReceipt receipt = proxy.transfer(new Address(users.get(i).getAddress()), new Uint256(amount)).get();//调用合约
```

由于 *http* 版本的 *Web3j* 对象采用长连接的方式。因此，在 *Web3j* 使用完成后，需要手动释放连接资源。

```java
finally {
    web3j.close();
}
```

**2）RPC接口调用**

初始化 *Web3j* 对象，连接网关节点的 *rpc* 通道。

```java
Web3j web3j = web3Manager.getWeb3jRandomly();
```

生成全局事件并发送上链，样例给出添加委员时的用例：

```java
Credentials credentials = Credentials.create(sender);
RawTransactionManager transactionManager = new RawTransactionManager(web3j, credentials);//生成交易管理器，用于发送交易
//组装全局事件，这里为投票准入委员事件
Long consensusNumber = transactionManager.getThanosLatestConsensusNumber();
Random r = new SecureRandom();
BigInteger randomid = new BigInteger(250, r);
byte[] proposalId = randomid.toByteArray();
VoteCommitteeCandidateEvent event = new VoteCommitteeCandidateEvent(0, 0, proposalId, candidateAddr);
ThanosGlobalNodeEvent globalNodeEvent = new ThanosGlobalNodeEvent(sender.getPubKey(), randomid.toByteArray(), consensusNumber + 10L, GlobalEventCommand.VOTE_COMMITTEE_CANDIDATE.getCode(), event.getEncoded(), (byte[])null);
//发送全局事件上链
EthSendTransaction transaction = transactionManager.sendGlobalNodeEvent(globalNodeEvent);
String str = transaction.getTransactionHash();
logger.debug("addCommittee txHash:{}", str);
//根据事件hash查询全局事件链上执行的回执，并根据回执判断是否成功。
 
ThanosGlobalNodeEventReceipt receipt = transactionManager.waitForGlobalNodeEventReceipt(str);
if (receipt == null || receipt.getExecutionResult() == null) {
    logger.warn("CommitteeManager voteForAddCommittee receipt is null.");
    return false;
}
 
int executeResult = ByteUtil.byteArrayToInt(receipt.getExecutionResult());
if (CandidateEventConstant.VOTE_FAILED == executeResult) {
    logger.error("CommitteeManager voteForAddCommittee failed. receipt:{}", receipt);
}
```

