// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IRatioVault {

    /// @notice This event is emitted when the contract is initialized with a minter and an amount of tokens.
    event initial(address indexed minter, uint amount);

    /// @notice This event is emitted when an NFT token is listed for sale, with a seller, price, and token ID.
    event listNFT(address indexed seller, uint price);

    /// @notice This event is emitted when an NFT token is purchased, with a buyer, amount paid, and token ID.
    event purchaseNFT(address indexed buyer, uint amount, uint tokenId);

    /// @notice This event is emitted when tokens are redeemed, with a redeemer and the amount of tokens being redeemed.
    event redeemTokens (address redeemer, uint amount);

    /// @notice This error is thrown when the contract has already been initialized.
    error AlreadyInitialized();

    /// @notice This error is thrown when a value being passed to the contract is less than zero.
    error CannotBeLessThanZero();

    /// @notice This error is thrown when an NFT token is not for sale.
    error NotForSale();

    /// @notice This error is thrown when there is not enough Ether to complete the transaction.
    error NotEnoughEther();

    /// @notice This error is thrown when tokens cannot be redeemed.
    error CannotRedeem();

    /// @dev The ID of the token
    function tokenId() external returns (uint256);

    /// @dev Boolean indicating whether the token has been initialized
    function initialized() external returns (bool);

    /// @dev Boolean indicating whether the token is for sale
    function forSale() external returns (bool);

    /// @dev Price of the token
    function salePrice() external returns (uint);

    /// @dev Boolean indicating whether the token can be redeemed
    function canRedeem() external returns (bool);

    /// @notice Initializes the contract with a specified token and amount
    /// @dev Initializes the contract with a specified token and amount
    /// @param _collection address of the ERC721 collection contract
    /// @param _tokenId uint256 ID of the NFT to be used in the contract
    /// @param _amount uint256 the amount of NFTs to be held by the contract
    function nftInit(address _collection, uint256 _tokenId, uint256 _amount) external;
    

    /// @notice Puts the NFT for sale
    /// @param price uint256 the price of the NFT
    function init(uint256 price) external;

    /// @notice Purchases the NFT
    function purchase() external payable;

    /// @notice Redeems the amount of NFTs for ether
    /// @dev Redeems the amount of NFTs for ether
    /// @param _amount uint256 amount of NFTs to be redeemed
    function redeem(uint256 _amount) external;
}