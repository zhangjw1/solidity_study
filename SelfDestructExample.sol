// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SelfDestructExample
 * @dev 演示 selfDestruct 功能的合约
 * @notice 这个合约演示了如何使用 selfdestruct 函数销毁合约，并将其余额发送给指定的接收者。只能销毁自己的合约
 */
contract SelfDestructExample {
    address public owner;
    string public message;
    
    // 事件：当合约被销毁时触发
    event ContractDestroyed(address indexed destroyedBy, uint256 balance);
    
    constructor(string memory _message) {
        owner = msg.sender;
        message = _message;
    }
    
    /**
     * @dev 接收以太币的函数
     */
    receive() external payable {
        // 合约可以接收以太币
    }
    
    /**
     * @dev 获取合约余额
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev 只有合约所有者可以销毁合约
     * @param _recipient 接收合约剩余以太币的地址
     */
    function destroyContract(address payable _recipient) public {
        require(msg.sender == owner, "只有合约所有者可以销毁合约");
        require(_recipient != address(0), "接收地址不能为零地址");
        
        // 记录销毁事件
        emit ContractDestroyed(msg.sender, address(this).balance);
        
        // 销毁合约并将所有以太币发送到指定地址
        selfdestruct(_recipient);
    }
    
    /**
     * @dev 紧急销毁函数 - 任何人都可以调用（用于演示）
     */
    function emergencyDestroy() public {
        // 注意：在实际应用中，这应该受到更严格的权限控制
        emit ContractDestroyed(msg.sender, address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}

/**
 * @title SelfDestructTarget
 * @dev 演示如何检查合约是否已被销毁
 */
contract SelfDestructTarget {
    address public targetContract;
    
    constructor(address _targetContract) {
        targetContract = _targetContract;
    }
    
    /**
     * @dev 检查目标合约是否已被销毁
     * @return bool 如果合约已被销毁返回 true
     */
    function isContractDestroyed() public view returns (bool) {
        uint256 size;
        //assembly（内联汇编）是 Solidity 提供的一种底层编程方式，允许你直接编写以太坊虚拟机（EVM）的汇编指令
        assembly {
            //extcodesize 是 EVM 的底层指令，用于获取某个地址上的合约代码长度,常用于判断合约是否已被销毁
            size := extcodesize(targetContract)
        }
        return size == 0;
    }
    
    /**
     * @dev 尝试调用已销毁合约的函数
     */
    function callDestroyedContract() public view returns (bool) {
        /**
        如果合约已被销毁，这个调用会失败
        Solidity 的 try/catch 只能用于外部合约调用和合约创建，不能捕获本地 require/assert/revert 的异常；
        */ 
        try SelfDestructExample(targetContract).getBalance() returns (uint256 balance) {
            return true; // 合约仍然存在
        } catch {
            return false; // 合约已被销毁
        }
    }
} 