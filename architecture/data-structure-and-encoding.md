# 数据结构&编码

区块链中，交易、收据、区块是三种重要的数据结构，是外界与区块链系统沟通的一种数据格式。

而天玄中，对以太坊原有的数据格式上新增了天玄必备的数据字段。如下：

### 交易数据（EthTransaction）

|名称| 类型            | 描述                                           | RLP编码索引 |                 
| ------------- | -------------------------------------------- | ------- | :---------------: |
|publicKey| bytes20       | 交易发起公钥                                       | 0       |          
|nonce| u256          | nonce值，标识当前交易执行的唯一性                          | 1       |              
|futureEventNumber| u256          | 系统查重使用                                | 2       |  
|gasPrice| u256          | gas价格，天玄中暂未启用                                | 3       |           
|gasLimit| u256          | gas限制，当前交易执行的gas消耗上限，天玄中暂无启用                | 4       |          
|receiveAddress| bytes20       | 调用地址，交易调用的接收地址                               | 5       |     
|value| u256          | 当前交易的转账数额，天玄中暂未启用                            | 6       |              
|data| vector&lt;byte&gt; | 调用内容，若receiveAddress=0x0，则为合约代码；否则为合约方法的函数签名 | 7       |             
|executeStates| set&lt;byte&gt;    | 读写状态，当前交易涉及读、写的状态集合                          | 8       
|signature| vector&lt;byte&gt; | 交易发起者签名                                      | 9       |          

### 区块数据（Block）

| 名称           | 类型                             | 描述                     | RLP编码索引                                                                    |
| ------------ | ------------------------------ | ---------------------- | -------------------------------------------------------------------------- |
| eventId      | bytes32                        | 当前区块内容哈希，构建链式数据        | 0                                                                          |
| preEventId   | bytes32                        | 上一个区块内容哈希，构建链式数据       | 1                                                                          |
| coinBase     | btyes0                         | 矿工地址，天玄中暂未启用           | 2                                                                          |
| stateRoot    | bytes0                         | 状态跟，天玄中暂未启用            | 3                                                                          |
| receiptsRoot | bytes0                         | 收据根，天玄中暂未启用            | 4                                                                          |
| epoch        | u256                           | 世代号，标记当前验证者集合所处时间单位    | 5                                                                          |
| number       | u256                           | 区块号，标记当前区块的高度          | 6                                                                          |
| timestamp    | u256                           | 时间错，标记当前区块的出块时间        | 7                                                                          |
| globalEvents | vector&lt;globalEvent&gt;          | 全局事件，当前区块内包含的系统更新事件    | 8                                                                          |
| receipts     | vector&lt;EthTransactionReceipt&gt; | 交易收据，当前区块内包含交易的所有执行后收据 | <p>9：receipts size</p><p>10：receipts[0]</p><p>11：receipts[1]</p><p>...</p> |

### 全局系统事件数据（globalEvent）

| 名称                | 类型            | 描述                  | RLP编码索引 |
| ----------------- | ------------- | ------------------- | ------- |
| publicKey         | vector&lt;byte&gt; | 全局交易发起者公钥           | 0       |
| nonce             | u256          | nonce值，标识当前交易执行的唯一性 | 1       |
| futureEventNumber | u256          | 系统查重使用         | 2       |
| commandCode       | byte          | 系统事件指令              | 3       |
| data              | vector&lt;byte&gt; | 调用内容，系统事件携带参数       | 4       |
| signature         | vector&lt;byte&gt; | 交易发起者签名             | 5       |

### 交易收据数据（EthTransactionReceipt）

| 名称              | 类型               | 描述                | RLP编码索引 |
| --------------- | ---------------- | ----------------- | ------- |
| logInfoList     | vector&lt;LogInfo&gt; | event事件列表         | 0       |
| ethTransaction  | EthTransaction   | 交易内容，产生收据的交易内容    | 1       |
| gasUsed         | u256             | gas消耗             | 2       |
| executionResult | vector&lt;byte&gt;    | 执行结果，当前交易的执行结果    | 3       |
| error           | string           | 错误日志，标记当前交易执行错误原因 | 4       |

### 合约事件数据（LogInfo）

| 名称      | 类型            | 描述   | RLP编码索引 |
| ------- | ------------- | ---- | ------- |
| address | btyes20       | 合约地址 | 0       |
| topics  | vector&lt;word&gt; | 事件主题 | 1       |
| data    | vector&lt;byte&gt; | 事件内容 | 2       |
