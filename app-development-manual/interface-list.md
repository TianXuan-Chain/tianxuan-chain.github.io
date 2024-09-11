# 天玄链功能接口列表

下列接口的示例中采用 curl 命令，curl 是一个利用 url 语法在命令行下运行的数据传输工具，通过 curl 命令发送 http post 请求，可以访问天玄链的 JSON RPC 接口。curl 命令的 url 地址设置为节点配置文件监听端口（gateway.http.port）。为了格式化 json ，使用 json工具进行格式化显示。

## thanos\_clientVersion <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosclientversion" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosclientversion"></a>

**描述**

* 返回节点的版本信息

**参数**

* 无

**返回值**

* `object` - 版本信息，字段如下：
  * version: `string` - 版本信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_clientVersion","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "id": 83,
  "jsonrpc": "2.0",
  "result": {
    "thanos/v1.0.0/Linux/Java/jdk1.8/1.0.0"
  }
}
```

## thanos\_sha3 <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanossha3" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanossha3"></a>

**描述**

* 计算参数的sha3的hash值，返回为16进制

**参数**

* data: String - 元数据

**返回值**

* `string` - 该元数据的hash值(0x开头的十六进制字符串)
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_sha3","params":["0x186a0"],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0x77caf3b88c63099c04df97ff5dc5ad40691663664611a522b0ca159436cb6efc"
}
```

## thanos\_net\_version <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosnetversion" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosnetversion"></a>

**描述**

* 返回thanos区块链组网版本

**参数**

* 无

**返回值**

* `string` - thanos区块链组网版本
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_net_version","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "1.0.0" //目前thanos组网版本
}
```

## thanos\_protocolVersion <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosprotocolversion" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosprotocolversion"></a>

**描述**

* 返回thanos区块链协议版本

**参数**

* 无

**返回值**

* `string` - thanos区块链协议版本
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_protocolVersion","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "1.0.0" //目前thanos协议版本
}
```

## thanos\_getCompilers <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetcompilers" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetcompilers"></a>

**描述**

* 返回thanos区块链编译器

**参数**

* 无

**返回值**

* `string[]` - thanos区块链编译器类型
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getCompilers","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    "solidity"  //目前thanos的evm版本
  ]
}
```

## thanos\_sendEthRawTransaction <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanossendethrawtransaction" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanossendethrawtransaction"></a>

**描述**

* 发送交易请求到区块链执行，返回交易hash

**参数**

* rawData : String - rlp序列化后交易

**返回值**

* `string` - 交易hash
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_sendEthRawTransaction","params":["0xf9051ea002bf9825d12eb69d5c397d37e2380923181b2a6c7cfa916632b878bbcac3fb0701832dc6c08080b90461608060405234801561001057600080fd5b5060408051808201909152600b8082527f48692c57656c636f6d652100000000000000000000000000000000000000000060209092019182526100559160009161005b565b506100f6565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061009c57805160ff19168380011785556100c9565b828001600101855582156100c9579182015b828111156100c95782518255916020019190600101906100ae565b506100d59291506100d9565b5090565b6100f391905b808211156100d557600081556001016100df565b90565b61035c806101056000396000f3006080604052600436106100615763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416634725721781146100665780634ed3885e1461008d5780636d4ce63c146100e857806380637f6e14610172575b600080fd5b34801561007257600080fd5b5061007b61018a565b60408051918252519081900360200190f35b34801561009957600080fd5b506040805160206004803580820135601f81018490048402850184019095528484526100e69436949293602493928401919081908401838280828437509497506101919650505050505050565b005b3480156100f457600080fd5b506100fd6101d1565b6040805160208082528351818301528351919283929083019185019080838360005b8381101561013757818101518382015260200161011f565b50505050905090810190601f1680156101645780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561017e57600080fd5b506100e6600435610267565b6001545b90565b80516101a4906000906020840190610298565b506040517f15504e11775a2cc1976320e3c666e5965057d329614934f0b707fc711dfb82ec90600090a150565b60008054604080516020601f600260001961010060018816150201909516949094049384018190048102820181019092528281526060939092909183018282801561025d5780601f106102325761010080835404028352916020019161025d565b820191906000526020600020905b81548152906001019060200180831161024057829003601f168201915b5050505050905090565b60018190556040517f15504e11775a2cc1976320e3c666e5965057d329614934f0b707fc711dfb82ec90600090a150565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106102d957805160ff1916838001178555610306565b82800160010185558215610306579182015b828111156103065782518255916020019190600101906102eb565b50610312929150610316565b5090565b61018e91905b80821115610312576000815560010161031c5600a165627a7a723058208e5a4aa7b5e303ce22caabadd228c8c48f4f9bf5e999cba9fcfbcec9096ed44a002986c58468656865b841043973cb86d7bef9c96e5d589601d788370f9e24670dcba0480c0b3b1b0647d13d0f0fffed115dd2d4b5ca1929287839dcd4e77bdc724302b44ae48622a8766ee6b846304402201f497a8224036e6d767e20e7adda8ceaaa62f5f1780101e2d1709b6a873a93a5022034e8559e0b421788dc9f4b1449588c3aaeb6fe7c808a84eec5e4ad1dbeb6627f"],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": "0xb4035c2dfde8b5234011130d554659dd5b16979c2b73e2f6691a90966b832726" //返回交易hash
}
```

