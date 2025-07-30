// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

// 目标合约
contract TargetContract {
    event FunctionCalled(string functionName, string message, uint256 value, uint256 ethReceived);
    
    // 接收ETH的函数
    receive() external payable {
        emit FunctionCalled("receive", "ETH received", 0, msg.value);
    }
    
    // 回退函数
    fallback() external payable {
        emit FunctionCalled("fallback", "Unknown function called", 0, msg.value);
    }
    
    // 带参数的函数
    function foo(string memory _message, uint256 _y) external payable returns (uint256) {
        emit FunctionCalled("foo", _message, _y, msg.value);
        return _y;
    }
    
    // 不带参数的函数
    function bar() external payable returns (string memory) {
        emit FunctionCalled("bar", "bar called", 0, msg.value);
        return "bar result";
    }
    
    // 获取余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 演示call方法的合约
contract CallDemo {
    TargetContract public target;
    
    event CallResult(bool success, bytes data, string description);
    
    constructor() {
        target = new TargetContract();
    }
    
    // 1. 最简单的call - 只发送ETH，不调用函数
    function simpleCall() external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}("");
        emit CallResult(success, data, "简单call - 只发送ETH");
    }
    
    // 2. 调用不存在的函数 - 触发fallback
    function callNonExistent() external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}("xyz");
        emit CallResult(success, data, "调用不存在的函数 - 触发fallback");
    }
    
    // 3. 调用foo函数 - 使用abi.encodeWithSignature
    function callFoo(string memory message, uint256 y) external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", message, y)
        );
        emit CallResult(success, data, "调用foo函数");
    }
    
    // 4. 调用bar函数 - 无参数函数
    function callBar() external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("bar()")
        );
        emit CallResult(success, data, "调用bar函数");
    }
    
    // 5. 演示不同的value值
    function callWithDifferentValue(uint256 ethAmount) external payable {
        require(msg.value >= ethAmount, "ETH不足");
        
        (bool success, bytes memory data) = address(target).call{value: ethAmount}(
            abi.encodeWithSignature("foo(string,uint256)", "不同ETH数量", 100)
        );
        emit CallResult(success, data, "不同ETH数量的调用");
    }
    
    // 6. 解析返回数据
    function callAndDecode() external payable returns (uint256 decodedValue) {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "解码测试", 42)
        );
        
        if (success) {
            // 解码返回的uint256值
            decodedValue = abi.decode(data, (uint256));
        }
        
        emit CallResult(success, data, "解码返回数据");
        return decodedValue;
    }
    
    // 7. 演示错误处理
    function callWithErrorHandling() external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("nonExistentFunction()")
        );
        
        if (!success) {
            // 处理调用失败的情况
            emit CallResult(false, data, "调用失败");
        } else {
            emit CallResult(true, data, "调用成功");
        }
    }
    
    // 8. 获取目标合约余额
    function getTargetBalance() external view returns (uint256) {
        return target.getBalance();
    }
    
    // 9. 演示abi.encodeWithSignature的详细用法
    function demonstrateAbiEncoding() external pure returns (
        bytes memory simpleCall,
        bytes memory functionCall,
        bytes memory multiParamCall
    ) {
        // 空调用
        simpleCall = "";
        
        // 调用无参数函数
        functionCall = abi.encodeWithSignature("bar()");
        
        // 调用多参数函数
        multiParamCall = abi.encodeWithSignature("foo(string,uint256)", "test", 123);
        
        return (simpleCall, functionCall, multiParamCall);
    }
} 