// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/**
对比call方法里直接调用方法和使用abi.encodeWithSignature()调用方法的区别
直接调用方法：
1. 需要知道合约接口
2. 编译器知道函数签名
3. 直接调用，编译器知道函数签名
使用abi.encodeWithSignature()调用方法：
1. 不需要知道合约接口
2. 运行时决定调用
3.类似于java的feign和httpclient，能调用任意合约函数
*/
// 目标合约
contract TargetContract {
    event FunctionCalled(string method, string message, uint256 value, uint256 ethReceived);
    
    function foo(string memory _message, uint256 _y) external payable returns (uint256) {
        emit FunctionCalled("foo", _message, _y, msg.value);
        return _y;
    }
    
    function bar() external payable returns (string memory) {
        emit FunctionCalled("bar", "bar called", 0, msg.value);
        return "bar result";
    }
    
    // 可能失败的函数
    function riskyFunction() external payable {
        require(msg.value > 1 ether, "需要超过1 ETH");
        emit FunctionCalled("riskyFunction", "success", 0, msg.value);
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 对比演示合约
contract CallComparisonDemo {
    TargetContract public target;
    
    event CallResult(string method, bool success, bytes data, string description);
    
    constructor() {
        target = new TargetContract();
    }
    
    // 1. 直接调用 - 需要知道合约接口
    function directCall() external payable {
        // 直接调用，编译器知道函数签名
        uint256 result = target.foo("direct call", 42);
        emit CallResult("directCall", true, abi.encode(result), "直接调用成功");
    }
    
    // 2. 使用call - 动态调用
    function callMethod() external payable {
        // 使用call，运行时决定调用
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "call method", 42)
        );
        emit CallResult("callMethod", success, data, "call方法调用");
    }
    
    // 3. 对比：错误处理
    function directCallWithError() external payable {
        try target.riskyFunction{value: msg.value}() {
            emit CallResult("directCallWithError", true, "", "直接调用成功");
        } catch {
            emit CallResult("directCallWithError", false, "", "直接调用失败");
        }
    }
    
    function callMethodWithError() external payable {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("riskyFunction()")
        );
        emit CallResult("callMethodWithError", success, data, "call方法调用");
    }
    
    // 4. 对比：返回值处理
    function directCallWithReturn() external payable returns (uint256) {
        // 直接调用可以直接获取返回值
        uint256 result = target.foo("direct return", 100);
        return result;
    }
    
    function callMethodWithReturn() external payable returns (uint256) {
        (bool success, bytes memory data) = address(target).call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "call return", 100)
        );
        
        if (success) {
            // 需要手动解码返回值
            return abi.decode(data, (uint256));
        }
        return 0;
    }
    
    // 5. 对比：动态函数选择
    function dynamicDirectCall(string memory funcName) external payable {
        // 直接调用需要预先知道所有可能的函数
        if (keccak256(bytes(funcName)) == keccak256(bytes("foo"))) {
            target.foo("dynamic", 42);
        } else if (keccak256(bytes(funcName)) == keccak256(bytes("bar"))) {
            target.bar();
        }
        // 无法处理未知函数
    }
    
    function dynamicCallMethod(string memory funcName) external payable {
        // call方法可以动态构建任何函数调用
        bytes memory data;
        if (keccak256(bytes(funcName)) == keccak256(bytes("foo"))) {
            data = abi.encodeWithSignature("foo(string,uint256)", "dynamic", 42);
        } else if (keccak256(bytes(funcName)) == keccak256(bytes("bar"))) {
            data = abi.encodeWithSignature("bar()");
        } else {
            // 可以处理未知函数
            data = abi.encodeWithSignature("unknownFunction()");
        }
        
        address(target).call{value: msg.value}(data);
    }
    
    // 6. 对比：gas消耗
    function compareGasUsage() external payable {
        // 直接调用
        uint256 gasBefore = gasleft();
        target.foo("gas test", 1);
        uint256 gasUsedDirect = gasBefore - gasleft();
        
        // call方法
        gasBefore = gasleft();
        address(target).call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "gas test", 1)
        );
        uint256 gasUsedCall = gasBefore - gasleft();
        
        emit CallResult("gasComparison", true, 
                       abi.encode(gasUsedDirect, gasUsedCall), 
                       "gas使用对比");
    }
    
    // 7. 实际应用场景：代理合约
    function proxyCall(bytes memory data) external payable {
        // 代理合约只能使用call方法
        (bool success, bytes memory result) = address(target).call{value: msg.value}(data);
        emit CallResult("proxyCall", success, result, "代理调用");
    }
    
    // 8. 实际应用场景：多签钱包
    function multiSigExecute(address target, bytes memory data) external payable {
        // 多签钱包执行任意交易
        (bool success, bytes memory result) = target.call{value: msg.value}(data);
        emit CallResult("multiSigExecute", success, result, "多签执行");
    }
    
    // 9. 获取目标合约余额
    function getTargetBalance() external view returns (uint256) {
        return target.getBalance();
    }
} 