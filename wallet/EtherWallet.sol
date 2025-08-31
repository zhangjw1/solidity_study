// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/**
这个合约只能转账/接收Ether
*/
contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // 接收ETH的函数
    receive() external payable {
        // 当合约收到ETH时自动调用此函数
    }

    // 存款函数 - 不需要参数，直接通过msg.value接收ETH
    function deposit() public payable onlyOwner {
        require(msg.value > 0, "Amount must be greater than 0");
        // 不需要transfer，ETH已经通过msg.value存入合约
        // 合约余额会自动增加
    }

    // 提款函数 - 从合约向owner转账
    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No balance to withdraw");
        owner.transfer(address(this).balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}