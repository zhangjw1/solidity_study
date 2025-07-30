// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

// 演示fallback函数的合约
contract FallbackDemo {
    event FallbackCalled(address caller, uint256 value, bytes data, string reason);
    
    // 普通函数
    function normalFunction() external pure returns (string memory) {
        return "normal function called";
    }
    
    // fallback函数 - 当调用不存在的函数时触发
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data, "fallback triggered");
    }
    
    // receive函数 - 当接收ETH时触发
    receive() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data, "receive triggered");
    }
    
    // 获取合约余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 没有fallback函数的合约
contract NoFallback {
    event FunctionCalled(string functionName);
    
    function normalFunction() external {
        emit FunctionCalled("normalFunction");
    }
    
    // 没有fallback函数，调用不存在的函数会失败
}

// 有fallback函数的合约
contract HasFallback {
    event FallbackCalled(string reason, bytes data);
    
    function normalFunction() external {
        emit FunctionCalled("normalFunction");
    }
    
    // fallback函数
    fallback() external payable {
        emit FallbackCalled("fallback called", msg.data);
    }
    
    // receive函数
    receive() external payable {
        emit FallbackCalled("receive called", msg.data);
    }
}

// 演示不同调用场景的合约
contract CallerDemo {
    FallbackDemo public fallbackContract;
    NoFallback public noFallbackContract;
    HasFallback public hasFallbackContract;
    
    event CallResult(string method, bool success, string description);
    
    constructor() {
        fallbackContract = new FallbackDemo();
        noFallbackContract = new NoFallback();
        hasFallbackContract = new HasFallback();
    }
    
    // 1. 调用存在的函数
    function callExistingFunction() external {
        try fallbackContract.normalFunction() {
            emit CallResult("existingFunction", true, "调用存在的函数成功");
        } catch {
            emit CallResult("existingFunction", false, "调用存在的函数失败");
        }
    }
    
    // 2. 调用不存在的函数 - 有fallback
    function callNonExistentWithFallback() external payable {
        try fallbackContract.call{value: msg.value}("nonExistentFunction()") {
            emit CallResult("nonExistentWithFallback", true, "调用不存在函数，fallback处理");
        } catch {
            emit CallResult("nonExistentWithFallback", false, "调用失败");
        }
    }
    
    // 3. 调用不存在的函数 - 没有fallback
    function callNonExistentWithoutFallback() external payable {
        try noFallbackContract.call{value: msg.value}("nonExistentFunction()") {
            emit CallResult("nonExistentWithoutFallback", true, "调用成功");
        } catch {
            emit CallResult("nonExistentWithoutFallback", false, "调用不存在函数，没有fallback，失败");
        }
    }
    
    // 4. 发送ETH - 有receive
    function sendETHWithReceive() external payable {
        try fallbackContract.call{value: msg.value}("") {
            emit CallResult("sendETHWithReceive", true, "发送ETH，receive处理");
        } catch {
            emit CallResult("sendETHWithReceive", false, "发送ETH失败");
        }
    }
    
    // 5. 发送ETH - 没有receive
    function sendETHWithoutReceive() external payable {
        try noFallbackContract.call{value: msg.value}("") {
            emit CallResult("sendETHWithoutReceive", true, "发送ETH成功");
        } catch {
            emit CallResult("sendETHWithoutReceive", false, "发送ETH失败");
        }
    }
    
    // 6. 演示fallback的数据处理
    function callWithData() external payable {
        bytes memory data = abi.encodeWithSignature("someFunction(uint256,string)", 123, "test");
        try fallbackContract.call{value: msg.value}(data) {
            emit CallResult("callWithData", true, "调用带数据的函数，fallback处理");
        } catch {
            emit CallResult("callWithData", false, "调用失败");
        }
    }
    
    // 7. 演示fallback的返回值
    function callAndGetReturn() external payable returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("getData()");
        (bool success, bytes memory returnData) = fallbackContract.call{value: msg.value}(data);
        
        if (success) {
            emit CallResult("callAndGetReturn", true, "fallback返回数据");
            return returnData;
        } else {
            emit CallResult("callAndGetReturn", false, "调用失败");
            return "";
        }
    }
}

// 实际应用：代理合约
contract Proxy {
    address public implementation;
    address public admin;
    
    event ImplementationChanged(address oldImpl, address newImpl);
    event FallbackCalled(address caller, bytes data);
    
    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "只有admin可以调用");
        _;
    }
    
    // 更新实现合约
    function upgrade(address _newImplementation) external onlyAdmin {
        address oldImpl = implementation;
        implementation = _newImplementation;
        emit ImplementationChanged(oldImpl, _newImplementation);
    }
    
    // fallback函数 - 将所有调用转发给实现合约
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.data);
        
        address _impl = implementation;
        assembly {
            // 复制调用数据
            calldatacopy(0, 0, calldatasize())
            
            // 调用实现合约
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            
            // 复制返回数据
            returndatacopy(0, 0, returndatasize())
            
            // 返回结果
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
    
    // receive函数
    receive() external payable {
        // 可以在这里添加逻辑
    }
}

// 实现合约
contract Implementation {
    uint256 public value;
    
    event ValueSet(uint256 newValue);
    
    function setValue(uint256 _value) external {
        value = _value;
        emit ValueSet(_value);
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
} 