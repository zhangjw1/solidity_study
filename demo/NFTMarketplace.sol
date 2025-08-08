// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

contract NFTMarketplace {
    struct NFTListing {
        address seller;
        uint256 price;
        bool isActive;
    }
    
    // NFT地址 => TokenID => 挂单信息
    mapping(address => mapping(uint256 => NFTListing)) public listings;
    
    // 合约owner
    address public owner;
    
    // 交易手续费（2%）
    uint256 public feePercentage = 200; // 2% = 200/10000
    
    constructor() {
        owner = msg.sender;
    }
    
    // 挂单出售NFT
    function listNFT(address nftContract, uint256 tokenId, uint256 price) external {
        // 这里应该检查msg.sender是否拥有该NFT
        listings[nftContract][tokenId] = NFTListing({
            seller: msg.sender,
            price: price,
            isActive: true
        });
    }
    
    // 购买NFT
    function buyNFT(address nftContract, uint256 tokenId) external payable {
        NFTListing memory listing = listings[nftContract][tokenId];
        require(listing.isActive, "NFT未在售");
        require(msg.value >= listing.price, "支付金额不足");
        
        // 计算手续费
        uint256 fee = (listing.price * feePercentage) / 10000;
        uint256 sellerAmount = listing.price - fee;
        
        // 转账给出售方
        payable(listing.seller).transfer(sellerAmount);
        
        // 转账给合约owner（手续费）
        payable(owner).transfer(fee);
        
        // 转移NFT（这里需要NFT合约支持）
        // transferNFT(nftContract, tokenId, listing.seller, msg.sender);
        
        // 关闭挂单
        listings[nftContract][tokenId].isActive = false;
        
        // 退还多余的ETH
        if (msg.value > listing.price) {
            payable(msg.sender).transfer(msg.value - listing.price);
        }
    }
    
    // 查看合约余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    // 查看挂单信息
    function getListing(address nftContract, uint256 tokenId) external view returns (address seller, uint256 price, bool isActive) {
        NFTListing memory listing = listings[nftContract][tokenId];
        return (listing.seller, listing.price, listing.isActive);
    }
} 