// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
1.Library 是一个无状态的合约，不能存储数据
2.只包含函数，用于提供可重用的工具函数
3.可以被多个合约调用，节省 gas 费用
4.类似于java的util工具类
*/
library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
}

contract Math {
    //配套语法，使用using for，uint256指定了库函数可以操作的数据类型
    using SafeMath for uint256;

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a.add(b);
    }

    //调用方式一
    function sub(uint256 a, uint256 b) public pure returns (uint256) {
        return a.sub(b);
    }

    //调用方式二
    function mul(uint256 a, uint256 b) public pure returns (uint256) {
        return SafeMath.mul(a, b);
    }
}