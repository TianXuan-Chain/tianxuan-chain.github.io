# 软件要求

## 要求清单 <a href="#id2.2-ruan-jian-yao-qiu-yao-qiu-qing-dan" id="id2.2-ruan-jian-yao-qiu-yao-qiu-qing-dan"></a>

天玄链和网关提供一键安装部署的脚本，方便用户快速搭建一条测试链。

在执行此脚本前，依赖的软件需要预先在执行脚本的服务器上安装好，具体的软件清单如下：

* 运行 “节点安装包构建” 脚本需要
  * [Oracle JDK - 1.8](#oracle-jdk-18-安装)
  * [Maven - 3.3.9](#maven-339-安装)
  * [Git](#git-安装)
  * [Crudini](#crudini-安装)
* 运行 “节点安装与启动” 脚本需要
  * [Oracle JDK - 1.8](#oracle-jdk-18-安装)
  * [Crudini](#crudini-安装)

## 安装教程 <a href="#id2.2-ruan-jian-yao-qiu-an-zhuang-jiao-cheng" id="id2.2-ruan-jian-yao-qiu-an-zhuang-jiao-cheng"></a>

### Oracle JDK \[1.8] 安装 <a href="#id2.2-ruan-jian-yao-qiu-oraclejdk1.8-an-zhuang-oraclejdk" id="id2.2-ruan-jian-yao-qiu-oraclejdk1.8-an-zhuang-oraclejdk"></a>

```
# 创建新的文件夹，安装Java 8或以上的版本，将下载的jdk放在software目录
# 从Oracle官网( https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html ) 选择Java 8版本下载，推荐下载jdk-8u201-linux-x64.tar.gz
$ mkdir /software
# 解压jdk
$ tar -zxvf jdk-8u201-linux-x64.tar.gz
# 配置Java环境，编辑/etc/profile文件
$ vim /etc/profile
# 打开以后将下面三句输入到文件里面并退出
export JAVA_HOME=/software/jdk1.8.0_201  #这是一个文件目录，非文件
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# 生效profile
$ source /etc/profile
# 查询Java版本，出现的版本是自己下载的版本，则安装成功。
$ java -version
```

**配置 jdk 的熵池**

```
打开$JAVA_PATH/jre/lib/security/java.security这个文件，找到下面的内容：
securerandom.source=file:/dev/random
替换成
securerandom.source=file:/dev/urandom
```

### Maven \[3.3.9] 安装 <a href="#id2.2-ruan-jian-yao-qiu-maven3.3.9-an-zhuang-maven" id="id2.2-ruan-jian-yao-qiu-maven3.3.9-an-zhuang-maven"></a>

```
# 下载安装文件
$ cd /software
$ wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
# 解压maven
$ tar -zxvf apache-maven-3.3.9-bin.tar.gz
# 配置环境变量
# 使用vim编辑/etc/profile文件
$ vim /etc/profile
# 在/etc/profile文件末尾增加以下配置：
MAVEN_HOME=/software/apache-maven-3.3.9
$ export PATH=${MAVEN_HOME}/bin:${PATH}
# 生效profile
$ source /etc/profile
# 查询Maven版本，出现的版本是自己下载的版本，则安装成功。
$ mvn -v
```

国内服务器有需要的话，在 maven 的 setting.xml 中更新一下 aliyun 的镜像源，后续在执行 maven 执行的时候，下载速度会快一些。

<pre><code><strong>&#x3C;mirror>
</strong><strong>  &#x3C;id>nexus-aliyun&#x3C;/id>
</strong>  &#x3C;mirrorOf>central&#x3C;/mirrorOf>
  &#x3C;name>Nexus aliyun&#x3C;/name>
  &#x3C;url>http://maven.aliyun.com/nexus/content/groups/public&#x3C;/url>
&#x3C;/mirrir>
</code></pre>

### Git 安装 <a href="#id2.2-ruan-jian-yao-qiu-git-an-zhuang-git" id="id2.2-ruan-jian-yao-qiu-git-an-zhuang-git"></a>

下载开发部署工具的源码需要依赖git，安装命令如下：

```
# Ubuntu 系统
$ sudo apt install -y git

# CentOS 系统
$ sudo yum install -y git
```

配置 git 密钥 (可选) ：

* 将自己的 github 账户私钥上传到 "\~/.ssh/" 目录下
* 修改私钥访问权限 “chmod 600 \~/.ssh/id\_rsa \~/.ssh/id\_rsa.pub”

### Crudini 安装 <a href="#id2.2-ruan-jian-yao-qiu-crudini-an-zhuang-crudini" id="id2.2-ruan-jian-yao-qiu-crudini-an-zhuang-crudini"></a>

机器需要安装crudini。

```
# Ubuntu 系统
$ sudo apt-get install -y crudini

# CentOS 系统
$ sudo yum install -y crudini
```

检查安装结果。

```
$ type crudini
# 返回类似如下信息即为安装成功：
# crudini is /usr/bin/crudini
```

如果直接安装失败，则需要配置epel源。

```
#配置yum源为aliyun
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
sudo yum -y install crudini
```
