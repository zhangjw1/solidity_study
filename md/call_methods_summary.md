# Solidity 调用方法详解

## ETH 转账方法对比

### 1. transfer() 方法
- **语法**: `payable(recipient).transfer(amount)`
- **特点**: 固定2300 gas，失败时回滚，简单易用
- **适用**: 简单ETH转账

### 2. send() 方法  
- **语法**: `bool success = payable(recipient).send(amount)`
- **特点**: 固定2300 gas，返回成功状态，失败时不回滚
- **适用**: 需要检查成功状态的转账

### 3. call() 方法
- **语法**: `(bool success, bytes memory data) = payable(recipient).call{value: amount}(data)`
- **特点**: 传递所有gas，可传递数据，最灵活但最危险
- **适用**: 现代合约开发标准

## call 方法详解

### 基本语法
```solidity
(bool success, bytes memory data) = target.call{value: ethAmount}(functionData);
```

### abi.encodeWithSignature
- **作用**: 将函数调用编码为字节数据
- **语法**: `abi.encodeWithSignature("函数签名", 参数1, 参数2, ...)`
- **示例**: 
```solidity
bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", recipient, amount);
target.call(data);
```

## receive 函数

### 触发条件
- 合约接收ETH时
- 没有其他数据时
- 优先级高于fallback

### 语法要求
```solidity
receive() external payable {
    // 处理逻辑
}
```

## fallback 函数

### 触发条件
- 调用不存在的函数时
- 调用时提供了数据
- receive()不存在时接收ETH

### 语法要求
```solidity
fallback() external payable {
    // 处理逻辑
}
```

## 安全考虑

### 重入攻击防护
- 使用检查-效果-交互模式（CEI）
- 先更新状态，后发送ETH
- 添加重入锁

### 最佳实践
- transfer(): 简单转账
- send(): 需要检查成功状态
- call(): 现代标准，需要安全防护

## 总结
现代合约开发推荐使用call()方法，但必须遵循安全最佳实践，防止重入攻击。 