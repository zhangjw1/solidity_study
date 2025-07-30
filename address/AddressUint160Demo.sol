// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract AddressUint160Demo {
    
    // 1. 数学运算 - address不能直接进行数学运算
    function addressMath(address addr) external pure returns (uint160) {
        // 错误：address不能直接进行数学运算
        // address result = addr + 1;  // 编译错误！
        
        // 正确：转换为uint160后进行数学运算
        uint160 addrAsNumber = uint160(addr);
        uint160 result = addrAsNumber + 1;
        return result;
    }
    
    // 2. 位运算 - address不能直接进行位运算
    function addressBitwise(address addr) external pure returns (uint160) {
        uint160 addrAsNumber = uint160(addr);
        
        // 位运算
        uint160 shifted = addrAsNumber >> 1;  // 右移1位
        uint160 masked = addrAsNumber & 0xFF; // 取低8位
        
        return shifted;
    }
    
    // 3. 地址生成和验证
    function generateAddress(uint160 number) external pure returns (address) {
        // 将数字转换为地址
        address generatedAddr = address(number);
        return generatedAddr;
    }
    
    // 4. 地址比较和排序
    function compareAddresses(address addr1, address addr2) external pure returns (bool) {
        // 转换为数字进行比较
        uint160 num1 = uint160(addr1);
        uint160 num2 = uint160(addr2);
        
        return num1 < num2;  // 数字比较
    }
    
    // 5. 地址范围检查
    function isInRange(address addr, address min, address max) external pure returns (bool) {
        uint160 addrNum = uint160(addr);
        uint160 minNum = uint160(min);
        uint160 maxNum = uint160(max);
        
        return addrNum >= minNum && addrNum <= maxNum;
    }
    
    // 6. 地址哈希和派生
    function deriveAddress(address base, uint160 offset) external pure returns (address) {
        uint160 baseNum = uint160(base);
        uint160 derivedNum = baseNum + offset;
        
        return address(derivedNum);
    }
    
    // 7. 地址格式转换
    function addressToBytes(address addr) external pure returns (bytes20) {
        return bytes20(addr);
    }
    
    function bytesToAddress(bytes20 addrBytes) external pure returns (address) {
        return address(addrBytes);
    }
    
    // 8. 地址验证
    function isValidAddress(address addr) external pure returns (bool) {
        uint160 addrNum = uint160(addr);
        
        // 检查是否为0地址
        if (addrNum == 0) return false;
        
        // 检查是否在有效范围内
        if (addrNum > 0xffffffffffffffffffffffffffffffffffffffff) return false;
        
        return true;
    }
    
    // 9. 地址生成算法
    function generateDeterministicAddress(address base, string memory salt) external pure returns (address) {
        // 使用keccak256哈希生成确定性地址
        bytes32 hash = keccak256(abi.encodePacked(base, salt));
        uint160 addrNum = uint160(uint256(hash));
        
        return address(addrNum);
    }
    
    // 10. 地址统计
    function addressStatistics(address[] calldata addresses) external pure returns (
        uint160 minAddr,
        uint160 maxAddr,
        uint256 count
    ) {
        require(addresses.length > 0, "数组不能为空");
        
        minAddr = uint160(addresses[0]);
        maxAddr = uint160(addresses[0]);
        count = addresses.length;
        
        for (uint256 i = 1; i < addresses.length; i++) {
            uint160 addrNum = uint160(addresses[i]);
            
            if (addrNum < minAddr) {
                minAddr = addrNum;
            }
            
            if (addrNum > maxAddr) {
                maxAddr = addrNum;
            }
        }
    }
} 