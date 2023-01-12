// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "lib/openzeppelin-contracts/contracts//token/ERC721/utils/ERC721Holder.sol";
import "src/interfaces/IRatioVault.sol";

/// @title A simulator for trees
/// @author William Phan
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

contract RatioVault is IRatioVault, ERC20, ERC20Permit, ERC721Holder {

    /// @dev This contract inherits from IERC721 and implements a collection of tokens
    IERC721 public collection;

    /// @dev The ID of the token
    uint256 public tokenId;

    /// @dev Boolean indicating whether the token has been initialized
    bool public initialized = false;

    /// @dev Boolean indicating whether the token is for sale
    bool public forSale = false;

    /// @dev Price of the token
    uint256 public salePrice;

    /// @dev Boolean indicating whether the token can be redeemed
    bool public canRedeem = false;

    /// @dev Constructor for the MyToken contract
    constructor() ERC20("Ratio", "RTIO") ERC20Permit("Ratio") {}

    /// @notice Initializes the contract with a specified token and amount
    /// @dev Initializes the contract with a specified token and amount
    /// @param _collection address of the ERC721 collection contract
    /// @param _tokenId uint256 ID of the NFT to be used in the contract
    /// @param _amount uint256 the amount of NFTs to be held by the contract
    function init(address _collection, uint256 _tokenId, uint256 _amount) external {
        if (initialized) revert IRatioVault.AlreadyInitialized();
        if (_amount <= 0) revert IRatioVault.CannotBeLessThanZero();
        collection = IERC721(_collection);
        collection.safeTransferFrom(msg.sender, address(this), _tokenId);
        tokenId = _tokenId;
        initialized = true;
        _mint(msg.sender, _amount);
        emit initial(msg.sender, _amount);
    }

    /// @notice Puts the NFT for sale
    /// @param price uint256 the price of the NFT
    /// @notice Puts the NFT for sale
    function putForSale(uint256 price) external {
        salePrice = price;
        forSale = true;
        emit listNFT(msg.sender, salePrice);
    }

    /// @notice Purchases the NFT
    function purchase() external payable {
        if (!forSale) revert IRatioVault.NotForSale();
        if (msg.value < salePrice) revert IRatioVault.NotEnoughEther();
        forSale = false;
        canRedeem = true;
        collection.transferFrom(address(this), msg.sender, tokenId);
        // forSale = false;
        // canRedeem = true;
        emit purchaseNFT(msg.sender, msg.value, tokenId);
    }

    /// @notice Redeems the amount of NFTs for ether
    /// @dev Redeems the amount of NFTs for ether
    /// @param _amount uint256 amount of NFTs to be redeemed
    function redeem(uint256 _amount) external {
        if (!canRedeem) revert IRatioVault.CannotRedeem();
        uint256 totalEther = address(this).balance;
        uint256 toRedeem = _amount * totalEther / totalSupply();

        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(toRedeem);
        emit redeemTokens(msg.sender, _amount);
    }
}