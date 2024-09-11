# 创建和使用账户

## 生成账户 <a href="#id4.1-chuang-jian-he-shi-yong-zhang-hu-sheng-cheng-zhang-hu" id="id4.1-chuang-jian-he-shi-yong-zhang-hu-sheng-cheng-zhang-hu"></a>

下面是使用 Java SDK 创建一个随机账户的方法，总共支持三种加密算法

**1）ECDSA**

```java
SecureKey secureKey = SecureKey.getInstance("ECDSA", 1);
Credentials credentials = Credentials.create(secureKey);
```

**2）SM**

```java
SecureKey secureKey = SecureKey.getInstance("SM", 1);
Credentials credentials = Credentials.create(secureKey);
```

**3）ED25519**

```java
SecureKey secureKey = SecureKey.getInstance("ED25519", 1);
Credentials credentials = Credentials.create(secureKey);
```

具体使用哪一种需要跟 sdk 配置保持一致，具体见 thanos-web3j.conf：

```editorconfig
crypto {
    #JCA cryptoprovider name.
    providerName="SC"
    #JCA sign Algorithm,such as ECDSA, ED25519 etc
    sign.algorithm="ECDSA"
    #sign.algorithm="ED25519"
    #sign.algorithm="SM"
    #Used for create JCA MessageDigest
    hash.alg256="ETH-KECCAK-256"
    hash.alg256="ETH-KECCAK-256-LIGHT"
    hash.alg512="ETH-KECCAK-512"
}
```

使用指定私钥创建账户的方式如下，以 ECDSA 为例

```java
// SecureKey.fromPrivate(privateKeyBytes);
SecureKey secureKey = SecureKey.fromPrivate(Hex.decode("010001308f761b30da0baa33457550420bb8938d040a0c6f0582d9351fd5cead86ff12"));
Credentials credentials = Credentials.create(secureKey);
```

获取账户地址的方式如下

```java
String accountAddr = credentials.getAddress();
```

## 账户地址的计算 <a href="#id4.1-chuang-jian-he-shi-yong-zhang-hu-zhang-hu-di-zhi-de-ji-suan" id="id4.1-chuang-jian-he-shi-yong-zhang-hu-zhang-hu-di-zhi-de-ji-suan"></a>

账户地址由ECDSA公钥计算得来，与以太坊兼容，对ECDSA公钥的16进制表示计算keccak-256sum哈希，取计算结果的后20字节的16进制表示作为账户地址，每个字节需要两个16进制数表示，所以账户地址长度为40。

**1）生成ECDSA私钥**

首先，我们使用OpenSSL生成椭圆曲线私钥，椭圆曲线的参数使用secp256k1。执行下面的命令，生成PEM格式的私钥并保存在ecprivkey.pem文件中。

```bash
openssl ecparam -name secp256k1 -genkey -noout -out ecprivkey.pem
```

执行下面的指令，查看文件内容。

```
cat ecprivkey.pem
```

可以看到类似下面的输出:

```
-----BEGIN EC PRIVATE KEY-----
MHQCAQEEINHaCmLhw9S9+vD0IOSUd9IhHO9bBVJXTbbBeTyFNvesoAcGBSuBBAAK
oUQDQgAEjSUbQAZn4tzHnsbeahQ2J0AeMu0iNOxpdpyPo3j9Diq3qdljrv07wvjx
zOzLpUNRcJCC5hnU500MD+4+Zxc8zQ==
-----END EC PRIVATE KEY-----
```

接下来根据额私钥计算公钥，执行下面指令

```bash
openssl ec -in ecprivkey.pem -text -noout 2>/dev/null| sed -n '7,11p' | tr -d ": \n" | awk '{print substr($0,3);}'
```

可以得到类似下面的输出：

```
8d251b400667e2dcc79ec6de6a143627401e32ed2234ec69769c8fa378fd0e2ab7a9d963aefd3bc2f8f1cceccba54351709082e619d4e74d0c0fee3e67173ccd
```

**2）根据公钥计算地址**

本节我们根据公钥计算对应的账户地址。我们需要获取keccak-256sum工具，可以从[这里下载](https://github.com/vkobel/ethereum-generate-wallet/tree/master/lib)。

```bash
openssl ec -in ecprivkey.pem -text -noout 2>/dev/null| sed -n '7,11p' | tr -d ": \n" | awk '{print substr($0,3);}' | ./keccak-256sum -x -l | tr -d ' -' | tail -c 41
```

得到类似下面的输出，就是计算得出的账户地址。

```
dcc703c0e500b653ca82273b7bfad8045d85a470
```
