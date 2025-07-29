// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract Receiver {
    event Received(address caller, uint256 amount, string message);

    receive() external payable {
        emit Received(msg.sender, msg.value, "receive was called");
    }
    fallback() external payable {
        emit Received(msg.sender, msg.value, "fallback was called");
     }

     function foo(string memory _message,uint _y) public payable  returns (uint) {
        emit Received(msg.sender,msg.value,_message);
        return _y;
     }

    //获取合约的地址
    function getAddress() external view returns (address) {
        return address(this);
    }

    function getBalance() external view returns (uint256) {
        //获取合约的余额
        return (address(this).balance);
    }
}

contract Caller {
    Receiver receiver;

    constructor() {
        receiver = new Receiver();
    }

    event response(bool success, bytes data);

    function testCall(address payable _addr) public payable {
        (bool hasSend, bytes memory data) = _addr.call{value: msg.value}("xyz");
        emit response(hasSend, data);
    }

    function testCallFoo(address payable _addr,uint _y) public payable {
        (bool hasSend, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo",_y));
         emit response(hasSend, data);
    }

    //获取操作用户的地址
    function getAddress() external view returns (address) {
        return receiver.getAddress();
    }

    function getBalance() public view returns (uint256) {
        //获取合约的余额
        return receiver.getBalance();
    }
}
