# Solidity 函数作用域与修饰符

## 一、函数作用域（可见性）

Solidity 提供了四种函数作用域，用于控制函数的访问权限：

| 作用域      | 合约外部可见 | 合约内部可见 | 子合约可见 | 说明 |
|-------------|:-----------:|:-----------:|:----------:|------|
| public      |     ✔️      |     ✔️      |    ✔️      | 公开，任何人都能调用 |
| external    |     ✔️      | 仅 this.    |    ✖️      | 只能外部调用，合约内部不能直接调用 |
| internal    |     ✖️      |     ✔️      |    ✔️      | 仅本合约和子合约可见 |
| private     |     ✖️      |     ✔️      |    ✖️      | 仅本合约可见 |

### 示例
```solidity
contract Example {
    function a() public {}      // 任何人都能调
    function b() external {}    // 只能外部调
    function c() internal {}    // 只能本合约和子合约调
    function d() private {}     // 只能本合约调
}
```

---

## 二、常用函数修饰符

### 1. view
- 只读函数，可以读取状态变量，但不能修改。
- 调用 view 函数不会消耗 gas（通过 call 调用时）。

```solidity
function getValue() public view returns (uint) {
    return value;
}
```

### 2. pure
- 更严格，既不能读也不能写合约状态，只能用参数和局部变量做计算。

```solidity
function add(uint a, uint b) public pure returns (uint) {
    return a + b;
}
```

### 3. payable
- 允许函数接收以太币。
- 没有 payable 的函数无法接收主币转账。

```solidity
function deposit() public payable {
    // 可以接收主币
}
```

### 4. virtual/override
- `virtual`：允许子合约重写该函数。
- `override`：重写父合约的函数时必须加。

```solidity
contract A {
    function foo() public virtual {}
}
contract B is A {
    function foo() public override {}
}
```

---

## 三、常见组合

- `public view`：公开只读函数
- `external payable`：外部可见且可接收主币
- `internal pure`：仅内部可见且纯计算

---

如需了解更多修饰符（如 onlyOwner、modifier 自定义修饰符等），欢迎继续提问！ 