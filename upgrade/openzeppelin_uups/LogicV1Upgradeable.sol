// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// UUPS 模式的 V1 实现合约示例
contract LogicV1Upgradeable is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public value;

    event ValueChanged(uint256 newValue);

    // 代替 constructor，用于代理上下文初始化
    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function setValue(uint256 newValue) external onlyOwner {
        value = newValue;
        emit ValueChanged(newValue);
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    // 限制升级权限(核心，升级控制权，与Transparent模式核心区别)
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // 预留存储槽，便于未来追加变量
    uint256[50] private __gap;
}


