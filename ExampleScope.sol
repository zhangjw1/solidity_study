// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract ExampleScope{
    uint256 public age = 100;
    uint256 public price = 99;

//view能读链上的数据，但是不能修改
    function getAgeWithView() public view returns (uint256){
        return age;
    }

//pure不能读链上的数据，也不能修改
    function getAgeWithPure(uint256 _age) public pure returns (uint256){

     //   return age + _age;
     return _age + 10;
    }

    //payable允许函数接收以太币(例如ICO定价，NFT定价)
    function getMoneyWithPayable(uint256 _price) public payable  returns (uint256){
     return price + _price;
    }


}