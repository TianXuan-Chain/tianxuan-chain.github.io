## 1.4.1. 概述 <a href="#id3.1.4-zheng-shu-shuo-ming-yi-gai-shu" id="id3.1.4-zheng-shu-shuo-ming-yi-gai-shu"></a>

天玄采用面向 *CA* 的节点准入机制，支持任意多级的证书结构，保障信息保密性、认证性、完整性、不可抵赖性。

天玄使用 [x509 协议的证书格式](https://en.wikipedia.org/wiki/X.509)，根据现有业务场景，默认采用三级的证书结构，自上而下分别为链证书、机构证书、节点证书。

每条链拥有一个链证书及对应的链私钥，链私钥由联盟链委员会共同管理。联盟链委员会可以根据机构的证书请求文件，使用链私钥签发机构证书。

机构私钥由机构管理员持有，可以对机构下属节点签发节点证书。

节点证书是节点身份的凭证，用于与其他持有合法证书的节点间建立 *SSL* 连接，并进行加密通讯。

天玄节点运行时的文件后缀介绍如下：

| .key | 私钥文件   |
| ---- | ------ |
| .crt | 证书文件   |
| .csr | 证书请求文件 |

## 1.4.2. 角色定义 <a href="#id3.1.4-zheng-shu-shuo-ming-er-jue-se-ding-yi" id="id3.1.4-zheng-shu-shuo-ming-er-jue-se-ding-yi"></a>

天玄证书结构中，共有三种角色，分别是联盟链委员会管理员、机构、节点。

**1）联盟链委员会**

联盟链委员会负责管理链私钥，并根据机构的证书请求文件，为机构颁发机构证书。

联盟链委员会管理文件如下：

```editorconfig
ca.crt # 链证书
ca.key # 链私钥
```

注意：节点建立 TLS 链接时，只有拥有相同链证书 `ca.crt` 的节点才可建立连接。

**2）机构**

机构管理员管理机构私钥，可以颁发节点证书。

机构管理员管理文件如下：

```
ca.crt      #链证书
agency.crt  #机构证书
agency.csr  #机构证书请求文件
agency.key  #机构私钥
```

**3）节点**

节点保存链证书、机构证书、节点证书和私钥，用于建立节点间 *TLS* 链接。

```
ca.crt      #链证书
agency.crt  #机构证书
node.crt    #节点证书
node.csr    #节点证书请求文件
node.key    #节点私钥
chain.crt   #链式证书文件，由 ca.crt agency.crt node.crt 合并而成
```

## 1.4.3. 证书生成流程 <a href="#id3.1.4-zheng-shu-shuo-ming-san-zheng-shu-sheng-cheng-liu-cheng" id="id3.1.4-zheng-shu-shuo-ming-san-zheng-shu-sheng-cheng-liu-cheng"></a>

注意：需要安装好 *GmSSL-v2* ，可参考 [GmSSL-v2 安装](../../installation-manual/tianxaun-chain/installation.md#前置依赖软件)

证书生成流程如下

**1）生成链证书**

联盟链委员会使用 *openssl* 命令请求链私钥 `ca.key` ，根据 `ca.key` 生成链证书 `ca.crt` 。

非国密
```sh
# 生成根ca的私钥ca.key与自签名证书ca.crt
gmssl genrsa -out ca.key 2048
gmssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```

国密

```sh
# 生成根ca的私钥ca.key与自签名证书ca.crt
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out ca.key
gmssl req -new -x509 -days 365 -key ca.key -sm3 -out ca.crt
```

**2）生成机构证书**

机构管理员使用 `openssl` 命令生成机构私钥 `agency.key` ，然后生成机构证书请求文件 `agency.csr` 并发送给联盟链委员会。联盟链委员会使用链私钥 `ca.key` ，根据得到机构证书请求文件 `agency.csr` 生成机构证书 `agency.crt` ，并将机构证书发送给对应机构管理员。

非国密

```sh
# 生成机构私钥agency.key与证书agency.crt (由根ca签发)
gmssl genrsa -out agency.key 2048
gmssl req -new -key agency.key -config cert.cnf -out agency.csr
gmssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -CAcreateserial -in agency.csr -out agency.crt  -extensions v4_req -extfile cert.cnf
```

国密

```sh
# 生成机构私钥agency.key与证书agency.crt (由根ca签发)
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out agency.key
gmssl req -new -sm3 -key agency.key -config cert.cnf -out agency.csr
gmssl x509 -req -days 3650 -CA ca.crt -CAkey ca.key -in agency.csr -out agency.crt -CAcreateserial -sm3 -extensions v4_req -extfile cert.cnf
```

配置文件 `cert.cnf` 的内容格式如下：

```editorconfig
[ca]
default_ca=default_ca //默认CA在[default_ca]段配置

[default_ca]
default_days = 365 //证书的默认有效期
default_md = sha256 //默认使用的摘要算法

[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = CN
countryName_default = CN //国家名称默认值
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = ZheJiang //省份默认值
localityName = Locality Name (eg, city)
localityName_default = HangZhou //城市默认值
organizationalUnitName = Organizational Unit Name (eg, section)
organizationalUnitName_default = netease //机构所属单位默认值
commonName =  Organizational  commonName (eg, netease)
commonName_default = netease //机构名称默认值
commonName_max = 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE //指明证书非CA证书
keyUsage = nonRepudiation, digitalSignature, keyEncipherment //指明密钥使用场景，包括加密和签名等

[ v4_req ]
basicConstraints = CA:TRUE //指明证书是CA证书
```

**3）生成节点证书**

节点生成私钥 `node.key` 和证书请求文件 `node.csr` 。而后机构管理员使用私钥 `agency.key` 为证书请求文件 `node.csr` 颁发证书。

非国密

```sh
# 1.生成节点私钥和节点证书
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:secp256k1 -out node.key
gmssl req -new -key node.key -config cert.cnf  -out node.csr
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -extensions v3_req -extfile cert.cnf
gmssl x509  -text -in node.crt | sed -n '5p' |  sed 's/://g' | tr "\n" " " | sed 's/ //g' | sed 's/[a-z]/\u&/g' | cat >node.serial
```

国密

```sh
# 1.生成节点私钥和节点证书
gmssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:sm2p256v1 -out node.key
gmssl req -new -sm3 -key node.key -config cert.cnf -out node.csr
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -sm3 -extensions v3_req -extfile cert.cnf
gmssl x509  -text -in node.crt | sed -n '5p' |  sed 's/://g' | tr "\n" " " | sed 's/ //g' | sed 's/[a-z]/\u&/g' | cat >node.serial
```

而后将多级证书合并成证书链文件 `chain.crt` (国密/非国密通用步骤) 。

```bash
# 2. 生成证书链文件
cat ca.crt agency.crt  node.crt > chain.crt
```

**4）生成节点密钥库文件**

由于 *Java* 建立 *tls* 链接需要读取 *keystore* 和 *truststore* 文件 (也可设置为不需要密钥)。因此，需要将节点私钥、节点/机构/链证书 转换成 *jks* 文件。

```bash
# 导出keystore文件
# step1: 合并证书链至chain.crt文件
cat ca.crt agency.crt  node.crt > chain.crt

# step2: 生成包含节点私钥和证书的pkcs12证书 node.p12
openssl pkcs12 -export -in node.crt -inkey node.key -out node.p12 -passout pass:123456 -name node_key

# step3: 将pkcs12证书转换成jks文件keystore.jks
keytool -importkeystore -v -srckeystore node.p12 -srcstoretype pkcs12 -srcstorepass 123456 -destkeystore keystore.jks -deststoretype jks -deststorepass 123456

# step4：向keystore中添加证书链
keytool -keystore keystore.jks -importcert -alias node_key -storepass 123456 -file chain.crt
 
# 导出truststore文件
keytool -keystore truststore.jks  -importcert  -storepass 123456 -file ca.crt
```

## 1.4.4. 节点证书续期操作 <a href="#id3.1.4-zheng-shu-shuo-ming-si-jie-dian-zheng-shu-xu-qi-cao-zuo" id="id3.1.4-zheng-shu-shuo-ming-si-jie-dian-zheng-shu-xu-qi-cao-zuo"></a>

当证书过期时，需要用户使用当前节点私钥重新申请证书，操作如下：

**1）节点将`node.csr`发送给所属机构，机构管理者使用机构私钥重新签发节点证书**

非国密

```sh
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -extensions v3_req -extfile cert.cnf
```

国密

```sh
gmssl x509 -req -days 3650 -in node.csr -CAkey agency.key -CA agency.crt -out node.crt -CAcreateserial -sm3 -extensions v3_req -extfile cert.cnf
```

**2）节点收到更新后的节点证书，更新本地密钥文件**

```
# 合并证书链至 chain.crt 文件
cat ca.crt agency.crt  node.crt > chain.crt
```

**3）将生成的节点密钥库文件添加至节点对应目录下，如 `node0` 的 `~/thanos-chain/node0/resource/tls` 目录**

## 1.4.5. 三级证书续期流程 <a href="#id3.1.4-zheng-shu-shuo-ming-wu-san-ji-zheng-shu-xu-qi-liu-cheng" id="id3.1.4-zheng-shu-shuo-ming-wu-san-ji-zheng-shu-xu-qi-liu-cheng"></a>

当整条链的证书均已过期时，需要重新对整条链的证书进行续期操作，续期证书的OpenSSL命令与证书生成流程基本相同，简要步骤如下：

1）使用链私钥 `ca.key` 重新签发链证书 `ca.crt`

2）使用链私钥 `ca.key` 和链证书 `ca.crt` 对机构证书请求文件 `agency.csr` 签发得到机构证书 `agency.crt`

3）使用机构私钥 `agency.key` 和机构证书 `agency.crt` 对证书请求文件 `node.csr` 签发得到节点证书 `node.crt`

4）使用新生成的节点私钥 `node.key` 以及 节点证书、机构证书和链证书组成证书链文件 `chain.crt` ，并替换节点 `/resource/tls` 目录下的旧文件。
