// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract AddressDemo {
    address public owner;
    
    // 事件
    event ETHSent(address indexed to, uint256 amount, bool success);
    event BalanceChecked(address indexed target, uint256 balance);
    
    constructor() {
        owner = msg.sender;
    }
    
    // 1. 获取余额
    function getBalance(address target) external view returns (uint256) {
        return target.balance;
    }
    
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    // 2. 使用transfer发送ETH
    function sendWithTransfer(address recipient, uint256 amount) external {
        require(address(this).balance >= amount, "合约余额不足");
        require(recipient != address(0), "无效地址");
        
        payable(recipient).transfer(amount);
        emit ETHSent(recipient, amount, true);
    }
    
    // 3. 使用send发送ETH
    function sendWithSend(address recipient, uint256 amount) external returns (bool) {
        require(address(this).balance >= amount, "合约余额不足");
        require(recipient != address(0), "无效地址");
        
        bool success = payable(recipient).send(amount);
        emit ETHSent(recipient, amount, success);
        return success;
    }
    
    // 4. 使用call发送ETH
    function sendWithCall(address recipient, uint256 amount) external returns (bool, bytes memory) {
        require(address(this).balance >= amount, "合约余额不足");
        require(recipient != address(0), "无效地址");
        
        (bool success, bytes memory data) = payable(recipient).call{value: amount}("");
        emit ETHSent(recipient, amount, success);
        return (success, data);
    }
    
    // 5. 检查地址是否为合约
    function isContract(address addr) external view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
    
    // 6. 批量检查余额
    function checkMultipleBalances(address[] calldata addresses) external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](addresses.length);
        
        for (uint256 i = 0; i < addresses.length; i++) {
            balances[i] = addresses[i].balance;
        }
        
        return balances;
    }
    
    // 7. 安全的ETH发送函数
    function safeSendETH(address recipient, uint256 amount) external returns (bool) {
        require(recipient != address(0), "不能发送到零地址");
        require(amount > 0, "金额必须大于0");
        require(address(this).balance >= amount, "余额不足");
        
        // 使用call方法（推荐）
        (bool success, ) = payable(recipient).call{value: amount}("");
        
        if (success) {
            emit ETHSent(recipient, amount, true);
        } else {
            emit ETHSent(recipient, amount, false);
        }
        
        return success;
    }
    
    // 8. 接收ETH的函数
    receive() external payable {
        // 合约可以接收ETH
    }
    
    // 9. 提取合约余额（只有owner）
    function withdraw() external {
        require(msg.sender == owner, "只有owner可以提取");
        require(address(this).balance > 0, "合约余额为0");
        
        uint256 amount = address(this).balance;
        payable(owner).transfer(amount);
        
        emit ETHSent(owner, amount, true);
    }
    
    // 10. 比较地址
    function compareAddresses(address addr1, address addr2) external pure returns (bool) {
        return addr1 == addr2;
    }
    
    // 11. 地址转换
    function addressConversions(address addr) external pure returns (uint160, bytes20) {
        uint160 asNumber = uint160(addr);
        bytes20 asBytes = bytes20(addr);
        return (asNumber, asBytes);
    }
    
    // 12. 展示payable的不同用法
    function demonstratePayable(address regularAddr, address payable payableAddr) external {
        // 普通地址可以查询余额
        uint256 balance1 = regularAddr.balance;
        
        // 普通地址需要转换才能接收ETH
        payable(regularAddr).transfer(100);
        
        // payable地址可以直接接收ETH
        payableAddr.transfer(100);
        
        // payable地址也可以查询余额
        uint256 balance2 = payableAddr.balance;
    }
    
    // 13. 灵活的地址处理函数
    function flexibleAddressHandler(address addr, bool shouldSendETH) external {
        if (shouldSendETH) {
            // 需要发送ETH时转换为payable
            payable(addr).transfer(100);
        } else {
            // 不需要发送ETH时保持为普通address
            uint256 balance = addr.balance;
        }
    }
} 