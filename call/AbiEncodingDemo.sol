// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract AbiEncodingDemo {
    
    // 演示编码过程
    function demonstrateEncoding() external pure returns (
        bytes memory encodedData,
        bytes4 functionSelector,
        string memory explanation
    ) {
        // 编码函数调用
        encodedData = abi.encodeWithSignature("foo(string,uint256)", "hello", 123);
        
        // 提取函数选择器（前4个字节）
        functionSelector = bytes4(encodedData);
        
        explanation = "编码将函数调用转换为字节数据，前4字节是函数选择器";
        
        return (encodedData, functionSelector, explanation);
    }
    
    // 演示不同函数的编码
    function demonstrateDifferentFunctions() external pure returns (
        bytes memory noParamCall,
        bytes memory oneParamCall,
        bytes memory multiParamCall
    ) {
        // 无参数函数
        noParamCall = abi.encodeWithSignature("bar()");
        
        // 单参数函数
        oneParamCall = abi.encodeWithSignature("baz(uint256)", 42);
        
        // 多参数函数
        multiParamCall = abi.encodeWithSignature("foo(string,uint256,bool)", "test", 123, true);
        
        return (noParamCall, oneParamCall, multiParamCall);
    }
    
    // 演示编码的内容
    function showEncodedContent() external pure returns (
        bytes4 selector,
        bytes memory parameters,
        string memory breakdown
    ) {
        bytes memory fullData = abi.encodeWithSignature("foo(string,uint256)", "hello", 123);
        
        // 前4字节是函数选择器
        selector = bytes4(fullData);
        
        // 剩余字节是参数数据
        parameters = new bytes(fullData.length - 4);
        for (uint256 i = 4; i < fullData.length; i++) {
            parameters[i - 4] = fullData[i];
        }
        
        breakdown = "编码数据 = 函数选择器(4字节) + 参数数据(可变长度)";
        
        return (selector, parameters, breakdown);
    }
    
    // 演示手动构建编码数据
    function manualEncoding() external pure returns (
        bytes memory autoEncoded,
        bytes memory manualEncoded,
        bool areEqual
    ) {
        // 自动编码
        autoEncoded = abi.encodeWithSignature("foo(string,uint256)", "hello", 123);
        
        // 手动编码（演示原理）
        bytes4 selector = bytes4(keccak256("foo(string,uint256)"));
        bytes memory params = abi.encode("hello", 123);
        
        // 组合
        manualEncoded = new bytes(4 + params.length);
        for (uint256 i = 0; i < 4; i++) {
            manualEncoded[i] = selector[i];
        }
        for (uint256 i = 0; i < params.length; i++) {
            manualEncoded[i + 4] = params[i];
        }
        
        areEqual = keccak256(autoEncoded) == keccak256(manualEncoded);
        
        return (autoEncoded, manualEncoded, areEqual);
    }
    
    // 演示解码过程
    function demonstrateDecoding() external pure returns (
        string memory decodedString,
        uint256 decodedNumber
    ) {
        // 编码数据
        bytes memory encodedData = abi.encodeWithSignature("foo(string,uint256)", "hello", 123);
        
        // 解码参数（跳过前4字节的函数选择器）
        bytes memory params = new bytes(encodedData.length - 4);
        for (uint256 i = 4; i < encodedData.length; i++) {
            params[i - 4] = encodedData[i];
        }
        
        // 解码参数
        (decodedString, decodedNumber) = abi.decode(params, (string, uint256));
        
        return (decodedString, decodedNumber);
    }
    
    // 演示函数选择器
    function showFunctionSelectors() external pure returns (
        bytes4 fooSelector,
        bytes4 barSelector,
        bytes4 bazSelector
    ) {
        // 不同函数的选择器
        fooSelector = bytes4(keccak256("foo(string,uint256)"));
        barSelector = bytes4(keccak256("bar()"));
        bazSelector = bytes4(keccak256("baz(uint256)"));
        
        return (fooSelector, barSelector, bazSelector);
    }
    
    // 演示编码的实际应用
    function practicalExample() external pure returns (
        bytes memory callData,
        string memory explanation
    ) {
        // 实际应用：准备调用数据
        callData = abi.encodeWithSignature("transfer(address,uint256)", 
                                         0x1234567890123456789012345678901234567890, 
                                         1000000000000000000); // 1 ETH
        
        explanation = "这是调用ERC20 transfer函数的标准编码数据";
        
        return (callData, explanation);
    }
    
    // 演示动态编码
    function dynamicEncoding(string memory funcName, string memory message, uint256 value) 
        external pure returns (bytes memory encodedData) {
        
        if (keccak256(bytes(funcName)) == keccak256(bytes("foo"))) {
            encodedData = abi.encodeWithSignature("foo(string,uint256)", message, value);
        } else if (keccak256(bytes(funcName)) == keccak256(bytes("bar"))) {
            encodedData = abi.encodeWithSignature("bar()");
        } else {
            // 默认调用
            encodedData = abi.encodeWithSignature("default(string)", message);
        }
        
        return encodedData;
    }
} 