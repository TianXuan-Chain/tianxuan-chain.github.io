本教程脚本运行环境需要在 <mark>*Linux*</mark> 系统中进行，系统版本要求请见：[硬件需求](./hardware-requirement.md)。

## 1.3.1. 下载物料包

```bash
cd ~ #使用 root 作为起始工作目录

git clone https://github.com/TianXuan-Chain/thanos-package-generate.git #拉取物料包

cd ./thanos-package-generate #进入工作目录
```

## 1.3.2. 主要配置

找到 `config.ini` 文件。

```bash
vim config.ini #修改配置文件
```
### 1.3.2.1. \[chain-nodes] 配置项
找到 \[*chain-nodes*] 部分的配置，初始化服务器和节点的数量

```editorconfig
[chain-nodes]
# 格式为 : nodeIDX=p2p_ip listen_ip num agent
# IDX为索引, 从0开始增加.
# p2p_ip     => 服务器上用于p2p通信的网段的ip，多数时候都是公网ip.
# private_ip => 服务器的内网ip
# listen_ip  => 服务器上的监听端口, 用来接收rpc、channel的链接请求, 建议默认值为"0.0.0.0".
# num        => 在服务器上需要启动的节点的数目.
# agent      => 机构名称, 若是不关心机构信息, 值可以随意, 但是不可以为空.
# node0 = 111.111.111.111 10.10.0.1  0.0.0.0  1  agent

node0=101.35.234.166  10.0.16.7  0.0.0.0  1  agency
```

如果只用作测试需求，建议只运行一个节点即可。

```editorconfig
# 单节点示例配置如下，请修改后使用
node0=101.35.234.166  10.0.16.7  0.0.0.0  1  agency
```

如果想要部署多节点网络，按照下面格式配置即可。

```editorconfig
# 多节点示例配置如下，请修改后使用
node0=101.35.234.166  10.0.16.7  0.0.0.0  2  agency
node1=101.44.225.133  10.0.11.5  0.0.0.0  1  agency1
```

上面配置中初始设置两个服务器 *agency* 和 *agency1*，其中 *agency* 上运行两个节点，*agency1* 上运行一个节点，一共三个节点。

### 1.3.2.2. \[chain-ports] 和 \[gateway-ports] 配置项

一般使用默认值即可。但需要在服务器对应安全组中打开，并注意以下两个事项：
* 如果一台服务器上启动多个节点，节点使用的端口会以默认端口为基准往后递增 1
* 检查默认配置的端口在服务器上是否被占用，如被占用则需要修改，*Linux* 系统可使用 `sudo netstat -tlnp | grep 端口号` 命令查询

该部分配置与 [服务器端口开放要求](./hardware-requirement.md#网络及端口要求) 部分相对应。

```editorconfig
# 端口配置, 一般不用做修改, 使用默认值即可.
[chain-ports]
peer_discovery_port = 30303    #p2p端口
peer_rpc_port = 9080    #rpc端口
listen_gateway_port = 7580    #监听gateway的端口，用于接收交易

[gateway-ports]
peer_rpc_port = 100    #peer_rpc端口,用于gateway之间互发消息
web3_rpc_port = 8180    #web3_rpc_port端口，用于向web3sdk提供rpc接口服务
web3_http_port = 8580    #web3_http_port端口，用于向web3sdk提供http接口服务
listen_chain_port = 7180    #监听chain的端口，用于接收共识完成的区块
```

## 1.3.3. 生成安装包

配置修改好后，在项目目录下，执行以下命令。

```bash
bash build_chain.sh build
```

中间会有 *thanos-common* ，*thanos-gateway* ，*thanos-chain* 等模块的下载和 *Maven* 打包，需要等待片刻。当前目录下生成 `build` 目录后，表明脚本执行成功。

查看生成的 `build` 目录结构（配置了多服务器多节点时）。

```sh
tree -L 1 build
```
```
build
├── 101.35.234.160_agency.tar.gz
├── 43.130.226.84_agency.tar.gz
└── follow
```

其中，`101.35.234.160_agency.tar.gz` 和 `43.130.226.84_agency.tar.gz` 即为节点的安装包。

将压缩包上传到 *Ip* 对应的服务器上，就可以进行节点的安装和运行即可。

## 1.3.4. 其他配置说明 <a href="#id2.3-gou-jian-jie-dian-an-zhuang-bao-qi-ta-pei-zhi-shuo-ming" id="id2.3-gou-jian-jie-dian-an-zhuang-bao-qi-ta-pei-zhi-shuo-ming"></a>

注：下面介绍的相关配置，没有必要不需要改动


### 1.3.4.1. \[common] 配置项

配置一些基础信息

* 指定天玄链相关库的 *github* 地址，便于拉取代码
* 打包 *jar* 后的存放路径 (可以不配置)

```editorconfig
[common]
# 物料包拉取thanos-common/chain和gateway源码的github地址.
common_github_url = https://github.com/TianXuan-Chain/thanos-common.git
chain_github_url = https://github.com/TianXuan-Chain/thanos-chain.git
gateway_github_url = https://github.com/TianXuan-Chain/thanos-gateway.git

# 物料包拉取天玄链源码之后, 会将源码保存在本地的目录, 保存的目录为thanos-common，thanos-chain，thanos-gateway
# chain_src_local = /root/src

# 源码打成jar包的本地存放地址
# jar_local_path=/root/jar
```

### 1.3.4.2. \[tls] 和 \[crypto] 配置项

国密和密钥算法相关配置。

```editorconfig
[tls]
gm_tls_open = false    #tls是否使用国密，如不使用，则采取传统ECDSA。
gateway_need_tls = false    #gateway是否需要开启tls
 
[crypto]
secure_key_type = ECDSA    #节点公私钥对的生成算法 ECDSA 或 ED25519 或 SM
sharding_number = 1    #节点所属分片号，保持默认为 1 即可
cipher_key_type = AES    #节点对称密钥的算法算法：AES 或 SM4
```

### 1.3.4.3. \[maven-repo] 配置项

注意：该配置暂时已废弃，目前可忽略。

*Maven* 私库配置，可以将打包好的 *jar* 包上传到私有库中，对应的 *Maven* 配置文件里也需配置相应的 *Maven* 私库以及凭证信息。

```editorconfig
# mvn私库配置
[maven]
release_url=""
release_repositoryId=""
snapshot_url=""
snapshot_repositoryId=""
```
