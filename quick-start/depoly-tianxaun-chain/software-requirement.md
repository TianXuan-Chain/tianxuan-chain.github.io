## 1.2.1. 要求清单 <a href="#id2.2-ruan-jian-yao-qiu-yao-qiu-qing-dan" id="id2.2-ruan-jian-yao-qiu-yao-qiu-qing-dan"></a>

天玄链和网关提供一键安装部署的脚本，方便用户快速搭建一条测试链。

在执行此脚本前，依赖的软件需要预先在执行脚本的服务器上安装好，具体的软件清单如下：

* 运行 "节点安装包构建脚本" 需要：
  * Oracle JDK - 1.8
  * Maven - 3.3.9
  * Git
  * Crudini
* 运行 "节点安装与启动脚本" 需要：
  * Oracle JDK - 1.8
  * Crudini

## 1.2.2. 安装教程 <a href="#id2.2-ruan-jian-yao-qiu-an-zhuang-jiao-cheng" id="id2.2-ruan-jian-yao-qiu-an-zhuang-jiao-cheng"></a>

### 1.2.2.1. Oracle JDK \[1.8] 安装 <a href="#id2.2-ruan-jian-yao-qiu-oraclejdk1.8-an-zhuang-oraclejdk" id="id2.2-ruan-jian-yao-qiu-oraclejdk1.8-an-zhuang-oraclejdk"></a>

```sh
# 创建新的文件夹，安装Java 8或以上的版本，将下载的jdk放在software目录
# 从Oracle官网( https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html ) 选择Java 8版本下载，推荐下载jdk-8u201-linux-x64.tar.gz
mkdir /software
# 解压jdk
tar -zxvf jdk-8u201-linux-x64.tar.gz
# 配置Java环境，编辑/etc/profile文件
vim /etc/profile
```

```editorconfig
# 打开以后将下面三句输入到文件里面并退出
export JAVA_HOME=/software/jdk1.8.0_201  #这是一个文件目录，非文件
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

```sh
# 生效profile
source /etc/profile
# 查询Java版本，出现的版本是自己下载的版本，则安装成功。
java -version
```

**配置 jdk 的熵池**

打开 `$JAVA_PATH/jre/lib/security/java.security` 这个文件，找到下面的内容：

```editorconfig
# 将
securerandom.source=file:/dev/random
# 替换成
securerandom.source=file:/dev/urandom
```

### 1.2.2.2. Maven \[3.3.9] 安装 <a href="#id2.2-ruan-jian-yao-qiu-maven3.3.9-an-zhuang-maven" id="id2.2-ruan-jian-yao-qiu-maven3.3.9-an-zhuang-maven"></a>

```sh
# 下载安装文件
cd /software
wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
# 解压maven
tar -zxvf apache-maven-3.3.9-bin.tar.gz
# 配置环境变量
# 使用vim编辑/etc/profile文件
vim /etc/profile
```

```editorconfig
# 在 /etc/profile 文件末尾增加以下配置：
MAVEN_HOME=/software/apache-maven-3.3.9
export PATH=${MAVEN_HOME}/bin:${PATH}
```

```sh
# 生效profile
source /etc/profile
# 查询Maven版本，出现的版本是自己下载的版本，则安装成功。
mvn -v
```

国内服务器有需要的话，在 *Maven* 的 `setting.xml` 中更新一下 *aliyun* 的镜像源，后续在执行 *Maven* 执行的时候，下载速度会快一些。

```xml
<mirror>
  <id>nexus-aliyun</id>
  <mirrorOf>central</mirrorOf>
  <name>Nexus aliyun</name>
  <url>>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>
```

### 1.2.2.3. Git 安装 <a href="#id2.2-ruan-jian-yao-qiu-git-an-zhuang-git" id="id2.2-ruan-jian-yao-qiu-git-an-zhuang-git"></a>

下载开发部署工具的源码需要依赖 *Git* ，安装命令如下：

```sh
# Ubuntu 系统
sudo apt install -y git
```

```sh
# CentOS 系统
sudo yum install -y git
```

配置 *git* 密钥 (可选) ：

* 将自己的 *github* 账户私钥上传到 `~/.ssh/` 目录下
* 修改私钥访问权限 `chmod 600 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub`

### 1.2.2.4. Crudini 安装 <a href="#id2.2-ruan-jian-yao-qiu-crudini-an-zhuang-crudini" id="id2.2-ruan-jian-yao-qiu-crudini-an-zhuang-crudini"></a>

机器需要安装 *crudini* 。

```sh
# Ubuntu 系统
sudo apt-get install -y crudini
```

```sh
# CentOS 系统
sudo yum install -y crudini
```

检查安装结果。

```sh
type crudini
# 返回类似如下信息即为安装成功：
# crudini is /usr/bin/crudini
```

如果直接安装失败，则需要配置 *epel* 源。

```sh
#配置yum源为aliyun
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
sudo yum -y install crudini
```
