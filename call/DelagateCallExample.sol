// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
 * delegateCall 总结：
 * 
 * 1. 基本概念：
 *    - delegateCall 是一种特殊的调用方式，允许一个合约调用另一个合约的函数
 *    - 关键特点：被调用的函数在调用合约的上下文中执行，而不是在被调用合约的上下文中
 * 
 * 2. 与普通 call 的区别：
 *    - call: 在目标合约的上下文中执行，修改目标合约的状态
 *    - delegateCall: 在调用合约的上下文中执行，修改调用合约的状态
 * 
 * 3. 执行环境：
 *    - msg.sender: 保持为原始调用者
 *    - msg.value: 保持为原始调用值
 *    - 存储上下文: 使用调用合约的存储空间
 *    - 代码执行: 使用被调用合约的代码逻辑
 * 
 * 4. 主要用途：
 *    - 代理模式 (Proxy Pattern)
 *    - 库函数调用
 *    - 合约升级
 *    - 代码复用
 * 
 * 5. 注意事项：
 *    - 函数签名必须完全匹配
 *    - 存储布局必须兼容
 *    - 参数类型必须精确匹配（如 uint256 而不是 uint）
 *    - 需要处理调用失败的情况
 * 
 * 6. 安全考虑：
 *    - 确保被调用的合约是可信的
 *    - 验证函数签名和参数
 *    - 检查返回值
 */

contract A{
    uint public number;

    function setNumber(uint num) public{
        number = num + 1;
    }

    function getNmumber() view public returns(uint){
        return number;
    }

    // 普通 call 示例：在目标合约B的上下文中执行，修改合约B的number
    function setNumberByCall(address _contractAddress, uint num)public {
       (bool success,) = _contractAddress.call(
            abi.encodeWithSignature("setNumber(uint256)",num)
        );
        if (!success) {
            revert();
        }
    }

    // delegateCall 示例：在合约A的上下文中执行合约B的代码，修改合约A的number
    // 关键点：虽然执行的是合约B的setNumber逻辑（num + 2），但修改的是合约A的number变量
    function setNumberByDelegateCall(address _contractAddress, uint num) public{
        //这里的setNumber的入参必须是uint256，不能是uint，否则会报错
       (bool success,) = _contractAddress.delegatecall(abi.encodeWithSignature("setNumber(uint256)",num));
       if (!success) {
            revert();
        }
    }

}

contract B{
    uint public number;

    function setNumber(uint num) public{
        number = num + 2;
    }

    function getNmumber() view public returns(uint){
        return number;
    }

}
