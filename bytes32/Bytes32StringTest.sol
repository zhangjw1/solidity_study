// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bytes32StringTest {
    // 测试不同长度的字符串
    bytes32 public shortString = "alice";           // ✅ 5 字节
    bytes32 public mediumString = "this is a medium string";  // ✅ 23 字节
    // bytes32 public longString = "this is a very long string that exceeds 32 bytes";  // ❌ 编译错误
    
    // 测试字符串转换
    function testStringConversion() external pure returns (bytes32) {
        bytes32 result = "hello world";  // ✅ 11 字节
        return result;
    }
    
    // 测试字符串比较
    function compareStrings() external pure returns (bool) {
        bytes32 str1 = "alice";
        bytes32 str2 = "alice";
        bytes32 str3 = "bob";
        
        return str1 == str2;  // true
        // return str1 == str3;  // false
    }
    
    // 测试字符串拼接（在 bytes32 中不可行）
    function concatenateStrings() external pure returns (bytes32) {
        bytes32 str1 = "hello";
        bytes32 str2 = "world";
        
        // ❌ 不能直接拼接，需要转换为 string
        // return str1 + str2;  // 编译错误
        
        // ✅ 正确的做法是转换为 string
        string memory combined = string(abi.encodePacked(str1, str2));
        return bytes32(abi.encodePacked(combined));  // 但这样会截断
    }
    
    // 测试字符串长度检查
    function checkStringLength(string memory str) external pure returns (bool) {
        bytes memory strBytes = bytes(str);
        return strBytes.length <= 32;  // 检查是否超过 32 字节
    }
    
    // 测试字符串截断
    function truncateString(string memory str) external pure returns (bytes32) {
        bytes memory strBytes = bytes(str);
        if (strBytes.length <= 32) {
            // 如果字符串长度 <= 32，直接转换
            return bytes32(abi.encodePacked(str));
        } else {
            // 如果字符串长度 > 32，截断到 32 字节
            bytes memory truncated = new bytes(32);
            for (uint i = 0; i < 32; i++) {
                truncated[i] = strBytes[i];
            }
            return bytes32(truncated);
        }
    }
}

// 演示投票合约中的字符串使用
contract BallotStringDemo {
    struct Proposal {
        bytes32 name;   // 最多 32 字节的字符串
        uint voteCount;
    }
    
    Proposal[] public proposals;
    
    constructor(string[] memory proposalNames) {
        for (uint i = 0; i < proposalNames.length; i++) {
            // 检查字符串长度
            bytes memory nameBytes = bytes(proposalNames[i]);
            require(nameBytes.length <= 32, "Proposal name too long");
            
            // 转换为 bytes32
            bytes32 nameBytes32 = bytes32(abi.encodePacked(proposalNames[i]));
            
            proposals.push(Proposal({
                name: nameBytes32,
                voteCount: 0
            }));
        }
    }
    
    // 获取提案名称（返回 string）
    function getProposalName(uint index) external view returns (string memory) {
        require(index < proposals.length, "Index out of bounds");
        return string(abi.encodePacked(proposals[index].name));
    }
    
    // 获取提案名称（返回 bytes32）
    function getProposalNameBytes32(uint index) external view returns (bytes32) {
        require(index < proposals.length, "Index out of bounds");
        return proposals[index].name;
    }
    
    // 添加新提案
    function addProposal(string memory name) external {
        bytes memory nameBytes = bytes(name);
        require(nameBytes.length <= 32, "Proposal name too long");
        
        bytes32 nameBytes32 = bytes32(abi.encodePacked(name));
        
        proposals.push(Proposal({
            name: nameBytes32,
            voteCount: 0
        }));
    }
} 