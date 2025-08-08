// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Test {
    uint x;
    // 所有发送到此合约的消息都会调用此函数（没有其他函数）。
    // 向该合约发送以太币将引起异常，
    // 因为fallback函数没有 `payable` 修饰器。
    fallback() external { x = 1; }
}

contract TestPayable {
    uint x;
    uint y;
    // 所有发送到此合约的消息都会调用这个函数，
    // 除了普通的以太传输（除了receive函数，没有其他函数）。
    // 任何对该合约的非空的调用都将执行fallback函数（即使以太与调用一起被发送）。
    fallback() external payable { x = 1; y = msg.value; }

    // 这个函数是为纯以太传输而调用的，
    // 即为每一个带有空calldata的调用。
    receive() external payable { x = 2; y = msg.value; }
}

contract Caller {
    function callTest(Test test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // 结果是 test.x 等于 1。

        // address(test)将不允许直接调用 ``send``，
        // 因为 ``test`` 没有可接收以太的fallback函数。
        // 它必须被转换为 ``address payable`` 类型，才允许调用 ``send``。
        address payable testPayable = payable(address(test));

        // 如果有人向该合约发送以太币，转账将失败，即这里返回false。
        return testPayable.send(2 ether);
    }

    function callTestPayable(TestPayable test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // 结果是 test.x 等于 1，test.y 等于 0。
        (success,) = address(test).call{value: 1}(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // 结果是 test.x 等于 1，test.y 等于 1。

        // 如果有人向该合约发送以太币，TestPayable的receive函数将被调用。
        // 由于该函数会写入存储空间，它需要的燃料比简单的 ``send`` 或 ``transfer`` 要多。
        // 由于这个原因，我们必须要使用一个低级别的调用。
        (success,) = address(test).call{value: 2 ether}("");
        require(success);
        // 结果是 test.x 等于 1，test.y 等于 2 个以太。

        return true;
    }
}