## thanos\_ethCall <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosethcall" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosethcall"></a>

**描述**

* 发送交易请求到区块链立即执行，无需共识

**参数**

* rawData : String - rlp序列化后交易

**返回值**

* `string :` - 交易执行回执
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d  '{"jsonrpc":"2.0","method":"thanos_ethCall","params":["0xf8d89f7d584aedd3309152a4acd24af50b66d0f1a9d0a64b5925d3b0e52b01e506998401c9c3808401c9c380940b0646c1f468c7e5756c8a854ee84b63a8dfe59201846d4ce63c86c58474657374b841043973cb86d7bef9c96e5d589601d788370f9e24670dcba0480c0b3b1b0647d13d0f0fffed115dd2d4b5ca1929287839dcd4e77bdc724302b44ae48622a8766ee6b8473045022100bf66e9305780cf55186973d3b65f7f32f524ec9c09acb77c95e8954fd8e7dd9702205ac6d7aca2b6fafc8fee975daa8f64d0ff97bc7fd30d8c4d58c81a527a1d9470"],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //result需要解析后才能查看
  "result":  "f90134c0f8cb945db10750e8caff27f906b41c71b3471057dd20049f7d584aedd3309152a4acd24af50b66d0f1a9d0a64b5925d3b0e52b01e50699808401c9c3808401c9c380940b0646c1f468c7e5756c8a854ee84b63a8dfe59201846d4ce63cc58474657374b8473045022100bf66e9305780cf55186973d3b65f7f32f524ec9c09acb77c95e8954fd8e7dd9702205ac6d7aca2b6fafc8fee975daa8f64d0ff97bc7fd30d8c4d58c81a527a1d9470a022c35de1f5275fb27d12ee936d8e7e636615d16e125a7b35d1c9ca2f36c3a7fb8202f8b86000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000003313030000000000000000000000000000000000000000000000000000000000080"
}
```

## thanos\_getLatestBeExecutedNum <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetlatestbeexecutednum" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetlatestbeexecutednum"></a>

**描述**

* 获取目前最新被异步执行的区块块高

**参数**

* 无

**返回值**

* `Long :` - 区块快高
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getLatestBeExecutedNum","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": 53 //返回最新执行块高
}
```

## thanos\_getLatestConsensusNumber <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetlatestconsensusnumber" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetlatestconsensusnumber"></a>

**描述**

* 获取目前最新被异步共识的区块块高

**参数**

* 无

**返回值**

* `Long :` - 区块快高
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getLatestConsensusNumber","params":[],"id":1}' --header "Content-Type: application/json" | jq
 
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": 53 //返回最新共识块高
}
```

## thanos\_getBlockByNumber <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetblockbynumber" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetblockbynumber"></a>

**描述**

* 通过blockNumber获取区块链信息

**参数**

* blockNumber : String - 区块链编号

**返回值**

* `string :` - 区块链信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getBlockByNumber","params":["52"],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
   //result需要解析才能查看数据  
  "result": "f9031ba03a669ef806525c555be50d1dfd7ec2be439c98175e3506e68c1c5059236e9ac3a0615a2b238bd9d9009f83999dc16198a430967db0e39a2729ac7105e3c452705300a024c810a501e47ed5a3b106234e8523373a124059266ad05f9bea4e0efbb290e3a0e25e105349583bb390dae102d1dd8c274922135255c79230bce3c019361d7ad00234860175d4148cc2c18001f9016cf83af838940b0646c1f468c7e5756c8a854ee84b63a8dfe592e1a015504e11775a2cc1976320e3c666e5965057d329614934f0b707fc711dfb82ec80f90128945db10750e8caff27f906b41c71b3471057dd2004a001a53e8a4ed98800a6b6d914c4c673f9ddd5b1a435a0b5f8ff62fd45ab1dd8603801832dc6c0940b0646c1f468c7e5756c8a854ee84b63a8dfe59280b8644ed3885e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000033130300000000000000000000000000000000000000000000000000000000000c58468656865b8473045022100b25b3cca6bf0404472dca9e32e72a77256b460733397e0fc6157f8a2dcfd71f202207a7b3a62e96d968be81d5efdf236484a88cf1a39d5009b90051903d6eed9eb3ca04bf7ad3c4c81b417cf7788e5d2107ea9213a880ca602290648fb5ca7820934288202898080f88bb841040d3a176a1e51f68e04deda9c6437543dcd87db185b970476c611052b106a2422af7c496e09fd7f6215284ed83cb3b66bc24f9a318eded9ec7f6722fc52616e29b846304402201830d020942385e79e2524073fce37d6680e1ce4f94b2d0122009a6504dee7c3022042f410c84597e053f52bc2fd748e13e27a83306c84a14646016a9657ce0a6bd7f88cb841047cbf053e81cc2cd1896fc5470c428cad1432cc53d19976a40fa70cae0e3a4415cc1648fc37dc07b5fef0f2a7da71093a88f308adb0c8ca24b0dfe983f78a04f7b84730450220504ffbc833858072c43a5d7a9d6e9555068956e25bda6695cfc8e9526db55459022100b30b63ace222805c9e328ee07bc7eb76e5038f9738b249265a3553257766553c"
}
```

