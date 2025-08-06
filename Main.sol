// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 Utils.sol 中的特定符号
import { Math, VERSION } from "./Utils.sol";

contract Main {
    // 直接使用导入的 VERSION 常量
    uint public contractVersion = VERSION;

    function calculate(uint x, uint y) public pure returns (uint) {
        // 使用导入的 Math 库
        return Math.add(x, y);
    }
}
