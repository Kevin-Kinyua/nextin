Billa Founder of NextIn Network, [12/02/2024 15:52]
/// @notice Withdraw the funds locked in the smart contract.
    /// @dev This function can only be called by the owner of the smart contract.
    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = owner().call{value: amount}("");
        require(success, Errors.withdrawStoped);
    }

    // /// @notice Return the current cost of minting a new NFT.
    // function inquireCostOfNFT() external view returns (uint256) {
    //     return nftCostInWei;
    // }

    /// @notice Change the cost for minting a new Nextin NFT
    /// Can only be called by the owner of the smart contract.
    // function changeCostOfNFT(uint256 _stampCost) external onlyOwner {
    //     nftCostInWei = _stampCost;
    // }

    /// @dev Set the royalty for all collection
    /// @param _feeNumerator The fee for collection
    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator)
        public
        onlyOwner
    {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    /// @dev Set royalty fee for specific token
    /// @param _tokenId The tokenId where to add the royalty
    /// @param _receiver The royalty receiver
    /// @param _feeNumerator the fee for specific tokenId
    function setTokenRoyalty(
        uint256 _tokenId,
        address _receiver,
        uint96 _feeNumerator
    ) public onlyOwner {
        _setTokenRoyalty(_tokenId, _receiver, _feeNumerator);
    }

     /// @dev Allow owner to delete the default royalty for all collection
    function deleteDefaultRoyalty() external onlyOwner {
        _deleteDefaultRoyalty();
    }

    /// @dev Reset specific royalty
    /// @param tokenId The token id where to reset the royalty
    function resetTokenRoyalty(uint256 tokenId) external onlyOwner {
        _resetTokenRoyalty(tokenId);
    }

    /// @notice Returns the number of minted Nextin NFTs for a given category ID
    /// @param _id The category ID (0 ~ 6)
    /// @return The number of minted NFTs for the specified category ID
    function inquireMintedCounts(uint256 _id) public view returns (uint256) {
        require(_id >= 0 && _id <= 6, Errors.invalidNextinNFTId);
        return mintedCounts[_id];
    }

    /// @notice Returns the total supply of Nextin NFTs for a given category ID
    /// @param _id The category ID (0 ~ 6)
    /// @return The total supply of NFTs for the specified category ID
    function inquireTotalSupply(uint256 _id) public view returns (uint256) {
        require(_id >= 0 && _id <= 6, Errors.invalidNextinNFTId);
        return tokenSupplys[_id];
    }

    /// @notice Returns the number of remaining Nextin NFTs supply by category ID
    /// @param _id The category ID (0 ~ 6)
    /// @return The number of remaining NFTs supply for the given category ID
    function inquireRemainedSupply(uint256 _id)
        external
        view
        returns (uint256)
    {
        require(_id >= 0 && _id <= 6, Errors.invalidNextinNFTId);
        return tokenSupplys[_id] - mintedCounts[_id];
    }

    /// @notice Increase or decrease the number of supply of Nextin NFTs by category id
    /// @param _id The category ID (0 ~ 6)
    /// @param _supplyChange The amount to increase or decrease the supply by
    function changeTotalSupply(uint256 _id, int256 _supplyChange)
        external
        onlyOwner
    {
        require(_id >= 0 && _id <= 6, Errors.invalidNextinNFTId);
        int256 newSupply = int256(tokenSupplys[_id]) + _supplyChange;
        require(newSupply >= int256(mintedCounts[_id]), Errors.invalidSupplyNumber);
        tokenSupplys[_id] = uint256(newSupply);
    }

    /// @notice Set the start date for a specific event or functionality.
    /// @dev This function can only be called by the owner of the smart contract.
    /// @param _startDate The new start date to start sale.
    function setStartDate(uint256 _startDate) external onlyOwner {
        require(_startDate > block.timestamp, Errors.invalidStartDate);
        startDate = _startDate;
    }

Billa Founder of NextIn Network, [12/02/2024 15:52]
/// @notice Set the end date for a specific event or functionality.
    /// @dev This function can only be called by the owner of the smart contract.
    /// @param _endDate The new end date to end sale.
    function setEndDate(uint256 _endDate) external onlyOwner {
        require(_endDate > block.timestamp, Errors.invalidEndDate);
        endDate = _endDate;
    }

    /// @notice Check if the sale is currently active.
    /// @return A boolean indicating whether the sale is active or not.
    function isSaleActive() public view returns (bool) {
        uint256 currentTimestamp = block.timestamp;
        return currentTimestamp >= startDate && currentTimestamp <= endDate;
    }

    /// @notice Change the URI of Nextin NFTs
    /// @param _tokenURIs Array of new token URIs
    /// @param _nextinNFTIds Array of nextin NFT Ids (0 ~ 6) for the respective URIs
    function changeURIs(
        string[] calldata _tokenURIs,
        uint256[] calldata _nextinNFTIds
    ) external onlyOwner {
        require(_tokenURIs.length == _nextinNFTIds.length, Errors.invalidArrayLength);

        for (uint256 i = 0; i < _tokenURIs.length; i++) {
            require(_nextinNFTIds[i] >= 0 && _nextinNFTIds[i] <= 6, Errors.invalidNextinNFTId);
            tokenURIs[_nextinNFTIds[i]] = _tokenURIs[i];
        }
    }

    /// @notice Returns the uri metadata. Used by marketplaces and wallets to show the NFT
    /// @param _tokenId The ID of the NFT to retrieve the metadata for.
    /// @return The URI metadata string.
    function uri(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
      return tokenURIs[_tokenId];
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155, ERC2981)
        returns (bool)
    {
        return
            interfaceId == type(IERC2981).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /// @dev Define the fee for the token specify
    /// @param tokenId uint256 token ID to specify
    /// @param recipient address account that receives the royalties
    // function setRotalty(address recipient, uint256 _tokenId) public {
    //     _setTokenRoyalty(_tokenId, recipient, _tokenRoyalties[_tokenId]);
    // }
    
}