# 构建节点安装包

## 下载物料包

```
$ git clone https//github.com/netease-blockchain/thanos-package-generate.git
```

## 主要配置

找到 config.ini 文件。

<pre><code><strong>$ cd ./thanos-package-generate
</strong><strong>$ vim config.ini
</strong></code></pre>

找到 \[chain-nodes] 部分的配置，初始化服务器和节点的数量

```
[chain-nodes]
# 格式为 : nodeIDX=p2p_ip listen_ip num agent
# IDX为索引, 从0开始增加.
# p2p_ip     => 服务器上用于p2p通信的网段的ip.
# listen_ip  => 服务器上的监听端口, 用来接收rpc、channel的链接请求, 建议默认值为"0.0.0.0".
# num        => 在服务器上需要启动的节点的数目.
# agent      => 机构名称, 若是不关心机构信息, 值可以随意, 但是不可以为空.
node0 = 127.0.0.1  0.0.0.0  1  agent
```

如果只用作测试需求，建议只运行一个节点即可。

```
node0=101.35.234.159  0.0.0.0  1  agency
```

如果想要部署多节点网络，按照下面格式配置即可。

```
node0=101.35.234.159  0.0.0.0  2  agency
node1=43.130.226.83  0.0.0.0  1  agency1
```

上面配置中初始设置两个服务器 agency 和 agency1，其中 agency 上运行两个节点，agency1 上运行一个节点，一共三个节点。

## 生成安装包

配置修改好后，在项目目录下，执行以下命令。

```
$ bash build_chain.sh build
```

中间会有 thanos-common，thanos-gateway，thanos-chain 等应用的下载和 maven 打包，需要等待片刻，执行成功后会在当前目录下生成 build 目录。

查看生成的build目录结构（多节点配置时）。

```
$tree -L 1 build
build
├── 101.35.234.160_agency.tar.gz
├── 43.130.226.84_agency.tar.gz
└── follow
```

其中，101.35.234.160\_agency.tar.gz 和 43.130.226.84\_agency.tar.gz 即为节点的安装包。

将压缩包上传到 ip 对应的服务器上，就可以进行节点的安装和运行即可。

## 其他配置说明 <a href="#id2.3-gou-jian-jie-dian-an-zhuang-bao-qi-ta-pei-zhi-shuo-ming" id="id2.3-gou-jian-jie-dian-an-zhuang-bao-qi-ta-pei-zhi-shuo-ming"></a>

注：下面介绍的相关配置，没有必要不需要改动

### 安装脚本配置 <a href="#id2.3-gou-jian-jie-dian-an-zhuang-bao-an-zhuang-jiao-ben-pei-zhi" id="id2.3-gou-jian-jie-dian-an-zhuang-bao-an-zhuang-jiao-ben-pei-zhi"></a>

**\[common] 部分**

配置一些基础信息

* 指定 thanos 相关库的 github 地址，便于拉取代码
* 打包 jar 后的存放路径

```
[common]
# 物料包拉取thanos-common/chain和gateway源码的github地址.
common_github_url = https://github.com/TianXuan-Chain/thanos-common.git
chain_github_url = https://github.com/TianXuan-Chain/thanos-chain.git
gateway_github_url = https://github.com/TianXuan-Chain/thanos-gateway.git
# 物料包拉取天玄源码之后, 会将源码保存在本地的目录, 保存的目录为thanos-common，thanos-chain，thanos-gateway
# chain_src_local = /root/src
# 源码打成jar包的本地存放地址
# jar_local_path=/root/jar
```

**\[chain-ports] 和 \[gateway-ports] 部分**

一般使用默认值即可。需要注意的是，如果一台服务器上启动多个节点，节点使用的端口会往后递增1。注意在服务器安全组中，将相应的端口都打开。

```
# 端口配置, 一般不用做修改, 使用默认值即可.
[chain-ports]
# p2p端口
peer_discovery_port = 30303
# rpc端口
peer_rpc_port = 9080
# 监听gateway的端口，用于接收交易
listen_gateway_port = 7580
 
[gateway-ports]
# peer_rpc端口,用于gateway之间互发消息
peer_rpc_port = 100
# web3_rpc_port端口，用于向web3sdk提供rpc接口服务
web3_rpc_port = 8180
# web3_http_port端口，用于向web3sdk提供http接口服务
web3_http_port = 8580
# 监听chain的端口，用于接收共识完成的区块
listen_chain_port = 7180
```

**\[tls] 和 \[crypto] 部分**

国密和密钥算法相关配置

```
[tls]
# tls是否使用国密，如不使用，则采取传统ECDSA。
gm_tls_open = false
# gateway是否需要开启tls
gateway_need_tls = false
 
[crypto]
# 节点公私钥对的生成算法 ECDSA 或 ED25519 或 SM
secure_key_type = ECDSA
# 节点所属分片号
sharding_number = 1
# 节点对称密钥的算法算法：AES 或 SM4
cipher_key_type = AES
```

**\[maven-repo] 部分**

注意：该配置暂时已废弃，目前可忽略

maven 私库配置，可以将打包好的 jar 包上传到私有库中，对应的 maven 配置文件里也需配置相应的 maven 私库以及凭证信息。

<pre><code><strong># mvn私库配置
</strong>[maven]
release_url= ......
release_repositoryId=nexus-releases
snapshot_url= ......
snapshot_repositoryId=nexus-snapshots
</code></pre>
