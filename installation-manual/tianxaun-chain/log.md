## 1.5.1. 概述 <a href="#id3.1.5-ri-zhi-shuo-ming-yi-gai-shu" id="id3.1.5-ri-zhi-shuo-ming-yi-gai-shu"></a>

天玄节点的所有日志都输出到 *logs* 目录下
 `thanos-chain-%d{yyyy-MM-dd-'h'HH}.log` 的文件中，且定制了日志格式，方便用户通过日志查看链运行状态。日志配置说明请参考：[日志管理配置文件](configuration.md#日志管理配置文件-chain-logbackxml)。

## 1.5.2. 日志格式 <a href="#id3.1.5-ri-zhi-shuo-ming-er-ri-zhi-ge-shi" id="id3.1.5-ri-zhi-shuo-ming-er-ri-zhi-ge-shi"></a>

每一条日志记录格式如下：

```
# 日志格式：
time log_level [module_name] content
 
# 日志示例：
10:00:38.857 DEBUG [network]  addActiveChannel channel:PeerChannel{remotePeer=[ip=127.0.0.1 port=8888 shardingNum=0 nodeId=1537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d1537a67922d21fb10681456efad62578e5f26328ac94a3e9136c68f5aa7a777d]}
```

各字段含义如下：

* **time**: 日志输出时间，精确到纳秒
* **log_level**: 日志级别，目前主要包括 *trace* , *debug* , *info* , *warning* , *error* 和 *fatal* ，其中在发生极其严重错误时会输出 *fatal*
* **module_name**：模块关键字，如网络模块关键字为 *network*，共识模块关键字为 *consensus*
* **content**：日志记录内容

## 1.5.3. 日志模块关键字 <a href="#id3.1.5-ri-zhi-shuo-ming-san-ri-zhi-mo-kuai-guan-jian-zi" id="id3.1.5-ri-zhi-shuo-ming-san-ri-zhi-mo-kuai-guan-jian-zi"></a>

*thanos-chain* 日志中核心模块关键字如下：

| 模块        | 关键字           |
| --------- | ------------- |
| 通用模块      | general       |
| 通用执行模块    | execute       |
| 节点发现模块    | discover      |
| 网络模块      | network       |
| 线程模型      | thanos-worker |
| 第二层同步模块   | sync-layer2   |
| 状态模块      | state         |
| 数据库模块     | db            |
| 序列化模块     | rlp           |
| 区块/交易同步模块 | sync          |
| 共识模块      | consensus     |
| 交易池       | txpool        |
| 主函数执行     | main          |
| EVM执行器    | VM            |
