
本教程脚本运行环境需要在 <mark>*Linux*</mark> 系统中进行

## 1.2.1. 硬件配置要求

| 配置     | 最低配置                     | 推荐配置 |
| ------ |--------------------------|------|
| 内存     | 1GB                      | 4GB  |
| CPU核心数 | 2核                       | 4核   |
| 硬盘大小   | 40G                      | 200G |
| 网络带宽   | 1Mb                      | 10Mb |
| 操作系统   | CentOS 7+ (推荐)、Ubuntu18+ |      |

## 1.2.2. 网络及端口要求

至少需要开放2个端口，供区块链浏览器部署使用。

| 端口信息       | 端口号     |
|------------|---------|
| 后端服务端口     | 7776 \~ |
| MySQL数据库端口 | 3306 \~ |

## 1.2.3. 功能说明

本工程是区块链浏览器的后端服务，功能是解析天玄链节点数据储存数据库，向前端提供数据接口，页面展示。

## 1.2.4. 前提条件

| 环境  | 版本                |
| ----- | ------------------- |
| Java  | JDK8或以上版本      |
| MySQL | MySQL-5.6或以上版本 |
| Maven | Maven-3.3或以上版本 |

## 1.2.5. 部署说明

### 1.2.5.1. 下载物料包
* 获取相关物料包（thanos-web3j和thanos-common已推到本地 Maven 仓库中的直接跳过即可），具体下载流程参见[快速入门](../../app-development-manual/java-sdk/quick-start.md) 3.1.2.1. 至3.1.2.2. 章节

### 1.2.5.2. 拉取代码

```sh
cd /root
git clone https://github.com/TianXuan-Chain/thanos-browser-backend.git
```

```sh
cd /root/thanos-browser-backend
```

### 1.2.5.3. 修改配置

* 进入配置文件

```sh
vim /root/thanos-browser-backend/thanos-browser-web/src/main/resources/application.properties
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

### 1.2.5.4. 编译代码

```sh
mvn clean package -U -Dmaven.test.skip=true
```

### 1.2.5.5. 数据初始化

* 新建数据库

```sh
#登录MySQL:
mysql -u${your_db_account} -p${your_db_password}  例如：mysql -uroot -p123456
```

```sql
#新建数据库：
CREATE DATABASE IF NOT EXISTS thanos_browser DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

* 运行SQL文件

```sql
#退出MySQL客户端
exit;
```

```sh
#运行SQL文件
mysql -u${your_db_account} -p${your_db_password} thanos_browser < thanos_browser.sql
```

### 1.2.5.6. 服务启动

* 拷贝jar包

```sh
#拷贝jar到root路径下
cp /root/thanos-browser-backend/thanos-browser-web/target/thanos-browser-web-1.0-SNAPSHOT.jar /root/
cd /root
```

```sh
#启动
nohup java -Xmx512m -Xms512m -Xmn200m -Xss4m -jar thanos-browser-web-1.0-SNAPSHOT.jar >/dev/null 2>&1 &
```

### 1.2.5.7. 查看日志

```sh
#启动日志
tail -f /root/logs/thanos-browser-normal.log
#运行日志
tail -f /root/logs/thanos-browser.log
```

启动日志中看到`Started MainAplication in 7.2 seconds (JVM running for 8.053)`说明启动成功
<div style="text-align: left;">
    <figure style="display: inline-block; margin: 0;">
        <img src="../../assets/浏览器启动成功日志.png" alt="浏览器启动成功日志" style="width: 100%; max-width: 600px; height: auto;">
        <figcaption style="text-align: center; max-width: 600px; font-weight: bold; font-size: 14px; color: #555;">图1. 浏览器启动成功日志</figcaption>
    </figure>
</div>

运行日志中看`BlockTnxReporterHandler start handle!`说明开始拉取区块信息
<div style="text-align: left;">
    <figure style="display: inline-block; margin: 0;">
        <img src="../../assets/浏览器开始拉取区块日志.png" alt="浏览器开始拉取区块" style="width: 100%; max-width: 600px; height: auto;">
        <figcaption style="text-align: center; max-width: 600px; font-weight: bold; font-size: 14px; color: #555;">图2. 浏览器开始拉取区块</figcaption>
    </figure>
</div>

## 1.2.6. 问题排查

### 1.2.6.1. 同步区块信息报错

`java.sql.SQLException: Table has no partition for value ${your_error_partition}`

数据库表分区未创建

注：标题中${your_error_partition}为报错日期，根据实际报错日志填写sql

```sql
#SQL中的日期填写报错日期+1
ALTER TABLE thanos_evm_transaction ADD PARTITION(PARTITION p${your_error_partition} + 1 VALUES LESS THAN (${your_error_partition} + 1) ENGINE = InnoDB);
```

```sql
例：
报错日志：java.sql.SQLException: Table has no partition for value 20240923
执行SQL:ALTER TABLE thanos_evm_transaction ADD PARTITION(PARTITION p20240924 VALUES LESS THAN (20240924) ENGINE = InnoDB);
```

## 1.2.7. 安装教程

### 1.2.7.1. Oracle JDK \[1.8] 安装

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

### 1.2.7.2. Maven \[3.3.9] 安装

```sh
# 下载安装文件
cd /software
wget https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
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

### 1.2.7.3. Git 安装

下载开发部署工具的源码需要依赖 *Git* ，安装命令如下：

```sh
CentOS:sudo yum install -y git
Ubuntu:sudo apt install -y git
```

配置 *git* 密钥 (可选) ：

* 将自己的 *github* 账户私钥上传到 `~/.ssh/` 目录下
* 修改私钥访问权限 `chmod 600 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub`
* 启动ssh-agent `eval $(ssh-agent)`
* 添加私钥到ssh-agent `ssh-add ~/.ssh/id_rsa`

### 1.2.7.4. MySQL安装

*MariaDB*数据库是 MySQL 的一个分支，主要由开源社区在维护，采用 GPL 授权许可。*MariaDB*完全兼容 MySQL，包括API和命令行。其他安装方式请参考[MySQL官网](https://dev.mysql.com/downloads/mysql/)。

**安装MariaDB**

* 安装命令

```sh
CentOS：sudo yum install -y mariadb*
Ubuntu：sudo apt install mariadb-server
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

**授权访问和添加用户**

* 使用root用户登录，密码为初始化设置的密码

```sh
mysql -uroot -p -h localhost -P 3306
```

* 授权root用户远程访问(如果执行完成远程访问失败，请查看服务器`3306`端口是否开放)

```sql
mysql > GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
mysql > flush PRIVILEGES;
```

* 创建test用户并授权本地访问

```sql
mysql > GRANT ALL PRIVILEGES ON *.* TO 'test'@localhost IDENTIFIED BY '123456' WITH GRANT OPTION;
mysql > flush PRIVILEGES;
```

**测试连接和创建数据库**

* 登录数据库

```sh
mysql -utest -p123456 -h localhost -P 3306
```

* 创建数据库

```sql
CREATE DATABASE IF NOT EXISTS thanos_browser DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

  