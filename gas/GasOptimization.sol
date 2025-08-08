// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
 * Gas 优化技巧和最佳实践示例
 * 
 * 1. 存储优化
 * 2. 循环优化
 * 3. 函数优化
 * 4. 数据类型优化
 * 5. 批量操作优化
 * 6. 内联汇编优化
 * 7. 事件优化
 */

contract GasOptimization {
    // 1. 存储优化 - 紧凑存储
    struct CompactUser {
        uint128 balance;    // 16 bytes
        uint64 lastActive;  // 8 bytes
        uint64 userId;      // 8 bytes
        bool isActive;      // 1 byte
        address userAddr;   // 20 bytes
    } // 总共 53 bytes，可以打包到 2 个存储槽
    
    struct InefficientUser {
        uint256 balance;    // 32 bytes
        uint256 lastActive; // 32 bytes
        uint256 userId;     // 32 bytes
        bool isActive;      // 32 bytes (浪费 31 bytes)
        address userAddr;   // 32 bytes (浪费 12 bytes)
    } // 总共 160 bytes，需要 5 个存储槽
    
    mapping(address => CompactUser) public users;
    mapping(address => InefficientUser) public inefficientUsers;
    
    // 2. 批量操作优化
    mapping(address => uint256) public balances;
    address[] public userList;
    
    // 低效的批量转账
    function inefficientBatchTransfer(
        address[] memory recipients,
        uint256[] memory amounts
    ) external {
        require(recipients.length == amounts.length, "Length mismatch");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += amounts[i];
            userList.push(recipients[i]); // 每次都 push，浪费 Gas
        }
    }
    
    // 高效的批量转账
    function efficientBatchTransfer(
        address[] calldata recipients,
        uint256[] calldata amounts
    ) external {
        require(recipients.length == amounts.length, "Length mismatch");
        
        uint256 currentLength = userList.length;
        uint256 newLength = currentLength + recipients.length;
        
        // 预分配数组空间
        userList.length = newLength;
        
        for (uint256 i = 0; i < recipients.length;) {
            balances[recipients[i]] += amounts[i];
            userList[currentLength + i] = recipients[i];
            
            // 使用 unchecked 优化循环
            unchecked {
                i++;
            }
        }
    }
    
    // 3. 函数优化 - 减少存储读取
    uint256 public totalSupply;
    mapping(address => uint256) public userBalances;
    
    // 低效的函数
    function inefficientFunction(address user) external view returns (uint256) {
        uint256 balance = userBalances[user];
        uint256 supply = totalSupply; // 额外的 SLOAD
        return balance + supply;
    }
    
    // 高效的函数
    function efficientFunction(address user) external view returns (uint256) {
        return userBalances[user] + totalSupply; // 直接计算，减少变量
    }
    
    // 4. 条件优化
    function inefficientCondition(uint256 amount) external pure returns (bool) {
        if (amount > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    function efficientCondition(uint256 amount) external pure returns (bool) {
        return amount > 0; // 直接返回布尔表达式
    }
    
    // 5. 字符串优化
    string public longString = "This is a very long string that takes up a lot of storage space";
    
    // 使用 bytes32 替代短字符串
    bytes32 public shortData = "Short data";
    
    // 6. 事件优化
    event OptimizedEvent(address indexed user, uint256 amount);
    event InefficientEvent(address user, uint256 amount, string description);
    
    function emitOptimizedEvent(address user, uint256 amount) external {
        emit OptimizedEvent(user, amount); // 只记录必要信息
    }
    
    function emitInefficientEvent(address user, uint256 amount) external {
        emit InefficientEvent(user, amount, "This is a long description that costs more gas"); // 包含不必要信息
    }
    
    // 7. 内联汇编优化
    function assemblyOptimization(uint256 a, uint256 b) external pure returns (uint256) {
        assembly {
            // 直接使用汇编进行数学运算
            let result := add(a, b)
            mstore(0x0, result)
            return(0x0, 32)
        }
    }
    
    // 8. 存储槽优化
    uint128 public value1 = 100;
    uint128 public value2 = 200; // 与 value1 共享同一个存储槽
    
    uint256 public value3 = 300; // 占用独立的存储槽
    
    // 9. 循环优化技巧
    function optimizedLoop(uint256[] calldata data) external pure returns (uint256) {
        uint256 sum = 0;
        uint256 length = data.length;
        
        // 缓存数组长度，避免重复访问
        for (uint256 i = 0; i < length;) {
            sum += data[i];
            
            // 使用 unchecked 优化递增
            unchecked {
                i++;
            }
        }
        
        return sum;
    }
    
    // 10. 函数可见性优化
    // 内部函数比公共函数更省 Gas
    function _internalFunction() internal pure returns (uint256) {
        return 42;
    }
    
    function publicFunction() external pure returns (uint256) {
        return _internalFunction(); // 调用内部函数
    }
}

// 高级 Gas 优化示例
contract AdvancedGasOptimization {
    // 使用位图优化布尔值存储
    mapping(address => uint256) public userFlags; // 每个地址使用 256 个布尔标志
    
    // 设置标志位
    function setFlag(address user, uint256 flagIndex) external {
        require(flagIndex < 256, "Flag index out of range");
        userFlags[user] |= (1 << flagIndex);
    }
    
    // 清除标志位
    function clearFlag(address user, uint256 flagIndex) external {
        require(flagIndex < 256, "Flag index out of range");
        userFlags[user] &= ~(1 << flagIndex);
    }
    
    // 检查标志位
    function hasFlag(address user, uint256 flagIndex) external view returns (bool) {
        require(flagIndex < 256, "Flag index out of range");
        return (userFlags[user] & (1 << flagIndex)) != 0;
    }
    
    // 批量标志操作
    function setMultipleFlags(address user, uint256[] calldata flagIndices) external {
        uint256 flags = userFlags[user];
        
        for (uint256 i = 0; i < flagIndices.length;) {
            require(flagIndices[i] < 256, "Flag index out of range");
            flags |= (1 << flagIndices[i]);
            
            unchecked {
                i++;
            }
        }
        
        userFlags[user] = flags;
    }
}

// 存储优化示例
contract StorageOptimization {
    // 紧凑的存储布局
    struct PackedData {
        uint128 value1;
        uint64 value2;
        uint32 value3;
        uint16 value4;
        uint8 value5;
        bool flag1;
        bool flag2;
        bool flag3;
        bool flag4;
        bool flag5;
        bool flag6;
        bool flag7;
        bool flag8;
        address addr;
    } // 总共 32 bytes，刚好一个存储槽
    
    PackedData public packedData;
    
    // 设置紧凑数据
    function setPackedData(
        uint128 v1,
        uint64 v2,
        uint32 v3,
        uint16 v4,
        uint8 v5,
        bool f1,
        bool f2,
        bool f3,
        bool f4,
        bool f5,
        bool f6,
        bool f7,
        bool f8,
        address addr
    ) external {
        packedData = PackedData(v1, v2, v3, v4, v5, f1, f2, f3, f4, f5, f6, f7, f8, addr);
    }
    
    // 读取紧凑数据
    function getPackedData() external view returns (
        uint128, uint64, uint32, uint16, uint8,
        bool, bool, bool, bool, bool, bool, bool, bool, address
    ) {
        PackedData memory data = packedData;
        return (
            data.value1, data.value2, data.value3, data.value4, data.value5,
            data.flag1, data.flag2, data.flag3, data.flag4,
            data.flag5, data.flag6, data.flag7, data.flag8, data.addr
        );
    }
}

// 测试合约
contract TestGasOptimization {
    GasOptimization public gasOpt;
    AdvancedGasOptimization public advancedOpt;
    StorageOptimization public storageOpt;
    
    constructor() {
        gasOpt = new GasOptimization();
        advancedOpt = new AdvancedGasOptimization();
        storageOpt = new StorageOptimization();
    }
    
    function testOptimizations() external {
        // 测试批量操作
        address[] memory recipients = new address[](3);
        uint256[] memory amounts = new uint256[](3);
        
        recipients[0] = address(0x1);
        recipients[1] = address(0x2);
        recipients[2] = address(0x3);
        
        amounts[0] = 100;
        amounts[1] = 200;
        amounts[2] = 300;
        
        gasOpt.efficientBatchTransfer(recipients, amounts);
        
        // 测试标志位操作
        advancedOpt.setFlag(msg.sender, 0);
        advancedOpt.setFlag(msg.sender, 1);
        
        // 测试存储优化
        storageOpt.setPackedData(
            1000, 2000, 3000, 4000, 50,
            true, false, true, false, true, false, true, false,
            address(0x123)
        );
    }
} 