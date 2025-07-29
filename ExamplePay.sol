// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExamplePay {

    

    function send(address payable _to) public payable {
        bool hasSend = _to.send(msg.value);
        require(hasSend, "send fail");
    }

    function transfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function call(address payable _to) public payable {
        (bool hasSend, ) = _to.call{value: msg.value}("");
        require(hasSend, "call send fail");
    }
}
