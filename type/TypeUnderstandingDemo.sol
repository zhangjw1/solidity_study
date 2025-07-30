// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/**
address,uint160和bytes20的比较与转换
1. address是封装了地址操作的地址号
2. uint160是20字节的数字值
3. bytes20是20字节的数组
4. address可以转换为uint160和bytes20
5. uint160和bytes20可以转换为address
6. bytes20可以转换为address
7. address可以转换为bytes20
8. uint160可以转换为bytes20
9. bytes20可以转换为uint160
*/


contract TypeUnderstandingDemo {
    
    // 验证您的理解：address 是封装了地址操作的地址号
    function demonstrateAddress() external view returns (
        uint256 balance,
        uint256 codeLength,
        string memory description
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        
        // address 特有的操作
        balance = addr.balance;           // 查询余额
        codeLength = addr.code.length;    // 查询合约代码长度
        
        description = "address: 封装了地址操作的地址号";
        
        return (balance, codeLength, description);
    }
    
    // 验证您的理解：uint160 是可以计算的数字值
    function demonstrateUint160() external pure returns (
        uint160 result1,
        uint160 result2,
        uint160 result3,
        string memory description
    ) {
        uint160 num = 0x1234567890123456789012345678901234567890;
        
        // uint160 的数学运算
        result1 = num + 1;        // 加法
        result2 = num * 2;        // 乘法
        result3 = num >> 1;       // 右移
        
        description = "uint160: 可以计算的数字值";
        
        return (result1, result2, result3, description);
    }
    
    // 验证您的理解：bytes20 是20个字节的数组
    function demonstrateBytes20() external pure returns (
        bytes1 firstByte,
        bytes1 lastByte,
        uint256 length,
        string memory description
    ) {
        bytes20 addrBytes = 0x1234567890123456789012345678901234567890;
        
        // bytes20 的数组操作
        firstByte = addrBytes[0];     // 第一个字节
        lastByte = addrBytes[19];     // 最后一个字节
        length = addrBytes.length;    // 数组长度
        
        description = "bytes20: 20个字节长度的数组";
        
        return (firstByte, lastByte, length, description);
    }
    
    // 验证底层存储相同
    function verifySameStorage() external pure returns (bool, bool, bool) {
        address addr = 0x1234567890123456789012345678901234567890;
        uint160 num = uint160(addr);
        bytes20 addrBytes = bytes20(addr);
        
        // 验证转换后是否相等
        bool addrEqualsNum = (addr == address(num));
        bool addrEqualsBytes = (addr == address(addrBytes));
        bool numEqualsBytes = (num == uint160(addrBytes));
        
        return (addrEqualsNum, addrEqualsBytes, numEqualsBytes);
    }
    
    // 演示不同操作的限制
    function demonstrateLimitations() external pure returns (string memory) {
        address addr = 0x1234567890123456789012345678901234567890;
        
        // 这些操作会被编译器阻止：
        // addr + 1;                    // 编译错误：address不能进行数学运算
        // addr[0];                     // 编译错误：address不是数组
        // addr.length;                 // 编译错误：address没有length属性
        
        return "address类型限制了不合适的操作，确保类型安全";
    }
    
    // 演示类型转换的必要性
    function demonstrateConversion() external pure returns (
        uint160 mathResult,
        bytes1 byteResult
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        
        // 需要明确转换才能进行特定操作
        uint160 num = uint160(addr);
        mathResult = num + 1;           // 数学运算
        
        bytes20 addrBytes = bytes20(addr);
        byteResult = addrBytes[0];      // 字节操作
        
        return (mathResult, byteResult);
    }
} 