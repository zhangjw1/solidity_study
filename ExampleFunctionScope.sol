// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/**
作用域	合约外部可见	合约内部可见	子合约可见	说明
public	✔️	✔️	✔️	公开，任何人都能调用
external	✔️	仅 this.	✖️	只能外部调用，合约内部不能直接调用
internal	✖️	✔️	✔️	仅本合约和子合约可见
private	✖️	✔️	✖️	仅本合约可见
*/

contract ExampleFunctionScope {
    uint256 public age = 100;

    function scopePublic() public view returns (uint256) {
        return age;
    }

    function scopePrivate() private view returns (uint256) {
        return age;
    }

    function scopeExternal() external view returns (uint256) {
        return age;
    }

    function scopeInternal() internal view returns (uint256) {
        return age;
    }

    function scopeCall() public view{
        //调用会失败，只能外部函数调用
   //   scopeExternal();
        scopeInternal();
        scopePrivate();
        scopePublic();
    }
}
