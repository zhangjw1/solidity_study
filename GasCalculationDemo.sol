// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract GasCalculationDemo {
    // 状态变量 - 存储操作
    uint256 public number = 0;                    // 部署时：20,000 Gas
    string public name = "Alice";                 // 部署时：20,000 Gas
    mapping(address => uint256) public balances;  // 部署时：0 Gas（映射不占用存储）
    
    // 结构体
    struct User {
        string name;
        uint256 age;
        bool isActive;
    }
    
    User public user;  // 部署时：0 Gas
    
    // 数组
    uint256[] public numbers;  // 部署时：0 Gas
    
    // 1. 简单的读取操作（便宜）
    function getNumber() external view returns (uint256) {
        return number;  // 100 Gas (SLOAD)
    }
    
    // 2. 简单的写入操作（昂贵）
    function setNumber(uint256 _number) external {
        number = _number;  // 5,000 Gas (SSTORE)
    }
    
    // 3. 首次写入操作（最昂贵）
    function setUser(string memory _name, uint256 _age) external {
        user = User(_name, _age, true);  // 20,000 Gas (首次 SSTORE)
    }
    
    // 4. 映射操作
    function setBalance(address _user, uint256 _amount) external {
        balances[_user] = _amount;  // 20,000 Gas (首次) / 5,000 Gas (修改)
    }
    
    // 5. 数组操作
    function addNumber(uint256 _number) external {
        numbers.push(_number);  // 20,000 Gas (首次) / 5,000 Gas (后续)
    }
    
    // 6. 循环操作（Gas 消耗与循环次数成正比）
    function sumArray(uint256[] memory arr) external pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            sum += arr[i];  // 每次循环：3 Gas (ADD)
        }
        return sum;
    }
    
    // 7. 字符串操作
    function concatenateStrings(string memory a, string memory b) external pure returns (string memory) {
        return string(abi.encodePacked(a, b));  // 取决于字符串长度
    }
    
    // 8. 条件操作
    function conditionalOperation(bool condition, uint256 a, uint256 b) external pure returns (uint256) {
        if (condition) {
            return a + b;  // 3 Gas (ADD)
        } else {
            return a - b;  // 3 Gas (SUB)
        }
    }
    
    // 9. 函数调用
    function callOtherFunction() external view returns (uint256) {
        return getNumber();  // 额外 Gas 消耗
    }
    
    // 10. 批量操作（Gas 优化示例）
    function batchSetNumbers(uint256[] memory _numbers) external {
        for (uint256 i = 0; i < _numbers.length; i++) {
            numbers.push(_numbers[i]);  // 每次 push：20,000 Gas (首次) / 5,000 Gas
        }
    }
    
    // 11. Gas 优化版本
    function optimizedBatchSetNumbers(uint256[] memory _numbers) external {
        uint256 currentLength = numbers.length;
        for (uint256 i = 0; i < _numbers.length; i++) {
            numbers.push(_numbers[i]);  // 避免重复的 SLOAD
        }
    }
}

// Gas 优化示例
contract GasOptimization {
    // 1. 使用紧凑的数据类型
    uint128 public smallNumber;  // 而不是 uint256
    bool public flag;            // 而不是 uint8
    
    // 2. 批量操作
    mapping(address => uint256) public balances;
    
    function batchTransfer(address[] memory recipients, uint256[] memory amounts) external {
        require(recipients.length == amounts.length, "Length mismatch");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            balances[recipients[i]] = amounts[i];
        }
    }
    
    // 3. 避免重复的存储访问
    function inefficientFunction() external view returns (uint256) {
        // ❌ 多次访问存储
        return balances[msg.sender] + balances[msg.sender] + balances[msg.sender];
    }
    
    function efficientFunction() external view returns (uint256) {
        // ✅ 一次性读取存储
        uint256 balance = balances[msg.sender];
        return balance + balance + balance;
    }
    
    // 4. 使用 memory 进行临时计算
    function calculateWithMemory(uint256[] memory data) external pure returns (uint256) {
        uint256[] memory temp = new uint256[](data.length);
        
        for (uint256 i = 0; i < data.length; i++) {
            temp[i] = data[i] * 2;  // 在 memory 中计算
        }
        
        uint256 sum = 0;
        for (uint256 i = 0; i < temp.length; i++) {
            sum += temp[i];
        }
        
        return sum;
    }
} 