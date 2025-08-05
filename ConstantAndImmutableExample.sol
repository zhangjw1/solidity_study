// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract ConstantAndImmutableExample{


    /**
    constant 变量在编译时就必须赋值，且赋值后不能再更改。
    只能用于数值型、字符串、字节型等基础类型。
    其值会直接嵌入到合约的字节码中，节省gas。
    可以在 pure 函数中读取
    */
    string constant name = "biden";
    /**
    immutable 变量在声明时可以不赋值，但必须在构造函数（constructor）中赋值，且只能赋值一次。
    赋值后不能再更改。
    适用于那些在部署时才能确定的常量，比如合约部署者地址、初始化参数等
    只能在 view 函数中读取，不能在 pure 函数中读取
    */
    uint immutable age;


    constructor() {
        age = 80;
    }

    function getAge() public view returns (uint) {
        return age;
    }

    //pure 修饰符表示该函数既不读取也不修改链上的状态,但 constant 变量不是存储在 storage 里，而是直接写在代码里，所以 pure 可以访问 constant
    function getName() public pure returns (string memory) {
        return name;
    }

}

