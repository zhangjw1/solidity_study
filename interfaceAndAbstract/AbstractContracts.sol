// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
 * 抽象合约和接口高级用法示例
 * 
 * 1. 抽象合约 (Abstract Contracts)
 * 2. 接口 (Interfaces)
 * 3. 多重继承
 * 4. 函数重写 (Override)
 * 5. 虚拟函数 (Virtual)
 * 6. 接口实现
 */

// 基础接口
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// 扩展接口
interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

// 访问控制接口
interface IAccessControl {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
    function renounceRole(bytes32 role, address account) external;
}

// 抽象基础合约
abstract contract BaseToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
    
    // 抽象函数 - 必须被子合约实现
    function _mint(address to, uint256 amount) internal virtual;
    function _burn(address from, uint256 amount) internal virtual;
    
    // 虚拟函数 - 可以被重写
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
        // 默认实现为空，子合约可以重写
    }
    
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {
        // 默认实现为空，子合约可以重写
    }
    
    // 实现 IERC20 接口
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
    
    // 内部函数
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        
        _beforeTokenTransfer(from, to, amount);
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Insufficient balance");
        
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        
        emit Transfer(from, to, amount);
        
        _afterTokenTransfer(from, to, amount);
    }
    
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");
        
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}

// 访问控制抽象合约
abstract contract AccessControl {
    mapping(bytes32 => mapping(address => bool)) private _roles;
    mapping(bytes32 => bytes32) private _roleAdmin;
    
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }
    
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        return _roles[role][account];
    }
    
    function getRoleAdmin(bytes32 role) public view virtual returns (bytes32) {
        return _roleAdmin[role];
    }
    
    function grantRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }
    
    function revokeRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }
    
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == msg.sender, "Can only renounce own role");
        _revokeRole(role, account);
    }
    
    function _checkRole(bytes32 role) internal view virtual {
        if (!hasRole(role, msg.sender)) {
            revert("AccessControl: account missing role");
        }
    }
    
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role][account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }
    
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role][account] = false;
            emit RoleRevoked(role, account, msg.sender);
        }
    }
}

// 具体的代币合约 - 实现抽象合约
contract MyToken is BaseToken, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    
    constructor() BaseToken("MyToken", "MTK", 18) {
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }
    
    // 实现抽象函数
    function _mint(address to, uint256 amount) internal virtual override onlyRole(MINTER_ROLE) {
        require(to != address(0), "Mint to zero address");
        
        totalSupply += amount;
        _balances[to] += amount;
        
        emit Transfer(address(0), to, amount);
    }
    
    function _burn(address from, uint256 amount) internal virtual override onlyRole(BURNER_ROLE) {
        require(from != address(0), "Burn from zero address");
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Burn amount exceeds balance");
        
        unchecked {
            _balances[from] = fromBalance - amount;
            totalSupply -= amount;
        }
        
        emit Transfer(from, address(0), amount);
    }
    
    // 重写虚拟函数
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        // 添加自定义逻辑，比如黑名单检查
    }
    
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._afterTokenTransfer(from, to, amount);
        // 添加自定义逻辑，比如更新统计数据
    }
    
    // 公共铸造函数
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
    
    // 公共销毁函数
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}

// 多重继承示例
interface IStaking {
    function stake(uint256 amount) external;
    function unstake(uint256 amount) external;
    function getStakedAmount(address user) external view returns (uint256);
}

abstract contract StakingBase is IStaking {
    mapping(address => uint256) public stakedAmounts;
    uint256 public totalStaked;
    
    function stake(uint256 amount) external virtual override;
    function unstake(uint256 amount) external virtual override;
    
    function getStakedAmount(address user) external view override returns (uint256) {
        return stakedAmounts[user];
    }
}

// 实现多重继承
contract StakingToken is MyToken, StakingBase {
    constructor() MyToken() {}
    
    function stake(uint256 amount) external override {
        require(amount > 0, "Cannot stake 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        _transfer(msg.sender, address(this), amount);
        stakedAmounts[msg.sender] += amount;
        totalStaked += amount;
    }
    
    function unstake(uint256 amount) external override {
        require(amount > 0, "Cannot unstake 0");
        require(stakedAmounts[msg.sender] >= amount, "Insufficient staked amount");
        
        stakedAmounts[msg.sender] -= amount;
        totalStaked -= amount;
        _transfer(address(this), msg.sender, amount);
    }
}

// 测试合约
contract TestAbstractContracts {
    StakingToken public token;
    
    constructor() {
        token = new StakingToken();
    }
    
    function testToken() external {
        // 测试代币功能
        token.mint(msg.sender, 1000 * 10**18);
        token.transfer(address(0x1), 100 * 10**18);
        
        // 测试质押功能
        token.stake(500 * 10**18);
        token.unstake(200 * 10**18);
    }
} 