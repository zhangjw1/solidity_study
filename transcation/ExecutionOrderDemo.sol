// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

// 演示执行顺序的合约
contract ExecutionOrderDemo {
    uint256 public step = 0;
    string public lastAction = "";
    
    // 发送ETH的函数
    function sendETH(address recipient) external payable {
        step = 1;
        lastAction = "准备发送ETH";
        
        // 发送ETH
        payable(recipient).call{value: msg.value}("");
        
        // 这行代码只有在receive()执行完毕后才会执行
        step = 3;
        lastAction = "ETH发送完成，余额已更新";
    }
    
    // 查看当前状态
    function getStatus() external view returns (uint256, string memory) {
        return (step, lastAction);
    }
}

// 接收ETH的合约
contract ReceiverContract {
    uint256 public receivedAmount = 0;
    uint256 public callCount = 0;
    
    // receive函数 - 当合约收到ETH时自动调用
    receive() external payable {
        receivedAmount += msg.value;
        callCount++;
        
        // 这里可以执行任何逻辑，包括重新调用发送方合约
        // 但在这个例子中，我们只是记录接收情况
    }
    
    // 查看接收状态
    function getReceiveStatus() external view returns (uint256, uint256) {
        return (receivedAmount, callCount);
    }
}

// 恶意接收合约（演示重入攻击）
contract MaliciousReceiver {
    ExecutionOrderDemo public sender;
    uint256 public attackCount = 0;
    
    constructor(address _sender) {
        sender = ExecutionOrderDemo(_sender);
    }
    
    // 开始攻击
    function startAttack() external payable {
        // 调用发送方的sendETH函数
        sender.sendETH{value: msg.value}(address(this));
    }
    
    // 恶意receive函数
    receive() external payable {
        attackCount++;
        
        // 如果攻击次数少于3次，继续攻击
        if (attackCount < 3) {
            // 重新调用发送方的函数
            sender.sendETH{value: msg.value}(address(this));
        }
    }
    
    // 提取攻击获得的ETH
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}

// 安全的发送合约（遵循CEI模式）
contract SafeSender {
    mapping(address => uint256) public balances;
    
    // 存款
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // 安全的提款（遵循检查-效果-交互模式）
    function safeWithdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "余额不足");
        
        // 先更新状态
        balances[msg.sender] -= amount;
        
        // 后发送ETH
        payable(msg.sender).call{value: amount}("");
    }
    
    // 查看余额
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
} 