// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleEvent {
    /**
        event 关键字用来声明一个事件。你可以把它想象成一个日志的模板。
        这个模板叫做 Deposit，它规定了每条日志需要包含三个信息：
        from: 存款人的地址 (address)。
        name: 这笔存款的名称，是一个字符串 (string)。
        value: 存款的金额 (uint256
    */
    event Deposit(address from, string name, uint256 value);

    //payable是一个非常重要的关键字，它表示在调用此函数时，可以同时向合约发送以太币
    function deposit(string memory name) public payable {
        //emit 关键字用于触发（或“广播”）一个事件
        emit Deposit(msg.sender, name, msg.value);
    }
    //memory 是一个临时的、易失性的数据存储区域。存储在 memory 中的数据只在函数执行期间存在，当函数执行结束后，这些数据就会被清除
}
