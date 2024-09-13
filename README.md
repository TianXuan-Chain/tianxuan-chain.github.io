# 天玄技术文档
1) 安装 node v10.24.1

2) 安装 gitbook-cli
   ```sh
   npm install gitbook-cli -g
   ```
3) 拉取文档代码库
   ```sh
   git clone https://github.com/TianXuan-Chain/tianxuan-docs.git
   ```
4) 安装 gitbook 依赖
   ```sh
   cd tianxuan-docs
   gitbook install
   ```
5) 打包 html
   ```sh
   npm run build
   ```
6) 本地部署
   ```sh
   gitbook serve
   ```
7) 部署到 github pages
   ```sh
   npm run deploy
   ```
