# Solidity 数据类型详解

## 目录
- [一、概念与分类](#一概念与分类)
- [二、值类型（Value Types）](#二值类型value-types)
- [三、引用类型（Reference Types）](#三引用类型reference-types)
- [四、特殊类型](#四特殊类型)
- [五、常见用法示例](#五常见用法示例)
- [六、注意事项](#六注意事项)

---

## 一、概念与分类

Solidity 的数据类型主要分为：
- **值类型**（Value Types）：变量直接存储值，赋值/传参时会复制。
- **引用类型**（Reference Types）：变量存储对数据的引用，赋值/传参时会共享。
- **特殊类型**：如函数类型、合约类型、接口类型等。

---

## 二、值类型（Value Types）

| 类型      | 说明                       | 示例                      |
|-----------|----------------------------|---------------------------|
| bool      | 布尔型，true/false         | bool flag = true;         |
| int/uint  | 有符号/无符号整数，8~256位 | uint256 a = 100; int8 b;  |
| address   | 以太坊地址，20字节         | address owner;            |
| bytesN    | 定长字节数组（1~32字节）   | bytes32 hash; bytes1 b;   |
| enum      | 枚举类型                   | enum Status {A,B};        |

---

## 三、引用类型（Reference Types）

| 类型         | 说明                         | 示例                        |
|--------------|------------------------------|-----------------------------|
| bytes        | 动态字节数组                 | bytes data = hex"0102";    |
| string       | 动态字符串                   | string name = "Alice";     |
| type[]       | 动态数组                     | uint[] arr = [1,2,3];      |
| type[k]      | 定长数组                     | address[2] addrs;          |
| struct       | 结构体                       | struct P {string n;uint a;} |
| mapping      | 映射（哈希表/字典）          | mapping(address=>uint) map; |

---

## 四、特殊类型

- **函数类型**：可声明函数变量、传递函数参数。
- **合约类型**：可声明为其他合约的类型。
- **接口类型**：interface。

---

## 五、常见用法示例

```solidity
// 值类型
bool flag = false;
uint256 amount = 1000;
int8 score = -5;
address owner = 0x1234...abcd;
bytes32 hash = 0xabc...;
enum Status { Pending, Done }
Status s = Status.Pending;

// 引用类型
bytes data = hex"0102";
string name = "Alice";
uint[] arr = [1,2,3];
address[2] addrs = [0x1, 0x2];
struct Person { string name; uint age; }
Person p = Person("Bob", 30);
mapping(address => uint) balances;

// mapping 用法
balances[msg.sender] = 100;
uint bal = balances[msg.sender];

// struct 用法
p.name = "Tom";
p.age = 18;
```

---

## 六、注意事项

- `int/uint` 默认是 256 位（int256/uint256）。
- `address` 是 20 字节，以太坊地址。
- `bytesN`（N=1~32）为定长字节数组，`bytes` 为动态字节数组。
- `mapping` 不能遍历，只能已知 key 时读取。
- `struct`、`mapping` 只能用作状态变量，不能作为函数参数/返回值。
- Solidity 不支持浮点型，小数需用定点整数方案。

---

如需了解某个类型的详细用法或限制，欢迎随时提问！ 