// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleEnum {
    enum Status {
        Pending, // 值为 0
        Shipped, // 值为 1
        Accepted, // 值为 2
        Rejected, // 值为 3
        Canceled // 值为 4
    }

    Status status;

    function get() public view returns (Status) {
        return status;
    }

    //输入的必须是数字1-5，不能是字符串
    function setStatus(Status _status) public {
        status = _status;
    }

    function set(uint256 _status) public {
        require(_status > 0 && _status <= 5, "Not a valid status");
        status = Status(_status);
    }

    //删除枚举，恢复默认值
    function reset() public {
        delete status;
    }

    function statusToString(
        Status _status
    ) public pure returns (string memory) {
        if (_status == Status.Pending) return "Pending";
        if (_status == Status.Shipped) return "Shipped";
        if (_status == Status.Accepted) return "Accepted";
        if (_status == Status.Rejected) return "Rejected";
        if (_status == Status.Canceled) return "Canceled";
        return "Unknown";
    }

    function StringTostatus(
        string memory _status
    ) public pure returns (Status) {
        if (keccak256(bytes(_status)) == keccak256(bytes("Pending")))
            return Status.Pending;
        if (keccak256(bytes(_status)) == keccak256(bytes("Shipped")))
            return Status.Shipped;
        if (keccak256(bytes(_status)) == keccak256(bytes("Accepted")))
            return Status.Accepted;
        if (keccak256(bytes(_status)) == keccak256(bytes("Rejected")))
            return Status.Rejected;
        if (keccak256(bytes(_status)) == keccak256(bytes("Canceled")))
            return Status.Canceled;
        revert();
    }

    // 测试函数：验证枚举标识符的实际值
    function testEnumValues()
        public
        pure
        returns (uint256, uint256, uint256, uint256, uint256)
    {
        return (
            uint256(Status.Pending), // 应该返回 0
            uint256(Status.Shipped), // 应该返回 1
            uint256(Status.Accepted), // 应该返回 2
            uint256(Status.Rejected), // 应该返回 3
            uint256(Status.Canceled) // 应该返回 4
        );
    }

    // 展示枚举的"key-value"对应关系
    function showEnumMapping()
        public
        pure
        returns (
            string memory key0,
            uint256 value0,
            string memory key1,
            uint256 value1,
            string memory key2,
            uint256 value2,
            string memory key3,
            uint256 value3,
            string memory key4,
            uint256 value4
        )
    {
        return (
            "Pending",
            uint256(Status.Pending), // key: "Pending", value: 0
            "Shipped",
            uint256(Status.Shipped), // key: "Shipped", value: 1
            "Accepted",
            uint256(Status.Accepted), // key: "Accepted", value: 2
            "Rejected",
            uint256(Status.Rejected), // key: "Rejected", value: 3
            "Canceled",
            uint256(Status.Canceled) // key: "Canceled", value: 4
        );
    }
}
