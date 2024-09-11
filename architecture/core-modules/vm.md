# 虚拟机

## 概述

在区块链中，业务数据被抽象为系统状态的一部分，即区块链状态。而区块链状态修改的逻辑则被抽象成智能合约代码。用户通过发送区块链交易完成智能合约完成区块链状态的变更，其中以太坊虚拟机是负责执行区块链交易完成这一变更过程的执行器。当被共识过的一系列交易，被每个节点按照相同顺序执行后，区块链的状态也保证一致性。

## EVM 虚拟机

EVM 虚拟机是一个图灵完备的栈式虚拟机，能够完成任意类型的计算工作，即任意代码逻辑可以被编写并在区块链上执行。

### EVM 指令

EVM 指令指定义了在 EVM 虚拟机上的计算规则的操作码及其参数。和其他类型的编程语言一样，智能合约代码会被编译器编译成 EVM 可读的字节码，由 EVM 内部的解释器读取每个操作码指令并执行。

#### 算数指令举例

一条 ADD 指令，在 EVM 中的代码实现如下。SP 是堆栈的指针，从栈顶第一和第二个位置 (`SP[0]`、`SP[1])` 拿出数据，进行加和后，写入结果堆栈SPP的顶端 `SPP[0]` 。

```java
case ADD: {
    DataWord word1 = program.stack.pop();
    DataWord word2 = program.stack.pop();
 
    DataWord addResult = word1.add(word2);
    program.stackPush(addResult);
    program.step();
}
```

#### 跳转指令举例

JUMP指令，实现了二进制代码间的跳转。首先从堆栈顶端 `SP[0]` 取出待跳转的地址，验证一下是否越界，放到程序计数器PC中，下一个指令，将从PC指向的位置开始执行。

```java
case JUMP: {
    DataWord pos = program.stack.pop();
    int nextPC = program.verifyJumpDest(pos);
    program.setPC(nextPC);
}
```

#### 状态读取指令举例

SLOAD 可以查询状态数据。大致过程是，从堆栈顶端取出要访问的 key ，把 key 作为参数，然后调 program.storageLoad ，查询相应的 key 对应的 value 。之后将读到的 value 写到结果堆栈顶端。

```java
case SLOAD: {
    DataWord key = program.stack.pop();
    DataWord value = program.storageLoad(key);
  
    if (value == null || value.getData() == null)
        value = key.and(DataWord.ZERO);
 
    program.stackPush(value);
    program.step();
}
```
#### 其他
完整指令请参考[EVM虚拟机指令](https://www.evm.codes/)
## JVM 虚拟机
当前版本仅支持，系统内部事件的合约编写。