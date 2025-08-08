// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Father {
    string public name;

    //如果方法要被继承，需要声明为virtual
    function getName() public pure virtual returns (string memory) {
        return "Father";
    }
}

    contract Son is Father {
        function getFatherName() public pure virtual returns (string memory) {
            return super.getName();
        }

        //如果要重写父类的方法，需要声明为override
        function getName() public pure virtual override returns (string memory) {
            return "Son";
        }
    }

    contract GrandSon is Son {
        function getFatherName() public pure override returns (string memory) {
            return super.getFatherName();
        }   
    }

    //可以多继承
    contract nobody is Father, Son {
        //如果多继承，调用super会按顺序，调用最后一个父类的方法
        function getName() public pure override(Father, Son) returns (string memory) {
            return super.getName();
        }
    }
