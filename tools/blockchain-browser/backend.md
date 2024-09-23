# 浏览器后端服务

## 1.功能说明

本工程是区块链浏览器的后端服务，功能是解析天玄链节点数据储存数据库，向前端提供数据接口，页面展示。

## 2.前提条件

| 环境  | 版本                |
| ----- | ------------------- |
| Java  | JDK8或以上版本      |
| MySQL | MySQL-5.6或以上版本 |
| Maven | Maven-3.3或以上版本 |

## 3.部署说明

### 3.1拉取代码

```sh
git clone ssh://git@gitlab.fuxi.netease.com:2222/thanos-blockchain/thanos-browser-backend.git
```

```sh
cd thanos-browser-backend
```

### 3.2修改配置

* 进入配置文件

```sh
vim thanos-browser-web/src/main/resources/application.properties
```

* 修改MySQL配置

```properties
# 在配置文件中找到这三个配置,修改成需要连接的MySQL的配置
nv.db.url=jdbc:mysql://127.0.0.1:3306/thanos_browser?useSSL=false
nv.db.username=root
nv.db.password=123456
```

* 修改测试链配置

```properties
# 根据自己部署的天玄链节点网关(thanos-gateway) ip 和 port 修改,具体配置见 thanos-gateway.conf
thanos.rpc.ip.List=127.0.0.1:8580
chain.node.list=[{"ip":"127.0.0.1","rpcPort":8580}]
```

### 3.3编译代码

```sh
mvn clean package -U -Dmaven.test.skip=true >mvn.log 2>&1
```

### 3.4数据初始化

* 新建数据库

```sh
#登录MySQL:
mysql -u ${your_db_account} -p${your_db_password}  例如：mysql -u root -p123456
```

```mysql
#新建数据库：
CREATE DATABASE IF NOT EXISTS thanos_browser DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

* 运行SQL文件

```mysql
#退出MySQL客户端
exit;
```

```sh
#运行SQL文件
mysql -u ${your_db_account} -p${your_db_password} < thanos_browser.sql
```

### 3.5服务启动

* 拷贝jar包

```sh
#拷贝jar到root路径下
cp thanos-browser-web/target/thanos-browser-web-1.0-SNAPSHOT.jar /root/
cd /root
```

```sh
#启动
nohup java -jar thanos-browser-web-1.0-SNAPSHOT.jar >/dev/null 2>&1 &
```

### 3.6查看日志

```sh
#启动日志
tail -f /logs/thanos-browser-normal.log
#运行日志
tail -f /logs/thanos-browser.log
```

## 4.问题排查

### 4.1 同步区块信息，报错：java.sql.SQLException: Table has no partition for value ${your_error_partition}

数据库表分区未创建

注：标题中${your_error_partition}为报错日期，根据实际报错日志填写sql

```mysql
#SQL中的日期填写报错日期+1
ALTER TABLE thanos_evm_transaction ADD PARTITION(PARTITION p${your_error_partition} + 1 VALUES LESS THAN (${your_error_partition} + 1) ENGINE = InnoDB);
```

```mysql
例：
报错日志：java.sql.SQLException: Table has no partition for value 20240923
执行SQL:ALTER TABLE thanos_evm_transaction ADD PARTITION(PARTITION p20240924 VALUES LESS THAN (20240924) ENGINE = InnoDB);
```

## 5.安装教程

### 5.1Oracle JDK \[1.8] 安装

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

### 5.2Maven \[3.3.9] 安装

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

### 5.3Git 安装

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

### 5.4MySQL安装

此处以Centos安装*MariaDB*为例。*MariaDB*数据库是 MySQL 的一个分支，主要由开源社区在维护，采用 GPL 授权许可。*MariaDB*完全兼容 MySQL，包括API和命令行。其他安装方式请参考[MySQL官网](https://dev.mysql.com/downloads/mysql/)。

#### 5.4.1安装MariaDB

* 安装命令

  ```sh
  sudo yum install -y mariadb*
  ```

* 启停

  ```sh
  启动：sudo systemctl start mariadb.service
  停止：sudo systemctl stop  mariadb.service
  ```

* 设置开机启动

  ```sh
  sudo systemctl enable mariadb.service
  ```

* 初始化

  ```sh
  执行以下命令：
  sudo mysql_secure_installation
  以下根据提示输入：
  Enter current password for root (enter for none):<–初次运行直接回车
  Set root password? [Y/n] <– 是否设置root用户密码，输入y并回车或直接回车
  New password: <– 设置root用户的密码
  Re-enter new password: <– 再输入一次你设置的密码
  Remove anonymous users? [Y/n] <– 是否删除匿名用户，回车
  Disallow root login remotely? [Y/n] <–是否禁止root远程登录，回车
  Remove test database and access to it? [Y/n] <– 是否删除test数据库，回车
  Reload privilege tables now? [Y/n] <– 是否重新加载权限表，回车
  ```

#### 5.4.2授权访问和添加用户

* 使用root用户登录，密码为初始化设置的密码

  ```sh
  mysql -uroot -p -h localhost -P 3306
  ```

* 授权root用户远程访问

  ```mysql
  mysql > GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
  mysql > flush PRIVILEGES;
  ```

* 创建test用户并授权本地访问

  ```mysql
  mysql > GRANT ALL PRIVILEGES ON *.* TO 'test'@localhost IDENTIFIED BY '123456' WITH GRANT OPTION;
  mysql > flush PRIVILEGES;
  ```

#### 5.4.3测试连接和创建数据库

* 登录数据库

  ```sh
  mysql -utest -p123456 -h localhost -P 3306
  ```

* 创建数据库

  ```mysql
  mysql > create database thanos_browser;
  ```

  