// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
 * 高级类型操作和类型安全示例
 * 
 * 1. 类型别名 (Type Aliases)
 * 2. 用户定义类型 (User-Defined Types)
 * 3. 类型转换和包装
 * 4. 类型安全操作
 * 5. 高级数据结构
 * 6. 类型约束
 */

// 1. 类型别名 - 提高代码可读性和类型安全
type UserId is uint256;
type Price is uint256;
type Timestamp is uint256;
type Percentage is uint8;

// 2. 用户定义类型 - 创建强类型
type NonZeroUint is uint256;
type ValidAddress is address;

// 3. 类型安全的库函数
library TypeSafeMath {
    // 安全的加法
    function add(NonZeroUint a, NonZeroUint b) internal pure returns (NonZeroUint) {
        return NonZeroUint.wrap(NonZeroUint.unwrap(a) + NonZeroUint.unwrap(b));
    }
    
    // 安全的乘法
    function mul(Price a, Price b) internal pure returns (Price) {
        return Price.wrap(Price.unwrap(a) * Price.unwrap(b));
    }
    
    // 安全的除法
    function div(Price a, Price b) internal pure returns (Price) {
        require(Price.unwrap(b) > 0, "Division by zero");
        return Price.wrap(Price.unwrap(a) / Price.unwrap(b));
    }
    
    // 比较操作
    function gt(Price a, Price b) internal pure returns (bool) {
        return Price.unwrap(a) > Price.unwrap(b);
    }
    
    function lt(Price a, Price b) internal pure returns (bool) {
        return Price.unwrap(a) < Price.unwrap(b);
    }
    
    function eq(Price a, Price b) internal pure returns (bool) {
        return Price.unwrap(a) == Price.unwrap(b);
    }
}

// 4. 类型安全的合约
contract TypeSafeContract {
    using TypeSafeMath for Price;
    using TypeSafeMath for NonZeroUint;
    
    // 类型安全的状态变量
    mapping(UserId => UserData) public users;
    mapping(Price => uint256) public priceHistory;
    
    // 类型安全的结构体
    struct UserData {
        ValidAddress addr;
        Price balance;
        Timestamp lastActive;
        Percentage discount;
    }
    
    // 类型安全的构造函数
    constructor() {
        // 初始化一些测试数据
        UserId userId = UserId.wrap(1);
        ValidAddress userAddr = ValidAddress.wrap(msg.sender);
        Price initialBalance = Price.wrap(1000);
        Timestamp now = Timestamp.wrap(block.timestamp);
        Percentage discount = Percentage.wrap(10);
        
        users[userId] = UserData(userAddr, initialBalance, now, discount);
    }
    
    // 类型安全的函数
    function createUser(uint256 id, address addr, uint256 balance) external returns (UserId) {
        require(id > 0, "User ID must be positive");
        require(addr != address(0), "Invalid address");
        require(balance > 0, "Balance must be positive");
        
        UserId userId = UserId.wrap(id);
        ValidAddress validAddr = ValidAddress.wrap(addr);
        Price userBalance = Price.wrap(balance);
        Timestamp now = Timestamp.wrap(block.timestamp);
        Percentage defaultDiscount = Percentage.wrap(0);
        
        users[userId] = UserData(validAddr, userBalance, now, defaultDiscount);
        
        return userId;
    }
    
    // 类型安全的转账
    function transfer(UserId from, UserId to, Price amount) external {
        require(UserId.unwrap(from) > 0, "Invalid from user");
        require(UserId.unwrap(to) > 0, "Invalid to user");
        require(Price.unwrap(amount) > 0, "Invalid amount");
        
        UserData storage fromUser = users[from];
        UserData storage toUser = users[to];
        
        require(Price.unwrap(fromUser.balance) >= Price.unwrap(amount), "Insufficient balance");
        
        // 使用类型安全的数学运算
        fromUser.balance = Price.wrap(Price.unwrap(fromUser.balance) - Price.unwrap(amount));
        toUser.balance = Price.wrap(Price.unwrap(toUser.balance) + Price.unwrap(amount));
        
        // 更新最后活跃时间
        fromUser.lastActive = Timestamp.wrap(block.timestamp);
        toUser.lastActive = Timestamp.wrap(block.timestamp);
    }
    
    // 类型安全的查询函数
    function getUserBalance(UserId userId) external view returns (Price) {
        require(UserId.unwrap(userId) > 0, "Invalid user ID");
        return users[userId].balance;
    }
    
    function getUserAddress(UserId userId) external view returns (ValidAddress) {
        require(UserId.unwrap(userId) > 0, "Invalid user ID");
        return users[userId].addr;
    }
    
    // 类型安全的折扣计算
    function applyDiscount(UserId userId, Percentage discount) external {
        require(UserId.unwrap(userId) > 0, "Invalid user ID");
        require(Percentage.unwrap(discount) <= 100, "Discount cannot exceed 100%");
        
        UserData storage user = users[userId];
        Price currentBalance = user.balance;
        Price discountAmount = Price.wrap(
            (Price.unwrap(currentBalance) * Percentage.unwrap(discount)) / 100
        );
        
        user.balance = Price.wrap(Price.unwrap(currentBalance) - Price.unwrap(discountAmount));
    }
}

