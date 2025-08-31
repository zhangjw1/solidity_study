// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TransferFromExample is ERC20 {
    constructor() ERC20("TransferFromExample", "TFX") {
        _mint(msg.sender, 10000 * 10**decimals());
    }
    
    // 演示transferFrom的参数验证
    function safeTransferFrom(
        address from,    // 代币来源地址
        address to,      // 代币目标地址
        uint256 amount   // 转账数量
    ) external returns (bool) {
        
        // 参数验证
        require(from != address(0), "From address cannot be zero");
        require(to != address(0), "To address cannot be zero");
        require(amount > 0, "Amount must be greater than 0");
        
        // 检查授权额度
        uint256 currentAllowance = allowance(from, msg.sender);
        require(currentAllowance >= amount, "Insufficient allowance");
        
        // 检查余额
        require(balanceOf(from) >= amount, "Insufficient balance");
        
        // 减少授权额度
        _approve(from, msg.sender, currentAllowance - amount);
        
        // 执行transferFrom
        return transferFrom(from, to, amount);
    }
    
    // 查询相关状态
    function getTransferInfo(
        address from, 
        address spender
    ) external view returns (
        uint256 balance,      // from的余额
        uint256 allowance,    // spender的授权额度
        uint256 totalSupply   // 总供应量
    ) {
        return (
            balanceOf(from),
            allowance(from, spender),
            totalSupply()
        );
    }
    
    // 批量转账（需要多次approve）
    function batchTransferFrom(
        address[] calldata froms,
        address[] calldata tos,
        uint256[] calldata amounts
    ) external returns (bool[] memory results) {
        require(
            froms.length == tos.length && tos.length == amounts.length,
            "Arrays length mismatch"
        );
        
        results = new bool[](froms.length);
        
        for (uint256 i = 0; i < froms.length; i++) {
            try this.safeTransferFrom(froms[i], tos[i], amounts[i]) {
                results[i] = true;
            } catch {
                results[i] = false;
            }
        }
        
        return results;
    }
}

// 模拟使用场景(transferFrom的使用场景是授权第三方使用代币，是在第三方调用)
contract TokenUser {
    TransferFromExample public token;
    
    constructor(address _token) {
        token = TransferFromExample(_token);
    }
    
    // 用户授权此合约使用代币
    function approveContract(uint256 amount) external {
        token.approve(address(this), amount);
    }
    
    // 合约代表用户转账
    function transferForUser(
        address user,    // 代币拥有者
        address recipient, // 接收者
        uint256 amount   // 数量
    ) external {
        // 调用transferFrom
        token.transferFrom(user, recipient, amount);
        // 参数说明：
        // user: 代币来源地址（from）
        // recipient: 代币目标地址（to）
        // amount: 转账数量
    }
} 