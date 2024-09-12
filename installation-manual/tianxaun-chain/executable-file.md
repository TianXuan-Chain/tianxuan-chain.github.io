# 打包可执行文件

注意：下述流程需要在同一台机器上完成，因为涉及到本地 maven 包相互依赖的问题

完成下述步骤后，将会获得 thanos-chain.jar 和 thanos-gateway.jar 两个可执行 jar 包。

## 安装依赖 <a href="#id3.1.1-huo-qu-ke-zhi-xing-wen-jian-yi-an-zhuang-yi-lai" id="id3.1.1-huo-qu-ke-zhi-xing-wen-jian-yi-an-zhuang-yi-lai"></a>

获取可执行文件之前，需要先安装如下软件

* Oracle JDK 1.8
* Maven 3.3.9
* git

上述软件的安装教程可见：[软件安装](../../quick-start/depoly-thanos-chain/software-requirement.md)

## 打包 thanos-common <a href="#id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon" id="id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon"></a>

thanos-common 包需要依赖于 bctls-gm-jdk15on.jar ，需要提前加载到本地库。该依赖包可在此处获取：[https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bctls-gm/bctls-gm-jdk15on.jar](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/bctls-gm/bctls-gm-jdk15on.jar)

获取后将其加载到本地的 Maven 仓库中

<pre class="language-bash"><code class="lang-bash"><strong>mvn install:install-file -Dfile=bctls-gm-jdk15on.jar -DgroupId=org.bouncycastle -DartifactId=bctls-gm-jdk15on -Dversion=0.1 -Dpackaging=jar
</strong></code></pre>

该依赖包加载成功后，开始 thanos-common 编译打包

<pre class="language-bash"><code class="lang-bash"><strong># thanos-common 代码已经开源，从 github 上拉取下载
</strong><strong>git clone https://github.com/TianXuan-Chain/thanos-common.git
</strong># 进入项目文件夹
cd thanos-common
# 编译
mvn clean install -Dmaven.test.skip=true
</code></pre>

打包命令执行后，会在 target 目录下生成 thanos-common.jar 包，并且该 jar 包会被自动加载到本地的 Maven 仓库中

## 打包 thanos-gateway <a href="#id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon" id="id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon"></a>

thanos-gateway 项目依赖于 thanos-common ，按照本教程流程，thanos-common.jar 以应被加载到了本地 Maven 库中。直接编译打包本项目即可。

```
# thanos-gateway 代码已经开源，从 github 上拉取下载
git clone https://github.com/TianXuan-Chain/thanos-gateway.git
# 进入项目文件夹
cd thanos-gateway
# 编译
mvn clean install -Dmaven.test.skip=true
```

打包命令执行成功后，会在target目录下生成 thanos-gateway.jar&#x20;

## 打包 thanos-chain <a href="#id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon" id="id3.1.1-huo-qu-ke-zhi-xing-wen-jian-san-da-bao-thanoscommon"></a>

thanos-chain 应用，除了依赖 thanos-common.jar 以外，还依赖于 solcJ-all-0.4.25.jar 。按照文档执行顺序，thanos-common.jar 以应被加载到了本地 Maven 库中，还需要手动加载一下 solcJ-all-0.4.25.jar 到本地库，该 jar 包可在此处下载：[https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/solc/solcJ-all-0.4.25.jar](https://github.com/TianXuan-Chain/thanos-package-generate/blob/main/dependencies/jar/solc/solcJ-all-0.4.25.jar)

```sh
# 将 solcJ-all-0.4.25.jar 加载到本地库
mvn install:install-file -DgroupId=org.ethereum -DartifactId=solcJ-all -Dversion=0.4.25 -Dversion=0.4.25 -Dpackaging=jar -Dfile=solcJ-all-0.4.25.jar
```

该依赖包加载成功后，开始 thanos-chain 编译打包。

```
# thanos-chain 代码已经开源，从 github 上拉取下载
git clone https://github.com/TianXuan-Chain/thanos-chain.git
# 进入项目文件夹
cd thanos-chain
# 编译
mvn clean install -Dmaven.test.skip=true
```
打包命令执行成功后，会在target目录下生成 thanos-chain.jar&#x20;

