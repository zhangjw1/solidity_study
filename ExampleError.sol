// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

error Unauthorized(string error,address _address);

contract ExampleError {
    address payable owner = payable(msg.sender);

    function withraw() public {
        if (msg.sender != owner) {
            revert Unauthorized({error:"invalid user",_address :msg.sender});
        } else {
            owner.transfer(address(this).balance);
        }
    }
}
