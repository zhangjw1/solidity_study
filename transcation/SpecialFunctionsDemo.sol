// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract SpecialFunctionsDemo {
    string public lastCalled = "";
    uint256 public ethReceived = 0;
    uint256 public fallbackCalled = 0;
    uint256 public receiveCalled = 0;
    
    // 构造函数 - 部署时调用
    constructor() {
        lastCalled = "constructor";
    }
    
    // receive函数 - 当合约接收ETH时调用
    // 不需要function关键字，必须external payable
    receive() external payable {
        lastCalled = "receive";
        ethReceived += msg.value;
        receiveCalled++;
    }
    
    // fallback函数 - 当调用不存在的函数时调用
    // 不需要function关键字，必须external
    fallback() external payable {
        lastCalled = "fallback";
        fallbackCalled++;
        
        // fallback也可以接收ETH
        if (msg.value > 0) {
            ethReceived += msg.value;
        }
    }
    
    // 普通函数 - 需要function关键字
    function normalFunction() external {
        lastCalled = "normalFunction";
    }
    
    // 查看状态
    function getStatus() external view returns (
        string memory last,
        uint256 eth,
        uint256 fallbackCount,
        uint256 receiveCount
    ) {
        return (lastCalled, ethReceived, fallbackCalled, receiveCalled);
    }
    
    // 发送ETH给其他合约
    function sendETH(address target) external payable {
        payable(target).call{value: msg.value}("");
    }
    
    // 调用不存在的函数
    function callNonExistentFunction(address target) external {
        // 这会触发目标合约的fallback函数
        target.call("");
    }
}

// 测试合约
contract TestContract {
    string public message = "";
    
    // 普通函数
    function testFunction() external {
        message = "testFunction called";
    }
    
    // 没有receive和fallback函数
    // 如果直接发送ETH给这个合约，交易会失败
}

// 有receive函数的合约
contract HasReceive {
    string public message = "";
    uint256 public ethReceived = 0;
    
    // 有receive函数，可以接收ETH
    receive() external payable {
        message = "ETH received";
        ethReceived += msg.value;
    }
    
    // 普通函数
    function normalFunction() external {
        message = "normalFunction called";
    }
}

// 有fallback函数的合约
contract HasFallback {
    string public message = "";
    uint256 public fallbackCount = 0;
    
    // fallback函数，处理未知调用
    fallback() external {
        message = "fallback called";
        fallbackCount++;
    }
    
    // 普通函数
    function normalFunction() external {
        message = "normalFunction called";
    }
} 