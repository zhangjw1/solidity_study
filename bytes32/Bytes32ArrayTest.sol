// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bytes32ArrayTest {
    // ❌ 错误：不能直接初始化
    // bytes32[] public names = ["alice", "bob"];  // 编译错误
    
    // ✅ 正确：逐个添加
    bytes32[] public names;
    
    constructor() {
        names.push("alice");  // ✅ 可以
        names.push("bob");    // ✅ 可以
        names.push("charlie"); // ✅ 可以
    }
    
    // ✅ 正确：明确指定类型
    function createArrayWithExplicitConversion() external pure returns (bytes32[] memory) {
        bytes32[] memory result = new bytes32[](3);
        result[0] = bytes32("alice");     // 明确转换
        result[1] = bytes32("bob");       // 明确转换
        result[2] = bytes32("charlie");   // 明确转换
        return result;
    }
    
    // ✅ 正确：使用 abi.encodePacked
    function createArrayWithAbiEncode() external pure returns (bytes32[] memory) {
        bytes32[] memory result = new bytes32[](3);
        result[0] = bytes32(abi.encodePacked("alice"));
        result[1] = bytes32(abi.encodePacked("bob"));
        result[2] = bytes32(abi.encodePacked("charlie"));
        return result;
    }
    
    // ✅ 正确：从字符串数组转换
    function convertFromStringArray(string[] memory stringArray) external pure returns (bytes32[] memory) {
        bytes32[] memory result = new bytes32[](stringArray.length);
        
        for (uint i = 0; i < stringArray.length; i++) {
            // 检查字符串长度
            bytes memory strBytes = bytes(stringArray[i]);
            require(strBytes.length <= 32, "String too long");
            
            // 转换为 bytes32
            result[i] = bytes32(abi.encodePacked(stringArray[i]));
        }
        
        return result;
    }
    
    // 添加新名称
    function addName(string memory name) external {
        bytes memory nameBytes = bytes(name);
        require(nameBytes.length <= 32, "Name too long");
        
        bytes32 nameBytes32 = bytes32(abi.encodePacked(name));
        names.push(nameBytes32);
    }
    
    // 获取名称数量
    function getNameCount() external view returns (uint) {
        return names.length;
    }
    
    // 获取名称（返回 string）
    function getName(uint index) external view returns (string memory) {
        require(index < names.length, "Index out of bounds");
        return string(abi.encodePacked(names[index]));
    }
    
    // 获取名称（返回 bytes32）
    function getNameBytes32(uint index) external view returns (bytes32) {
        require(index < names.length, "Index out of bounds");
        return names[index];
    }
}

// 演示投票合约的正确实现
contract BallotCorrect {
    struct Proposal {
        bytes32 name;
        uint voteCount;
    }
    
    Proposal[] public proposals;
    
    // 方法1：接受 bytes32[] 参数
    constructor(bytes32[] memory proposalNames) {
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    // 方法2：接受 string[] 参数并转换
    function initializeWithStrings(string[] memory proposalNames) external {
        require(proposals.length == 0, "Already initialized");
        
        for (uint i = 0; i < proposalNames.length; i++) {
            bytes memory nameBytes = bytes(proposalNames[i]);
            require(nameBytes.length <= 32, "Proposal name too long");
            
            bytes32 nameBytes32 = bytes32(abi.encodePacked(proposalNames[i]));
            
            proposals.push(Proposal({
                name: nameBytes32,
                voteCount: 0
            }));
        }
    }
    
    // 获取提案信息
    function getProposal(uint index) external view returns (
        string memory name,
        uint voteCount
    ) {
        require(index < proposals.length, "Index out of bounds");
        return (
            string(abi.encodePacked(proposals[index].name)),
            proposals[index].voteCount
        );
    }
} 