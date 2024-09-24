## 3.3.1. 接口方法调用 <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-jie-kou-fang-fa-diao-yong" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-jie-kou-fang-fa-diao-yong"></a>

按照教程配置好 *Web3j* 并初始化 *Web3Manager* 实例后，以 *thanosGetLatestBeExecutedNum* 为例：

```java
Web3j web3j = web3Manager.getHttpWeb3jRandomly();
Long res = web3j.thanosGetLatestBeExecutedNum().send().getNumber();
```

更多接口请参考后文。

## 3.3.2. 接口清单

### 3.3.2.1. thanosGetLatestBeExecutedNum <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetlatestbeexecutednum" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetlatestbeexecutednum"></a>

获取目前最新被异步执行的区块块高

**参数**

* 无

**返回值**

* Long - 区块块高

### 3.3.2.2. thanosGetLatestConsensusNumber <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetlatestconsensusnumber" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetlatestconsensusnumber"></a>

获取目前最新被异步共识的区块块高

**参数**

* 无

**返回值**

* Long - 区块块高

### 3.3.2.3. thanosGetCurrentCommitRound <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetcurrentcommitround" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetcurrentcommitround"></a>

获取目前最新的共识轮次

**参数**

* 无

**返回值**

* Long - 轮次

### 3.3.2.4. thanosGetBlockNumber <a href="#id4.3.6-yuan-cheng-tiao-yong-jie-kou-thanosgetblocknumber" id="id4.3.6-yuan-cheng-tiao-yong-jie-kou-thanosgetblocknumber"></a>

通过blockNumber获取区块链信息

**参数**

* blockNumber : String - 区块链编号

**返回值**

* string - 区块链信息

### 3.3.2.5. thanosGetEthTransactionByHash <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetethtransactionbyhash" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetethtransactionbyhash"></a>

通过交易hash获取交易信息，只能获取到网关处缓存中的历史交易

**参数**

* transactionHash : String - 交易hash

**返回值**

* string - 交易信息

### 3.3.2.6. thanosGetEthTransactionByHashByChain <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetethtransactionbyhashbychain" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetethtransactionbyhashbychain"></a>

通过交易hash获取交易信息，可以获取到全量的历史交易

**参数**

* transactionHash : String - 交易hash

**返回值**

* string - 交易信息

### 3.3.2.7. thanosGetEehTransactionsByHashes <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgeteehtransactionsbyhashes" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgeteehtransactionsbyhashes"></a>

通过交易hash批量获取交易信息

**参数**

* transactionHashList : String - 交易hash

**返回值**

* string - 交易信息

### 3.3.2.8. thanosGetGlobalNodeEventByHash <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventbyhash" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventbyhash"></a>

通过全局节点事件hash获取事件信息，只能获取到网关处缓存中的历史全局节点事件

**参数**

* eventHash : String - 事件hash

**返回值**

* string - 事件信息

### 3.3.2.9. thanosGetGlobalNodeEventByHashByChain <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventbyhashbychain" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventbyhashbychain"></a>

通过交易hash批量获取交易信息，可以获取到全量的历史全局节点事件

**参数**

* transactionHash : String - 交易hash

**返回值**

* string - 交易信息

### 3.3.2.10. thanosGetGlobalNodeEventReceiptByHash <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventreceiptbyhash" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosgetglobalnodeeventreceiptbyhash"></a>

通过全局节点事件hash获取事件回执

**参数**

* eventHash : String - 事件hash

**返回值**

* string - 事件回执信息

### 3.3.2.11. thanosEthCall <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosethcall" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanosethcall"></a>

发送交易请求到区块链立即执行，无需共识

**参数**

* rawData : String - rlp序列化后交易

**返回值**

* string - 交易执行回执

### 3.3.2.12. thanosSendGlobalNodeEvent <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendglobalnodeevent" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendglobalnodeevent"></a>

发送全局节点事件请求到区块链执行，返回事件hash

**参数**

* rawData : String - rlp序列化后事件信息

**返回值**

* string - 事件hash

### 3.3.2.13. thanosSendEthRawTransaction <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendethrawtransaction" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendethrawtransaction"></a>

发送交易请求到区块链执行，返回交易hash

**参数**

* rawData : String - rlp序列化后交易

**返回值**

* string - 交易hash

### 3.3.2.14. thanosSendEthRawTransactionList <a href="#id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendethrawtransactionlist" id="id4.3.6-yuan-cheng-diao-yong-jie-kou-thanossendethrawtransactionlist"></a>

批量发送交易请求到区块链执行，返回交易 hash 列表

**参数**

* rawData : List\<byte\[]> - rlp序列化后的交易信息列表

**返回值**

* list\<string> - 交易 hash 列表



