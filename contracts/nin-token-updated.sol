// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract NinToken is ERC1155, Ownable {
    uint256 public constant MINIMUM_PRICE_PERCENTAGE = 0.000588235 ether; // 0.000588235% represented as ether
    uint256 public constant MINIMUM_PRICE_TARGET = 10 ether;
    uint256 public constant PRICE_CHANGE_DURATION = 90 days;

    uint256 public lastPriceChangeTimestamp;
    uint256 public minimumTokenPrice;

    address public teamWallet;
    
    mapping(uint256 => uint256) public mintedCounts;
    mapping(uint256 => uint256) public tokenSupplys;
    mapping(uint256 => string) public tokenURIs;

    modifier onlyTeam() {
        require(msg.sender == teamWallet || msg.sender == owner(), "Not authorized");
        _;
    }

    constructor(address initialOwner) ERC1155("https://yourapi.com/token/{id}.json") Ownable(initialOwner) {
        minimumTokenPrice = MINIMUM_PRICE_PERCENTAGE;
        lastPriceChangeTimestamp = block.timestamp;
    }

    function setTeamWallet(address _teamWallet) external onlyOwner {
        teamWallet = _teamWallet;
    }

    function determineMinimumPrice() external onlyOwner {
        require(block.timestamp >= lastPriceChangeTimestamp + PRICE_CHANGE_DURATION, "Price change not allowed yet");

        uint256 networkAssets = address(this).balance;

        if (minimumTokenPrice < MINIMUM_PRICE_TARGET) {
            minimumTokenPrice = MINIMUM_PRICE_TARGET;
        } else {
            minimumTokenPrice = (networkAssets * MINIMUM_PRICE_PERCENTAGE) / 1e18;
        }

        lastPriceChangeTimestamp = block.timestamp;
    }

    function sendTeamDues(uint256 _amount, address _wallet) external onlyTeam {
        require(_amount > 0, "Amount must be greater than 0");
        require(_wallet != address(0), "Invalid wallet address");

        _mint(_wallet, 0, _amount, "");
    }

    function changeTotalSupply(uint256 _id, uint256 _totalSupply) external onlyOwner {
        require(_id >= 0 && _id <= 6, "Invalid Nextin NFT ID");
        tokenSupplys[_id] = _totalSupply;
    }

    function uri(uint256 _tokenId) public view override returns (string memory) {
        return tokenURIs[_tokenId];
    }
}
