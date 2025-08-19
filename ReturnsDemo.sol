// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**

                 ┌─────────────────────────────┐
                 │   函数声明了 returns 吗？   │
                 └─────────────┬──────────────┘
                               │
             ┌─────────────────┴─────────────────┐
             │                                   │
           是                                否
             │                                   │
┌────────────┴─────────────┐                编译错误或无返回值
│                         │
函数是否有具名返回变量？      │
│                         │
├─────────────┬───────────┤
│             │           │
是           否          ─> 必须显式写 return
│
│
函数体里是否给具名返回变量赋值？
│
├─────────────┬────────────┐
│             │            │
是           否           ─> 返回类型的默认值
│
│
函数结束时会自动 return 这些变量，无需显式 return


没有 returns → 函数不返回值，return 可省略。

有 returns 且无具名变量 → 必须显式写 return，否则编译报错。

有具名返回变量

赋值了 → 结尾会自动 return，return 可省略。

未赋值 → 返回类型默认值（如 uint → 0, bool → false 等）。
*/

contract ReturnsDemo {
    // 1. 状态变量的自动 getter
    uint public number = 42;                    // 自动生成 getter
    string public name = "Alice";               // 自动生成 getter
    bool public isActive = true;                // 自动生成 getter
    
    // 2. 结构体的自动 getter
    struct Person {
        string name;
        uint age;
        bool isStudent;
    }
    
    Person public person = Person("Bob", 25, true);  // 自动生成 getter
    
    // 3. 映射的自动 getter
    mapping(address => uint) public balances;   // 自动生成 getter
    mapping(address => Person) public users;    // 自动生成 getter
    
    constructor() {
        balances[msg.sender] = 1000;
        users[msg.sender] = Person("Charlie", 30, false);
    }
    
    // 4. 显式定义的函数（有 return 语句）
    function getNumber() external view returns (uint) {
        return number;  // 显式 return
    }
    
    function getPerson() external view returns (Person memory) {
        return person;  // 显式 return
    }
    
    // 5. 显式定义的函数（没有 return 语句）
    function getNumberWithoutReturn() external view returns (uint) {
        // 没有 return 语句，会编译错误！
        // 编译器会报错：Function declared as view, but this expression (potentially) modifies the state and thus requires non-payable (the default) or payable.
    }
    
    // 6. 正确的函数（有 return 语句）
    function calculateSum(uint a, uint b) external pure returns (uint) {
        return a + b;  // 显式 return
    }
    
    // 7. 多个返回值的函数
    function getPersonDetails() external view returns (string memory, uint, bool) {
        return (person.name, person.age, person.isStudent);  // 显式 return
    }
    
    // 8. 命名返回值的函数
    function getPersonNamed() external view returns (
        string memory name,
        uint age,
        bool isStudent
    ) {
        name = person.name;      // 直接赋值给返回值
        age = person.age;        // 直接赋值给返回值
        isStudent = person.isStudent;  // 直接赋值给返回值
        // 不需要 return 语句，会自动返回
    }
    
    // 9. 混合使用命名返回值和 return
    function getPersonMixed() external view returns (
        string memory name,
        uint age,
        bool isStudent
    ) {
        name = person.name;      // 直接赋值
        age = person.age;        // 直接赋值
        return (name, age, true);  // 使用 return 覆盖 isStudent
    }
}