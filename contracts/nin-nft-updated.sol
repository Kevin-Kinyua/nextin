// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NextinNFT is ERC1155, Ownable, Pausable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Define the NFT categories
    enum NFTCategory { EarlyInvestors, EarlySupporters, ContentCreators, Experts, Members, Referral, NextInNetwork }

    // Struct to store NFT metadata
    struct NFTMetadata {
        string name;
        string symbol;
        string description;
        uint256 supply;
        uint256 royaltyPercentage;
        // Add more metadata fields as needed
    }

    // Mapping to store metadata for each category
    mapping(NFTCategory => NFTMetadata) public nftMetadata;

    // Mapping to store the number of tokens sold for each category
    mapping(NFTCategory => uint256) public tokensSold;

    // Sale details
    uint256 public saleStartTime;
    uint256 public saleEndTime;
    uint256 public salePrice;
    address public paymentReceiver;

    // Event to track NFT purchases
    event NFTPurchased(address indexed buyer, uint256 tokenId, NFTCategory category);

    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) Pausable() ReentrancyGuard() {
        // Initialize NFT categories with metadata
        initializeCategories();

        // Set sale details
        saleStartTime = block.timestamp;
        saleEndTime = block.timestamp + 30 days; // Set your desired duration
        salePrice = 10 ether; // Set your desired sale price
        paymentReceiver = msg.sender; // Set the address to receive payments
    }

    // Function to initialize NFT categories with metadata
    function initializeCategories() internal {
        nftMetadata[NFTCategory.EarlyInvestors] = NFTMetadata({
            name: "Early Investors of NextIn Network",
            symbol: "$NIN-EI",
            description: "This NFT is intended for the first investors...",
            supply: 142858,
            royaltyPercentage: 25
        });

        // Add metadata for other categories
    }

    // Function to purchase NFTs
    function purchaseNFT(NFTCategory category) external payable nonReentrant whenNotPaused {
        require(block.timestamp >= saleStartTime && block.timestamp <= saleEndTime, "Sale is not active");
        require(tokensSold[category] < nftMetadata[category].supply, "Sold out");
        require(msg.value == salePrice, "Incorrect payment amount");

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _mint(msg.sender, tokenId, 1, "");
        tokensSold[category]++;
        emit NFTPurchased(msg.sender, tokenId, category);

        // Send payment to the payment receiver
        payable(paymentReceiver).transfer(msg.value);
    }

    // Function to mint more tokens (only for the owner)
    function mintTokens(NFTCategory category, uint256 amount) external onlyOwner {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _mint(msg.sender, tokenId, amount, "");
        tokensSold[category] += amount;
    }

    // Function to pause and unpause the sale
    function toggleSaleStatus() external onlyOwner {
        if (paused()) {
            _unpause();
        } else {
            _pause();
        }
    }

    // Function to withdraw funds (only for the owner)
    function withdrawFunds() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Add more functions as needed, such as setting start and end times, updating metadata, etc.
}