## thanos\_getEthTransactionByHash <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionbyhash" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionbyhash"></a>

**描述**

* 通过交易hash获取交易信息

**参数**

* transactionHash : String - 交易hash

**返回值**

* `string :` - 交易信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getEthTransactionByHash","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"]}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": "f9016cf83af8389436ac9fe88d2652c30169d4658eddf0e15a97da3fe1a015504e11775a2cc1976320e3c666e5965057d329614934f0b707fc711dfb82ec80f90128945db10750e8caff27f906b41c71b3471057dd2004a00313f1b08e9917b6c8bf2d77e4ba00d7adcc1bcd3161204f20cd6dd80add92e83b01832dc6c09436ac9fe88d2652c30169d4658eddf0e15a97da3f80b8644ed3885e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000033130300000000000000000000000000000000000000000000000000000000000c58468656865b847304502200563ac7a29fedc093f971c23dcdd6b552c812d41308d4d136aa0d1dbfac60a5a022100ee377f570e6daf183c09e820fa534b82232640e20576482cbb71579e3fcaf944a01f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd8202bb8080"
}
```

## thanos\_getEthTransactionByHashByChain <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionbyhashbychain" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionbyhashbychain"></a>

**描述**

* 通过交易hash获取交易信息

**参数**

* transactionHash : String - 交易hash

**返回值**

* `string :` - 交易信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getEthTransactionByHashByChain","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": "f9016cf83af8389436ac9fe88d2652c30169d4658eddf0e15a97da3fe1a015504e11775a2cc1976320e3c666e5965057d329614934f0b707fc711dfb82ec80f90128945db10750e8caff27f906b41c71b3471057dd2004a00313f1b08e9917b6c8bf2d77e4ba00d7adcc1bcd3161204f20cd6dd80add92e83b01832dc6c09436ac9fe88d2652c30169d4658eddf0e15a97da3f80b8644ed3885e000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000033130300000000000000000000000000000000000000000000000000000000000c58468656865b847304502200563ac7a29fedc093f971c23dcdd6b552c812d41308d4d136aa0d1dbfac60a5a022100ee377f570e6daf183c09e820fa534b82232640e20576482cbb71579e3fcaf944a01f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd8202bb8080"
}
```

## thanos\_getEthTransactionsByHashes <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionsbyhashes" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetethtransactionsbyhashes"></a>

**描述**

* 通过交易hash批量获取交易信息

**参数**

* transactionHashList : String - 交易hash

**返回值**

* `string :` - 交易信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getEthTransactionByHashByChain","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"]}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": []
}
```

## thanos\_getGlobalNodeEventByHash <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventbyhash" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventbyhash"></a>

**描述**

* 通过全局节点事件hash获取事件信息

**参数**

* eventHash : String - 事件hash

**返回值**

* `string :` - 事件信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getGlobalNodeEventByHash","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"]}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": ""
}
```

## thanos\_getGlobalNodeEventReceiptByHash <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventreceiptbyhash" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventreceiptbyhash"></a>

**描述**

* 通过全局节点事件hash获取事件回执

**参数**

* eventHash : String - 事件hash

**返回值**

* `string :` - 事件回执信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getGlobalNodeEventReceiptByHash","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"]}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": ""
}
```

## thanos\_getGlobalNodeEventByHashByChain <a href="#id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventbyhashbychain" id="id4.4-qu-kuai-lian-gong-neng-jie-kou-lie-biao-thanosgetglobalnodeeventbyhashbychain"></a>

**描述**

* 通过交易hash批量获取交易信息

**参数**

* transactionHash : String - 交易hash

**返回值**

* `string :` - 交易信息
* 示例

```json
// Request
curl http://127.0.0.1:8080/rpc  -X POST -d '{"jsonrpc":"2.0","method":"thanos_getGlobalNodeEventByHashByChain","params":["1f4470f412c41f8df44397fbe576ecd1cd557a7b15af2973c66cc4f7caa825fd"],"id":1}' --header "Content-Type: application/json" | jq
 
// Result
{
  "jsonrpc": "2.0",
  "id": 1,
  //交易回执
  "result": ""
}
```

\