// 5. 高级数据结构示例
contract AdvancedDataStructures {
    // 类型安全的枚举
    enum OrderStatus { Pending, Confirmed, Shipped, Delivered, Cancelled }
    enum PaymentMethod { ETH, ERC20, CreditCard }
    
    // 类型安全的订单结构
    struct Order {
        uint256 orderId;
        UserId userId;
        Price totalAmount;
        OrderStatus status;
        PaymentMethod paymentMethod;
        Timestamp createdAt;
        Timestamp updatedAt;
    }
    
    // 类型安全的映射
    mapping(uint256 => Order) public orders;
    mapping(UserId => uint256[]) public userOrders;
    mapping(OrderStatus => uint256[]) public ordersByStatus;
    
    uint256 public nextOrderId = 1;
    
    // 创建订单
    function createOrder(
        UserId userId,
        Price amount,
        PaymentMethod paymentMethod
    ) external returns (uint256) {
        require(UserId.unwrap(userId) > 0, "Invalid user ID");
        require(Price.unwrap(amount) > 0, "Invalid amount");
        
        uint256 orderId = nextOrderId++;
        Timestamp now = Timestamp.wrap(block.timestamp);
        
        Order memory newOrder = Order({
            orderId: orderId,
            userId: userId,
            totalAmount: amount,
            status: OrderStatus.Pending,
            paymentMethod: paymentMethod,
            createdAt: now,
            updatedAt: now
        });
        
        orders[orderId] = newOrder;
        userOrders[userId].push(orderId);
        ordersByStatus[OrderStatus.Pending].push(orderId);
        
        return orderId;
    }
    
    // 更新订单状态
    function updateOrderStatus(uint256 orderId, OrderStatus newStatus) external {
        require(orderId > 0, "Invalid order ID");
        require(orders[orderId].orderId != 0, "Order not found");
        
        Order storage order = orders[orderId];
        OrderStatus oldStatus = order.status;
        
        // 移除旧状态
        _removeFromStatusArray(ordersByStatus[oldStatus], orderId);
        
        // 更新状态
        order.status = newStatus;
        order.updatedAt = Timestamp.wrap(block.timestamp);
        
        // 添加到新状态
        ordersByStatus[newStatus].push(orderId);
    }
    
    // 内部函数：从数组中移除元素
    function _removeFromStatusArray(uint256[] storage arr, uint256 value) internal {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                arr[i] = arr[arr.length - 1];
                arr.pop();
                break;
            }
        }
    }
    
    // 获取用户的所有订单
    function getUserOrders(UserId userId) external view returns (uint256[] memory) {
        return userOrders[userId];
    }
    
    // 获取特定状态的所有订单
    function getOrdersByStatus(OrderStatus status) external view returns (uint256[] memory) {
        return ordersByStatus[status];
    }
}

// 6. 类型约束和验证
contract TypeConstraints {
    // 类型约束：确保地址不为零
    function validateAddress(address addr) internal pure returns (ValidAddress) {
        require(addr != address(0), "Zero address not allowed");
        return ValidAddress.wrap(addr);
    }
    
    // 类型约束：确保数值为正数
    function validatePositive(uint256 value) internal pure returns (NonZeroUint) {
        require(value > 0, "Value must be positive");
        return NonZeroUint.wrap(value);
    }
    
    // 类型约束：确保百分比在有效范围内
    function validatePercentage(uint8 value) internal pure returns (Percentage) {
        require(value <= 100, "Percentage cannot exceed 100");
        return Percentage.wrap(value);
    }
    
    // 类型约束：确保时间戳合理
    function validateTimestamp(uint256 value) internal pure returns (Timestamp) {
        require(value > 0, "Timestamp must be positive");
        require(value <= block.timestamp + 365 days, "Timestamp too far in future");
        return Timestamp.wrap(value);
    }
}

// 7. 测试合约
contract TestAdvancedTypes {
    TypeSafeContract public typeSafeContract;
    AdvancedDataStructures public dataStructures;
    
    constructor() {
        typeSafeContract = new TypeSafeContract();
        dataStructures = new AdvancedDataStructures();
    }
    
    function testTypeSafety() external {
        // 测试用户创建
        UserId userId1 = typeSafeContract.createUser(1, msg.sender, 1000);
        UserId userId2 = typeSafeContract.createUser(2, address(0x123), 500);
        
        // 测试转账
        typeSafeContract.transfer(userId1, userId2, Price.wrap(100));
        
        // 测试订单创建
        uint256 orderId = dataStructures.createOrder(
            userId1,
            Price.wrap(200),
            AdvancedDataStructures.PaymentMethod.ETH
        );
        
        // 测试订单状态更新
        dataStructures.updateOrderStatus(orderId, AdvancedDataStructures.OrderStatus.Confirmed);
    }
} 