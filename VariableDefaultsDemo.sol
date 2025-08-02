// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract VariableDefaultsDemo {
    // 合约级别的状态变量 - 默认是 storage
    string public stateString = "state";           // storage
    uint256[] public stateArray;                   // storage
    mapping(address => uint256) public stateMapping;  // storage
    
    // 函数内的局部变量 - 默认是 memory
    function demonstrateDefaults() external {
        // 局部变量默认是 memory
        string localString = "local";              // memory
        uint256[] localArray;                      // memory
        uint256 localNumber = 123;                 // memory
        
        // 需要明确指定 storage 来引用状态变量
        string storage stateRef = stateString;     // storage 引用
        uint256[] storage arrayRef = stateArray;   // storage 引用
    }
    
    // 函数参数默认是 memory
    function processData(string data) external {   // data 默认是 memory
        // 可以明确指定 memory
        string memory explicitMemory = data;       // memory
        
        // 可以创建 storage 引用
        string storage stateRef = stateString;     // storage 引用
    }
    
    // 返回值默认是 memory
    function getData() external view returns (string) {  // 返回 memory
        return stateString;  // 从 storage 复制到 memory
    }
    
    // 明确指定返回 storage 引用
    function getStorageRef() external view returns (string storage) {
        return stateString;  // 返回 storage 引用
    }
}

// 演示不同场景的默认类型
contract DefaultTypesDemo {
    // 状态变量 - storage
    string public name = "John";
    uint256[] public numbers;
    
    // 结构体中的变量
    struct Person {
        string name;        // 在 storage 结构体中，默认为 storage
        uint256 age;        // 在 storage 结构体中，默认为 storage
    }
    
    Person public person;
    
    function demonstrateStructDefaults() external {
        // 创建 memory 结构体
        Person memory memoryPerson = Person("Alice", 25);  // 明确指定 memory
        
        // 修改 storage 结构体
        Person storage storagePerson = person;  // 明确指定 storage
        storagePerson.name = "Bob";
        storagePerson.age = 30;
    }
    
    function demonstrateArrayDefaults() external {
        // 局部数组默认是 memory
        uint256[] localArray;                    // memory
        uint256[] memory explicitMemory = new uint256[](5);  // memory
        
        // 状态数组是 storage
        uint256[] storage storageArray = numbers;  // storage 引用
        
        // 可以创建 memory 数组
        uint256[] memory memoryArray = new uint256[](10);
        for (uint256 i = 0; i < 10; i++) {
            memoryArray[i] = i;
        }
    }
    
    function demonstrateMappingDefaults() external {
        // 局部 mapping 默认是 storage（但需要引用现有 mapping）
        mapping(address => uint256) storage localMapping;  // 需要引用现有 mapping
        
        // 不能创建 memory mapping
        // mapping(address => uint256) memory memoryMapping;  // 编译错误！
    }
}

// 演示常见错误
contract CommonErrors {
    string public name = "Test";
    
    function wrongFunction() external {
        // ❌ 错误：不能将 storage 直接赋值给 storage 变量
        // string storage wrongRef = name;  // 编译错误
        
        // ✅ 正确：创建 storage 引用
        string storage correctRef = name;
        
        // ✅ 正确：storage 到 memory
        string memory memoryCopy = name;
    }
    
    function demonstrateParameterDefaults() external {
        // 函数参数默认是 memory
        processString("hello");  // 参数是 memory
    }
    
    function processString(string data) internal {
        // data 默认是 memory
        string memory processed = data;  // 明确指定 memory
    }
} 