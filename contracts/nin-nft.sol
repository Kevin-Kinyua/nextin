// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

/// @notice Error library for centralised error messaging
library Errors {
    string constant invalidNextinNFTId = "Unknown Nextin NFT ID";
    string constant insufficientNFTSupply = "Insufficient NFT supply";
    string constant withdrawStoped = "Withdraw stoped";
    string constant invalidSupplyNumber = "Cannot decrease supply below the number of minted NFTs";
    string constant invalidStartDate = "Start date must be in the future";
    string constant invalidEndDate = "End date must be in the future";
    string constant invalidArrayLength = "Array lengths must be equal";
}

contract NextinNFT is ERC1155, ERC2981, Ownable {
    //Token Owner
    address private _owner;

    string public name = "Nextin NFTs";

    // NFT metadata
    string[7] private tokenURIs = [
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/1.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/2.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/3.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/4.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/5.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/6.json",
            "https://gateway.pinata.cloud/ipfs/QmU3ZJE35QwaKDCTszZXMTnq3Ux6K3XsrfMqPnuUQSDhNd/7.json"
        ];

    //Number of minted NFTs
    uint256[7] private mintedCounts;

    //Number of total supply
    uint256[7] private tokenSupplys = [142858, 142858, 142858, 142858, 142858, 142858, 142858];

    // mapping(uint256 => uint256) private tokenSupplys;

    // uint256 private nftCostInWei = 10000000000000000;

    // EIP2981
    struct TokenRoyalty {
        address recipient;
        uint16 bps;
    }

    TokenRoyalty public defaultRoyalty;
    mapping(uint256 => TokenRoyalty) private _tokenRoyalties;

    //Sale time
    uint256 public startDate;
    uint256 public endDate;

    constructor(address _tokenOwner, uint96 _feeNumerator) Ownable(_tokenOwner) ERC1155("") {
        // defaultRoyalty = TokenRoyalty(_royaltyRecipient, _royaltyBPS);
        //Set token owner
        _owner = _tokenOwner;
        _setDefaultRoyalty(_msgSender(), _feeNumerator);
    }

    /// @notice Mint Nextin NFTs to users by admin.
    /// @param _to The address of the recipient who will receive the minted NFTs.
    /// @param _tokenId The ID of the Nextin NFT type to be minted.
    /// @param _numberOfNextinNFT The number of Nextin NFTs to mint and assign to the recipient.
    function issueNewNextinNFTsByAdmin(
        address _to,
        uint256 _tokenId,
        uint256 _numberOfNextinNFT
    ) public onlyOwner {
        require(_tokenId >= 0 && _tokenId <= 6, Errors.invalidNextinNFTId);

        uint256 new_minted_number = mintedCounts[_tokenId] + _numberOfNextinNFT;
        require(new_minted_number <= tokenSupplys[_tokenId], Errors.insufficientNFTSupply);

        mintedCounts[_tokenId] = new_minted_number;
        _mint(_to, _tokenId, _numberOfNextinNFT, "");
    }

    function issueNewNextinNFTs(uint256 _tokenId, uint256 _numberOfNextinNFT)
        public
    {
        require(_tokenId >= 0 && _tokenId <= 6, Errors.invalidNextinNFTId);

        uint256 new_minted_number = mintedCounts[_tokenId] + _numberOfNextinNFT;
        require(new_minted_number <= tokenSupplys[_tokenId], "No enough nfts");

        // require(
        //     msg.value >= nftCostInWei * _numberOfNextinNFT,
        //     "Not enough funds"
        // );

        _mint(msg.sender, _tokenId, _numberOfNextinNFT, "");
    }