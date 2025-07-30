// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract AddressStorageDemo {
    
    // 演示相同的值在不同类型中的表示
    function demonstrateStorage() external pure returns (
        address,
        uint160,
        bytes20,
        uint256
    ) {
        // 同一个地址值
        address addr = 0x1234567890123456789012345678901234567890;
        uint160 num = uint160(addr);
        bytes20 addrBytes = bytes20(addr);
        uint256 asUint256 = uint256(addr);
        
        return (addr, num, addrBytes, asUint256);
    }
    
    // 演示转换的等价性
    function demonstrateEquivalence() external pure returns (bool, bool, bool) {
        address addr = 0x1234567890123456789012345678901234567890;
        
        // 转换后是否相等
        bool addrToNum = (addr == address(uint160(addr)));
        bool addrToBytes = (addr == address(bytes20(addr)));
        bool numToBytes = (uint160(addr) == uint160(bytes20(addr)));
        
        return (addrToNum, addrToBytes, numToBytes);
    }
    
    // 演示不同表示方式的数值
    function showValues() external pure returns (
        string memory addrHex,
        string memory numHex,
        string memory bytesHex
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        uint160 num = uint160(addr);
        bytes20 addrBytes = bytes20(addr);
        
        // 转换为十六进制字符串
        addrHex = toHexString(addr);
        numHex = toHexString(num);
        bytesHex = toHexString(addrBytes);
        
        return (addrHex, numHex, bytesHex);
    }
    
    // 辅助函数：转换为十六进制字符串
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint160(addr));
    }
    
    function toHexString(uint160 num) internal pure returns (string memory) {
        if (num == 0) return "0x0";
        
        uint256 temp = num;
        uint256 length = 0;
        
        while (temp != 0) {
            length++;
            temp >>= 4;
        }
        
        bytes memory buffer = new bytes(length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        
        for (uint256 i = length; i > 0; --i) {
            buffer[i + 1] = toHexDigit(uint8(num & 0xF));
            num >>= 4;
        }
        
        return string(buffer);
    }
    
    function toHexString(bytes20 addrBytes) internal pure returns (string memory) {
        return toHexString(uint160(addrBytes));
    }
    
    function toHexDigit(uint8 d) internal pure returns (bytes1) {
        if (0 <= d && d <= 9) {
            return bytes1(uint8(bytes1('0')) + d);
        } else if (10 <= d && d <= 15) {
            return bytes1(uint8(bytes1('a')) + d - 10);
        }
        revert();
    }
    
    // 演示数学运算
    function demonstrateMath() external pure returns (
        uint160,
        uint160,
        uint160
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        uint160 num = uint160(addr);
        
        // 数学运算
        uint160 plusOne = num + 1;
        uint160 doubled = num * 2;
        uint160 shifted = num >> 1;
        
        return (plusOne, doubled, shifted);
    }
    
    // 演示字节操作
    function demonstrateBytes() external pure returns (
        bytes1,
        bytes1,
        bytes20
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        bytes20 addrBytes = bytes20(addr);
        
        // 字节操作
        bytes1 firstByte = addrBytes[0];  // 第一个字节
        bytes1 lastByte = addrBytes[19];  // 最后一个字节
        
        // 创建新的字节数组
        bytes20 newBytes = bytes20(uint160(addr) + 1);
        
        return (firstByte, lastByte, newBytes);
    }
    
    // 演示地址的特殊操作
    function demonstrateAddressOps() external view returns (
        uint256,
        bool
    ) {
        address addr = 0x1234567890123456789012345678901234567890;
        
        // address 特有的操作
        uint256 balance = addr.balance;  // 查询余额
        bool isContract = addr.code.length > 0;  // 检查是否为合约
        
        return (balance, isContract);
    }
} 