# 浏览器前端

本项目是天玄区块链浏览器前端项目，使用框架react。
兼容浏览器IE9及以上，360浏览器兼容版（IE9内核），360浏览器极速版，chrome浏览器。

## 1.依赖环境

| 环境 | 版本|
| --- | --- |
| nginx |nginx1.6或以上版本  |
| node |node12~16  |

nginx及node安装请参考附录

## 2.部署



### 2.1 拉取代码

```sh
git clone https://gitlab.fuxi.netease.com:8081/thanos-blockchain/thanos-browser-frontend.git
```

### 2.2 打包

```sh
#进入项目文件夹
cd thanos-browser-frontend
#下载依赖(下载好node执行以下两步)
npm i
#打包
npm run build
```

### 2.3 nginx反向代理

#### 2.3.1 启动nginx

执行
```
nginx
```
一般输入后没有反馈，如果想确认nginx是否启动成功可以使用netstat -anput | grep nginx这个命令看看有没有nginx的端口占用。
然后在浏览器输入你对外的ip地址，如果页面出现了内容（一般是nginx页面）就说明你的nginx启动成功了。

#### 2.3.2 将打包产物放到服务器上

```sh
#将dist文件复制到nginx
cp -r dist /usr/share/nginx/html
```
#### 2.3.3 nginx配置

先找到默认的nginx配置文件路径
```
nginx -t
```
正常情况的信息输出：

```
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```
其中 /usr/local/nginx/conf/nginx.conf 就是配置config文件路径

修改nginx.conf：

```sh
#路径根据nginx -t输出填写
vim /usr/local/nginx/conf/nginx.conf
```

* 修改前端服务的ip地址和端口。
* 修改前端文件的路径,直接指向已拉取代码的dist目录。并且如果有需要请修改nginx的user配置，换成对应的user用户（有dist目录访问权限的用户）
* 修改后端服务的ip和端口。示例如下：

```
server {
    listen       80; #步骤1、前端nginx监听端口
    server_name  localhost; #步骤1、前端地址，可配置为域名
    
    location /browser {
        proxy_pass http://127.0.0.1:7776; #步骤3、后端地址及端口，修改为浏览器后端地址
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }

    location  /  {
        root   /usr/share/nginx/html/dist; #步骤2、前端文件路径，修改为你上传dist包的路径地址
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;    
    }
}
```
#### 2.3.4 重启nginx

执行命令重启

```
nginx -s reload
```

重启之后没有反馈是正常现象，此时刷新一下页面即会显示浏览器网页。

## 3.附录

### 3.1 安装nginx (可参考[网络教程](https://https://www.runoob.com/linux/nginx-install-setup.html))

#### 3.1.1 下载nginx(本文以Ubuntu系统为例，centos可参考网络教程)

安装nginx

```
sudo apt-get update
sudo apt-get install nginx
```

执行命令时注意权限问题，如遇到，请加上sudo

查看安装版本

```
nginx -v
```

#### 3.1.2  查看nginx

nginx下载地址：https://nginx.org/download/（下载最新稳定版本即可） 或者使用命令：

```
wget http://nginx.org/download/nginx-1.10.2.tar.gz  (版本号可换)
```

将下载的包移动到/usr/local/下

##### 3.1.3 测试是否安装成功

使用命令：

```
/usr/local/nginx/sbin/nginx –t
```

正常情况的信息输出：

```
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

##### 3.1.4 nginx几个常见命令

```
/usr/local/nginx/sbin/nginx -s reload            # 重新载入配置文件
/usr/local/nginx/sbin/nginx -s reopen            # 重启 Nginx
/usr/local/nginx/sbin/nginx -s stop              # 停止 Nginx
ps -ef | grep nginx                              # 查看nginx进程

```

### 3.2 安装node
#### 3.2.1 安装NVM
推荐使用nvm管理nodejs版本
使用命令安装nvm

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
```

#### 3.2.2 更新会话
安装完成后，您需要关闭并重新打开终端，或者运行以下命令来更新会话以使用NVM
```
source ~/.bashrc
```
#### 3.2.3 使用NVM安装指定版本的Node.js
现在，您可以使用NVM安装任何您想要的Node.js版本。例如，要安装Node.js 16.20.2，您可以运行：
```
nvm install 16.20.2
```
#### 3.2.4 验证安装
安装完成后，您可以使用以下命令来检查Node.js是否安装成功：
```
node -v
```
这个命令应该会显示您刚刚安装的Node.js版本号。如果要切换版本可执行nvm use 版本号