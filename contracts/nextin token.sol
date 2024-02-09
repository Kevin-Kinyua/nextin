// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NinToken is ERC20, Ownable {
    uint256 public constant MINIMUM_PRICE_PERCENTAGE = 0.000588235 ether; // 0.000588235% represented as ether
    uint256 public constant MINIMUM_PRICE_TARGET = 10 ether;
    uint256 public constant PRICE_CHANGE_DURATION = 90 days;

    uint256 public lastPriceChangeTimestamp;
    uint256 public minimumTokenPrice;

    address public teamWallet;

    constructor() ERC20("NIN Token", "NIN") {
        minimumTokenPrice = MINIMUM_PRICE_PERCENTAGE;
        lastPriceChangeTimestamp = block.timestamp;
    }

    modifier onlyTeam() {
        require(msg.sender == teamWallet || msg.sender == owner(), "Not authorized");
        _;
    }

    function setTeamWallet(address _teamWallet) external onlyOwner {
        teamWallet = _teamWallet;
    }

    function determineMinimumPrice() external onlyOwner {
        require(block.timestamp >= lastPriceChangeTimestamp + PRICE_CHANGE_DURATION, "Price change not allowed yet");

        uint256 networkAssets = getNetworkAssets(); // Implement your logic to get network assets

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

        _transfer(owner(), _wallet, _amount);
    }
}
