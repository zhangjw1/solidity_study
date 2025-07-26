// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleModifier {
    address public owner;
    uint256 public account;

    constructor() {
        owner = msg.sender;
        account = 0;
    }

    //modifier 是一个可复用的代码检查器，而不是一个可直接调用的函数，不需要加作用域
    modifier onlyOwner() {
        //不过不满足条件，抛出"only owner"异常信息
        require(msg.sender == owner, "only owner");
        //_; 是一个占位符。当将一个 modifier 附加到一个函数上时，该函数的全部代码逻辑会在执行时被“插入”到 _; 的位置
        _;
    }

    //检验添加的money是不大于100，否则报错
    modifier validBalance(uint256 money) {
        require(money > 100, "invalid money");
        _;
    }

    function updateAccount(uint256 money) public onlyOwner validBalance(money) {
        // 如果调用者不是合约的所有者，则抛出异常
        account = account + money;
    }
}
