// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bytes32Test {
    bytes32 public testName;
    
    constructor(bytes32 _name) {
        testName = _name;
    }
    
    // 测试直接存储字符串
    function testStringStorage() public pure returns (bytes32) {
        bytes32 name = "Alice";
        return name;
    }
    
    // 测试十六进制存储
    function testHexStorage() public pure returns (bytes32) {
        bytes32 hexValue = 0x416c696365000000000000000000000000000000000000000000000000000000;
        return hexValue;
    }
    
    // 比较两种方式是否相同
    function compareStorage() public pure returns (bool) {
        bytes32 stringValue = "Alice";
        bytes32 hexValue = 0x416c696365000000000000000000000000000000000000000000000000000000;
        return stringValue == hexValue;
    }
    
    // 获取当前存储的名称
    function getName() public view returns (bytes32) {
        return testName;
    }
}

// 演示投票合约的正确使用方式
contract BallotDemo {
    struct Proposal {
        bytes32 name;
        uint voteCount;
    }
    
    Proposal[] public proposals;
    
    constructor(bytes32[] memory proposalNames) {
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    // 获取提案名称
    function getProposalName(uint index) public view returns (bytes32) {
        require(index < proposals.length, "Index out of bounds");
        return proposals[index].name;
    }
    
    // 获取提案数量
    function getProposalCount() public view returns (uint) {
        return proposals.length;
    }
} 