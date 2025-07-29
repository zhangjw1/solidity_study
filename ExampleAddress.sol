// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleAddress {
    address public owner;

    //构造方法，获取合约的发布用户
    constructor() {
        owner = msg.sender;
    }

    //获取合约的发布用户
    function getOwner() external  view returns (address) {
        return owner;
    }

    //获取合约的地址
    function getContractAddress() external view returns (address) {
        return address(this);
    }

    //获取操作用户的地址
    function getUserAddress(address _address) external pure returns (address) {
        return _address;
    }

    //获取操作用户的地址
    function getMsgAddress() external view returns (address) {
        return msg.sender;
    }

    function getBalance() external  view returns (uint256, uint256, uint256) {
        //获取合约的余额，获取合约发布者的余额，获取操作用户的余额
        return (address(this).balance, owner.balance, msg.sender.balance);
    }
}
