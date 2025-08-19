// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    // 逻辑合约地址
    address public implementation;
    
    // 管理员地址
    address public admin;
    
    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }
    
    // 升级逻辑合约
    function upgradeTo(address newImplementation) external {
        require(msg.sender == admin, "Only admin");
        implementation = newImplementation;
    }
    
    // 委托调用逻辑合约
    fallback() external payable {
        address _impl = implementation;
        require(_impl != address(0), "Implementation not set");
        
        //内联汇编
        assembly {
            // 复制calldata到内存
            calldatacopy(0, 0, calldatasize())
            
            // 使用delegatecall调用逻辑合约(保证调用的数据变量存储在proxy合约中，升级时不会丢失数据)
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            
            // 复制返回数据
            returndatacopy(0, 0, returndatasize())
            
            // 处理结果
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
    
    // 接收ETH
    receive() external payable {}
}