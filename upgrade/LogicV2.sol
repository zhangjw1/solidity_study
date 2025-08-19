// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV2 {
    uint256 public value;
    address public owner;
    string public name; // 新增字段
    
    /**
    构造函数只在部署时执行一次
    1.当逻辑合约被部署时，它的constructor会执行并设置owner为部署者地址
    2.但是通过代理合约调用时，实际执行的是代理合约的代码，逻辑合约的构造函数不会再次执行
    3.这意味着通过代理访问时，逻辑合约的构造函数设置的状态变量不会被初始化

    代理合约和逻辑合约的存储分离
    1.代理合约有自己的存储空间
    2.当通过代理调用逻辑合约时，使用的是代理合约的存储空间
    3.逻辑合约的构造函数只会在逻辑合约自己的存储空间上运行，不会影响代理合约的存储
    */
    function initialize() external {
        require(owner == address(0), "Already initialized");
        owner = msg.sender;
    }
    
    function setValue(uint256 _value) external {
        require(msg.sender == owner, "Only owner");
        value = _value;
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
    
    // 新增功能
    function setName(string memory _name) external {
        require(msg.sender == owner, "Only owner");
        name = _name;
    }
}