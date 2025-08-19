// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV1 {
    uint256 public value;
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function setValue(uint256 _value) external {
        require(msg.sender == owner, "Only owner");
        value = _value;
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
    
    // 初始化函数（用于代理模式）
    function initialize() external {
        require(owner == address(0), "Already initialized");
        owner = msg.sender;
    }
}