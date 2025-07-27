# Solidity 字节类型（bytes、bytes[]、hex）详解

## 一、概念

### 1. bytes
- 动态长度字节数组，可以存储任意长度的二进制数据。
- 常用于存储哈希、签名、原始数据流等。

### 2. bytesN（如 bytes1、bytes2、bytes32）
- 定长字节数组，长度为 N（1~32）。
- 适合存储定长二进制数据，如哈希片段、标识符等。

### 3. bytes[]
- bytes 类型的动态数组，每个元素都是 bytes。
- 适合存储多组变长二进制数据。

### 4. hex 字面量
- Solidity 专用的十六进制字节字面量写法，用于初始化 bytes/bytesN 类型。
- 语法：`hex"010203"`，每两个字符代表一个字节。

---

## 二、语法与用法

### 1. bytes 的声明与赋值
```solidity
bytes memory a = hex"010203"; // [0x01, 0x02, 0x03]
bytes memory b = bytes("abc"); // [0x61, 0x62, 0x63]
```

### 2. bytesN 的声明与赋值
```solidity
bytes1 x = 0x01;
bytes2 y = 0x0102;
bytes3 z = hex"010203";
```

### 3. bytes[] 的声明与赋值
```solidity
bytes[] public arr;

function addBytes() public {
    arr.push(hex"01");
    arr.push(hex"0203");
    arr.push(bytes("abc"));
}
```

### 4. hex 字面量
```solidity
bytes memory data = hex"deadbeef"; // [0xde, 0xad, 0xbe, 0xef]
bytes4 fixedData = hex"12345678";  // 0x12345678
```

---

## 三、典型使用场景

- **bytes**：
  - 存储哈希值（如 keccak256、sha256）
  - 存储签名、加密数据
  - 处理任意长度的二进制流
- **bytesN**：
  - 存储定长哈希（如 bytes32 存储 keccak256）
  - 存储定长标识符、片段
- **bytes[]**：
  - 存储多组变长二进制数据（如多份签名、文件分片等）
- **hex**：
  - 方便初始化字节数据，避免手动转字符串或数组

---

## 四、注意事项

- `bytes` 和 `bytesN` 都属于字节类型，但 `bytes` 是动态长度，`bytesN` 是定长。
- `bytes` 不能直接赋值 `0x...`，需用 `hex"..."` 或 `bytes("...")`。
- `bytes[]` 的每个元素必须是 bytes 类型，不能直接用 uint8。
- `hex"..."` 只能用于字节类型的初始化。

---

## 五、示例合约

```solidity
pragma solidity ^0.8.20;

contract BytesDemo {
    bytes public dynamicBytes = hex"010203";
    bytes3 public fixedBytes = 0x010203;
    bytes[] public bytesArray;

    function addBytes() public {
        bytesArray.push(hex"01");
        bytesArray.push(hex"0203");
        bytesArray.push(bytes("abc"));
    }
}
```

---

如需了解更多字节类型的操作、转换或实际应用，欢迎随时提问！ 