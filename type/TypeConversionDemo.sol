// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/**
合约类型转换
1. address可以转换为TargetContract
2. 合约可以转换为address
3. 接口可以转换为address
4. address可以转换为接口
*/
contract TargetContract {
    string public name = "Target";
    
    function getName() external view returns (string memory) {
        return name;
    }
}

// 演示类型转换的合约
contract TypeConversionDemo {
    // 存储目标合约的引用
    TargetContract public target;
    
    // 构造函数 - 接收地址并转换为合约类型
    constructor(address _targetAddress) {
        // 类型转换：address -> TargetContract
        target = TargetContract(_targetAddress);
    }

    
    // 演示合约类型转换
    function convertToContract(address contractAddr) external pure returns (TargetContract) {
        // 将地址转换为合约类型
        TargetContract contract = TargetContract(contractAddr);
        return contract;
    }
    
    // 调用目标合约的函数
    function callTarget() external view returns (string memory) {
        // 通过转换后的合约实例调用函数
        return target.getName();
    }
}

// 工厂合约 - 创建并返回合约地址
contract ContractFactory {
    // 创建目标合约
    function createTarget() external returns (address) {
        TargetContract target = new TargetContract();
        return address(target);
    }
    
    // 创建演示合约
    function createDemo(address targetAddress) external returns (address) {
        TypeConversionDemo demo = new TypeConversionDemo(targetAddress);
        return address(demo);
    }
    
    // 完整的创建流程
    function createComplete() external returns (address target, address demo) {
        // 1. 创建目标合约
        TargetContract targetContract = new TargetContract();
        
        // 2. 创建演示合约，传入目标合约地址
        TypeConversionDemo demoContract = new TypeConversionDemo(address(targetContract));
        
        return (address(targetContract), address(demoContract));
    }
}

// 演示接口转换
interface ITarget {
    function getName() external view returns (string memory);
}

contract InterfaceDemo {
    ITarget public target;
    
    constructor(address _target) {
        // 将地址转换为接口类型
        target = ITarget(_target);
    }
    
    function callInterface() external view returns (string memory) {
        return target.getName();
    }
} 