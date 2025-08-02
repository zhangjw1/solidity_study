// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

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

// 演示投票合约中的情况
contract BallotReturns {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    
    struct Proposal {
        bytes32 name;
        uint voteCount;
    }
    
    mapping(address => Voter) public voters;  // 自动生成 getter
    Proposal[] public proposals;              // 自动生成 getter
    
    constructor(bytes32[] memory proposalNames) {
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    // 显式定义的函数（有 return）
    function getVoter(address voter) external view returns (Voter memory) {
        return voters[voter];  // 显式 return
    }
    
    function getProposal(uint index) external view returns (Proposal memory) {
        require(index < proposals.length, "Index out of bounds");
        return proposals[index];  // 显式 return
    }
    
    // 命名返回值的函数
    function getVoterDetails(address voter) external view returns (
        uint weight,
        bool voted,
        address delegate,
        uint vote
    ) {
        Voter storage v = voters[voter];
        weight = v.weight;       // 直接赋值
        voted = v.voted;         // 直接赋值
        delegate = v.delegate;   // 直接赋值
        vote = v.vote;           // 直接赋值
        // 不需要 return 语句
    }
    
    // 混合使用
    function getProposalDetails(uint index) external view returns (
        bytes32 name,
        uint voteCount
    ) {
        require(index < proposals.length, "Index out of bounds");
        name = proposals[index].name;        // 直接赋值
        return (name, proposals[index].voteCount);  // 使用 return
    }
} 