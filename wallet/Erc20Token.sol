// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
创建一个Erc20合约
*/
contract Erc20Token is ERC20 {

    constructor() ERC20("MyToken","MTK"){
        _mint(msg.sender,1000000*10**decimals()); // 创建1000000个代币)
    }


}