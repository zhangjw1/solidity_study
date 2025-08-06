// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
只能声明函数，不能实现函数体。
不能声明状态变量（只能常量）。
所有函数都必须是 external。
不能有构造函数、不能继承其他合约（但可以继承接口）
*/
interface IEmployee {
    function setName(string memory name) external;
    function getName() external view returns (string memory);
}

/**
用 is IEmployee 继承接口
实现接口的合约必须实现接口中的所有方法
如果不想实现某些方法，可以将合约标记为 abstract
abstract 合约不能被直接部署，只能被其他合约继承
实现接口方法时，override 是必须的
*/
contract Employee is IEmployee {
    string public name;

    function setName(string memory _name) external override {
        name = _name;
    }

    function getName() external view override returns (string memory) {
        return name;
    }
}

contract commany {
    IEmployee employee;

    //传的是实现了IEmployee接口的合约的地址
    constructor(address _employee) {
        employee = IEmployee(_employee);
    }

    function setName(string memory _name) external {
        employee.setName(_name);
    }

    function getName() external view returns (string memory) {
        return employee.getName();
    }
}
