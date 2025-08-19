// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LogicV1Upgradeable.sol";

// 在 V1 的基础上追加状态与功能的 V2 示例（使用openzeppelin的UUPS模式，不需要自己写proxy合约，直接使用openzeppelin的插件即可）
contract LogicV2Upgradeable is LogicV1Upgradeable {
    // 新增状态变量（只能追加在末尾）
    uint256 public incrementStep;

    event Incremented(uint256 newValue);

    // 升级时的二次初始化，用于初始化新增状态
    function initializeV2(uint256 step) public reinitializer(2) {
        incrementStep = step;
    }

    function increment() external onlyOwner {
        uint256 step = incrementStep == 0 ? 1 : incrementStep;
        value += step;
        emit Incremented(value);
    }

    function version() external pure returns (string memory) {
        return "V2";
    }

    // 追加新的 gap，保持可扩展性
    uint256[49] private __gapV2;
}


