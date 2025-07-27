// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleEnum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    Status status;

    function get() public view returns (Status) {
        return status;
    }

    //输入的必须是数字1-5，不能是字符串
    function setStatus(Status _status)  public {
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

    function statusToString(Status _status) public  pure returns (string memory) {
        if (_status == Status.Pending) return "Pending";
        if (_status == Status.Shipped) return "Shipped";
        if (_status == Status.Accepted) return "Accepted";
        if (_status == Status.Rejected) return "Rejected";
        if (_status == Status.Canceled) return "Canceled";
        return "Unknown";
    }

        function StringTostatus(string memory _status) public  pure returns (Status) {
        if (keccak256(bytes(_status)) == keccak256(bytes("Pending"))) return Status.Pending;
        if (keccak256(bytes(_status)) == keccak256(bytes("Shipped"))) return Status.Shipped;
        if (keccak256(bytes(_status)) == keccak256(bytes("Accepted"))) return Status.Accepted;
        if (keccak256(bytes(_status)) == keccak256(bytes("Rejected"))) return Status.Rejected;
        if (keccak256(bytes(_status)) == keccak256(bytes("Canceled"))) return Status.Canceled;
       revert();
    }
}
