# 浏览器前端

本项目是天玄区块链浏览器前端项目，使用框架react。
兼容浏览器IE9及以上，360浏览器兼容版（IE9内核），360浏览器极速版，chrome浏览器。

## 1.功能

* 主要功能是区块链概览，查看区块，查看交易，节点配置以及群组切换。
* 支持群组切换，需要配置群组和节点。
* 上传并编译发送交易的合约后，可以查看交易的inputs和event解码数据。
* 区块链概览，查看区块，查看交易和节点配置页面每10s执行一轮请求。

## 2.部署

### 2.1 依赖环境

| 环境 | 版本|
| --- | --- |
| nginx |nginx1.6或以上版本  |

nginx安装请参考附录

### 2.2 拉取代码

```sh
https://gitlab.fuxi.netease.com:8081/thanos-blockchain/thanos-browser-frontend.git
```

### 2.3 打包

下载好依赖后直接终端执行npm run build即可，打包产物在dist文件夹中。

### 2.4 部署云端服务器

部署云服务器可参考具体服务器的api或网络教程，示例：[阿里云部署](https://blog.csdn.net/weixin_43239880/article/details/129434402)。

### 2.5 nginx配置

配置文件默认路径在/usr/local/nginx/conf/nginx.conf
修改nginx.conf：

* 修改前端服务的ip地址和端口。
* 修改前端文件的路径,直接指向已拉取代码的dist目录。并且如果有需要请修改nginx的user配置，换成对应的user用户（有dist目录访问权限的用户）
* 修改后端服务的ip和端口。示例如下：

```sh
server {
    listen       80; #步骤1、前端nginx监听端口
    server_name  localhost; #步骤1、前端地址，可配置为域名
    
    location /browser {
        proxy_pass http://nft-browser-prod.2013-prod-10125:8080; #步骤3、后端地址及端口
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }

    location  /  {
        root   /usr/share/nginx/html; #步骤2、前端文件路径
        index  index.html index.htm;
        try_files $uri $uri/ /index.html;    
    }
}
```
### 2.6 启动nginx

1. 启动命令

```sh
/usr/local/nginx/sbin/nginx
```

2.启动报错重点排查：

* 日志路径是否正确（error.log和access.log）
* nginx有没有添加用户权限。

## 3.附录

### 3.1 安装nginx (可参考[网络教程](https://https://www.runoob.com/linux/nginx-install-setup.html))

#### 3.1.1 下载nginx依赖

在安装nginx前首先要确认系统中安装了gcc.pcre-devel.zlib-devel、openssl-devel。如果没有，请执行命令

```
yum -y install gcc pcre-devel zlib-devel openssl openssl-devel
```

执行命令时注意权限问题，如遇到，请加上sudo

#### 3.1.2  下载nginx

nginx下载地址：https://nginx.org/download/（下载最新稳定版本即可） 或者使用命令：

```
wget http://nginx.org/download/nginx-1.10.2.tar.gz  (版本号可换)
```

将下载的包移动到/usr/local/下

#### 3.1.3 安装nginx

##### 3.1.3.1 解压

```
tar -zxvf nginx-1.10.2.tar.gz
```

##### 3.1.3.2 进入nginx目录

```
cd nginx-1.10.2
```

##### 3.1.3.3 配置

```
./configure --prefix=/usr/local/nginx
```

##### 3.1.3.4 make

```
make
make install
```

##### 3.1.3.5 测试是否安装成功

使用命令：

```
/usr/local/nginx/sbin/nginx –t
```

正常情况的信息输出：

```
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

##### 3.1.3.6 nginx几个常见命令

```
/usr/local/nginx/sbin/nginx -s reload            # 重新载入配置文件
/usr/local/nginx/sbin/nginx -s reopen            # 重启 Nginx
/usr/local/nginx/sbin/nginx -s stop              # 停止 Nginx
ps -ef | grep nginx                              # 查看nginx进程