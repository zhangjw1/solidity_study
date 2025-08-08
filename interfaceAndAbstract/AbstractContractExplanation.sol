// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

/*
 * 抽象合约详细解释
 * 
 * 1. 抽象合约 vs 接口 vs 普通合约
 * 2. 抽象函数 vs 虚拟函数
 * 3. 实际应用场景
 * 4. 最佳实践
 */

// 1. 接口 (Interface) - 只能定义函数签名
interface IToken {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    
    // 接口不能有实现
    // function transfer(address to, uint256 amount) external returns (bool) {
    //     // 错误！接口不能有实现
    // }
}

// 2. 抽象合约 (Abstract Contract) - 可以有实现和抽象函数
abstract contract AbstractToken {
    // 状态变量
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping(address => uint256) internal _balances;
    
    // 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // 构造函数
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
    
    // 抽象函数 - 必须被子合约实现
    function _mint(address to, uint256 amount) internal virtual;
    function _burn(address from, uint256 amount) internal virtual;
    
    // 虚拟函数 - 有默认实现，但可以被重写
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
        // 默认实现为空
    }
    
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {
        // 默认实现为空
    }
    
    // 已实现的函数
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
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
}

// 3. 普通合约 (Concrete Contract) - 完全实现
contract ConcreteToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
    
    // 所有函数都有完整实现
    function mint(address to, uint256 amount) external {
        totalSupply += amount;
        balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }
    
    function burn(address from, uint256 amount) external {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}

// 4. 实现抽象合约的子合约
contract MyToken is AbstractToken {
    address public owner;
    
    constructor() AbstractToken("MyToken", "MTK", 18) {
        owner = msg.sender;
    }
    
    // 必须实现抽象函数
    function _mint(address to, uint256 amount) internal virtual override {
        require(msg.sender == owner, "Only owner can mint");
        require(to != address(0), "Mint to zero address");
        
        totalSupply += amount;
        _balances[to] += amount;
        
        emit Transfer(address(0), to, amount);
    }
    
    function _burn(address from, uint256 amount) internal virtual override {
        require(msg.sender == owner, "Only owner can burn");
        require(from != address(0), "Burn from zero address");
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Burn amount exceeds balance");
        
        unchecked {
            _balances[from] = fromBalance - amount;
            totalSupply -= amount;
        }
        
        emit Transfer(from, address(0), amount);
    }
    
    // 可以选择重写虚拟函数
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        // 添加自定义逻辑，比如黑名单检查
        require(from != address(0x123), "Blacklisted address");
    }
    
    // 公共函数
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
    
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}

// 5. 多重抽象合约继承
abstract contract AccessControl {
    mapping(bytes32 => mapping(address => bool)) private _roles;
    
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    
    modifier onlyRole(bytes32 role) {
        require(_roles[role][msg.sender], "AccessControl: account missing role");
        _;
    }
    
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        return _roles[role][account];
    }
    
    function grantRole(bytes32 role, address account) public virtual onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(role, account);
    }
    
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role][account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }
}

// 6. 实现多重继承
contract AdvancedToken is AbstractToken, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    
    constructor() AbstractToken("AdvancedToken", "ADV", 18) {
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }
    
    // 实现抽象函数，使用访问控制
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
    
    // 公共函数
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
    
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}

// 7. 抽象合约的实际应用场景

// 基础游戏合约
abstract contract BaseGame {
    struct Player {
        uint256 score;
        uint256 level;
        bool isActive;
    }
    
    mapping(address => Player) public players;
    
    // 抽象函数 - 每个游戏的具体逻辑不同
    function playGame(address player) external virtual returns (uint256);
    function calculateReward(address player) external virtual returns (uint256);
    
    // 虚拟函数 - 有默认实现
    function updatePlayerLevel(address player) internal virtual {
        Player storage p = players[player];
        p.level = p.score / 100;
    }
    
    // 已实现的函数
    function getPlayer(address player) external view returns (Player memory) {
        return players[player];
    }
}

// 具体游戏实现
contract CardGame is BaseGame {
    function playGame(address player) external override returns (uint256) {
        // 卡牌游戏的具体逻辑
        uint256 score = uint256(keccak256(abi.encodePacked(block.timestamp, player))) % 100;
        players[player].score += score;
        updatePlayerLevel(player);
        return score;
    }
    
    function calculateReward(address player) external override returns (uint256) {
        // 卡牌游戏的奖励计算
        return players[player].score * 10;
    }
}

contract PuzzleGame is BaseGame {
    function playGame(address player) external override returns (uint256) {
        // 拼图游戏的具体逻辑
        uint256 score = uint256(keccak256(abi.encodePacked(block.number, player))) % 50;
        players[player].score += score;
        updatePlayerLevel(player);
        return score;
    }
    
    function calculateReward(address player) external override returns (uint256) {
        // 拼图游戏的奖励计算
        return players[player].score * 5;
    }
}

// 8. 测试合约
contract TestAbstractContracts {
    MyToken public myToken;
    AdvancedToken public advancedToken;
    CardGame public cardGame;
    PuzzleGame public puzzleGame;
    
    constructor() {
        myToken = new MyToken();
        advancedToken = new AdvancedToken();
        cardGame = new CardGame();
        puzzleGame = new PuzzleGame();
    }
    
    function testTokens() external {
        // 测试基础代币
        myToken.mint(msg.sender, 1000);
        myToken.transfer(address(0x1), 100);
        
        // 测试高级代币
        advancedToken.mint(msg.sender, 1000);
        advancedToken.burn(msg.sender, 100);
    }
    
    function testGames() external {
        // 测试卡牌游戏
        cardGame.playGame(msg.sender);
        cardGame.calculateReward(msg.sender);
        
        // 测试拼图游戏
        puzzleGame.playGame(msg.sender);
        puzzleGame.calculateReward(msg.sender);
    }
} 